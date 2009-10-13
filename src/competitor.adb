package body Competitor is

   -- Set function - CAR
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

   -- Get function - CAR MAX_SPEED
   function Get_MaxSpeed(Car_In : CAR) return FLOAT is
   begin
      return Car_In.MaxSpeed;
   end Get_MaxSpeed;

   -- Get function - CAR MAX_ACCELERATION
   function Get_MaxAcceleration(Car_In : CAR) return FLOAT is
   begin
      return Car_In.MaxAcceleration;
   end Get_MaxAcceleration;

   -- Get function - CAR GASTANKCAPACITY
   function Get_GasTankCapacity(Car_In : CAR) return FLOAT is
   begin
      return Car_In.GasTankCapacity;
   end Get_GasTankCapacity;

   -- Get function - CAR ENGINE
   function Get_Engine(Car_In : CAR) return STRING is
   begin
      return Car_In.Engine;
   end Get_Engine;

   -- Functino for Calculate Status
   procedure Calculate_Status(infoLastSeg : in out STATUS) is
   begin
      null;
   end Calculate_Status;
   -- is
   --begin
     -- if infoLastSeg.TyreUsury <= 10.0 or infoLastSeg.GasolineLevel <= 10 then
         -- i parametri si possono cambiare ovviamente
         -- basta darci dei valori consistenti
      --   return TRUE;
      --else return FALSE;
     -- end if;

   --end Calculate_Status;
   -- procedure Calculate_Status(infoLastSeg);
   -- questo metodo controlla tyre usury e gasoline level
   -- se sono sotto una soglia critica richiede l'intervento dei box
   -- per ora metto parametri a caso (cioè bisogna definire di preciso
   -- quale dev'essere il limite per richiamare i box, bisogna evitare che
   --la macchina non riesca più a girare nel caso il box non sia tempestivo
   --  nella risposta quindi bisogna che la soglia permetta ancora qualche giro,
   -- almeno 2 direi.


   -- Set function - STATUS USURY
   procedure Set_Usury(Status_In : in out STATUS;
                       Usury_In : FLOAT) is
   begin
      Status_In.TyreUsury := Usury_In;
   end;

   -- Set function - STATUS GASLEVEL
   procedure Set_GasLevel(Status_In : in out STATUS;
                          GasLevel_In : INTEGER) is
   begin
      Status_In.GasolineLevel := GasLevel_In;
   end;

   -- Get function - STATUS USURY
   function Get_Usury(Status_In : STATUS) return FLOAT is
   begin
      return Status_In.TyreUsury;
   end Get_Usury;

   -- Get function - STATUS GASLEVEL
   function Get_GasLevel(Status_In : STATUS) return INTEGER is
   begin
      return Status_In.GasolineLevel;
   end Get_GasLevel;

   -- Get function - COMPETITOR_INFO TEAM
   function Get_Team(Competitor_In : COMPETITOR_INFO) return STRING is
   begin
      return Competitor_In.Team;
   end Get_Team;

   -- Get function - COMPETITOR_INFO FIRSTNAME
   function Get_FirstName(Competitor_In : COMPETITOR_INFO) return STRING is
   begin
      return Competitor_In.FirstName;
   end Get_FirstName;

   -- Get function - COMPETITOR_INFO LASTNAME
   function Get_LastName(Competitor_In : COMPETITOR_INFO) return STRING is
   begin
      return Competitor_In.LastName;
   end Get_LastName;

   -- Set function - COMPETITOR_INFO TEAM
   procedure Set_Team(Competitor_In: in out COMPETITOR_INFO;
                      Team_In : in STRING) is
   begin
      Competitor_In.Team := Team_In;
   end Set_Team;

   -- Set function - COMPETITOR_INFO FIRSTNAME
   procedure Set_FirstName(Competitor_In: in out COMPETITOR_INFO;
                           FirstName_In : in STRING) is
   begin
      Competitor_In.FirstName := FirstName_In;
   end Set_FirstName;

   -- Set function - COMPETITOR_INFO LASTNAME
   procedure Set_LastName(Competitor_In: in out COMPETITOR_INFO;
                          LastName_In : in STRING) is
   begin
      Competitor_In.LastName := LastName_In;
   end Set_LastName;

   -- Get function - TYRE MIXTURE
   function Get_Mixture(Tyre_In : TYRE) return STRING is
   begin
      return Tyre_In.Mixture;
   end Get_Mixture;

   -- Get function - TYRE TYPETYRE
   function Get_TypeTyre(Tyre_In : TYRE) return STRING is
   begin
      return Tyre_In.Type_Tyre;
   end Get_TypeTyre;

   -- Get function - TYRE MODEL
   function Get_Model(Tyre_In : TYRE) return STRING is
   begin
      return Tyre_In.Model;
   end Get_Model;

   -- Set function - TYRE MIXTURE
   procedure Set_Mixture(Tyre_In : in out TYRE;
                         Mixture_In : in STRING) is
   begin
      Tyre_In.Mixture := Mixture_In;
   end Set_Mixture;

   -- Set function - TYRE TYPETYRE
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
