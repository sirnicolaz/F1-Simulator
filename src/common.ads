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
   subtype ANGLE_GRADE is FLOAT range 0.0..360.00;
   subtype DIFFICULTY_RANGE is FLOAT range 0.0..10.0;
   subtype GRIP_RANGE is FLOAT range 0.0..10.0;
   type COMPETITOR_LIST is array(INTEGER range <>) of INTEGER;
   type FLOAT_POINT is access FLOAT;
   type STRING_POINT is access STRING;
   type FLOAT_ARRAY is array(INTEGER range <>) of FLOAT;
   type UNBOUNDED_STRING_POINT is access Unbounded_String.Unbounded_String;

   type STRATEGY is record
      Type_Tyre : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Style : DRIVING_STYLE;
      GasLevel : FLOAT;
      PitStopLaps : INTEGER;
      PitStopDelay : FLOAT;
   end record;

   function SaveToFile(FileName : STRING;
                        Content : STRING;
                       Path : STRING) return BOOLEAN;

   -- It returns the distance between to driving styles
   --+ (ie: between NORMAL and AGGRESSIVE there only one step forward, so the distance
   --+ is 1 )
   function Style_Distance ( Style1 : DRIVING_STYLE;
                            Style2 : DRIVING_STYLE ) return INTEGER;

   --Open and parse an XML document starting from the document name
   function Get_Document(doc_file : STRING) return Document;

   --Given a starting node and a tag name, the method returns
   --+ the first node with the given tag name, child of the Node_In
   function Get_Feature_Node(Node_In : NODE;
                             FeatureName_In : STRING) return NODE;

   --Convert a float into a string, not in the exponential notation: 42.0 and not 4.20000E1
   function FloatToString( num : FLOAT ) return STRING;

   --Convert an integer into a string
   function IntegerToString( num : INTEGER ) return STRING;


private


end Common;
