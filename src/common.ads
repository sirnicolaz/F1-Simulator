with Input_Sources.File;
use Input_Sources.File;
with Sax.Readers; use Sax.Readers;
with DOM.Readers; use DOM.Readers;
with DOM.Core; use DOM.Core;

with Ada.Strings.Unbounded;
with Ada.Strings.Fixed;

with Ada.Float_Text_IO;


package Common is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   subtype PERCENTAGE is FLOAT range 0.0..100.0;
   type DRIVING_STYLE is (AGGRESSIVE,NORMAL,CONSERVATIVE);
   type COMPETITORS_LIST is array(INTEGER range <>) of INTEGER;
   type FLOAT_LIST is array(INTEGER range <>) of FLOAT;
   subtype IP_PART is INTEGER range 0..255;
   type IP_ADDRESS is private;

   procedure Set_IpAddress(ip_out : out IP_ADDRESS;
                 ip_string : in STRING);
   function Get_IpAddress(ip : in IP_ADDRESS) return STRING;

   --Open and parse an XML document starting from the document name
   function Get_Document(doc_file : STRING) return Document;

   --Convert a float into a string, not in the exponential notation: 42.0 and not 4.20000E1
   function FloatToString( num : FLOAT ) return STRING;

   --Convert an integer into a string
   function IntegerToString( num : INTEGER ) return STRING;

private
   type IP_ADDRESS is array(1..4) of INTEGER; -- TODO: bound the INTEGER within 0..255
end Common;
