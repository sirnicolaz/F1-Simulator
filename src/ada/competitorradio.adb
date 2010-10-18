with Input_Sources.File;
use Input_Sources.File;
with Sax.Readers; use Sax.Readers;
with DOM.Readers; use DOM.Readers;
with DOM.Core; use DOM.Core;
with DOM.Core.Documents; use DOM.Core.Documents;
with DOM.Core.Nodes; use DOM.Core.Nodes;
with DOM.Core.Attrs; use DOM.Core.Attrs;

package body CompetitorRadio is

   procedure Init_BoxConnection ( BoxRadio_CorbaLOC : in STRING;
                                 Radio : out BOX_CONNECTION;
                                 ID : in INTEGER;
                                 Success : out BOOLEAN) is
   begin

      Radio.CompetitorID := ID;

      CORBA.ORB.String_To_Object
        (CORBA.To_CORBA_String (BoxRadio_CorbaLOC), Radio.Connection);

      --  Checking if it worked
      if Broker.Radio.BoxRadio.Is_Nil (Radio.Connection) then
         Success := false;
      else
         Success := true;
      end if;

   end Init_BoxConnection;

   procedure Close_BoxConnection ( Radio : out BOX_CONNECTION) is
   begin
      --Release the resource
      Broker.Radio.BoxRadio.Release(Radio.Connection);
   end Close_BoxConnection;

   --Helper method (given a file name, it return the strategy object extracted from that file)
   function XML_To_Strategy( StrategyFile : Unbounded_String.Unbounded_String) return Strategy is
      -- Objects needed for reading the XML strategy file
      Config : Node_List;
      Current_Node : NODE;
      Strategy_Doc : DOCUMENT;

      Tmp_Strategy : Strategy;
      StyleStr : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   begin

      Strategy_Doc := Common.Get_Document(doc_file => Unbounded_String.To_String(StrategyFile));
      Config := Get_Elements_By_Tag_Name(Strategy_Doc,"strategy");
      Current_Node := Item(Config,0);

      Tmp_Strategy.Tyre_Type := Unbounded_String.To_Unbounded_String(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"tyreType"))));
      Tmp_Strategy.Gas_Level := Float'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"gasLevel"))));
      Tmp_Strategy.Laps_To_Pitstop := Integer'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"Laps_To_Pitstop"))));
      Tmp_Strategy.Pit_Stop_Delay := Float'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"Pit_Stop_Delay"))));

      StyleStr := Unbounded_String.To_Unbounded_String(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"style"))));

      if(StyleStr = "Aggressive") then
         Tmp_Strategy.Style := Common.AGGRESSIVE;
      elsif(StyleStr = "Conservative") then
         Tmp_Strategy.Style := Common.CONSERVATIVE;
      else
         Tmp_Strategy.Style := Common.NORMAL;
      end if;

      return Tmp_Strategy;

   end XML_To_Strategy;

   function Get_Strategy( Radio : BOX_CONNECTION;
                         Lap : in INTEGER) return Strategy is
      Strategy_XML : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      File_Name : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   begin
      Ada.Text_IO.Put_Line(INTEGER'IMAGE(Radio.CompetitorID)
                           &" Connecting for strategy");

      Strategy_XML := Unbounded_String.To_Unbounded_String(
                                                           CORBA.To_Standard_String
                                                             (Broker.Radio.BoxRadio.RequestStrategy(Radio.Connection,CORBA.Short(Lap))));

      Ada.Text_IO.Put_Line(INTEGER'IMAGE(Radio.CompetitorID)
                           &" connected succesfully");

      File_Name := Unbounded_String.To_Unbounded_String("Strategy-" & Common.Integer_To_String(Radio.CompetitorID));

      if Common.SaveToFile(FileName => Unbounded_String.To_String(File_Name),
                           Content  => Unbounded_String.To_String(Strategy_XML),
                           Path     => "") then
         Ada.Text_IO.Put_Line(INTEGER'IMAGE(Radio.CompetitorID)
                              &" saved");

         return XML_To_Strategy(StrategyFile => File_Name);

         --return Unbounded_String.To_String(File_Name);
      else
         declare
            Empty_Strategy : Strategy;
         begin
            Empty_Strategy.Laps_To_Pitstop := -1;
            Ada.Text_IO.Put_Line(INTEGER'IMAGE(Radio.CompetitorID)
                                 &" fail");
            return Empty_Strategy;
         end;
      end if;
   end Get_Strategy;

end CompetitorRadio;
