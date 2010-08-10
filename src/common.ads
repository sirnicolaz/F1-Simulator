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
   type FLOAT_LIST is array(INTEGER range <>) of FLOAT;
   subtype IP_PART is INTEGER range 0..255;
   type IP_ADDRESS is private;

   procedure Set_IpAddress(ip_out : out IP_ADDRESS;
                 ip_string : in STRING);
   function Get_IpAddress(ip : in IP_ADDRESS) return STRING;

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

   type COMP_STATS is private;
   type COMP_STATS_POINT is access COMP_STATS;


   procedure Set_Checkpoint(Stats_In : out COMP_STATS_POINT; Checkpoint_In : INTEGER);
   procedure Set_Sector(Stats_In : out COMP_STATS_POINT; Sector_In : INTEGER);
   procedure Set_Lap(Stats_In : out COMP_STATS_POINT; Lap_In : INTEGER);
   procedure Set_Gas(Stats_In : out COMP_STATS_POINT; Gas_In : FLOAT);--PERCENTAGE); --meglio float
   procedure Set_Tyre(Stats_In : out COMP_STATS_POINT; Tyre_In : FLOAT);--PERCENTAGE); -- meglio float
   procedure Set_Time(Stats_In : out COMP_STATS_POINT; Time_In : FLOAT);
   procedure Set_LastCheckInSect(Stats_In : out COMP_STATS_POINT; LastCheck_In : BOOLEAN);
   procedure Set_FirstCheckInSect(Stats_In : out COMP_STATS_POINT; FirstCheck_In : BOOLEAN);
   --procedure Set_Index(Stats_In : out COMP_STATS_POINT; Index_In : INTEGER);
   procedure Update_Stats(compStats : in out COMP_STATS_POINT);-- global : GLOBAL_STATS_HANDLER_POINT);

   function Get_Checkpoint(Stats_In : COMP_STATS) return INTEGER;
   function Get_Sector(Stats_In : COMP_STATS) return INTEGER;
   function Get_Lap(Stats_In : COMP_STATS) return INTEGER;
   function Get_Gas(Stats_In : COMP_STATS) return FLOAT;--PERCENTAGE;
   function Get_Tyre(Stats_In : COMP_STATS) return FLOAT;--PERCENTAGE;
   function Get_Time(Stats_In : COMP_STATS) return FLOAT;
   function Get_LastCheckInSect(Stats_In : COMP_STATS_POINT) return BOOLEAN;


private
   type IP_ADDRESS is array(1..4) of INTEGER; -- TODO: bound the INTEGER within 0..255

   type COMP_STATS is record
      Checkpoint : INTEGER;
      -- Is this the last check-point in the sector?
      LastCheckInSect : BOOLEAN;
      -- Is this the first check-point in the sector?
      FirstCheckInSect : BOOLEAN;
      Sector : INTEGER;
      Lap : INTEGER;
      Time : FLOAT;
      GasLevel : FLOAT;--PERCENTAGE;
      TyreUsury : FLOAT;--PERCENTAGE;
                        -- GLOBAL_STATS_HANDLER_POINT section
      --sgs_In : S_GLOB_STATS_POINT;
      updatePeriod_In : FLOAT := 100.0; --TODO : fissare altro valore, valutare
      --global : GLOBAL_STATS_HANDLER_POINT; --:= initGlobalStatsHandler(global, sgs_In, updatePeriod_In);
   end record;

end Common;
