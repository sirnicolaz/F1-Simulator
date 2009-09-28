package Competitor is

   type CAR is private;
   procedure Set_Values(Car_In : in out CAR;
                        MaxSpeed_In : FLOAT;
                        MaxAcceleration_In : FLOAT;
                        GasTankCapacity_In : FLOAT;
                        Engine_In : STRING);
   function Get_MaxSpeed(Car_In : CAR) return FLOAT;
   function Get_MaxAcceleration(Car_In : CAR) return FLOAT;
   function Get_GasTankCapacity(Car_In : CAR) return FLOAT;
   function Get_Engine(Car_In : CAR) return STRING;

   procedure Calculate_Status(infoLastSeg);
   -- procedure Calculate_Status(infoLastSeg);
   -- questo metodo controlla tyre usury e gasoline level
   -- se sono sotto una soglia critica richiede l'intervento dei box
   -- per ora metto parametri a caso (cioè bisogna definire di preciso
   -- quale dev'essere il limite per richiamare i box, bisogna evitare che
   --la macchina non riesca più a girare nel caso il box non sia tempestivo
   --  nella risposta quindi bisogna che la soglia permetta ancora qualche giro,
   -- almeno 2 direi.



   type STATUS is private;
   procedure Set_Usury(Status_In : in out STATUS;
                       Usury_In : FLOAT);
   procedure Set_GasLevel(Status_In : in out STATUS;
                          GasLevel_In : INTEGER);
   function Get_Usury(Status_In : STATUS) return FLOAT;
   function Get_GasLevel(Status_In : STATUS) return INTEGER;

   type COMPETITOR_INFO is private;
   function Get_Team(Competitor_In : COMPETITOR_INFO) return STRING;
   function Get_FirstName(Competitor_In : COMPETITOR_INFO) return STRING;
   function Get_LastName(Competitor_In : COMPETITOR_INFO) return STRING;
   procedure Set_Team(Competitor_In: in out COMPETITOR_INFO;
                      Team_In : in STRING);
   procedure Set_FirstName(Competitor_In: in out COMPETITOR_INFO;
                           FirstName_In : in STRING);
   procedure Set_LastName(Competitor_In: in out COMPETITOR_INFO;
                          LastName_In : in STRING);

   type TYRE is private;
   function Get_Mixture(Tyre_In : TYRE) return STRING;
   function Get_TyreType(Tyre_In : TYRE) return STRING;
   function Get_Model(Tyre_In : TYRE) return STRING;
   procedure Set_Mixture(Tyre_In : in out TYRE;
                         Mixture_In : in STRING);
   procedure Set_TypeTyre(Tyre_In : in out TYRE;
                          TypeTyre_In: in STRING);
   procedure Set_Model(Tyre_In : in out TYRE;
                       Model_In : in STRING);


private
   type CAR is
      record
         MaxSpeed : FLOAT;
         MaxAcceleration : FLOAT;
         GasTankCapacity : FLOAT;
         Engine : STRING(1..50);
         CarStatus : STATUS;
      end record;

   type STATUS is
      record
         TyreUsury : FLOAT;
         GasolineLevel : INTEGER;
      end record;
   type COMPETITOR_INFO is
      record
         Team : STRING(1..20);
         FirstName : STRING(1..20);
         LastName : STRING(1..20);
      end record;
   type COMPETITOR is
      record
         Id_Competitor : INTEGER;
      end record;

   type TYRE is
      record
         Mixture : STRING(1..20);
         Model : STRING(1..20);
         Type_Tyre : STRING(1..20);
      end record;

end Competitor;
