with CORBA.ORB;

with Ada.Calendar;
use Ada.Calendar;
with Ada.Exceptions;

with Broker.Radio.Competition_Monitor_Radio;

--with PolyORB.Utils.Report;
--with Monitor_Radio;

with Input_Sources.File;
use Input_Sources.File;
with Sax.Readers; use Sax.Readers;
with DOM.Readers; use DOM.Readers;
with DOM.Core; use DOM.Core;
with DOM.Core.Documents; use DOM.Core.Documents;
with DOM.Core.Nodes; use DOM.Core.Nodes;
with DOM.Core.Attrs; use DOM.Core.Attrs;

with Ada.Text_IO;
with ADA.Float_Text_IO;

package body Box is


   --Competitor_Qty : Integer := 10;
   --TODO:if possible, sooner or later try to use the cmpetitor classific
   --+ for calculating the Strategy

   -- Circuit length. Initialised after the competitor registration
   Circuit_Length : Float := 6.0;

   -- Hypothetical values for the gas and tyre consumption.
   --+ These are generic values, not connected neither to the type
   --+ of circuit nor to the driving style of the competitor. They're
   --+ ought to be used to calculate the first statistics when
   --+no statistical information are available yet.
   Mean_Tyre_Usury_Per_Km : Percentage := 0.83;
   Mean_Litre_Per_Km : Float := 0.68;

   -- Total laps
   Laps : Integer := 0;

   procedure Init(Laps_In : in Integer;
                  Circuit_Length_In : in Float;
                  Competitor_Id_In : in Integer;
                  Box_Strategy_In : in Artificial_Intelligence.Box_Strategy;
                  Gas_Tank_Capacity_In : Float) is
   begin

      Laps := Laps_In;
      --TODO: decide wheter to you km or m for the circuit length and
      --+ keep this unit wherever.
      Circuit_Length := Circuit_Length_In/1000.00;
      Competitor_Id := Competitor_Id_In;

      Artificial_Intelligence.Configure(Laps_In,
                                        Box_Strategy_In,
                                        Gas_Tank_Capacity_In,
                                        Circuit_Length_In/1000.00);

   end Init;

   task body Update_Retriever is

      Info_XMLStr : Unbounded_String.Unbounded_String;
      Info : Competition_Update_Point;
      Time : Float;
      Metres : Float;
      CorbaInfo : CORBA.String;
      Sector : Integer := 1;
      Lap : Integer := 0;
      UpdateBuffer : Synch_Competition_Updates_Point := Shared_Buffer;

      Radio : Broker.Radio.Competition_Monitor_Radio.Ref;
      Radio_Corba_Loc : STRING := Unbounded_String.To_String(Monitor_Radio_CorbaLOC.all);

      --Generic boolean
      Success : BOOLEAN := false;
   begin

      --CORBA.ORB.Initialize("ORB");
      Corba.ORB.String_To_Object(CORBA.To_CORBA_String
                                 (Radio_Corba_Loc) , Radio);

      if Broker.Radio.Competition_Monitor_Radio.Is_Nil(Radio) then
         Ada.Text_IO.Put_Line("Monitor radio down");

      end if;


      Ada.Text_IO.Put_Line("Updater Starting");

      Success := Broker.Radio.Competition_Monitor_Radio.Ready(Radio,CORBA.Short(Competitor_Id));


      -- Test init values to avoid warnings DEL
      Info := new Competition_Update;
      loop


         declare
               INFO_GOT : BOOLEAN := false;
         begin

		loop


               Ada.Text_IO.Put_Line("Updater asking for info");
		      Broker.Radio.Competition_Monitor_Radio.Get_CompetitorInfo
		      (
		      Radio,
		      CORBA.Short(Lap),
		      CORBA.Short(Sector),
		      CORBA.Short(Competitor_Id),
		      CORBA.Float(Time),
		      CORBA.Float(Metres),
		      CorbaInfo);



		      Info_XMLStr := Unbounded_String.To_Unbounded_String(CORBA.To_Standard_String(CorbaInfo));
               Ada.Text_IO.Put_Line("Updater parsing info");

               Info := XML2CompetitionUpdate(Unbounded_String.To_String(Info_XMLStr),"../temp/competitor-" & Common.IntegerToString(Competitor_Id) & "-update.xml");

               Ada.Text_IO.Put_Line("Update savinmg");
		      INFO_GOT := true;
		      exit when INFO_GOT = true;
		end loop;
		exception
		      when Error : others =>
			  Ada.Text_IO.Put_Line("Exception: " & Ada.Exceptions.Exception_Message(Error));
			  delay until(Ada.Calendar.Clock + Standard.Duration(3));
         end;

         Info.Time := Time;


         Info.Path_Length := Metres;

         UpdateBuffer.Add_Data(Info);


         if(Sector = Sector_Qty) then
            Sector := 0;
            Lap := Lap + 1;
         end if;

         exit when (Info.Gas_Level <= 0.0 or Info.Tyre_Usury >= 100.0) or else Lap = Laps;

         Sector := Sector + 1;
      end loop;




   end Update_Retriever;

   task body Strategy_Updater is
      Index : Integer := 1;
      New_Info : Competition_Update_Point;
      Evolving_Strategy : Strategy;
      All_Info : Box_Data.Synch_All_Info_Buffer_Point := All_Info_Buffer;
      UpdateBuffer : Synch_Competition_Updates_Point := Shared_Buffer;
      Strategy_History : SYNCH_Strategy_HISTORY_POINT := Shared_History;

      -- The starting value are hypothetic value depending on the static
      --+ configuration of a generic F1 car
      Latest_Lap_Mean_Gas_Consumption : Float := Mean_Litre_Per_Km;
      Latest_Lap_Mean_Tyre_Usury : Float := Mean_Tyre_Usury_Per_Km;
      -- Variables used to calculate the means progressively
      Previous_Sector_Gas_Level : Float := Initial_Gas_Level.all;
      Previous_Sector_Tyre_Usury : Float := 0.0;
      Partial_Gas_Consumption_Mean : Float := Mean_Litre_Per_Km;
      Partial_Tyre_Usury_Mean : Float := Mean_Tyre_Usury_Per_Km;

      --it starts from 1 because the Strategy is updated once the competitor reaches
      --+ sector previous to the last one. So the first lap Strategy will be calculated
      --+ using only the firts 2 sectors.
      Sector : Integer := 2;

      Skip : Integer := 0;
      Extended_Information : Extended_Competition_Update;
   begin


      New_Info := new Competition_Update;
      --The first Strategy is stored before the beginning of the competition
      --+ and it's calculated against some configured parameter and some hypothetical
      --+ values

      Ada.Text_IO.Put_Line("Calculate first doable laps");
      Evolving_Strategy.PitStopLaps := Artificial_Intelligence.Calculate_Doable_Laps(Initial_Gas_Level.all,
                                                                                     0.0,
                                                                                     Latest_Lap_Mean_Gas_Consumption,
                                                                                     Latest_Lap_Mean_Tyre_Usury);

      Evolving_Strategy.Tyre_Type := Unbounded_String.To_Unbounded_String(Initial_Tyre_Type.all);
      Evolving_Strategy.Style := NORMAL;
      Evolving_Strategy.Gas_Level := Initial_Gas_Level.all;
      Evolving_Strategy.PitStopDelay := 0.0;

      Ada.Text_IO.Put_Line("Adding strategy");
      Strategy_History.AddStrategy(Evolving_Strategy);

      Ada.Text_IO.Put_Line("Done");
      -- Time = -1.0 means that race is over (think about when the competitor
      --+ is out of the race).
      loop

         UpdateBuffer.Get_Update(New_Info.all, Index);


         Box_Data.Competition_Update(Extended_Information) := New_Info.all;


         if( New_Info.Gas_Level < 0.0 ) then
            New_Info.Gas_Level := 0.0;
         end if;

         -- The following 7 lines handle the problem of the pitstop lap.
         --+ When the car does the pitstop, the statystics of bot the 3rd
         --+ and the 1st sectors get altered by the pitstop lane.
         --+ So, after the pitstop done, we use the latest consumption means
         --+ to compute the statystic for the lap following the pitstop one.
         --+ (for the sector before the box and the following one, the 2 sectors
         --+ affected.

         if( Skip /= 0 ) then

            Skip := Skip - 1;
            Partial_Gas_Consumption_Mean := Partial_Gas_Consumption_Mean +
              Latest_Lap_Mean_Gas_Consumption;
            Previous_Sector_Gas_Level := New_Info.Gas_Level;

            Extended_Information.Mean_Gas_Consumption := Latest_Lap_Mean_Gas_Consumption;

            Partial_Tyre_Usury_Mean := Partial_Tyre_Usury_Mean +
              Latest_Lap_Mean_Tyre_Usury;
            Previous_Sector_Tyre_Usury := New_Info.Tyre_Usury;

            Extended_Information.Mean_Tyre_Usury := Latest_Lap_Mean_Tyre_Usury;

            --TODO: don't use so stupid values for the means
         else


            Partial_Gas_Consumption_Mean :=
              Partial_Gas_Consumption_Mean +
                ((Previous_Sector_Gas_Level - New_Info.Gas_Level)/
                 (New_Info.Path_Length/1000.0) -- We want the ratio in Km

              );

            Extended_Information.Mean_Gas_Consumption :=
              (Previous_Sector_Gas_Level - New_Info.Gas_Level)/
              (New_Info.Path_Length/1000.0);


            Previous_Sector_Gas_Level := New_Info.Gas_Level;


            Partial_Tyre_Usury_Mean :=
              Partial_Tyre_Usury_Mean +
                (New_Info.Tyre_Usury - Previous_Sector_Tyre_Usury)/
                ((New_Info.Path_Length/1000.0) -- We want the ratio in Km

                );

            Extended_Information.Mean_Tyre_Usury :=
              (New_Info.Tyre_Usury - Previous_Sector_Tyre_Usury)/
                (New_Info.Path_Length/1000.0);

            Previous_Sector_Tyre_Usury := New_Info.Tyre_Usury;
         end if;

         Index := Index + 1;



         exit when (New_Info.Gas_Level <= 0.0 or New_Info.Tyre_Usury >= 100.0) or else --The car is out
           (New_Info.Lap = Laps-1 and New_Info.Sector = 3); --The competition is over



         if(Sector = Sector_Qty) then

            Evolving_Strategy := Artificial_Intelligence.Compute_Strategy(New_Info.all,
                                                                          Evolving_Strategy,
                                                                          Latest_Lap_Mean_Gas_Consumption,
                                                                          Latest_Lap_Mean_Tyre_Usury);

            --  "/3" because it's the sum of the mean of 3 sectors
             Latest_Lap_Mean_Gas_Consumption := Partial_Gas_Consumption_Mean/3.0;
            Latest_Lap_Mean_Tyre_Usury := Partial_Tyre_Usury_Mean/3.0;

            Strategy_History.AddStrategy(Evolving_Strategy);
            Sector := 0;
            Partial_Gas_Consumption_Mean := 0.0;
            Partial_Tyre_Usury_Mean := 0.0;

            All_Info.Add_Info(Update_In   => Extended_Information,
                             Strategy_In => Evolving_Strategy);

            if(Evolving_Strategy.PitStopLaps = 0) then
               Skip := 2;
            end if;

         else

            All_Info.Add_Info(Update_In   => Extended_Information);

         end if;

         Sector := Sector + 1;

      end loop;

      All_Info.Add_Info(Update_In   => Extended_Information);



   end Strategy_Updater;

   --StrategyUpdater_Task : access Strategy_Updater;

   -- Used to send to the client interface the information concerning the competition
   function CompetitionUpdateToXML(update : Competition_Update) return STRING is

      Competitor_Qty : Integer := 0;

      XML_String : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;

      begin

      --Updating related to the classific are temporary removed.
      --if update.Classific /= null then
        -- Competitor_Qty := update.Classific'LENGTH;
      --end if;

      XML_String := Unbounded_String.To_Unbounded_String("<update>" &
                                                         "<gasLevel>" & Common.FloatToString(update.Gas_Level) & "</gasLevel> <!-- % -->" &
                                                         "<tyreUsury>" & Common.FloatToString(update.Tyre_Usury) & "</tyreUsury> <!-- % -->" &
                                                         --"<meanSpeed>" & Common.FloatToString(update.MeanSpeed) & "</meanSpead> <!-- km/h --> " &
                                                         --"<Mean_Gas_Consumption>" & Common.FloatToString(update.Mean_Gas_Consumption) & "</Mean_Gas_Consumption> <!-- l/h --> " &
                                                         "<lap>" & Common.IntegerToString(update.Lap) & "</lap> " &
                                                         "<sector>" & Common.IntegerToString(update.Sector) & "</sector>" &
                                                         "</update>" );-- &
                                                         --"<classific competitors="" " & Common.IntegerToString(Competitor_Qty) & " "" >   <!-- competitor ids, pol position = first one --> ");
      -- The classific is expressed as an Integer sequence where the first place
      --+ in the competition is related to the first position in the array.
      --for Index in 1..Competitor_Qty loop
        -- XML_String := XML_String & "<compId>" & Common.IntegerToString(update.Classific(Index)) & "</compId> ";
      --end loop;

      --XML_String := XML_String & "</classific></update> ";

      return Unbounded_String.To_String(XML_String);
   end CompetitionUpdateToXML;

   function XML2CompetitionUpdate(UpdateStr_In : STRING;
                                  Temporary_StringName : STRING) return Competition_Update_Point is
      Update : Competition_Update_Point := new Competition_Update;
      Doc : Document;
      Update_NodeList : Node_List;
      Current_Node : NODE;

      Gas_Level : Float;
      Max_Speed : Float;
      Tyre_Usury : Percentage;
  --    Time : Float;
      Lap : Integer;
      Sector : Integer;
  --    Path_Length : Float;

      --Update_FileName : Unbounded_String.Unbounded_String := Unbounded_String.To_Unbounded_String("new_update.xml");
      Success : BOOLEAN := false;
   begin
      --TODO: handle the exception

      Success := Common.SaveToFile(FileName => Temporary_StringName,
                        Content  => UpdateStr_In,
                        Path     => "");

      Doc := Common.Get_Document(Temporary_StringName);

      Update_NodeList := Get_Elements_By_Tag_Name(Doc,"update");

      Current_Node := Item(Update_NodeList,0);

      Gas_Level := Float'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"gasLevel"))));

      Max_Speed := Float'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"maxSpeed"))));

      Tyre_Usury := Float'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"tyreUsury"))));

      Lap := Integer'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"lap"))));

      Sector := Integer'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"sector"))));

--      Time := Float'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"time"))));

--      Path_Length := Float'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"metres"))));

      Update.Max_Speed := Max_Speed;

      Update.Gas_Level := Gas_Level;

      Update.Tyre_Usury := Tyre_Usury;

--      Update.Time := Time;
      Update.Lap := Lap;
      Update.Sector := Sector;
--      Update.Path_Length := Path_Length;


      return Update;
   end XML2CompetitionUpdate;

end Box;
