with Circuit;
use Circuit;

with Input_Sources.File;
use Input_Sources.File;
with Sax.Readers; use Sax.Readers;
with DOM.Readers; use DOM.Readers;
with DOM.Core; use DOM.Core;
with DOM.Core.Documents; use DOM.Core.Documents;
with DOM.Core.Nodes; use DOM.Core.Nodes;
with DOM.Core.Attrs; use DOM.Core.Attrs;
with Ada.IO_Exceptions;

with Competitor_Computer;
use Competitor_Computer;

with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Strings;
with Ada.Strings.Unbounded;

with CompetitorRadio;
use CompetitorRadio;

with Common;
package Competitor is
   package Str renames Ada.Strings.Unbounded;
   use type Str.Unbounded_String;

   procedure Set_Laps( LapsQty : in Integer);

   -- Competitor components
   type VEL is array (POSITIVE range <>) of Float;
   type Driver is private;

   type Car is private;

   type Competitor_Details is private;

   type Competitor_Details_Point is Access Competitor_Details;

   -- Get Methods
   function Get_First_Name(Competitor_In : Competitor_Details_Point) return Str.Unbounded_String;
   function Get_Tyre_Usury(Competitor_In : Competitor_Details_Point) return Common.PERCENTAGE;
   function Get_Gasoline_Level(Competitor_In : Competitor_Details_Point) return Float;
   function Get_Max_Acceleration(Competitor_In : Competitor_Details_Point) return Float;
   function Get_Last_Speed_Reached(Competitor_In : Competitor_Details_Point) return Float;
   function Get_Strategy_Style(Competitor_In : Competitor_Details_Point) return Common.Driving_Style;
   function Init_Competitor(Xml_File : STRING;
                            Current_Circuit_Race_Iterator : Racetrack_Iterator;
                            Id_In : Integer;
                            Laps_In : Integer;
                            BoxRadio_CorbaLoc : in STRING) return Competitor_Details_Point;

   procedure Configure_Car(Car_In : in out Car;
                           Max_Speed_In : Float;
                           Max_Acceleration_In : Float;
                           Gas_Tank_Capacity_In : Float;
                           Engine_In : Str.Unbounded_String;
                           Tyre_Usury_In : Common.Percentage;
                           Gasoline_Level_In : Float;
                           Mixture_In : Str.Unbounded_String;
                           Model_In : Str.Unbounded_String;
                           Tyre_Type_In : Str.Unbounded_String);

   function Calculate_Status(infoLastSeg : in Competitor_Details_Point) return BOOLEAN;
   -- procedure Calculate_Status(infoLastSeg);
   -- questo metodo controlla tyre usury e gasoline level
   -- se sono sotto una soglia critica richiede l'intervento dei box
   -- per ora metto parametri a caso (cioè bisogna definire di preciso
   -- quale dev'essere il limite per richiamare i box, bisogna evitare che
   --la macchina non riesca più a girare nel caso il box non sia tempestivo
   --  nella risposta quindi bisogna che la soglia permetta ancora qualche giro,
   -- almeno 2 direi.

   --type Competitor_Details_Access is Access Competitor_Details;
--task TASKCOMPETITOR(Car_In : Competitor_Details_Access);

   task type TASKCOMPETITOR(Car_Driver_In : Competitor_Details_Point) is
      entry Start;
   end TASKCOMPETITOR;
   --type taskdebug is Access TASKCOMPETITOR;
--procedure Set_endWait(temp : in taskdebug);
   -- subtype str is Strategy.STRATEGY;

   procedure Configure_Driver(Driver_In: in out Driver;
                              Team_In : Str.Unbounded_String;
                              First_Name_In : Str.Unbounded_String;
                              Last_Name_In : Str.Unbounded_String);

private

   type Car is record
      Max_Speed          : Float;
      Max_Acceleration   : Float;
      Gas_Tank_Capacity  : Float;
      Engine             : Str.Unbounded_String := Str.Null_Unbounded_String;
      Tyre_Usury         : Common.Percentage;
      Gasoline_Level     : Float;
      Mixture            : Str.Unbounded_String := Str.Null_Unbounded_String;
      Model              : Str.Unbounded_String := Str.Null_Unbounded_String;
      Tyre_Type          : Str.Unbounded_String := Str.Null_Unbounded_String;
      Last_Speed_Reached : Float := 0.0;
   end record;

   type Driver is record
      Team       : Str.Unbounded_String := Str.Null_Unbounded_String;
      First_Name : Str.Unbounded_String := Str.Null_Unbounded_String;
      Last_Name  : Str.Unbounded_String := Str.Null_Unbounded_String;
    end record;

   type Competitor_Details is tagged record
      Racing_Car   : Car;
      Racing_Driver : Driver;
      Current_Strategy : Common.Strategy;
      Current_Circuit_Race_Iterator : Racetrack_Iterator;
      Id: Integer;
      On_Board_Computer : Computer_Point := new Computer;
      Radio : Box_Connection;
   end record;

end Competitor;
