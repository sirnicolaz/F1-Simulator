with Ada.Text_IO;

with Broker.Init.CompetitionConfigurator.Skel;
pragma Warnings (Off, Broker.Init.CompetitionConfigurator.Skel);
with CORBA;

use Broker.Init.CompetitionConfigurator;

with Common;

with Ada.Strings.Unbounded;
with Sax.Readers; use Sax.Readers;
with DOM.Readers; use DOM.Readers;
with DOM.Core; use DOM.Core;
with DOM.Core.Documents; use DOM.Core.Documents;
with DOM.Core.Nodes; use DOM.Core.Nodes;

package body Broker.Init.CompetitionConfigurator.impl is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   Comp : SYNCH_COMPETITION_POINT;

   procedure Init( Comp_In : in SYNCH_COMPETITION_POINT ) is
   begin
      Comp := Comp_In;
   end Init;

   function Configure(Self : access Object;
                      config_file : CORBA.STRING) return CORBA.STRING is
      Name : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Circuit_File : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Competitor_Qty : INTEGER;
      Laps : INTEGER;

      Config : Node_List;
      Current_Node : NODE;
      Config_Doc : DOCUMENT;
   begin

      Config_Doc := Common.Get_Document(doc_file => CORBA.To_Standard_String(config_file));

      Config := Get_Elements_By_Tag_Name(Config_Doc,"config");
      Current_Node := Item(Config,0);

      Name := Unbounded_String.To_Unbounded_String(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"name"))));
      Circuit_File := Unbounded_String.To_Unbounded_String(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"circuitConfigFile"))));
      Competitor_Qty := POSITIVE'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"competitorQty"))));
      Laps := POSITIVE'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"laps"))));

      Comp.Configure(Competitor_Qty,Unbounded_String.To_String(Name),Laps,Unbounded_String.To_String(Circuit_File));

      return CORBA.To_CORBA_String(Comp.Get_MonitorCorbaLOC);
   end Configure;

end Broker.Init.CompetitionConfigurator.impl;
