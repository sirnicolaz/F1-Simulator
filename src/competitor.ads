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
  -- procedure Calculate_Status(infoLastSeg);


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
   procedure Set_Team(Team_In : in STRING);
   procedure Set_FirstName(FirstName_In : in STRING);
   procedure Set_LastName(LastName_In : in STRING);
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
         Team : STRING;
         FirstName : STRING;
         LastName : STRING;
      end record;
   type COMPETITOR is
      record
         Id_Competitor : INTEGER;
      end record;

end Competitor;
