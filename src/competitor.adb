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


   procedure Set_Usury(Status_In : in out STATUS;
                       Usury_In : FLOAT) is
   begin
      Status_In.TyreUsury := Usury_In;
   end;

   procedure Set_GasLevel(Status_In : in out STATUS;
                          GasLevel_In : INTEGER) is
   begin
      Status_In.GasolineLevel := GasLevel_In;
   end;

   function Get_Usury(Status_In : STATUS) return FLOAT is
   begin
      return Status_In.TyreUsury;
   end Get_Usury;

   function Get_GasLevel(Status_In : STATUS) return INTEGER is
   begin
      return Status_In.GasolineLevel;
   end Get_GasLevel;

   function Get_Team(Competitor_In : COMPETITOR_INFO) return STRING is
   begin
      return Competitor_In.Team;
   end Get_Team;

   function Get_FirstName(Competitor_In : COMPETITOR_INFO) return STRING is
   begin
      return Competitor_In.FirstName;
   end Get_FirstName;

   function Get_LastName(Competitor_In : COMPETITOR_INFO) return STRING is
   begin
      return Competitor_In.LastName;
   end Get_LastName;

   procedure Set_Team(Competitor_In: in out COMPETITOR_INFO;
                      Team_In : in STRING) is
   begin
      Competitor_In.Team := Team_In;
   end Set_Team;

   procedure Set_FirstName(Competitor_In: in out COMPETITOR_INFO;
                           FirstName_In : in STRING) is
   begin
      Competitor_In.FirstName := FirstName_In;
   end Set_FirstName;

   procedure Set_LastName(Competitor_In: in out COMPETITOR_INFO;
                          LastName_In : in STRING) is
   begin
      Competitor_In.LastName := LastName_In;
   end Set_LastName;

   function Get_Mixture(Tyre_In : TYRE) return STRING is
   begin
      return Tyre_In.Mixture;
   end Get_Mixture;

   function Get_TyreType(Tyre_In : TYRE) return STRING is
   begin
      return Tyre_In.Type_Tyre;
   end Get_TyreType;

   function Get_Model(Tyre_In : TYRE) return STRING is
   begin
      return Tyre_In.Model;
   end Get_Model;



   procedure Set_Mixture(Tyre_In : in out TYRE;
                         Mixture_In : in STRING) is
   begin
      Tyre_In.Mixture := Mixture_In;
   end Set_Mixture;




  procedure Set_TypeTyre(Tyre_In : in out TYRE;
                         TypeTyre_In: in STRING) is
   begin
      Tyre_In.Type_Tyre := TypeTyre_In;
   end Set_TypeTyre;

   procedure Set_Model(Tyre_In : in out TYRE;
                    Model_In : in STRING) is
   begin
      Tyre_In.Model := Model_In;
   end Set_Model;

end Competitor;
