--with Circuit;
--use Circuit;
--with Strategy;
--use Strategy;
with Ada.Float_Text_IO;
 use Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions;
with Queue; use Queue;

with Competition_Monitor;

with Common;
with Ada.Calendar;
use Ada.Calendar;

with CompetitionComputer;
use CompetitionComputer;


with Ada.Exceptions;

package body Competitor is

   --THis value has to be the same for oeveryone
   LastLap : INTEGER;
   procedure Set_Laps( LapsQty : in INTEGER) is
   begin
      LastLap := LapsQty;
   end Set_Laps;

   -- Set function - CAR
   procedure Configure_Car(Car_In : in out CAR;
                           MaxSpeed_In : FLOAT;
                           MaxAcceleration_In : FLOAT;
                           GasTankCapacity_In : FLOAT;
                           Engine_In : Str.Unbounded_String;
                           TyreUsury_In : Common.PERCENTAGE;
                           GasolineLevel_In : FLOAT;
                           Mixture_In : Str.Unbounded_String;
                           Model_In : Str.Unbounded_String;
                           Type_Tyre_In : Str.Unbounded_String) is
   begin
      Car_In.MaxSpeed := MaxSpeed_In;
      Car_In.MaxAcceleration := MaxAcceleration_In;
      Car_In.GasTankCapacity := GasTankCapacity_In;
      Car_In.Engine := Engine_In;
      Car_In.TyreUsury:=TyreUsury_In;
      Car_In.GasolineLevel:=GasolineLevel_In;
      Car_In.Mixture:=Mixture_In;
      Car_In.Model:=Model_In;
      CAr_In.Type_Tyre:=Type_Tyre_In;
   end Configure_Car;

   procedure Set_Vel_In(Competitor_In : in out CAR_AND_DRIVER_ACCESS; PVel_In : in FLOAT) is
   begin
      Competitor_In.pilota.Vel_In:=PVel_In;
   end Set_Vel_In;

   function Get_Vel_In(Competitor_In : CAR_AND_DRIVER_ACCESS) return FLOAT is
   begin
      return Competitor_In.pilota.Vel_In;
   end Get_Vel_In;
   -- Get function - CAR MAX_SPEED
   function Get_MaxSpeed(Car_In : CAR_AND_DRIVER_ACCESS) return FLOAT is
   begin
      return Car_In.auto.MaxSpeed;
   end Get_MaxSpeed;

   -- Get function - CAR MAX_ACCELERATION
   function Get_MaxAcceleration(Car_In : CAR_AND_DRIVER_ACCESS) return FLOAT is
   begin
      return Car_In.auto.MaxAcceleration;
   end Get_MaxAcceleration;

   -- Get function - CAR GASTANKCAPACITY
   function Get_GasTankCapacity(Car_In : CAR_AND_DRIVER_ACCESS) return FLOAT is
   begin
      return Car_In.auto.GasTankCapacity;
   end Get_GasTankCapacity;

   -- Get function - CAR ENGINE
   function Get_Engine(Car_In : CAR_AND_DRIVER_ACCESS) return Str.Unbounded_String is
   begin
      return Car_In.auto.Engine;
   end Get_Engine;

