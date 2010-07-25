with Input_Sources.File;
use Input_Sources.File;
with Sax.Readers; use Sax.Readers;
with DOM.Readers; use DOM.Readers;
with DOM.Core; use DOM.Core;
with DOM.Core.Nodes; use DOM.Core.Nodes;

with Ada.IO_Exceptions;
with Ada.Text_IO;

package body COMMON is
   procedure Set_IpAddress(ip_out : out IP_ADDRESS;
                           ip_string : in STRING) is
   begin
      null;
      --TODO: find a way to manage Strings in ADA
   end Set_IpAddress;

   function Get_IpAddress(ip : in IP_ADDRESS) return STRING is
   begin
      --TODO: the same as above
        return "127.0.0.1";
   end Get_IpAddress;

   function Get_Document(doc_file : STRING) return Document is
      Input : File_Input;
      Reader : Tree_Reader;
      Doc : Document;
   begin

      Open(doc_file,Input);

      Set_Feature(Reader,Validation_Feature,False);
      Set_Feature(Reader,Namespace_Feature,False);

      Parse(Reader,Input);

      Doc := Get_Tree(Reader);

      return Doc;
   exception
      when ADA.IO_EXCEPTIONS.NAME_ERROR => Doc := null;
         return Doc;
         --TODO: do something after this exception that's not returning a null pointer
   end Get_Document;

   function Get_Feature_Node(Node_In : NODE;
                             FeatureName_In : STRING) return NODE is
      Child_Nodes_In : NODE_LIST;
      Current_Node : NODE;
   begin

      Child_Nodes_In := Child_Nodes(Node_In);
      for Index in 1..Length(Child_Nodes_In) loop
         Current_Node := Item(Child_Nodes_In,Index-1);
         if Node_Name(Current_Node) = FeatureName_In then
            return Current_Node;
         end if;
      end loop;

      return null;
   end Get_Feature_Node;

   function FloatToString( num : FLOAT ) return STRING is
      Temp_StringLength : INTEGER;
      Temp_String : access STRING;
      Temp_UnboundedString : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   begin

      Temp_StringLength := FLOAT'IMAGE(num)'LENGTH;
      Temp_String := new STRING(1..Temp_StringLength);
      Ada.Float_Text_IO.Put(Temp_String.all,num,0,0);

      Temp_UnboundedString := Unbounded_String.To_Unbounded_String(Ada.Strings.Fixed.Trim(Temp_String.all,Ada.Strings.Left));
      return Unbounded_String.To_String(Temp_UnboundedString);
   end FloatToString;

   function IntegerToString( num : INTEGER ) return STRING is
      Temp_StringLength : INTEGER;
      Temp_String : access STRING;
      Temp_UnboundedString : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   begin

      Temp_StringLength := INTEGER'IMAGE(num)'LENGTH;
      Temp_String := new STRING(1..Temp_StringLength);
      Temp_String.all := INTEGER'IMAGE(num);

      Temp_UnboundedString := Unbounded_String.To_Unbounded_String(Ada.Strings.Fixed.Trim(Temp_String.all,Ada.Strings.Left));

      return Unbounded_String.To_String(Temp_UnboundedString);

   end IntegerToString;

   procedure Set_Checkpoint(Stats_In : out COMP_STATS_POINT; Checkpoint_In : INTEGER) is
   begin
      Stats_In := new COMP_STATS;
      Stats_In.Checkpoint := Checkpoint_In;
   end Set_Checkpoint;

   procedure Set_Sector(Stats_In : out COMP_STATS_POINT; Sector_In : INTEGER) is
   begin
      Stats_In.Sector := Sector_In;
   end Set_Sector;

   procedure Set_Lap(Stats_In : out COMP_STATS_POINT; Lap_In : INTEGER) is
   begin
      Stats_In.Lap := Lap_In;
   end Set_Lap;

   procedure Set_Gas(Stats_In : out COMP_STATS_POINT; Gas_In : 	FLOAT) is
   begin
      Stats_In.GasLevel := Gas_In;
   end Set_Gas;

   procedure Set_Tyre(Stats_In : out COMP_STATS_POINT; Tyre_In : FLOAT) is
   begin
      Stats_In.TyreUsury := Tyre_In;
   end Set_Tyre;

   procedure Set_Time(Stats_In : out COMP_STATS_POINT; Time_In : FLOAT) is
   begin
      Stats_In.Time := Time_In;
   end Set_Time;

   procedure Set_LastCheckInSect(Stats_In : out COMP_STATS_POINT; LastCheck_In : BOOLEAN) is
   begin
      Stats_In.LastCheckInSect := LastCheck_In;
   end Set_LastCheckInSect;

   procedure Set_FirstCheckInSect(Stats_In : out COMP_STATS_POINT; FirstCheck_In : BOOLEAN) is
   begin
      Stats_In.FirstCheckInSect := FirstCheck_In;
   end Set_FirstCheckInSect;

--     procedure Set_Index(Stats_In : out COMP_STATS_POINT; Index_In : INTEGER) is
--     begin
--        Stats_In.
   function Get_LastCheckInSect(Stats_In : COMP_STATS_POINT) return BOOLEAN is
   begin
      return Stats_In.LastCheckInSect;
   end Get_LastCheckInSect;

   function Get_Checkpoint(Stats_In : COMP_STATS) return INTEGER is
   begin
      return Stats_In.Checkpoint;
   end Get_Checkpoint;

   function Get_Sector(Stats_In : COMP_STATS) return INTEGER is
   begin
      return Stats_In.Sector;
   end Get_Sector;

   function Get_Lap(Stats_In : COMP_STATS) return INTEGER is
   begin
      return Stats_In.Lap;
   end Get_Lap;

   function Get_Gas(Stats_In : COMP_STATS) return FLOAT is
   begin
      return Stats_In.GasLevel;
   end Get_Gas;

   function Get_Tyre(Stats_In : COMP_STATS) return FLOAT is
   begin
      return Stats_In.TyreUsury;
   end Get_Tyre;

   function Get_Time(Stats_In : COMP_STATS) return FLOAT is
   begin
      return Stats_In.Time;
   end Get_Time;

   procedure Update_Stats(compStats : in out COMP_STATS_POINT) is-- , global : GLOBAL_STATS_HANDLER) is
   begin
      Ada.Text_IO.Put_Line("Update_Stats");
--        Ada.Text_IO.Put_Line(Integer'Image(compStats.sgs_In.Get_CompetitorsQty));
--initGlobalStatsHandler(compStats.global,compStats.sgs_In, 100.0);
--  	updateCompetitorInfo(compStats)
   end Update_Stats;



end COMMON;
