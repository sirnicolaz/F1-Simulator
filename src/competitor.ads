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


   type STATUS is private;
   procedure Set_Usury(Status_In : in out STATUS;
                       Usury_In : FLOAT);
   procedure Set_GasLevel(Status_In : in out STATUS;
                          GasLevel_In : INTEGER);
   function Get_Usury(Status_In : STATUS) return FLOAT;
   function Get_GasLevel(Status_In : STATUS) return INTEGER;

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






end Competitor;
