with Input_Sources.File;
use Input_Sources.File;
with Sax.Readers; use Sax.Readers;
with DOM.Readers; use DOM.Readers;
with DOM.Core; use DOM.Core;

package Common is
   type PERCENTAGE is delta 0.01 range 0.0..100.0;
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
private
   type IP_ADDRESS is array(1..4) of INTEGER; -- TODO: bound the INTEGER within 0..255
end Common;
