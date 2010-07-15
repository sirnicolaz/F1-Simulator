with CORBA.ORB;
with Polyorb.Setup.Client;
with CompetitorRadio;

with Input_Sources.File;
use Input_Sources.File;
with Sax.Readers; use Sax.Readers;
with DOM.Readers; use DOM.Readers;
with DOM.Core; use DOM.Core;
with DOM.Core.Documents; use DOM.Core.Documents;
with DOM.Core.Nodes; use DOM.Core.Nodes;
with DOM.Core.Attrs; use DOM.Core.Attrs;

with ADA.Float_Text_IO;
with Common;
use Common;

package body Box is


   UpdatesBuffer : SYNCH_COMPETITION_UPDATES;
   CompetitorRadio_IOR : access STRING;

   task body MONITOR is
      Info : COMPETITION_UPDATE;
      Sector : INTEGER := 0;
      Lap : INTEGER := 0;
   begin
      loop
         -- Test init values to avoid warnings DEL
         Info.GasLevel := 42.0;
         Info.TyreUsury := 42.0;
         Info.MeanSpeed := 42.0;
         Info.MeanGasConsumption := 42.0;
         Info.Time := 42.0;

         -- Info := RequestInfo (Competitor_Id,Sector,Lap); TODO: implement this.
         UpdatesBuffer.Add_Data(Info);
         exit when Info.Time = -1.0;
         Sector := Sector + 1;
         if(Sector = Sector_Qty) then
            Sector := 0;
            Lap := Lap + 1;
         end if;

      end loop;

   end MONITOR;

   -- Intanto è solo la bozza dello scheletro. In base all'algoritmo
   -- che si deciderà di utilizzare, verranno adottati più o meno
   -- parametri.
   function Compute_Strategy(
                             New_Info : COMPETITION_UPDATE;
                             Old_Info : COMPETITION_UPDATE;
                             Old_Strategy : BOX_STRATEGY
                            ) return BOX_STRATEGY is
      New_Strategy : BOX_STRATEGY;
   begin
      New_Strategy.Type_Tyre := "12345678901234567890";
      return New_Strategy;
   end Compute_Strategy;

   task body STRATEGY_UPDATER is
      Old_Info : COMPETITION_UPDATE;
      New_Info : COMPETITION_UPDATE;
      Strategy : BOX_STRATEGY;
      Sector : INTEGER := 0;
   begin
      Old_Info.GasLevel := 0.0;
      Old_Info.TyreUsury := 0.0;
      Old_Info.MeanSpeed := 0.0;
      Old_Info.MeanGasConsumption := 0.0;
      Old_Info.Time := 0.0;
      New_Info.GasLevel := 0.0;
      New_Info.TyreUsury := 0.0;
      New_Info.MeanSpeed := 0.0;
      New_Info.MeanGasConsumption := 0.0;
      New_Info.Time := 0.0;
      Strategy.Type_Tyre := "Regular             ";
      Strategy.Style := NORMAL;
      Strategy.GasLevel := 0.0;
      Strategy.PitStopLap := 1;
      Strategy.PitStopDelay := 0.0;
      -- Time = -1.0 means that race is over.
      loop
         UpdatesBuffer.Wait(New_Info);
         exit when New_Info.Time /= -1.0;
         Sector := Sector + 1;
         Strategy := Compute_Strategy(New_Info    => New_Info,
                                      Old_Info    => Old_Info,
                                      Old_Strategy => Strategy
                                     );
         if(Sector = Sector_Qty) then
            -- send strategy to competitor
            Sector := 0;
         end if;
         Old_Info := New_Info;
      end loop;
   end STRATEGY_UPDATER;


   procedure Set_Node(Info_Node_Out : in out INFO_NODE_POINT; Value : COMPETITION_UPDATE ) is
   begin
      Info_Node_Out.This := Value;
   end Set_Node;

   procedure Set_PreviousNode(Info_Node_Out : in out Info_Node_POINT ; Value : in out Info_Node_POINT) is
   begin
      if(Value /= null) then
         Info_Node_Out.Previous := Value;
         Info_Node_Out.Previous.Next := Info_Node_Out;
         Info_Node_Out.Index := Info_Node_Out.Previous.Index + 1;
      end if;
   end Set_PreviousNode;

   procedure Set_NextNode(Info_Node_Out : in out Info_Node_POINT; Value : in out Info_Node_POINT ) is
   begin
      if(Value /= null) then
         Info_Node_Out.Next := Value;
         Info_Node_Out.Next.Previous := Info_Node_Out;
         Info_Node_Out.Next.Index := Info_Node_Out.Index + 1;
      end if;
   end Set_NextNode;

   protected body SYNCH_COMPETITION_UPDATES is

      procedure Init_Buffer is
      begin
         Updated := False;
         Updates_CUrrent := new Info_Node;
         Updates_Current.Index := 1;
         Updates_Current.Previous := null;
         Updates_Current.Next := null;
         Updates_Current.This.MeanSpeed := -1.0;
         Updates_Last := Updates_Current;
      end Init_Buffer;

      procedure Add_Data(CompetitionUpdate_In : COMPETITION_UPDATE) is
         New_Update : INFO_NODE_POINT := new INFO_NODE;
      begin
         -- If info related to a time interval are already saved, do nothing.
         if(Updates_Last.Previous = null) or (Updates_Last.Previous.This.Time >= CompetitionUpdate_In.Time) then
            Updates_Last.This := CompetitionUpdate_In;
            Set_NextNode(Updates_Last,New_Update);
            Updates_Last := New_Update;
            Updated := True;
         end if;
      end Add_Data;

      entry Wait(NewInfos : out COMPETITION_UPDATE) when Updated is
         New_Update : INFO_NODE_POINT;
      begin
         NewInfos := Updates_Current.This;
         if(Updates_Current.Next = null) then
            New_Update :=  new INFO_NODE;
            Set_NextNode(Updates_Current,New_Update);
            Updates_Current := New_Update;
            Updated := false;
         end if;
      end Wait;

      function IsUpdated return BOOLEAN is
      begin
         return Updated;
      end;

   end SYNCH_COMPETITION_UPDATES;

   function BoxStrategyToXML(strategy : BOX_STRATEGY) return STRING is
      Gas : access String;
      GasLength : INTEGER;
      Gas_Unb : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Tyre : STRING(1..20);
      TyreLength : INTEGER;
      Style : access STRING;
      StyleLength : INTEGER;
      PStopLap : access STRING;
      PStopLapLength : INTEGER;
      PStopLap_Unb : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      PStopDelay : access STRING;
      PStopDelay_Unb : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      PStopDelayLength : INTEGER;

      Tot_Length : INTEGER;
      XML_String : access STRING;

   begin
      --Initialise gas String
      GasLength := FLOAT'IMAGE(strategy.GasLevel)'LENGTH;
      Gas := new STRING(1..GasLength);
      Ada.Float_Text_IO.Put(Gas.all,strategy.GasLevel,0,0);

      Gas_Unb := Unbounded_String.To_Unbounded_String(Ada.Strings.Fixed.Trim(Gas.all,Ada.Strings.Left));
      GasLength := Unbounded_String.Length(Gas_Unb);
      --Initialise tyre string
      Tyre := strategy.Type_Tyre;
      TyreLength := Tyre'LENGTH;
      --Initialise style string
      case strategy.Style is
         when AGGRESSIVE =>
            StyleLength := 10;
            Style := new STRING(1..StyleLength);
            Style.all := "Aggressive";
         when NORMAL =>
            StyleLength := 6;
            Style := new STRING(1..StyleLength);
            Style.all := "Normal";
         when CONSERVATIVE =>
            StyleLength := 12;
            Style := new STRING(1..StyleLength);
            Style.all := "Conservative";
      end case;
      --Initialise pit stop lap string
      PStopLapLength := INTEGER'IMAGE(strategy.PitStopLap)'LENGTH;
      PStopLap := new STRING(1..PStopLapLength);
      PStopLap.all := INTEGER'IMAGE(strategy.PitStopLap);
      PStopLap_Unb := Unbounded_String.To_Unbounded_String(Ada.Strings.Fixed.Trim(PStopLap.all, Ada.Strings.Left));
      PStopLapLength := Unbounded_String.Length(PStopLap_Unb);
      --Initialise pit stop delay string
      PStopDelayLength := FLOAT'IMAGE(strategy.PitStopDelay)'LENGTH;
      PStopDelay := new STRING(1..PStopDelayLength);
      Ada.Float_Text_IO.Put(PStopDelay.all,strategy.PitStopDelay,0,0);

      PStopDelay_Unb := Unbounded_String.To_Unbounded_String(Ada.Strings.Fixed.Trim(PStopDelay.all,Ada.Strings.Left));
      PStopDelayLength := Unbounded_String.Length(PStopDelay_Unb);
      -- <?xml version="1.0"?>   21 char
      --+<strategy>     10 char
      --+	<tyreType></tyreType>      21 char
      --+	<style></style>  15 char
      --+	<gasLevel></gasLevel>    21 char
      --+	<pitStopLap></pitStopLap>    25 char
      --+	<pitStopDelay></pitStopDelay>     29 char
      --+</strategy>    11 char
      --+ tot 153

      Tot_Length := 153 + GasLength + TyreLength + StyleLength + PStopLapLength + PStopDelayLength;
      XML_String := new STRING(1..Tot_Length);
      XML_String.all := "<?xml version=""1.0""?>" &
      			"<strategy>" &
			      "<tyreType>" & Tyre & "</tyreType>" &
			      "<style>" & Style.all & "</style>" &
			      "<gasLevel>" & Unbounded_String.To_String(Gas_Unb) & "</gasLevel>" &
			      "<pitStopLap>" & Unbounded_String.To_String(PStopLap_Unb) & "</pitStopLap>" &
			      "<pitStopDelay>" & Unbounded_String.To_String(PStopDelay_Unb) & "</pitStopDelay>" &
		        "</strategy>";


