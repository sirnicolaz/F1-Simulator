--with Circuit;
--use Circuit;
--with Strategy;
--use Strategy;
with Ada.Numerics.Generic_Elementary_Functions;
--use Ada.Numerics.Generic_Elementary_Functions;
package body Competitor is



   -- Set function - CAR
   procedure Configure_Car(Car_In : in out CAR_DRIVER_ACCESS;
                           MaxSpeed_In : FLOAT;
                           MaxAcceleration_In : FLOAT;
                           GasTankCapacity_In : FLOAT;
                           Engine_In : STRING) is
   begin
      Car_In.auto.MaxSpeed := MaxSpeed_In;
      Car_In.auto.MaxAcceleration := MaxAcceleration_In;
      Car_In.auto.GasTankCapacity := GasTankCapacity_In;
      Car_In.auto.Engine := Engine_In;
   end Configure_Car;

   procedure Set_Vel_In(Competitor_In : in out CAR_DRIVER_ACCESS; PVel_In : in FLOAT) is
   begin
      Competitor_In.pilota.Vel_In:=PVel_In;
   end Set_Vel_In;

   function Get_Vel_In(Competitor_In : CAR_DRIVER_ACCESS) return FLOAT is
   begin
      return Competitor_In.pilota.Vel_In;
   end Get_Vel_In;
   -- Get function - CAR MAX_SPEED
   function Get_MaxSpeed(Car_In : CAR_DRIVER_ACCESS) return FLOAT is
   begin
      return Car_In.auto.MaxSpeed;
   end Get_MaxSpeed;

   -- Get function - CAR MAX_ACCELERATION
   function Get_MaxAcceleration(Car_In : CAR_DRIVER_ACCESS) return FLOAT is
   begin
      return Car_In.auto.MaxAcceleration;
   end Get_MaxAcceleration;

   -- Get function - CAR GASTANKCAPACITY
   function Get_GasTankCapacity(Car_In : CAR_DRIVER_ACCESS) return FLOAT is
   begin
      return Car_In.auto.GasTankCapacity;
   end Get_GasTankCapacity;

   -- Get function - CAR ENGINE
   function Get_Engine(Car_In : CAR_DRIVER_ACCESS) return STRING is
   begin
      return Car_In.auto.Engine;
   end Get_Engine;

   -- Functino for Calculate Status
   function Calculate_Status(infoLastSeg : in CAR_DRIVER_ACCESS) return BOOLEAN is
      --questa funzione ritorna un boolean che indica se il concorrente
      --deve tornare o meno ai box
   begin
      if infoLastSeg.auto.TyreUsury <= 10.0 or infoLastSeg.auto.GasolineLevel <= 10 then
         -- i parametri si possono cambiare ovviamente
         -- basta darci dei valori consistenti
         return TRUE;
      else return FALSE;
      end if;

   end Calculate_Status;
   -- procedure Calculate_Status(infoLastSeg);
   -- questo metodo controlla tyre usury e gasoline level
   -- se sono sotto una soglia critica richiede l'intervento dei box
   -- per ora metto parametri a caso (cioè bisogna definire di preciso
   -- quale dev'essere il limite per richiamare i box, bisogna evitare che
   --la macchina non riesca più a girare nel caso il box non sia tempestivo
   --  nella risposta quindi bisogna che la soglia permetta ancora qualche giro,
   -- almeno 2 direi.


   procedure Set_Id(Car_In : in out CAR_DRIVER_ACCESS; Id_In : INTEGER;) is
   begin
      Car_In.pilota.ID := Id_In;
   end Set_Id;
   -- Set function - STATUS USURY
   procedure Set_Usury(Car_In : in out CAR_DRIVER_ACCESS;
                       Usury_In : FLOAT) is
   begin
      Car_In.auto.TyreUsury := Usury_In;
   end;

   -- Set function - STATUS GASLEVEL
   procedure Set_GasLevel(Car_In : in out CAR_DRIVER_ACCESS;
                          GasLevel_In : INTEGER) is
   begin
      Car_In.auto.GasolineLevel := GasLevel_In;
   end;

   -- Get function - STATUS USURY
   function Get_Usury(Car_In : CAR_DRIVER_ACCESS) return FLOAT is
   begin
      return Car_In.auto.TyreUsury;
   end Get_Usury;

   -- Get function - STATUS GASLEVEL
   function Get_GasLevel(Car_In : CAR_DRIVER_ACCESS) return INTEGER is
   begin
      return Car_In.auto.GasolineLevel;
   end Get_GasLevel;

   -- Get function - COMPETITOR_INFO TEAM
   function Get_Team(Competitor_In : CAR_DRIVER_ACCESS) return STRING is
   begin
      return Competitor_In.pilota.Team;
   end Get_Team;

   -- Get function - COMPETITOR_INFO FIRSTNAME
   function Get_FirstName(Competitor_In : CAR_DRIVER_ACCESS) return STRING is
   begin
      return Competitor_In.pilota.FirstName;
   end Get_FirstName;

   -- Get function - COMPETITOR_INFO LASTNAME
   function Get_LastName(Competitor_In : CAR_DRIVER_ACCESS) return STRING is
   begin
      return Competitor_In.pilota.LastName;
   end Get_LastName;

   -- Set function - COMPETITOR_INFO TEAM
   procedure Set_Team(Competitor_In: in out CAR_DRIVER_ACCESS;
                      Team_In : in STRING) is
   begin
      Competitor_In.pilota.Team := Team_In;
   end Set_Team;

   -- Set function - COMPETITOR_INFO FIRSTNAME
   procedure Set_FirstName(Competitor_In: in out CAR_DRIVER_ACCESS;
                           FirstName_In : in STRING) is
   begin
      Competitor_In.pilota.FirstName := FirstName_In;
   end Set_FirstName;

   -- Set function - COMPETITOR_INFO LASTNAME
   procedure Set_LastName(Competitor_In: in out CAR_DRIVER_ACCESS;
                          LastName_In : in STRING) is
   begin
      Competitor_In.pilota.LastName := LastName_In;
   end Set_LastName;

   -- Get function - TYRE MIXTURE
   function Get_Mixture(Car_In : CAR_DRIVER_ACCESS) return STRING is
   begin
      return Car_In.auto.Mixture;
   end Get_Mixture;

   -- Get function - TYRE TYPETYRE
   function Get_TypeTyre(Car_In : CAR_DRIVER_ACCESS) return STRING is
   begin
      return Car_In.auto.Type_Tyre;
   end Get_TypeTyre;

   -- Get function - TYRE MODEL
   function Get_Model(Car_In : CAR_DRIVER_ACCESS) return STRING is
   begin
      return Car_In.auto.Model;
   end Get_Model;

   -- Set function - TYRE MIXTURE
   procedure Set_Mixture(Car_In : in out CAR_DRIVER_ACCESS;
                         Mixture_In : in STRING) is
   begin
      Car_In.auto.Mixture := Mixture_In;
   end Set_Mixture;

   -- Set function - TYRE TYPETYRE
   procedure Set_TypeTyre(Car_In : in out CAR_DRIVER_ACCESS;
                          TypeTyre_In: in STRING) is
   begin
      Car_In.auto.Type_Tyre := TypeTyre_In;
   end Set_TypeTyre;

   procedure Set_Model(Car_In : in out CAR_DRIVER_ACCESS;
                       Model_In : in STRING) is
   begin
      Car_In.auto.Model := Model_In;
   end Set_Model;

   procedure Configure_Driver(Car_In: in out CAR_DRIVER_ACCESS;
                              Team_In : STRING;
                              FirstName_In : STRING;
                              LastName_In : STRING;
                              ID_In : INTEGER;
                              Vel_In : FLOAT) is
   begin
      Car_In.pilota.Team:=Team_In;
      Car_In.pilota.FirstName:=FirstName_In;
      Car_In.pilota.LastName:=LastName_In;
      Car_In.pilota.ID:=ID_In;
      Car_In.pilota.Vel_In:=Vel_In;
   end Configure_Driver;

   --Configuration Method of Strategy
   procedure Configure_Strategy(Car_In : in out CAR_DRIVER_ACCESS;
                                pitstopGasolineLevel_In : INTEGER;
                                pitstopLaps_In: INTEGER;
                                pitstopCondition_In : BOOLEAN;
                                trim_In : INTEGER;
                                pitstop_In : BOOLEAN) is
   begin
      Car_In.strategia.pitstopGasolineLevel :=  pitstopGasolineLevel_In;
      Car_In.strategia.pitstopLaps := pitstopLaps_In;
      Car_In.strategia.pitstopCondition := pitstopCondition_In;
      Car_In.strategia.trim := trim_In;
      Car_In.strategia.pitstop := pitstop_In;
   end Configure_Strategy;

   procedure Get_Status(Car_In : CAR_DRIVER_ACCESS; Usury_Out : out FLOAT; Level_Out : out INTEGER) is

   begin
      Usury_Out:=Get_Usury(Car_In);
      Level_Out:=Get_GasLevel(Car_In);
   end Get_Status;

   function Init_Competitor(xml_file : STRING; RaceIterator : RACETRACK_ITERATOR) return CAR_DRIVER_ACCESS is
      --parametri
      carDriver : CAR_DRIVER_ACCESS;
      procedure Configure_Strategy_File(Car_In : in out CAR_DRIVER_ACCESS;
                                        xml_file : STRING) is -- metodo per la configurazione della strategia a partire da un file
         pitstopGasolineLevel_In : INTEGER;
         pitstopLaps_In : INTEGER;
         pitstopCondition_In : BOOLEAN;
         trim_In : INTEGER;
         pitstop_In : BOOLEAN;
      begin
         -- lettura parametri dal file xml
         -- scrittura parametri
         Car_In.Configure_Strategy(pitstopGasolineLevel_In ,
                                   pitstopLaps_In,
                                   pitstopCondition_In,
                                   trim_In,
                                   pitstop_In);

      end Configure_Strategy_File;


      procedure Configure_Car_File(Car_In : in out CAR_DRIVER_ACCESS; xml_file : STRING) is
         MaxSpeed_In : FLOAT;
         MaxAcceleration_In : FLOAT;
         GasTankCapacity_In : FLOAT;
         Engine_In : STRING(1..50);
      begin
         Car_In.Configure_Car(MaxSpeed_In,
                              MaxAcceleration_In,
                              GasTankCapacity_In,
                              Engine_In);
      end Configure_Car_File;

      procedure Configure_Driver_File(Car_In : in out CAR_DRIVER_ACCESS; xml_file : STRING) is
         Team_In : STRING(1..20);
         FirstName_In : STRING(1..20);
         LastName_In : STRING(1..20);
         ID_In : INTEGER;
         Vel_In : FLOAT :=0.0;
      begin
         --lettura parametri, vel_in esclusa
         Car_In.Configure_Driver(Team_In,
                                 FirstName_In,
                                 LastName_In,
                                 ID_In,
                                 Vel_In);
      end Configure_Driver_File;
   begin
      carDriver.strategia:=Configure_Strategy_File(Car_In , xml_file);
      carDriver.auto:=Configure_Car_File(Car_In , xml_file);
      carDriver.pilota:=Configure_Driver_File(Car_In , xml_file);
      return carDriver;
   end Set_Get_CarDriver;
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

      MinSegTime : FLOAT :=1.0;-- <minima quantità di tempo per attraversare un tratto>

      --<minima quantità di tempo per attraversare la pista>
      carDriver : CAR_DRIVER_ACCESS;--
      MinRaceTime : FLOAT := MinSegTime * FLOAT(Get_RaceLength(carDriver.RaceIterator));

      ActualTime : FLOAT;
      Finished : BOOLEAN := FALSE;
      Index : INTEGER := 0;
      id : INTEGER := carDriver.pilota.ID;
      StartingPosition :INTEGER;
      --Path2Cross : carDriver.RaceIterator;
      CrossingTime : FLOAT;

   begin

      Get_NextCheckPoint(carDriver.RaceIterator,C_Checkpoint);

      loop
         --Istante di tempo segnato nel checkpoint attuale per il competitor
         ActualTime := C_Checkpoint.GetTime(id); -- non trovo la getTime nel checkpoint

         --Viene segnalato l'arrivo effettivo al checkpoint. In caso risulti primo,
         --viene subito assegnata la collezione  di path per la scelta della traiettoria
         C_Checkpoint.Signal_Arrival(id,Paths2Cross);--arrived

         --altrimenti si comincia ad attendere il proprio turno
         while Paths2Cross = null loop
            C_Checkpoint.Wait(id,Paths2Cross);
         end loop;

         --Ogni volta che si taglia il traguardo, bisogna controllare se le gara è finita.
         --Probabilmente bisognerà sistemare la procedura perchè le auto si fermino
         --anche prima di tagliare il traguardo nel caso il vincitore sia arrivato da un pezzo
         StartingPosition := Get_Position(carDriver.RaceIterator);

         if StartingPosition = 1 then
            Finished := Get_IsFinished(carDriver.RaceIterator);
         end if;

         --Se la gara è finita non è necessario effettuare la valutazione della traiettoria
         exit when Finished = true;

         --Inizio sezione dedicata alla scelta della traiettoria
         --questa è la soluzione attuale. Il crossing time e il choosenpath
         --sono valori restituiti dalla funzione

         --Path2Cross.ChooseBestPath(ID,CrossingTime,ChoosenPath,ActualTime);
         CrossingTime:= Evaluate(carDriver,C_Checkpoint); -- CrossingTime è il tempo effettivo di attraversamento del
         --tratto, compreso il tempo di attesa nella traiettoria.

         --Fine sezione  per la scelta della traiettoria

         --Ora non c'è più rischio di race condition sulla scelta delle traiettorie
         --quindi può essere segnalato il passaggio del checkpoint per permettere agli
         --altri thread di eseguire finchè vengono aggiornati i tempi di arrivo negli
         --altri checkpoint

         C_Checkpoint.Signal_Leaving(ID);


         --Da adesso in poi, essendo state  rilasciate tutte le risorse, si possono
         --aggiornare i tempi di arrivo sui vari checkpoint senza rallentare il
         --procedere degli altri competitor

         PredictedTime := ActualTime + CrossingTime;

         loop
            C_Checkpoint := Get_PreviousCheckpoint(carDriver.RaceIterator);--missing argument --
            PredictedTime := PredictedTime + MinRaceTime - MinSegTime * Float(Index);
            C_Checkpoint.Set_ArrivalTime(id); --manca un parametro
            Index := Index + 1;
            exit when Get_Position(carDriver.RaceIterator) = StartingPosition+1;
         end loop;

         --Delay(DELAY_TIME);
         Delay(Standard.Duration(PredictedTime));
      end loop;

      --+Path2Cross.ChooseBestPath(ID,CrossingTime,ChoosenPath,ActualTime);
      --+come parametri bisogna che in entrata ci sia la strategia, altrimenti non
      --+abbiamo niente con cui poterla usare.
      --+come metodo non è male solo che credo stia meglio nella strategy in modo da
      --+poter essere disponibile anche per "l'oggetto" di StrategyBox.
      --+ultima cosa, è corretto chiamare path2cross quando noi invece abbiamo
      --+il segmento su cui poi scegliere il path giusto?



   end TASKCOMPETITOR;

   -----------------------------------
   -----------------------------------
   ------ CALCOLO CROSSING TIME  -----
   -----------------------------------
   -----------------------------------
   function CalculateCrossingTime(CarDriver : CAR_DRIVER_ACCESS; PathsCollection_Index : CIRCUIT.RACETRACK_POINT;
                                  F_Segment : CHECKPOINT_SYNCH_POINT ; Vel_In : FLOAT) return FLOAT is
      length_path : FLOAT; --lunghezza tratto
      size_path : INTEGER; -- molteplicità tratto
      angle_path : FLOAT; -- angolo
      grip_path : FLOAT; -- attrito
      difficulty_path : FLOAT; -- difficoltà del tratto
      tyre_usury : FLOAT; -- usura delle gomme
      gasoline_level : INTEGER; -- livello di benzina
      vel_max_reale : FLOAT; --velocità massima raggiungibile
      vel_max : FLOAT;
      lc : FLOAT;
      timeCritical: FLOAT;
      acc: FLOAT;

   begin
      --velocità massima scalata per usura gomme e benzina presente.
      --V =velocità massima
      --U =usura gomme (valori da 0 a 1)
      --B =benzina presente (valori da 0 a 100)
      --VR=Velocità Reale (Velocita-%usura)scalato sulla benzina presente,+ benzina + lento..
      --VR= (V - (V*(U x 10)/100))-((B*V)/1000)
      -- B*V/1000 è la formula B/10 * V/100 quindi B=0, la velocità non diminuisce, B=100
      -- la velocità diminuisce di un 10 %
      --++++++++++++++++++++++++++++++++++++--
      -- bisogna prevedere una accelerazione (positiva o negativa) per calcolare il tempo di attraversamento..

      length_path := Get_Length(PathsCollection_Index);
      size_path := Get_Size(PathsCollection_Index);
      angle_path:= Get_Angle(PathsCollection_Index);
      grip_path:= Get_Grip(PathsCollection_Index);
      difficulty_path:= Get_Difficulty(PathsCollection_Index);
      tyre_usury := Get_Usury(CarDriver);
      gasoline_level:=Get_GasLevel(CarDriver);
      vel_max := Get_MaxSpeed(CarDriver); --
      acc := 1.2; -- cercare un valora buono per l'accelerazione da impostare nell'auto
      vel_max_reale := vel_max - ((vel_max * (tyre_usury * 10.0))/100.0) - ((Float(gasoline_level)*vel_max)/1000.0);
      --V - (V*(U x 10)/100))-((B*V)/1000)
      -- formula per il tempo di attraversamento
      -- caso 1
      -- tempo di percorrenza= tempo per raggiungere velocità massima.
      -- lunghezza tratto in accelerazione = lunghezza tratto
      -- velocità finale = velocità massima per quel tratto

      timeCritical := (vel_max_reale - Vel_In) / acc; -- tempo per arrivare a Vmax partendo da Vel_iniziale
      lc := Vel_In*timeCritical + 0.5*acc*timeCritical*timeCritical;
      if lc = length_path then
         CarDriver.pilota.Vel_In:=vel_max_reale;
         return timeCritical;-- aggiornare velocità
      end if;
      if lc < length_path then
         CarDriver.pilota.Vel_In:=vel_max_reale;
         return timeCritical + ( length_path - lc )/vel_max_reale;
      end if;

      if lc> length_path  then
         timeCritical := (-1.0) * (Vel_In/acc) + Sqrt(((Vel_In ** 2 ) + (2.0 * length_path))/(acc ** 2));
         CarDriver.pilota.Vel_In:=CarDriver.pilota.Vel_In + (acc * timeCritical);
         return timeCritical;
      end if;

   end CalculateCrossingTime;

   -----------------------------------
   -----------------------------------
   ------------ EVALUATE  ------------
   -----------------------------------
   -----------------------------------
   function Evaluate(driver : CAR_DRIVER_ACCESS ;
                     F_Segment : CHECKPOINT_SYNCH_POINT) return FLOAT is

      --qua dentro va effettuata la valutazione della traiettoria migliore e calcolato il tempo di attraversamento
      -- da restituire poi a chi invoca questo metodo.
      --qua credo che vadano eseguite le operazioni per attraversare il tratto


      --driver dovrà salvarsi la velocità che ha raggiunto.

      StartingInstant : FLOAT := 0.0;
      WaitingTime : FLOAT := 0.0;
      PathTime : FLOAT;
      CompArrivalTime : FLOAT := Get_ArrivalTime(F_Segment.Queue,1);--metodo non visibile
      CrossingTime : FLOAT := 0.0;
      TotalDelay : FLOAT := 0.0;
      MinDelay : FLOAT := -1.0;
      BestPath : PATH;
      Competitor_Status_Tyre : FLOAT;
      Competitor_Status_Level: INTEGER;

      -- Competitor_Strategy : STRATEGY_CAR := Competitor.Get_Strategy();

   begin
      -- loop on paths
      Competitor.Get_Status(driver, Competitor_Status_Tyre, Competitor_Status_Level);
      for Index in F_Segment.PathsCollection'RANGE loop
         PathTime := F_Segment.PathsCollection(Index).LastTime;
         WaitingTime := PathTime - CompArrivalTime;
         StartingInstant := PathTime;

         if WaitingTime < 0.0 then
            WaitingTime := 0.0;
            StartingInstant := CompArrivalTime;
         end if;

         CrossingTime := CalculateCrossingTime(driver, F_Segment.PathsCollection(Index), F_Segment,
                                               Get_Vel_In(driver));
         TotalDelay := StartingInstant + CrossingTime; --decidere come calcolare CrossingTime
         if TotalDelay < MinDelay or MinDelay < 0.0 then
            MinDelay := TotalDelay;
         end if;

         -- BestPath := segm[i] dicitura un po alla c++, da correggere.
         -- il significato è quello di cercare il path con tempo di attesa+attraversamento minore.

      end loop;
      return MinDelay;
   end evaluate;


   function Get_pitstopGasolineLevel(str_In : CAR_DRIVER_ACCESS) return INTEGER is
   begin
      return str_In.strategia.pitstopGasolineLevel;
   end Get_pitstopGasolineLevel;

   function Get_pitstopLaps(str_In : CAR_DRIVER_ACCESS) return INTEGER is
   begin
      return str_In.strategia.pitstopLaps;
   end Get_pitstopLaps;

   function Get_pitstopCondition (str_In : CAR_DRIVER_ACCESS) return BOOLEAN is
   begin
      return str_In.strategia.pitstopCondition;
   end Get_pitstopCondition;

   function Get_trim (str_In : CAR_DRIVER_ACCESS) return INTEGER is
   begin
      return str_In.strategia.trim;
   end Get_trim;

   function Get_pitstop (str_In : CAR_DRIVER_ACCESS) return BOOLEAN is
   begin
      return str_In.strategia.pitstop;
   end Get_pitstop;

   ---------------------------------------------------------------------------------------------

end Competitor;