--     function Get_Strategy(Car_In :  CAR_AND_DRIVER_ACCESS) return Common.DRIVING_STYLE is
--     begin
--        return Car_In.strategia.Style;
--     end Get_Strategy;

   -- Functino for Calculate Status
   function Calculate_Status(infoLastSeg : in CAR_AND_DRIVER_ACCESS) return BOOLEAN is
      --questa funzione ritorna un boolean che indica se il concorrente
      --deve tornare o meno ai box
   begin
      if infoLastSeg.auto.TyreUsury <= 10.0 or infoLastSeg.auto.GasolineLevel <= 10.0 then
         -- i parametri si possono cambiare ovviamente
         -- basta darci dei valori consistenti
         return TRUE;
      else return FALSE;
      end if;

   end Calculate_Status;
   -- procedure Calculate_Status(infoLastSeg);
   -- questo metodo controlla tyre usury e gasoline level
   -- se sono sotto una soglia critica richiede l'intervento dei box
   -- per ora metto parametri a caso (cio� bisogna definire di preciso
   -- quale dev'essere il limite per richiamare i box, bisogna evitare che
   --la macchina non riesca pi� a girare nel caso il box non sia tempestivo
   --  nella risposta quindi bisogna che la soglia permetta ancora qualche giro,
   -- almeno 2 direi.


   procedure Set_Id(Car_In : in out CAR_AND_DRIVER_ACCESS; Id_In : INTEGER) is
   begin
      Car_In.Id := Id_In;
   end Set_Id;
   -- Set function - STATUS USURY
   procedure Set_Usury(Car_In : in out CAR_AND_DRIVER_ACCESS;
                       Usury_In : Common.PERCENTAGE) is
   begin
      Car_In.auto.TyreUsury := Usury_In;
   end;

   -- Set function - STATUS GASLEVEL
   procedure Set_GasLevel(Car_In : in out CAR_AND_DRIVER_ACCESS;
                          GasLevel_In : FLOAT) is
   begin
      Car_In.auto.GasolineLevel := GasLevel_In;
   end;

   -- Get function - STATUS USURY
   function Get_Usury(Car_In : CAR_AND_DRIVER_ACCESS) return Common.PERCENTAGE is
   begin
      return Car_In.auto.TyreUsury;
   end Get_Usury;

   -- Get function - STATUS GASLEVEL
   function Get_GasLevel(Car_In : CAR_AND_DRIVER_ACCESS) return FLOAT is
   begin
      return Car_In.auto.GasolineLevel;
   end Get_GasLevel;

   -- Get function - COMPETITOR_INFO TEAM
   function Get_Team(Competitor_In : CAR_AND_DRIVER_ACCESS) return Str.Unbounded_String is
   begin
      return Competitor_In.pilota.Team;
   end Get_Team;

   -- Get function - COMPETITOR_INFO FIRSTNAME
   function Get_FirstName(Competitor_In : CAR_AND_DRIVER_ACCESS) return Str.Unbounded_String is
   begin
      return Competitor_In.pilota.FirstName;
   end Get_FirstName;

   -- Get function - COMPETITOR_INFO LASTNAME
   function Get_LastName(Competitor_In : CAR_AND_DRIVER_ACCESS) return Str.Unbounded_String is
   begin
      return Competitor_In.pilota.LastName;
   end Get_LastName;

   -- Set function - COMPETITOR_INFO TEAM
   procedure Set_Team(Competitor_In: in out CAR_AND_DRIVER_ACCESS;
                      Team_In : in Str.Unbounded_String) is
   begin
      Competitor_In.pilota.Team := Team_In;
   end Set_Team;

   -- Set function - COMPETITOR_INFO FIRSTNAME
   procedure Set_FirstName(Competitor_In: in out CAR_AND_DRIVER_ACCESS;
                           FirstName_In : in Str.Unbounded_String) is
   begin
      Competitor_In.pilota.FirstName := FirstName_In;
   end Set_FirstName;

   -- Set function - COMPETITOR_INFO LASTNAME
   procedure Set_LastName(Competitor_In: in out CAR_AND_DRIVER_ACCESS;
                          LastName_In : in Str.Unbounded_String) is
   begin
      Competitor_In.pilota.LastName := LastName_In;
   end Set_LastName;

   -- Get function - TYRE MIXTURE
   function Get_Mixture(Car_In : CAR_AND_DRIVER_ACCESS) return Str.Unbounded_String is
   begin
      return Car_In.auto.Mixture;
   end Get_Mixture;

   -- Get function - TYRE TYPETYRE
   function Get_TypeTyre(Car_In : CAR_AND_DRIVER_ACCESS) return Str.Unbounded_String is
   begin
      return Car_In.auto.Type_Tyre;
   end Get_TypeTyre;

   -- Get function - TYRE MODEL
   function Get_Model(Car_In : CAR_AND_DRIVER_ACCESS) return Str.Unbounded_String is
   begin
      return Car_In.auto.Model;
   end Get_Model;

   -- Set function - TYRE MIXTURE
   procedure Set_Mixture(Car_In : in out CAR_AND_DRIVER_ACCESS;
                         Mixture_In : in Str.Unbounded_String) is
   begin
      Car_In.auto.Mixture := Mixture_In;
   end Set_Mixture;

   -- Set function - TYRE TYPETYRE
   procedure Set_TypeTyre(Car_In : in out CAR_AND_DRIVER_ACCESS;
                          TypeTyre_In: in Str.Unbounded_String) is
   begin
      Car_In.auto.Type_Tyre := TypeTyre_In;
   end Set_TypeTyre;

   procedure Set_Model(Car_In : in out CAR_AND_DRIVER_ACCESS;
                       Model_In : in Str.Unbounded_String) is
   begin
      Car_In.auto.Model := Model_In;
   end Set_Model;

   procedure Configure_Driver(Car_In: in out DRIVER;
                              Team_In :  Str.Unbounded_String;
                              FirstName_In :  Str.Unbounded_String;
                              LastName_In :  Str.Unbounded_String;
                              Vel_In : FLOAT) is
   begin
      Car_In.Team:=Team_In;
      Car_In.FirstName:=FirstName_In;
      Car_In.LastName:=LastName_In;
      Car_In.Vel_In:=Vel_In;
   end Configure_Driver;

   procedure Get_Status(Car_In : CAR_AND_DRIVER_ACCESS; Usury_Out : out FLOAT; Level_Out : out FLOAT) is

   begin
      Usury_Out:=Get_Usury(Car_In);
      Level_Out:=Get_GasLevel(Car_In);
   end Get_Status;

   function Init_Competitor(xml_file : STRING;
                            RaceIterator : RACETRACK_ITERATOR;
                            id_In : INTEGER;
                            laps_In : INTEGER;
                            BoxRadio_CorbaLOC : STRING) return CAR_AND_DRIVER_ACCESS is
      --parametri
      Doc : Document;
      carDriver_XML : Node_List;
      carDriver_Length : INTEGER;

      --   carDriver_Out : CAR_AND_DRIVER_ACCESS;
      carDriver : CAR_AND_DRIVER_ACCESS := new CAR_AND_DRIVER;


      procedure Try_OpenFile is--(xml_file : STRING; Input : in out File_Input; Reader : in out Tree_Reader; Doc : in out Document;
         --carDriver_XML : in out Node_List; carDriver_Length : in out INTEGER) is
      begin

	 Doc := Common.Get_Document(xml_file);

         carDriver_XML := Get_Elements_By_Tag_Name(Doc,"car_driver");
         carDriver_Length := Length(carDriver_XML);
      exception
         when ADA.IO_EXCEPTIONS.NAME_ERROR => Doc := null;
      end Try_OpenFile;


      function Configure_Car_File(xml_file_In : DOCUMENT) return CAR is
         MaxSpeed_In : FLOAT;
         MaxAcceleration_In : FLOAT;
         GasTankCapacity_In : FLOAT;--FLOAT;
         --Engine_In : STRING(1..50);
         TyreUsury_In : FLOAT;
         GasolineLevel_In : FLOAT;--FLOAT;
         Mixture_In : Str.Unbounded_String;--access STRING;
         Model_In : Str.Unbounded_String;-- STRING(1..20);
         Type_Tyre_In : Str.Unbounded_String;-- STRING(1..20);
         car_XML : Node_List;
         Current_Node : Node;
         -- Current_Team : STRING(1..7) :="Ferrari";
         -- Current_FirstName : STRING(1..8):="Fernando";
         -- Current_LastName : STRING(1..6) :="Alonso";
         Car_In : CAR;
         --Car_Current : CAR;
         Engine_In : Str.Unbounded_String;--STRING(1..6):="xxxxxx";

         function Get_Feature_Node(Node_In : NODE;
                                   FeatureName_In : STRING) return NODE is
            Child_Nodes_In : NODE_LIST;
            Current_Node : NODE;
         begin

            Child_Nodes_In := Child_Nodes(Node_In);
            for Index in 1..Length(Child_Nodes_In) loop
               Current_Node := Item(Child_Nodes_In,Index-1);
               if Node_Name(Current_Node) = FeatureName_In then
                  return Current_Node;
               end if;
            end loop;

            return null;
         end Get_Feature_Node;

      begin

         --If there is a conf file, use it to auto-init;

         -- if Document_In /= null then

         car_XML := Get_Elements_By_Tag_Name(xml_file_In,"car");

         Current_Node := Item(car_XML, 0);

         car_XML := Child_Nodes(Current_Node);
         MaxSpeed_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"maxspeed"))));
         MaxAcceleration_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"maxacceleration"))));
         GasTankCapacity_In := FLOAT'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"gastankcapacity"))));
         Engine_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"engine"))));
         TyreUsury_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"tyreusury"))));
         GasolineLevel_In := FLOAT'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"gasolinelevel"))));

         Mixture_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"mixture"))));

         --Ada.Strings.Unbounded.Text_IO.Put_Line(Mixture_In);
         Model_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"model"))));
         Type_Tyre_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"type_tyre"))));
         --Car_Temp := new CAR;
         --Mixture_In := "morbidaxxxxxxxxxxxxx";