--      ADA.Float_Text_IO.Put(Temp_Str, strategy.Type_Tyre, Float'Base'Digits);
      return XML_String.all;
   end BoxStrategyToXML;

   procedure SendStrategy(New_Strategy : BOX_STRATEGY) is

      competitor_radio_ref : CompetitorRadio.Ref;
      strategy_xml : access STRING;
      result : BOOLEAN;
   begin

      --Initialise the connection with the competitor radio
      CORBA.ORB.Initialize("ORB");
      CORBA.ORB.String_To_Object(
                                 CORBA.To_CORBA_String(CompetitorRadio_IOR.all),competitor_radio_ref);

      --Convert the strategy in an XML string
      strategy_xml := new STRING(1..BoxStrategyToXML(New_Strategy)'LENGTH);
      strategy_xml.all := BoxStrategyToXML(New_Strategy);

      --Invoke the method to communicate the new strategy
      result := CompetitorRadio.SendStrategy(competitor_radio_ref,CORBA.To_CORBA_String(strategy_xml.all));

   end SendStrategy;

   procedure StrategyEmergencyRequest (Lap : INTEGER;
                                       Update : COMPETITION_UPDATE) is
   begin
      null;
   end StrategyEmergencyRequest;

   procedure RequestPitstop is
   begin
      null;
   end RequestPitstop;

   function GetLocalFrequency(radio : in BOX_RADIO) return INTEGER is
   begin
      return radio.Local_Frequency;
   end GetLocalFrequency;

   function GetRemoteFrequency(radio : in BOX_RADIO) return INTEGER is
   begin
      return radio.Remote_Frequency;
   end GetRemoteFrequency;

begin
   UpdatesBuffer.Init_Buffer;
   --Test init for avoiding warning. DEL
   CompetitorRadio_IOR := new STRING(1..3);
   CompetitorRadio_IOR.all := "101";

end Box;
