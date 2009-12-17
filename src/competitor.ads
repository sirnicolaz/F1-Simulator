with Circuit;
use Circuit;


package Competitor is

   type DRIVER is record
      Team : STRING(1..20);
      FirstName : STRING(1..20);
      LastName : STRING(1..20);
      ID : INTEGER;
      Vel_In : FLOAT := 0.0;
    end record;

   type CAR is record -- macchina
      MaxSpeed : FLOAT;
      MaxAcceleration : FLOAT;
      GasTankCapacity : FLOAT;
      Engine : STRING(1..50);
      TyreUsury : FLOAT;
      GasolineLevel : INTEGER;
      -- private subtype TYRE is record
      Mixture : STRING(1..20);
      Model : STRING(1..20);
      Type_Tyre : STRING(1..20);
      --end record;

   end record;
   type STRATEGY_CAR is record
      pitstopGasolineLevel : INTEGER;
      pitstopLaps : INTEGER;
      pitstopCondition : BOOLEAN; -- correggere il tipo
      trim : INTEGER; -- correggere il tipo
      pitstop : BOOLEAN;
   end record;

   type CAR_DRIVER is tagged record
      auto : CAR;
      pilota : DRIVER;
      strategia : STRATEGY_CAR;
      RaceIterator : RACETRACK_ITERATOR;
   end record;
   type CAR_DRIVER_ACCESS is access CAR_DRIVER;

   function Init_Competitor(xml_file : STRING; RaceIterator : RACETRACK_ITERATOR) return CAR_DRIVER_ACCESS;
   procedure Set_Id(Car_In : in out CAR_DRIVER_ACCESS; Id_In : INTEGER;);
-- set and get function for tyre into car
   function Get_Mixture(Car_In : CAR_DRIVER_ACCESS) return STRING;
   function Get_TypeTyre(Car_In : CAR_DRIVER_ACCESS) return STRING;
   function Get_Model(Car_In : CAR_DRIVER_ACCESS) return STRING;
   procedure Set_Mixture(Car_In : in out CAR_DRIVER_ACCESS;
                         Mixture_In : in STRING);
   procedure Set_TypeTyre(Car_In : in out CAR_DRIVER_ACCESS;
                          TypeTyre_In: in STRING);
   procedure Set_Model(Car_In : in out CAR_DRIVER_ACCESS;
                       Model_In : in STRING);



   -- Set car values


   function Get_MaxSpeed(Car_In : CAR_DRIVER_ACCESS) return FLOAT;
   function Get_MaxAcceleration(Car_In : CAR_DRIVER_ACCESS) return FLOAT;
   function Get_GasTankCapacity(Car_In : CAR_DRIVER_ACCESS) return FLOAT;
   function Get_Engine(Car_In : CAR_DRIVER_ACCESS) return STRING;

   procedure Configure_Car(Car_In : in out CAR_DRIVER_ACCESS;
                           MaxSpeed_In : FLOAT;
                           MaxAcceleration_In : FLOAT;
                           GasTankCapacity_In : FLOAT;
                           Engine_In : STRING);

   procedure Set_Usury(Car_In : in out CAR_DRIVER_ACCESS;
                       Usury_In : FLOAT);
   procedure Set_GasLevel(Car_In : in out CAR_DRIVER_ACCESS;
                          GasLevel_In : INTEGER);
   function Get_Usury(Car_In : CAR_DRIVER_ACCESS) return FLOAT;
   function Get_GasLevel(Car_In : CAR_DRIVER_ACCESS) return INTEGER;
   function Calculate_Status(infoLastSeg : in CAR_DRIVER_ACCESS) return BOOLEAN;
   -- procedure Calculate_Status(infoLastSeg);
   -- questo metodo controlla tyre usury e gasoline level
   -- se sono sotto una soglia critica richiede l'intervento dei box
   -- per ora metto parametri a caso (cioè bisogna definire di preciso
   -- quale dev'essere il limite per richiamare i box, bisogna evitare che
   --la macchina non riesca più a girare nel caso il box non sia tempestivo
   --  nella risposta quindi bisogna che la soglia permetta ancora qualche giro,
   -- almeno 2 direi.
   procedure Get_Status(Car_In : CAR_DRIVER_ACCESS; Usury_Out : out FLOAT; Level_Out : out INTEGER );
   procedure Set_Vel_In(Competitor_In : in out CAR_DRIVER_ACCESS; PVel_In : in FLOAT);
   function Get_Vel_In(Competitor_In : CAR_DRIVER_ACCESS) return FLOAT;
   function Get_Team(Competitor_In :CAR_DRIVER_ACCESS) return STRING;
   function Get_FirstName(Competitor_In : CAR_DRIVER_ACCESS) return STRING;
   function Get_LastName(Competitor_In : CAR_DRIVER_ACCESS) return STRING;
   procedure Set_Team(Competitor_In: in out CAR_DRIVER_ACCESS;
                      Team_In : in STRING);
   procedure Set_FirstName(Competitor_In: in out CAR_DRIVER_ACCESS;
                           FirstName_In : in STRING);
   procedure Set_LastName(Competitor_In: in out CAR_DRIVER_ACCESS;
                          LastName_In : in STRING);

   --type CAR_DRIVER_ACCESS is access CAR_DRIVER;
   task TASKCOMPETITOR;



   -- subtype str is Strategy.STRATEGY;

   procedure Configure_Driver(Car_In: in out CAR_DRIVER_ACCESS;
                              Team_In : STRING;
                              FirstName_In : STRING;
                              LastName_In : STRING;
                              ID_In : INTEGER;
                              Vel_In : FLOAT);
   procedure Configure_Strategy(Car_In : in out CAR_DRIVER_ACCESS;
                                pitstopGasolineLevel_In : INTEGER;
                                pitstopLaps_In: INTEGER;
                                pitstopCondition_In : BOOLEAN;
                                trim_In : INTEGER;
                                pitstop_In : BOOLEAN);

   function Evaluate(driver : CAR_DRIVER_ACCESS ; F_Segment : CHECKPOINT_SYNCH_POINT) return FLOAT;
   function CalculateCrossingTime(CarDriver : CAR_DRIVER_ACCESS; PathsCollection_Index : CIRCUIT.RACETRACK_POINT;
                                  F_Segment : CHECKPOINT_SYNCH_POINT ; Vel_In : FLOAT) return FLOAT;
   function Get_pitstopGasolineLevel(str_In : CAR_DRIVER_ACCESS) return INTEGER;

   function Get_pitstopLaps(str_In : CAR_DRIVER_ACCESS) return INTEGER;

   function Get_pitstopCondition (str_In : CAR_DRIVER_ACCESS) return BOOLEAN;

   function Get_trim (str_In : CAR_DRIVER_ACCESS) return INTEGER;

   function Get_pitstop (str_In : CAR_DRIVER_ACCESS) return BOOLEAN;

end Competitor;
