with Input_Sources.File;
use Input_Sources.File;
with Sax.Readers; use Sax.Readers;
with DOM.Readers; use DOM.Readers;
with DOM.Core; use DOM.Core;
with DOM.Core.Nodes; use DOM.Core.Nodes;

with Ada.IO_Exceptions;

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

end COMMON;
