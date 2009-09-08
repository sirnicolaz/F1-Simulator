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

private
   type Car is
      record
         MaxSpeed : FLOAT;
         MaxAcceleration : FLOAT;
         GasTankCapacity : FLOAT;
         Engine : STRING(1..20);
      end record;


end Competitor;