--           Model_In := "michelinxxxxxxxxxxxx";
--         Type_Tyre_In := "rainxxxxxxxxxxxxxxxx";
         --Racetrack_In(Index) := CheckpointSynch_Current;


         -- end if;



         Configure_Car(Car_In,
                       MaxSpeed_In,
                       MaxAcceleration_In,
                       GasTankCapacity_In,
                       Engine_In,
                       TyreUsury_In,
                       GasolineLevel_In,
                       Mixture_In ,
                       Model_In ,
                       Type_Tyre_In );
         return Car_In;
      end Configure_Car_File;

      function Configure_Driver_File(xml_file_In : DOCUMENT) return DRIVER is
         Team_In : Str.Unbounded_String;--STRING(1..7):="xxxxxxx";
         FirstName_In : Str.Unbounded_String;-- STRING(1..8):="xxxxxxxx";
         LastName_In : Str.Unbounded_String;-- STRING(1..6):="xxxxxx";
         Vel_In : FLOAT :=0.0;
         driver_XML : Node_List;
         Current_Node : Node;
         Car_In : DRIVER;
         --global : GLOBAL_STATS_HANDLER_POINT;-- global stats handler - "singleton"
         function Get_Feature_Node(Node_In : NODE;
                                   FeatureName_In : STRING) return NODE is
            Child_Nodes_In : NODE_LIST;
            Current_Node : NODE;
         begin

            Child_Nodes_In := Child_Nodes(Node_In);
            for Index in 1..Length(Child_Nodes_In) loop
               Current_Node := Item(Child_Nodes_In,Index-1);
               if Node_Name(Current_Node) = FeatureName_In then
                  return Current_Node;
               end if;
            end loop;

            return null;
         end Get_Feature_Node;

      begin

         --If there is a conf file, use it to auto-init;

         --if Document_In /= null then

         driver_XML := Get_Elements_By_Tag_Name(xml_file_In,"driver");
         Current_Node := Item(driver_XML, 0);
         driver_XML := Child_Nodes(Current_Node);
         Team_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"team"))));
         FirstName_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"firstname"))));
         LastName_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"lastname"))));
         --Car_Temp := new CAR;
         --Team_In := "Ferrari";
         --FirstName_In := "Fernando";
         --LastName_In := "Alonso";
         --Racetrack_In(Index) := CheckpointSynch_Current;
         --end loop;
         --end if;

         --lettura parametri, vel_in esclusa
         Configure_Driver(Car_In,
                          Team_In,
                          FirstName_In,
                          LastName_In,
                          Vel_In);
         return Car_In;
      end Configure_Driver_File;


      --TODO: try to remove this stuff
      --remote communication declaration section
      --use PolyORB.Utils.Report;
      --boxCorbaLoc : Str.Unbounded_String := Str.Null_Unbounded_String;

      RadioConnection_Success : BOOLEAN := false;
   begin

      --apertura del file
      Try_OpenFile;
      --configurazione parametri

      --Teoricamente non serve pi� perch� la strategia viene presa su giusto
      --+ prima di iniziare la gare
      --carDriver.strategia := Configure_Strategy_File(doc);


      carDriver.auto := Configure_Car_File(doc);

      carDriver.pilota := Configure_Driver_File(doc);
      carDriver.RaceIterator:=RaceIterator;
      carDriver.Id:=id_In;

      --Init onboard computer
      OnboardComputer.Init_Computer(Computer_In     => carDriver.statsComputer,
                                    CompetitorId_In => id_in,
                                    Laps            => laps_in);

      --Adding minimal information to stats (for presentation purspose)
      CompetitionComputer.Add_CompetitorMinInfo(Id      => id_in,
                                                Name    => carDriver.pilota.FirstName,
                                                Surname => carDriver.pilota.LastName,
                                                Team    => carDriver.pilota.Team);

      --Initializing onboard computer references in the Competition Monitor
      Competition_Monitor.AddOBC(carDriver.statsComputer,carDriver.Id);
      --Try to initialize the competitor radio. If it's still down, retry in 5 seconds
      --+ (probably other problems are occured in such a case)
      loop CompetitorRadio.Init_BoxConnection(BoxRadio_CorbaLOC => BoxRadio_CorbaLOC,
                                            Radio             => carDriver.Radio,
                                            ID                => carDriver.Id,
                                              Success           => RadioConnection_Success);
         exit when RadioConnection_Success = true;
         Ada.Text_IO.Put_Line("Connection to box failed for competitor n. " &
                              Common.IntegerToString(id_In));
         Ada.Text_IO.Put_Line("Retry in 5 seconds...");
         Delay(Standard.Duration(5));
      end loop;

      return carDriver;
   end Init_Competitor;


   -----------------------------------
   -----------------------------------
   ------ CALCOLO CROSSING TIME  -----
   -----------------------------------
   -----------------------------------
   procedure CalculateCrossingTime (TimeCriticalTemp : out FLOAT; CarDriver : CAR_AND_DRIVER_ACCESS; PathsCollection_Index : INTEGER;
                                    F_Segment : CHECKPOINT_SYNCH_POINT ; Vel_In : FLOAT;
                                    Paths2Cross : CROSSING_POINT; Vel_Out : out FLOAT) is
      length_path : FLOAT; --lunghezza tratto
      --size_path : INTEGER; -- molteplicit� tratto
      angle_path : FLOAT; -- angolo
      grip_path : FLOAT; -- attrito
      difficulty_path : FLOAT; -- difficolt� del tratto
      tyre_usury : Common.PERCENTAGE; -- usura delle gomme %
      gasoline_level : FLOAT; -- livello di benzina l
      vel_max_reale : FLOAT; --velocit� massima raggiungibile km/h
      vel_max : FLOAT := carDriver.auto.MaxSpeed; -- km/h
      lc : FLOAT; -- m
      timeCritical: FLOAT; -- s
      acc: FLOAT; -- metri al secondo quadrato

   begin
      --velocit� massima scalata per usura gomme e benzina presente.
      --V =velocit� massima
      --U =usura gomme (valori da 0 a 100 in percentuale)
      --B =benzina presente (valori da 0 a 100)
      --VR=Velocit� Reale (Velocita-%usura)scalato sulla benzina presente,+ benzina + lento..
      --VR= (V - (V*(U / 10)/100))-((0.025*B*V)/100)
      -- B*V/1000 � la formula B/10 * V/100 quindi B=0, la velocit� non diminuisce, B=100
      -- la velocit� diminuisce di un 10 %
      --++++++++++++++++++++++++++++++++++++--
      -- bisogna prevedere una accelerazione (positiva o negativa) per calcolare il tempo di attraversamento..

      length_path := Paths2Cross.Get_Length(PathsCollection_Index);
      --size_path := Paths2Cross.Get_Size(PathsCollection_Index);

      angle_path:= Paths2Cross.Get_Angle(PathsCollection_Index);

      grip_path:= Paths2Cross.Get_Grip(PathsCollection_Index);

      difficulty_path:= Paths2Cross.Get_Difficulty(PathsCollection_Index);

      tyre_usury := Get_Usury(CarDriver);

      gasoline_level:=Get_GasLevel(CarDriver);

      vel_max := Get_MaxSpeed(CarDriver); --

      --acc := Get_MaxAcceleration(carDriver);
      -- aggiornamento dell'accelerazione in base allo stile di guida
      -- 0.008 � un buon valore trovato facendo dei test
      -- oltre allo stile di guida infulir� sull'accelerazione anche l'usura delle gomme
      -- sommando i due modificatori si arriva a cambiare l'accelerazione al pi� di 0.012 (rispetto al valore
      -- normale che � stato fissato in fase di configurazione ) che
      -- secondo i test eseguiti � un buon valore che modifica in maniera buona i tempi di percorrenza
      case carDriver.strategia.Style is
      when Common.AGGRESSIVE => acc:= Get_MaxAcceleration(carDriver)+0.008;
      when Common.CONSERVATIVE => acc := Get_MaxAcceleration(carDriver) - 0.008;
      when Common.NORMAL => acc := Get_MaxAcceleration(carDriver);
      end case;

      if tyre_usury <= 50.0 then acc:= acc + (0.001*tyre_usury); --al max aumento di 0.005 l'accelerazione
      else acc:= acc - (0.001*(tyre_usury-50.0)); -- al max diminuisco di 0.005 l'accelerazione
      end if;
      -- fine aggiornamento accelerazione in base allo stile di guida e all'usura delle gomme

      vel_max_reale := vel_max-(((tyre_usury/10.0) * (vel_max))/10.0)-(((gasoline_level*0.025)*(vel_max))/100.0);-- con 400 litri(massimo serbatoio esistente) si ha una decadenza del 10% della velocit� massima raggiungibile

      if gasoline_level <= 0.0 then
         Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : ATTENZIONE - BENZINA FINITA !!!");
      end if;

      -- formula per il tempo di attraversamento
      -- caso 1
      -- tempo di percorrenza= tempo per raggiungere velocit� massima.
      -- lunghezza tratto in accelerazione = lunghezza tratto
      -- velocit� finale = velocit� massima per quel tratto
      timeCritical := ((vel_max_reale/3.6) - (Vel_In/3.6)) / acc;
      -- tempo per arrivare a Vmax partendo da Vel_iniziale
      -- divisione per 3,6 per portare alla stessa unit� di misura cosi abbiamo la velocit� in
      -- m/s e l'accelerazione in m/s^2 per avere cosi un tempo in secondi
      if vel_max_reale <= 0.0 then lc:=0.0;
      else lc := (Vel_In/3.6)*timeCritical + 0.5*acc*(timeCritical*timeCritical);
      end if;
      
      if lc = length_path then

         Vel_Out:=vel_max_reale;---attenzione TODO se cambio vel in in una traiettoria lo cambio anche per quella dopo...
         TimeCriticalTemp := timeCritical;-- aggiornare velocit�
      elsif lc < length_path then

         Vel_Out:=vel_max_reale;
         --if vel_max_reale = 0.0 then timeCriticalTemp := -1000.0;
         --else
         if vel_max_reale = 0.0 then timeCriticalTemp := 0.0; -- per evitare di dividere per zero dopo
         else
            TimeCriticalTemp := timeCritical + ( length_path - lc )/(vel_max_reale/3.6);
            --moto accelerato + moto uniforme
            -- tempo per arrivare alla velocit� max + (spazio/velocit�)= tempo moto rettilineo uniforme
         end if;
      elsif lc> length_path  then

