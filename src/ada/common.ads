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

   subtype Percentage is Float range 0.0..100.0;
   type Driving_Style is (AGGRESSIVE,NORMAL,CONSERVATIVE);
   subtype Angle_Grade is Float range 0.0..360.00;
   subtype Difficulty_Range is Float range 0.0..10.0;
   subtype Grip_Range is Float range 0.0..10.0;
   type Competitor_List is array ( Integer range <> ) of Integer;
   type Float_Point is access Float;
   type String_Point is access String;
   type Float_Array is array ( Integer range <> ) of Float;
   type Float_Array_Point is access Float_Array;
   type Integer_Array is array ( Integer range <> ) of Integer;
   type Integer_Array_Point is access Integer_Array;
   type UNBOUNDED_String_Point is access Unbounded_String.Unbounded_String;


   FilePath : constant String(1..8) := "../temp/";

   type Strategy is record
      Tyre_Type : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Style : Driving_Style;
      Gas_Level : Float;
      Laps_To_Pitstop : Integer; --PitStopLaps
      Pit_Stop_Delay : Float;
   end record;

   --Used to simulate wait and notify
   protected type WAITING_BLOCK is
      entry Wait(Competitor_ID : Integer);
      procedure Notify;
   private
      IsWait : BOOLEAN := TRUE;
   end WAITING_BLOCK;

   type WAITING_BLOCK_Array is Array(POSITIVE range <>) of WAITING_BLOCK;

   function SaveToFile(FileName : String;
                        Content : String;
                       Path : String) return BOOLEAN;

   -- It returns the distance between to driving styles
   --+ (ie: between NORMAL and AGGRESSIVE there only one step forward, so the distance
   --+ is 1 )
   function Style_Distance ( Style1 : Driving_Style;
                            Style2 : Driving_Style ) return Integer;

   --Open and parse an XML document starting from the document name
   function Get_Document(doc_file : String) return Document;

   --Given a starting node and a tag name, the method returns
   --+ the first node with the given tag name, child of the Node_In
   function Get_Feature_Node(Node_In : NODE;
                             FeatureName_In : String) return NODE;

   --Convert a Float into a String, not in the exponential notation: 42.0 and not 4.20000E1
   function Float_To_String( num : Float ) return String;

   --Convert an Integer into a String
   function Integer_To_String( num : Integer ) return String;


private


end Common;
