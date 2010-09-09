with Input_Sources.File;
use Input_Sources.File;
with Sax.Readers; use Sax.Readers;
with DOM.Readers; use DOM.Readers;
with DOM.Core; use DOM.Core;
with DOM.Core.Nodes; use DOM.Core.Nodes;

with Ada.IO_Exceptions;
with Ada.Text_IO;

package body COMMON is
   function Style_Distance ( Style1 : DRIVING_STYLE;
                            Style2 : DRIVING_STYLE ) return INTEGER is
   begin
      if ( Style1 = CONSERVATIVE ) then
         if(Style2 = NORMAL) then
            return 1;
         elsif(Style2 = AGGRESSIVE) then
            return 2;
         else
            return 0;
         end if;
      elsif ( Style1 = NORMAL ) then
         if(Style2 = CONSERVATIVE) then
            return -1;
         elsif(Style2 = AGGRESSIVE) then
            return 1;
         else
            return 0;
         end if;
      else
         if(Style2 = NORMAL) then
            return -1;
         elsif(Style2 = CONSERVATIVE) then
            return -2;
         else
            return 0;
         end if;
      end if;
   end Style_Distance;

   function Get_Document(doc_file : STRING) return Document is
      Input : File_Input;
      Reader : Tree_Reader;
      Doc : Document;
   begin

      Open(FilePath & doc_file,Input);

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

   function SaveToFile(FileName : STRING;
                        Content : STRING;
                        Path : STRING) return BOOLEAN is
      File : Ada.Text_IO.FILE_TYPE;
   begin
      --TODO: return false if file creation fails
      Ada.Text_IO.Create(File, Ada.Text_IO.Out_File, FilePath & Path & FileName);
      Ada.Text_IO.Put(File, Content);
      Ada.Text_IO.Close(File);
      return true;
   end SaveToFile;

   protected body WAITING_BLOCK is
      entry Wait(Competitor_ID : INTEGER) when IsWait = false is
      begin
         IsWait := true;
      end Wait;

      procedure Notify is
      begin
         Ada.Text_IO.Put_Line("Notifying");
         IsWait := false;
      end Notify;

   end WAITING_BLOCK;

   function FloatToString( num : FLOAT ) return STRING is
      Temp_StringLength : INTEGER;
      Temp_String : access STRING;
      Temp_UnboundedString : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   begin

      Temp_StringLength := FLOAT'IMAGE(num)'LENGTH;
      Temp_String := new STRING(1..Temp_StringLength);
      Ada.Float_Text_IO.Put(Temp_String.all,num,8,0);

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

end COMMON;