--         timeCritical := (-1.0) * (Vel_In/acc) + Ada.Numerics.Elementary_Functions.Sqrt(((Vel_In ** 2 ) + (2.0 * length_path))/(acc ** 2));--TODO Correggere
           timeCritical := (((-1.0) * (Vel_In/3.6)) + Ada.Numerics.Elementary_Functions.Sqrt(((Vel_In/3.6) ** 2 ) + (2.0 * length_path *acc)))/acc;--TODO : controllare correttezza

         Vel_Out:=((CarDriver.pilota.Vel_In/3.6) + (acc * timeCritical))*3.6;
         TimeCriticalTemp := timeCritical;
      end if;

   end CalculateCrossingTime;

   -----------------------------------
   -----------------------------------
   ------------ EVALUATE  ------------
   -----------------------------------
   -----------------------------------
   procedure Evaluate(driver : CAR_AND_DRIVER_ACCESS ;
                     F_Segment : CHECKPOINT_SYNCH_POINT; Paths2Cross : CROSSING_POINT; 
                     lengthPath : out FLOAT ; 
                     crossingTime_Out : out FLOAT; 
                     vel_out : out FLOAT) is

      --qua dentro va effettuata la valutazione della traiettoria migliore e calcolato il tempo di attraversamento
      -- da restituire poi a chi invoca questo metodo.
      --qua credo che vadano eseguite le operazioni per attraversare il tratto


      --driver dovr� salvarsi la velocit� che ha raggiunto.

      StartingInstant : FLOAT := 0.0;
      WaitingTime : FLOAT := 0.0;
      PathTime : FLOAT;
      CompArrivalTime : FLOAT := F_Segment.Get_Time(driver.Id);
      --ho bisogno di avere metodi per il ritorno dei campi dati del checkpoint_sync_point
      --inoltre non vedo il metodo Get_ArrivalTime
      CrossingTime : FLOAT:= 0.0;
      CrossingTimeTemp : FLOAT;
      TotalDelay : FLOAT := 0.0;
      MinDelay : FLOAT := -1.0;
      pathTimeMinore : FLOAT;
      --BestPath : PATH;
      Competitor_Status_Tyre : FLOAT;
      Competitor_Status_Level: FLOAT;
      --manca il metodo per tornare un pathcollection;
      -- Competitor_Strategy : STRATEGY_CAR := Competitor.Get_Strategy();
      velTemp : FLOAT :=0.0;
      traiettoriaScelta : INTEGER;
      vel_array : VEL(1..Paths2Cross.Get_Size);
      waitingTimeMinore : FLOAT := 0.0;
      temp_usury : Common.PERCENTAGE := 0.0;
      gas_modifier : FLOAT := 0.0;
   begin

      -- loop on paths
      Competitor.Get_Status(driver, Competitor_Status_Tyre, Competitor_Status_Level);

      for Index in 1..Paths2Cross.Get_Size loop
         PathTime := Paths2Cross.Get_PathTime(Index);
         WaitingTime := PathTime - CompArrivalTime;

	 StartingInstant := PathTime;
         if WaitingTime < 0.0 then
            WaitingTime := 0.0;
            StartingInstant := CompArrivalTime;
         end if;
         
	 CalculateCrossingTime(CrossingTimeTemp, driver, Index, F_Segment, Get_Vel_In(driver), Paths2Cross, velTemp);

	 vel_array(Index):=velTemp;
         CrossingTimeTemp := CrossingTimeTemp + WaitingTime;--StartingInstant;

         if CrossingTime > CrossingTimeTemp or else  CrossingTime <= 0.0 then
            CrossingTime := CrossingTimeTemp;
            traiettoriaScelta := Index;
            pathTimeMinore := PathTime;
            waitingTimeMinore := WaitingTime;
         end if;
         
         -- NEW : ho sottratto il WaitingTime, altrimenti lo contavo 2 volte
         --+ ora ho il delay totale da scrivere sul path, se � quello minimo calcolato..quel controllo lo faccio nella prossima
         --+ istruzione. il total delay minimo � quello che corrisponde a tempo di attesa + tempo di attraversamento minore
         --+ qua devo usare CrossingTimeTemp e WaitingTime perch� altrimenti rischio di usare il CrossingTime che � il miglior tempo di attraversament
         --+ anche nelle iterazioni successive, tanto non pu� succedere che MinDelay venga aggiornato con TotalDelay nel caso non sia stato aggiornato anche CrossingTime
         TotalDelay := StartingInstant + CrossingTimeTemp - WaitingTime; 

         if TotalDelay < MinDelay or else MinDelay < 0.0 then
            MinDelay := TotalDelay;-- MinDelay ha cos� il valore da scrivere sul path

	end if;
     
      end loop;
      Paths2Cross.Update_Time(MinDelay, traiettoriaScelta);
      driver.pilota.Vel_In := vel_array(traiettoriaScelta); --aggiorno la velocit� di entrata al tratto successivo

     
      --aggiorno il lengthPath in modo da averlo poi quando aggiorno l'onboardcomputer
      lengthPath := Paths2Cross.Get_Length(traiettoriaScelta);

      --aggiorno il modificatore in base all'angolo
      if Paths2Cross.Get_Angle(traiettoriaScelta) < 45.0 then temp_usury := temp_usury + 0.005;
      elsif Paths2Cross.Get_Angle(traiettoriaScelta) > 45.0 and Paths2Cross.Get_Angle(traiettoriaScelta) < 90.0 then temp_usury := temp_usury + 0.0035;
      else temp_usury := temp_usury + 0.0015;
      end if;

      --aggiorno il modificatore in base alla mescola
      if driver.auto.Type_Tyre = "Soft" then temp_usury := temp_usury + 0.03;
      else temp_usury := temp_usury + 0.01;
      end if;

      --aggiorno il modificatore in base alla velocit� massima raggiunta
      if vel_array(traiettoriaScelta) >= 300.0 then temp_usury := temp_usury + 0.02;
      elsif vel_array(traiettoriaScelta) >= 200.0 and vel_array(traiettoriaScelta) <300.0 then temp_usury := temp_usury + 0.01;
      elsif vel_array(traiettoriaScelta) >= 100.0 and vel_array(traiettoriaScelta) <200.0 then temp_usury := temp_usury + 0.007;
      else temp_usury := temp_usury + 0.005;
      end if;

      -- adesso in temp_usury � presente una percentuale da sommare a quella statica calcolata.
      -- al massimo il valore di usura arriva a 0.86, nella peggiore delle ipotesi.
      -- il valore di usura si intende ogni 1000 metri
      -- quindi x = (1000*100)/0.80 = 125 km
      -- x = (1000*100)/0.86 = 116,279 km
      -- in totale quasi due giri (in media 5.5 km al giro) di differenza
      driver.auto.TyreUsury := driver.auto.TyreUsury + (Paths2Cross.Get_Length(traiettoriaScelta)*(0.8+temp_usury)/1000.0);

      --il valore di 0.8 � stato scelto facendo il calcolo che con le gomme si percorrono circa 115 km
      -- calcolo gas_modifier
      if vel_array(traiettoriaScelta) >= 300.0 then gas_modifier := 0.15;
      elsif vel_array(traiettoriaScelta) >= 200.0 and vel_array(traiettoriaScelta) <300.0 then gas_modifier := 0.10;
      elsif vel_array(traiettoriaScelta) >= 100.0 and vel_array(traiettoriaScelta) <200.0 then gas_modifier := 0.05;
      else gas_modifier := 0.0;
      end if;

      driver.auto.GasolineLevel := driver.auto.GasolineLevel - ((0.6 + gas_modifier) * Paths2Cross.Get_Length(traiettoriaScelta)/1000.0);
      -- 0.6 � il valore di  litri al km consumati
      -- questo valore pu� arrivare (in base alla velocit� ) fino a 0.75 litri al km
      -- il calcolo � quindi (0.6 + modificatore) * lunghezzaTratto /1000
      -- derivante da (0.6+modificatore): 1000 = x : lunghezzaTratto
      
      --aggiorno velocità raggiunta
      vel_out := vel_array(traiettoriaScelta);

      crossingTime_Out := CrossingTime;
   end evaluate;

   -----------------------------------
   -----------------------------------
   -- TASKCOMPETITOR IMPLEMENTATION --
   -----------------------------------
   -----------------------------------



   task body TASKCOMPETITOR is
      C_Checkpoint : CHECKPOINT_SYNCH_POINT;
      PredictedTime : FLOAT := 0.0;
      DelayTime : FLOAT := 1.0;
      Paths2Cross : CROSSING_POINT;
      MinSegTime : FLOAT :=1.0;-- <minima quantit� di tempo per attraversare un tratto>
      lengthPath : FLOAT := 0.0;
      --<minima quantit� di tempo per attraversare la pista>
      carDriver : CAR_AND_DRIVER_ACCESS := carDriver_In;--
      MinRaceTime : FLOAT := MinSegTime * FLOAT(Get_RaceLength(carDriver.RaceIterator));
      CurrentCheckpoint : INTEGER := 1;
      ActualTime : FLOAT;
      Finished : BOOLEAN := FALSE;
      Index : INTEGER := 0;
      id : INTEGER := carDriver.Id;
      StartingPosition :INTEGER;
      Speed : FLOAT;
      CrossingTime : FLOAT;
      endWait : Boolean :=False;
      j: INTEGER:=0;
      tempoTotale : FLOAT := 0.0;
      valore:BOOLEAN :=False;
      --statistiche COMPETITOR_STATS
      compStats : COMPETITOR_STATS;
      SectorID : INTEGER;
      PitStop : BOOLEAN := false;  -- NEW, indica se fermarsi o meno ai box

      -- The lap count is kept in this variable
      --TODO: chiedere a lorenzo se non era gi� da qualche altra parte
      CurrentLap : INTEGER := 0;

      PitStopDone : BOOLEAN := false;

      --Strategy file name got from the box
      Strategy_FileName : Str.Unbounded_String := Str.Null_Unbounded_String;
      --Strategy got from the box
      BrandNewStrategy : Common.STRATEGY;

      --TODO: remove this test variable;
      --Tmp_Bool : BOOLEAN;

      --Helper method (given a file name, it return the strategy object extracted from that file)
      function XML2Strategy( StrategyFile : Str.Unbounded_String) return Common.STRATEGY is
         -- Objects needed for reading the XML strategy file
         Config : Node_List;
         Current_Node : NODE;
         Strategy_Doc : DOCUMENT;

         Tmp_Strategy : Common.STRATEGY;
         StyleStr : Str.Unbounded_String := Str.Null_Unbounded_String;
      begin

         Strategy_Doc := Common.Get_Document(doc_file => Str.To_String(StrategyFile));
         Config := Get_Elements_By_Tag_Name(Strategy_Doc,"strategy");
         Current_Node := Item(Config,0);

         Tmp_Strategy.Type_Tyre := Str.To_Unbounded_String(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"tyreType"))));
         Tmp_Strategy.GasLevel := FLOAT'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"gasLevel"))));
         Tmp_Strategy.PitStopLaps := INTEGER'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"pitStopLaps"))));
         Tmp_Strategy.PitStopDelay := FLOAT'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"pitStopDelay"))));

         StyleStr := Str.To_Unbounded_String(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"style"))));

         if(StyleStr = "Aggressive") then
            Tmp_Strategy.Style := Common.AGGRESSIVE;
         elsif(StyleStr = "Conservative") then
            Tmp_Strategy.Style := Common.CONSERVATIVE;
         else
            Tmp_Strategy.Style := Common.NORMAL;
         end if;

         return Tmp_Strategy;

      end XML2Strategy;

      procedure Remove_CompetitorFromRace(Iterator_In : out Circuit.RACETRACK_ITERATOR;
                                          PitStopDone_In : in BOOLEAN;
                                          Competitor_ID : INTEGER) is
         StartingPosition_P : INTEGER;
         Checkpoint_P : CHECKPOINT_SYNCH_POINT;
      begin
         Circuit.Get_NextCheckpoint(Iterator_In,Checkpoint_P);
         StartingPosition_P := Get_Position(Iterator_In);

         loop
            Checkpoint_P.Remove_Competitor(Competitor_ID);

            Circuit.Get_NextCheckpoint(Iterator_In,Checkpoint_P);
            exit when Get_Position(Iterator_In) = StartingPosition_P;
         end loop;

         if(PitStopDone_In = true) then

            Get_BoxCheckpoint(Iterator_In,Checkpoint_P);

            Checkpoint_P.Remove_Competitor(Competitor_ID);

         end if;
      end Remove_CompetitorFromRace;

   begin

      Ada.Text_IO.Put_Line("init task");--sincronizzazione task iniziale
      loop exit when endWait=true;
         accept Start do

            endWait := True;
        end Start;
      end loop;




      Get_CurrentCheckPoint(carDriver.RaceIterator,C_Checkpoint); -- NEW


                                                                  --end loop;
      -- Ask the box for the starting strategy
      Strategy_FileName := Str.To_Unbounded_String(CompetitorRadio.Get_Strategy(carDriver.Radio, CurrentLap));

      BrandNewStrategy := XML2Strategy(Strategy_FileName);

      --Updating the driver strategy with the first strategy given
      --+ by the box. TODO: verify wheter to set the gas level with
      --+ the one given by the box.
      carDriver.strategia.Type_Tyre := BrandNewStrategy.Type_Tyre;
      carDriver.strategia.PitStopLaps := BrandNewStrategy.PitStopLaps;
      carDriver.strategia.GasLevel := BrandNewStrategy.GasLevel;
      carDriver.strategia.Style := BrandNewStrategy.Style;

      loop


	 Ada.Text_IO.Put_Line("1");
         --Istante di tempo segnato nel checkpoint attuale per il competitor
         ActualTime := C_Checkpoint.Get_Time(id);
         Ada.Text_IO.Put_Line("2");

         Ada.Text_IO.Put_Line(Integer'Image(carDriver.Id)& Integer'Image(id)&
                              ": SUMMURY lap : " & INTEGER'IMAGE(CurrentLap) &
                              ", actual time : " & Float'Image(ActualTime) &
                              ", gas " & Float'IMAGE(carDriver.auto.GasolineLevel) &
                              ", tyre " & FLoat'IMAGE(carDriver.auto.TyreUsury) &
                              ", pit stop done " & BOOLEAN'IMAGE(PitStopDone));
         --Viene segnalato l'arrivo effettivo al checkpoint. In caso risulti primo,
         --viene subito assegnata la collezione  di path per la scelta della traiettoria
        
         if( C_Checkpoint.Is_PreBox = true ) then -- If true, the check point is a prebox
	  Ada.Text_IO.Put_Line("3");
            begin
               --Box comunication section
               -- Ask for the box strategy once the prebox checkpoint is reached
               Strategy_FileName := Str.To_Unbounded_String(CompetitorRadio.Get_Strategy(carDriver.Radio,CurrentLap+1));

	       --Get the strategy object from the file
               BrandNewStrategy := XML2Strategy(Strategy_FileName);

            exception
               when Error : others =>
                  Ada.Text_IO.Put_Line("Exception: " & Ada.Exceptions.Exception_Message(Error));
                  if( carDriver.strategia.PitStopLaps = 0) then
                     --To avoid another pitstop if done before
                     carDriver.strategia.PitStopLaps := 1;
                  end if;
                  --Reuse the same strategy as a new one
                  BrandNewStrategy := carDriver.strategia;
            end;


	    --Bisogna verificare se la strategia dice di tornare ai box, in tal caso:
            if(BrandNewStrategy.PitStopLaps = 0) then
               PitStop := true;
            end if;

	    carDriver.strategia.Style := BrandNewStrategy.Style;
            carDriver.strategia.PitStopLaps := BrandNewStrategy.PitStopLaps;
         end if;


	Ada.Text_IO.Put_Line("4");

         C_Checkpoint.Signal_Arrival(id);

         --When the competitor will be at the top of the list, he will be notified to
         --+ go ahead
         Ada.Text_IO.Put_Line("5");
         C_Checkpoint.Wait_Ready(carDriver.Id);

         --Now the competitor is for sure first and he can pick up the paths collection
         --+ evaluate the best way to take
         Ada.Text_IO.Put_Line("6");
         C_Checkpoint.Get_Paths(Paths2Cross,
                                Go2Box      => PitStop);
        
	Ada.Text_IO.Put_Line("7");
         StartingPosition := Get_Position(carDriver.RaceIterator);
Ada.Text_IO.Put_Line("8");
         --NEW: Moved. It was just before the crossing time calculation.
         SectorID:=C_Checkpoint.Get_SectorID;
Ada.Text_IO.Put_Line("9");
         --Inizio sezione dedicata alla scelta della traiettoria
         --questa � la soluzione attuale. Il crossing time e il choosenpath
         --sono valori restituiti dalla funzione
         --Path2Cross.ChooseBestPath(ID,CrossingTime,ChoosenPath,ActualTime);

         -- CrossingTime � il tempo effettivo di attraversamento del
         --tratto, compreso il tempo di attesa nella traiettoria.
         --Fine sezione  per la scelta della traiettoria

	 --If the competitor is in the box lane, set up the maximum speed
	 if(PitStop = true or PitStopDone = true) then
	 Ada.Text_IO.Put_Line("10");
         declare
           OriginalSpeed : FLOAT := Get_MaxSpeed(carDriver);
          begin
	    carDriver.auto.MaxSpeed := 80.0;
	    Evaluate(carDriver,C_Checkpoint, Paths2Cross, lengthPath, CrossingTime, Speed); -- NEW aggiunto parametro lunghezza del path scelto
	    --original driver speed restored.
	    carDriver.auto.MaxSpeed := OriginalSpeed;
	  end;
	 else
          Evaluate(carDriver,C_Checkpoint, Paths2Cross, lengthPath, CrossingTime, Speed); -- NEW aggiunto parametro lunghezza del path scelto
	 end if;
Ada.Text_IO.Put_Line("11");
         --Ora non c'� pi� rischio di race condition sulla scelta delle traiettorie
         --quindi pu� essere segnalato il passaggio del checkpoint per permettere agli
         --altri thread di eseguire finch� vengono aggiornati i tempi di arrivo negli
         --altri checkpoint
         C_Checkpoint.Signal_Leaving(id);

         --If a pitstop occured, add the pit stop time to the crossing time.
         --+ We assume that the pitstop is in the first half of the lane, so before
         --+ the goal.
         -- TODO: add the time when the competitor has to leave the box
         if (PitStop = true) then
            CrossingTime := CrossingTime + BrandNewStrategy.PitStopDelay;

         end if;
Ada.Text_IO.Put_Line("12");
         --Da adesso in poi, essendo state  rilasciate tutte le risorse, si possono
         --aggiornare i tempi di arrivo sui vari checkpoint senza rallentare il
         --procedere degli altri competitor

         PredictedTime := ActualTime + CrossingTime;
         --NEW, Ricordarsi del tempo di stop ai box in caso ci sia

         --If the checkpoint is the prebox, it's necessary to update all
         --+ the statistics from the prebox to the goal
         if(PitStop = TRUE) then

            declare
               Temp_Checkpoint : CHECKPOINT_SYNCH_POINT;
               Iterator_InitialPosition : INTEGER := Get_Position(carDriver.RaceIterator);
               Step : FLOAT := 0.0001;
               UpdatedCheckpoints : FLOAT := 1.0;
            begin
               Get_CurrentCheckpoint( carDriver.RaceIterator,Temp_Checkpoint);--NEW
               --Update all the statistics up to the goal checkpoint
               while Get_Position(carDriver.RaceIterator) /= Circuit.Checkpoints_Qty  loop
                  --Update the statistic to send to the OnboardComputer
                  compStats.Checkpoint := CurrentCheckpoint;
                  CurrentCheckpoint := CurrentCheckpoint + 1;
                  compStats.LastCheckInSect := FALSE;
                  compStats.FirstCheckInSect := FALSE;
                  compStats.Sector := Temp_Checkpoint.Get_SectorID;
                  compStats.GasLevel := carDriver.auto.GasolineLevel;
                  compStats.TyreUsury := carDriver.auto.TyreUsury;
                  compStats.MaxSpeed := Speed;
                  compStats.IsPitStop := false;
                  --TODO: explane the "Step" purpose
                  compStats.Time := PredictedTime + Step*UpdatedCheckpoints;

                  UpdatedCheckpoints := UpdatedCheckpoints + 1.0;
                  compStats.Lap := CurrentLap;
                  compStats.PathLength := 0.0;

                  OnBoardComputer.Add_Data(Computer_In => carDriver.statsComputer,
                                           Data        => compStats);

                  Get_NextCheckpoint(carDriver.RaceIterator,Temp_Checkpoint);
               end loop;
               CurrentCheckpoint := Circuit.Checkpoints_Qty;
               --Restore the iterator initial position
               while Get_Position(carDriver.RaceIterator) /= Iterator_InitialPosition loop
                  Get_NextCheckpoint(carDriver.RaceIterator, Temp_Checkpoint );
               end loop;
            end;

         end if;

Ada.Text_IO.Put_Line("13");

         --Update the statistic to send to the OnboardComputer
         compStats.Checkpoint := CurrentCheckpoint;
         compStats.LastCheckInSect := C_Checkpoint.Is_LastOfTheSector;
         compStats.FirstCheckInSect := C_Checkpoint.Is_FirstOfTheSector;
         compStats.Sector := SectorID;
         compStats.GasLevel := carDriver.auto.GasolineLevel;
         compStats.TyreUsury := carDriver.auto.TyreUsury;
         compStats.Time := PredictedTime;
         compStats.Lap := CurrentLap;
         compStats.PathLength := lengthPath;
         compStats.IsPitStop := FALSE;
         compStats.MaxSpeed := Speed;

         -- The prebox might be way before the last checkpoint in the sector.
         --+ It's necessary though to set the field to TRUE to allow the update
         --+ of the box. Otherwise the information related to the 3rd sectod
         --+ of this lap would never be add.
         if(PitStop = true) then
            compStats.LastCheckInSect := true;
         end if;
         if(PitStopDone = true) then
            compStats.IsPitStop := TRUE;
         end if;

         OnBoardComputer.Add_Data(Computer_In => carDriver.statsComputer,
                                  Data        => compStats);
Ada.Text_IO.Put_Line("14");
         --If the checkpoint is the box, it's necessary to update all
         --+ the statistics from the box to the exit-box
         if(PitStopDone = true) then

            declare
               Temp_Checkpoint : CHECKPOINT_SYNCH_POINT;
               Iterator_InitialPosition : INTEGER := 1;
               ExitBox_Position : INTEGER;
               Step : FLOAT := 0.0001;
               UpdatedCheckpoints : FLOAT := 1.0;
            begin
               --Find the exit box positino
               Get_ExitBoxCheckpoint(carDriver.RaceIterator,Temp_Checkpoint);
               ExitBox_Position := Get_Position(carDriver.RaceIterator);

               --Put che iterator in position number one
               while Get_Position(carDriver.RaceIterator) /= 2 loop
                  Get_NextCheckpoint(carDriver.RaceIterator,Temp_Checkpoint);
               end loop;
               CurrentCheckpoint := 2;

               --Update all the statistics up to the goal checkpoint
               while Get_Position(carDriver.RaceIterator) /= ExitBox_Position loop
                  --Update the statistic to send to the OnboardComputer
                  compStats.Checkpoint := CurrentCheckpoint;
                  CurrentCheckpoint := CurrentCheckpoint + 1;
                  compStats.LastCheckInSect := FALSE;
                  compStats.FirstCheckInSect := FALSE;
                  compStats.Sector := Temp_Checkpoint.Get_SectorID;
                  compStats.GasLevel := carDriver.auto.GasolineLevel;
                  compStats.TyreUsury := carDriver.auto.TyreUsury;
                  compStats.IsPitStop := TRUE;
                  compStats.Time := PredictedTime - (Step * UpdatedCheckpoints);
                  UpdatedCheckpoints := UpdatedCheckpoints + 1.0;
                  compStats.MaxSpeed := Speed;
                  compStats.Lap := CurrentLap;
                  compStats.PathLength := 0.0;

                  OnBoardComputer.Add_Data(Computer_In => carDriver.statsComputer,
                                           Data        => compStats);

                  Get_NextCheckpoint(carDriver.RaceIterator,Temp_Checkpoint);
               end loop;
               CurrentCheckpoint := ExitBox_Position-1;
               --Restore the iterator initial position
               Get_BoxCheckpoint(carDriver.RaceIterator,Temp_Checkpoint);

            end;

         end if;
Ada.Text_IO.Put_Line("15");

         if(carDriver.auto.GasolineLevel <= 0.0 or else carDriver.auto.TyreUsury >= 100.0) then

            --Update all the remaining information in the stats
            declare
               Temp_Checkpoint : CHECKPOINT_SYNCH_POINT;
               Temp_CheckpointPos : INTEGER;
               Temp_Lap : INTEGER := CurrentLap;
            begin

               CompetitorOut(Computer_In => carDriver.statsComputer,
                             Lap         => CUrrentLap,
                             Data        => compStats);

               loop


                  Get_NextCheckpoint(carDriver.RaceIterator,Temp_Checkpoint);
                  Temp_CheckpointPos := Get_Position(RaceIterator => carDriver.RaceIterator);

                  if(Temp_Checkpoint.Is_Goal) then
                     Temp_Lap := Temp_Lap + 1;
                  end if;

                  exit when Temp_Lap = LastLap;

                  compStats.Checkpoint := Temp_CheckpointPos;
                  compStats.LastCheckInSect := Temp_Checkpoint.Is_LastOfTheSector;
                  compStats.FirstCheckInSect := Temp_Checkpoint.Is_FirstOfTheSector;
                  compStats.Sector := Temp_Checkpoint.Get_SectorID;
                  compStats.GasLevel := carDriver.auto.GasolineLevel;
                  compStats.TyreUsury := carDriver.auto.TyreUsury;
                  compStats.IsPitStop := FALSE;
                  compStats.Time := PredictedTime;
                  compStats.Lap := Temp_Lap;
                  compStats.PathLength := 0.0;

                  OnBoardComputer.Add_Data(Computer_In => carDriver.statsComputer,
                                           Data        => compStats);

               end loop;

            end;

            Remove_CompetitorFromRace(Iterator_In    => carDriver.RaceIterator,
                                      PitStopDone_In => PitStopDone,
                                      Competitor_ID => carDriver.Id);
            
            Finished := TRUE;
         end if;
         exit when Finished = TRUE;
Ada.Text_IO.Put_Line("16");
         -- UPdate the time signed in the checkpoint queues. The first
         --+ one with the predicted time (the time the car will arrive)
         --+ and the other ones with that time increased with the minimum
         --+ time to cross a segment of the track.
         loop
            Circuit.Get_NextCheckpoint(carDriver.RaceIterator,C_Checkpoint);
            C_Checkpoint.Set_ArrivalTime(id,PredictedTime);
            PredictedTime := PredictedTime + 0.001;--MinRaceTime - MinSegTime * Float(Index);
            Index := Index + 1;

            exit when Get_Position(carDriver.RaceIterator) = StartingPosition;
            --HACK:
            --+ premise: the Get_NextCheckpoint never picks up the Box checkpoint
            --+(in the reality it's not a track checkpoint). The starting position
            --+ in case we are at the box is 0. So the loop will never finish
            --+ if we keep just the exit statement-
            --+ Given these premises, once we find that the starting position is
            --+ 0 we have to reset it to another value to make the loop finish.
            --+ This value is the position before the ExitBox (the first checkpoint
            --+ retrieved in this loop). So taking the position of the first checkpoint
            --+ retrieved in the loop and subtracting one, we have the pre-exitbox checkpoint.
            if StartingPosition = 0 then
               StartingPosition := Get_Position(carDriver.RaceIterator)-1;
            end if;
         end loop;
Ada.Text_IO.Put_Line("17");
         if(PitStopDone) then
            Get_BoxCheckpoint(carDriver.RaceIterator,C_Checkpoint);
         end if;
Ada.Text_IO.Put_Line("18");
         -- If it was a pitstop, get the checkpoint following the one of the boxes
         if( PitStop = true) then

            PitStop := false;
            PitStopDone := true;
            Get_BoxCheckpoint(carDriver.RaceIterator,C_Checkpoint);
            --HACK: in this way we add the competitor to the box queue (that is empty
            --+ by default)
            C_Checkpoint.Set_ArrivalTime(carDriver.Id, predictedTime);

            --Those updates will be effective in the next loop, so
            --+ they'll be used while doing the after-box path.
            carDriver.strategia.GasLevel := BrandNewStrategy.GasLevel;
            carDriver.strategia.Type_Tyre := BrandNewStrategy.Type_Tyre;
            carDriver.auto.GasolineLevel := BrandNewStrategy.GasLevel;
            carDriver.auto.Type_Tyre := BrandNewStrategy.Type_Tyre;
            --We assume che every pitstop the tyre are replaced
            carDriver.auto.TyreUsury := 0.0;

         else

            if(PitStopDone = true) then
               PitStopDone := false;
               C_Checkpoint.Remove_Competitor(carDriver.Id);
            end if;

            Get_NextCheckPoint(carDriver.RaceIterator,C_Checkpoint); --NEW
         end if;
Ada.Text_IO.Put_Line("19");

         if(C_CheckPoint.Is_Goal) then

            -- later on, at the end of the loop it will be updated to 1
            CurrentCheckpoint := 0;
            CurrentLap := CurrentLap + 1;
         end if;
Ada.Text_IO.Put_Line("20");
         -- Just for simulation purpose
         delay until(Ada.Calendar.Clock + Standard.Duration(CrossingTime));
         --Delay(1.0);
Ada.Text_IO.Put_Line("21");
         --If the checkpoint is the goal, get the race over
         if C_CheckPoint.Is_Goal and CurrentLap = LastLap then
            Ada.Text_IO.Put_Line(Integer'Image(carDriver.Id)&" Last lap reached");
            Finished := true;

            Remove_CompetitorFromRace(Iterator_In    => carDriver.RaceIterator,
                                      PitStopDone_In => PitStopDone,
                                      Competitor_ID => carDriver.Id);

            --Not necessary to send last information to box because it should
            --+ already know that the last lap has been reached


         end if;
Ada.Text_IO.Put_Line("22");
         exit when Finished = true;

         CurrentCheckpoint := CurrentCheckpoint + 1;

      end loop;

      --+Path2Cross.ChooseBestPath(ID,CrossingTime,ChoosenPath,ActualTime);
      --+come parametri bisogna che in entrata ci sia la strategia, altrimenti non
      --+abbiamo niente con cui poterla usare.
      --+come metodo non � male solo che credo stia meglio nella strategy in modo da
      --+poter essere disponibile anche per "l'oggetto" di StrategyBox.
      --+ultima cosa, � corretto chiamare path2cross quando noi invece abbiamo
      --+il segmento su cui poi scegliere il path giusto?
      --quando esco dal loop devo togliere il concorrente dalla coda altrimeni si pianta tutto, ovviamente perch� il suo segnaposto
      --rimane nelle code

      CompetitorRadio.Close_BOxCOnnection(Radio => carDriver.Radio);
   end TASKCOMPETITOR;


   function Get_StrategyGasLevel(str_In : CAR_AND_DRIVER_ACCESS) return FLOAT is
   begin
      return str_In.strategia.GasLevel;
   end Get_StrategyGasLevel;

   function Get_StrategyPitStopLaps(str_In : CAR_AND_DRIVER_ACCESS) return INTEGER is
   begin
      return str_In.strategia.PitStopLaps;
   end Get_StrategypitstopLaps;

   function Get_StrategyTyreType (str_In : CAR_AND_DRIVER_ACCESS) return Str.Unbounded_String is
   begin
      return str_In.strategia.Type_Tyre;
   end Get_StrategyTyreType;

   function Get_StrategyStyle (str_In : CAR_AND_DRIVER_ACCESS) return Common.DRIVING_STYLE is
   begin
      return str_In.strategia.Style;
   end Get_StrategyStyle;

   function Get_StrategyPitstopDelay (str_In : CAR_AND_DRIVER_ACCESS) return FLOAT is
   begin
      return str_In.strategia.PitStopDelay;
   end Get_StrategyPitstopDelay;

   ---------------------------------------------------------------------------------------------

end Competitor;

