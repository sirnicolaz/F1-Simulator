package body Competitor is

   procedure Set_Values(Car_In : in out CAR;
                        MaxSpeed_In : FLOAT;
                        MaxAcceleration_In : FLOAT;
                        GasTankCapacity_In : FLOAT;
                        Engine_In : STRING) is
   begin
      Car_In.MaxSpeed := MaxSpeed_In;
      Car_In.MaxAcceleration := MaxAcceleration_In;
      Car_In.GasTankCapacity := GasTankCapacity_In;
      Car_In.Engine := Engine_In;
   end Set_Values;


   function Get_MaxSpeed(Car_In : CAR) return FLOAT is
   begin
      return Car_In.MaxSpeed;
   end Get_MaxSpeed;

   function Get_MaxAcceleration(Car_In : CAR) return FLOAT is
   begin
      return Car_In.MaxAcceleration;
   end Get_MaxAcceleration;

   function Get_GasTankCapacity(Car_In : CAR) return FLOAT is
   begin
      return Car_In.GasTankCapacity;
   end Get_GasTankCapacity;

   function Get_Engine(Car_In : CAR) return STRING is
   begin
      return Car_In.Engine;
   end Get_Engine;

end Competitor;
