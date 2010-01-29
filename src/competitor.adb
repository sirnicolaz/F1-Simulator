--with Circuit;
--use Circuit;
--with Strategy;
--use Strategy;
with Ada.Numerics.Generic_Elementary_Functions;
with Queue; use Queue;
with Queue; use Queue;
--use Ada.Numerics.Generic_Elementary_Functions;
package body Competitor is



   -- Set function - CAR
   procedure Configure_Car(Car_In : in out CAR;
                           MaxSpeed_In : FLOAT;
                           MaxAcceleration_In : FLOAT;
                           GasTankCapacity_In : FLOAT;
                           Engine_In : STRING;
                           TyreUsury_In : FLOAT;
                           GasolineLevel_In : FLOAT;
                           Mixture_In : STRING;
                           Model_In : STRING;
                           Type_Tyre_In : STRING) is
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
   -- per ora metto parametri a caso (cioè bisogna definire di preciso
   -- quale dev'essere il limite per richiamare i box, bisogna evitare che
   --la macchina non riesca più a girare nel caso il box non sia tempestivo
   --  nella risposta quindi bisogna che la soglia permetta ancora qualche giro,
   -- almeno 2 direi.


   procedure Set_Id(Car_In : in out CAR_DRIVER_ACCESS; Id_In : INTEGER) is
   begin
      Car_In.Id := Id_In;
   end Set_Id;
   -- Set function - STATUS USURY
   procedure Set_Usury(Car_In : in out CAR_DRIVER_ACCESS;
                       Usury_In : FLOAT) is
   begin
      Car_In.auto.TyreUsury := Usury_In;
   end;

   -- Set function - STATUS GASLEVEL
   procedure Set_GasLevel(Car_In : in out CAR_DRIVER_ACCESS;
                          GasLevel_In : FLOAT) is
   begin
      Car_In.auto.GasolineLevel := GasLevel_In;
   end;

   -- Get function - STATUS USURY
   function Get_Usury(Car_In : CAR_DRIVER_ACCESS) return FLOAT is
   begin
      return Car_In.auto.TyreUsury;
   end Get_Usury;

   -- Get function - STATUS GASLEVEL
   function Get_GasLevel(Car_In : CAR_DRIVER_ACCESS) return FLOAT is
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

   procedure Configure_Driver(Car_In: in out DRIVER;
                              Team_In : STRING;
                              FirstName_In : STRING;
                              LastName_In : STRING;
                              Vel_In : FLOAT) is
   begin
      Car_In.Team:=Team_In;
      Car_In.FirstName:=FirstName_In;
      Car_In.LastName:=LastName_In;
      Car_In.Vel_In:=Vel_In;
   end Configure_Driver;

   --Configuration Method of Strategy
   procedure Configure_Strategy(Car_In : in out STRATEGY_CAR;
                                pitstopGasolineLevel_In : FLOAT;
                                pitstopLaps_In: INTEGER;
                                pitstopCondition_In : BOOLEAN;
                                trim_In : INTEGER;
                                pitstop_In : BOOLEAN) is
   begin
      Car_In.pitstopGasolineLevel :=  pitstopGasolineLevel_In;
      Car_In.pitstopLaps := pitstopLaps_In;
      Car_In.pitstopCondition := pitstopCondition_In;
      Car_In.trim := trim_In;
      Car_In.pitstop := pitstop_In;
   end Configure_Strategy;

   procedure Get_Status(Car_In : CAR_DRIVER_ACCESS; Usury_Out : out FLOAT; Level_Out : out FLOAT) is

   begin
      Usury_Out:=Get_Usury(Car_In);
      Level_Out:=Get_GasLevel(Car_In);
   end Get_Status;

   function Init_Competitor(xml_file : STRING; RaceIterator : RACETRACK_ITERATOR) return CAR_DRIVER_ACCESS is
      --parametri
      Input : File_Input;
      Reader : Tree_Reader;
      Doc : Document;
      carDriver_XML : Node_List;
      carDriver_Length : INTEGER;
      --   carDriver_Out : CAR_DRIVER_ACCESS;
      carDriver : CAR_DRIVER_ACCESS;

      procedure Try_OpenFile is
      begin

         Open(xml_file,Input);

         Set_Feature(Reader,Validation_Feature,False);
         Set_Feature(Reader,Namespace_Feature,False);

         Parse(Reader,Input);

         Doc := Get_Tree(Reader);
         carDriver_XML := Get_Elements_By_Tag_Name(Doc,"car_driver");
         carDriver_Length := Length(carDriver_XML);
      exception
         when ADA.IO_EXCEPTIONS.NAME_ERROR => Doc := null;
      end Try_OpenFile;

      procedure Configure_Strategy_File(Car_In : in out STRATEGY_CAR;
                                        xml_file : DOCUMENT) is -- metodo per la configurazione della strategia a partire da un file
         pitstopGasolineLevel_In : FLOAT;
         pitstopLaps_In : INTEGER;
         pitstopCondition_In : BOOLEAN;
         trim_In : INTEGER;
         pitstop_In : BOOLEAN;
         strategy_XML : Node_List;
         Current_Node : Node;

         --Car_Temp : CAR;
         --Car_Current : CAR;

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

         strategy_XML := Get_Elements_By_Tag_Name(xml_file,"strategy_car");

         Current_Node := Item(strategy_XML, 0);

         strategy_XML := Child_Nodes(Current_Node);
         pitstopGasolineLevel_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"pitstopGasolineLevel"))));
         pitstopLaps_In := Integer'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"pitstopLaps"))));
         pitstopCondition_In := Boolean'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"pitstopCondition"))));
         trim_In := Integer'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"trim"))));
         pitstop_In := Boolean'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"pitstop"))));

         --Racetrack_In(Index) := CheckpointSynch_Current;


         --end if;
         -- scrittura parametri
         Configure_Strategy(Car_In,
                            pitstopGasolineLevel_In ,
                            pitstopLaps_In,
                            pitstopCondition_In,
                            trim_In,
                            pitstop_In);

      end Configure_Strategy_File;


      procedure Configure_Car_File(Car_In : in out CAR; xml_file : DOCUMENT) is
         MaxSpeed_In : FLOAT;
         MaxAcceleration_In : FLOAT;
         GasTankCapacity_In : FLOAT;
         --Engine_In : STRING(1..50);
         TyreUsury_In : FLOAT;
         GasolineLevel_In : FLOAT;
         Mixture_In : STRING(1..20);
         Model_In : STRING(1..20);
         Type_Tyre_In : STRING(1..20);
         car_XML : Node_List;
         Current_Node : Node;
         Current_Team : STRING(1..7) :="Ferrari";
         Current_FirstName : STRING(1..8):="Fernando";
         Current_LastName : STRING(1..6) :="Alonso";
         --Car_Temp : CAR;
         --Car_Current : CAR;
         Engine_In : INTEGER;

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

         car_XML := Get_Elements_By_Tag_Name(xml_file,"car");

         Current_Node := Item(car_XML, 0);

         car_XML := Child_Nodes(Current_Node);
         MaxSpeed_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"maxspeed"))));
         MaxAcceleration_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"maxacceleration"))));
         GasTankCapacity_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"gastankcapacity"))));
         Engine_In := Integer'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"engine"))));
         TyreUsury_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"tyreusury"))));
         GasolineLevel_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"gastankcapacity"))));
         --Mixture_In := Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"mixture"))));
         --Model_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"model"))));
         --Type_Tyre_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"type_tyre"))));
         --Car_Temp := new CAR;
         Mixture_In := "morbidaxxxxxxxxxxxxx";
         Model_In := "michelinxxxxxxxxxxxx";
         Type_Tyre_In := "rainxxxxxxxxxxxxxxxx";
         --Racetrack_In(Index) := CheckpointSynch_Current;


         -- end if;



         Configure_Car(Car_In,
                       MaxSpeed_In,
                       MaxAcceleration_In,
                       GasTankCapacity_In,
                       "strong",--Engine_In,
                       TyreUsury_In,
                       GasolineLevel_In,
                       Mixture_In ,
                       Model_In ,
                       Type_Tyre_In );
      end Configure_Car_File;

      procedure Configure_Driver_File(Car_In : in out DRIVER; xml_file : DOCUMENT) is
         Team_In : STRING(1..7);
         FirstName_In : STRING(1..8);
         LastName_In : STRING(1..6);
         Vel_In : FLOAT :=0.0;
         driver_XML : Node_List;
         --Checkpoint_XML : Node_List;
         Current_Node : Node;
         --IsGoal_Attr : Attr;
         --IsGoal : BOOLEAN;
         --Current_Team : STRING(1..7);
         --Current_FirstName : STRING(1..10);
         --Current_LastName : STRING(1..10);
         --Car_Temp : CAR;
         --Car_Current : CAR;

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

         driver_XML := Get_Elements_By_Tag_Name(xml_file,"driver");
         Current_Node := Item(driver_XML, 0);
         driver_XML := Child_Nodes(Current_Node);
         --Team_In := Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"team"))));
         --FirstName_In := String'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"firstname"))));
         --LastName_In := String'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"lastname"))));
         --Car_Temp := new CAR;
         Team_In := "Ferrari";
         FirstName_In := "Fernando";
         LastName_In := "Alonso";
         --Racetrack_In(Index) := CheckpointSynch_Current;
         --end loop;


         --end if;

         --lettura parametri, vel_in esclusa
         Configure_Driver(Car_In,
                          Team_In,
                          FirstName_In,
                          LastName_In,
                          Vel_In);
      end Configure_Driver_File;
   begin
      --apertura del file
      Try_OpenFile;
      --configurazione parametri
      Configure_Strategy_File(carDriver.strategia , doc);
      Configure_Car_File(carDriver.auto , doc);
      Configure_Driver_File(carDriver.pilota , doc);
      return carDriver;
   end Init_Competitor;
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
      id : INTEGER := carDriver.Id;
      StartingPosition :INTEGER;
      --Path2Cross : carDriver.RaceIterator;
      CrossingTime : FLOAT;

   begin

      Get_NextCheckPoint(carDriver.RaceIterator,C_Checkpoint);

      loop
         --Istante di tempo segnato nel checkpoint attuale per il competitor
         ActualTime := C_Checkpoint.Get_Time(id); -- non trovo la getTime nel checkpoint

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
         CrossingTime:= Evaluate(carDriver,C_Checkpoint, Paths2Cross); -- CrossingTime è il tempo effettivo di attraversamento del
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
            Circuit.Get_PreviousCheckpoint(carDriver.RaceIterator,C_Checkpoint);--missing argument --
            PredictedTime := PredictedTime + MinRaceTime - MinSegTime * Float(Index);
            C_Checkpoint.Set_ArrivalTime(id,PredictedTime); --manca un parametro
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
   function CalculateCrossingTime (CarDriver : CAR_DRIVER_ACCESS; PathsCollection_Index : INTEGER;
                                   F_Segment : CHECKPOINT_SYNCH_POINT ; Vel_In : FLOAT;
                                   Paths2Cross : CROSSING_POINT) return FLOAT is
      length_path : FLOAT; --lunghezza tratto
      --size_path : INTEGER; -- molteplicità tratto
      angle_path : FLOAT; -- angolo
      grip_path : FLOAT; -- attrito
      difficulty_path : FLOAT; -- difficoltà del tratto
      tyre_usury : FLOAT; -- usura delle gomme
      gasoline_level : FLOAT; -- livello di benzina
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

      length_path := Paths2Cross.Get_Length(PathsCollection_Index);
      --size_path := Paths2Cross.Get_Size(PathsCollection_Index);

      angle_path:= Paths2Cross.Get_Angle(PathsCollection_Index);
      grip_path:= Paths2Cross.Get_Grip(PathsCollection_Index);
      difficulty_path:= Paths2Cross.Get_Difficulty(PathsCollection_Index);
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
      elsif lc < length_path then
         CarDriver.pilota.Vel_In:=vel_max_reale;
         return timeCritical + ( length_path - lc )/vel_max_reale;
      elsif lc> length_path  then
         timeCritical := (-1.0) * (Vel_In/acc) + 25.0;--Sqrt(((Vel_In ** 2 ) + (2.0 * length_path))/(acc ** 2));
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
                     F_Segment : CHECKPOINT_SYNCH_POINT; Paths2Cross : CROSSING_POINT) return FLOAT is

      --qua dentro va effettuata la valutazione della traiettoria migliore e calcolato il tempo di attraversamento
      -- da restituire poi a chi invoca questo metodo.
      --qua credo che vadano eseguite le operazioni per attraversare il tratto


      --driver dovrà salvarsi la velocità che ha raggiunto.

      StartingInstant : FLOAT := 0.0;
      WaitingTime : FLOAT := 0.0;
      PathTime : FLOAT;
      CompArrivalTime : FLOAT := F_Segment.Get_Time(driver.Id);
      --ho bisogno di avere metodi per il ritorno dei campi dati del checkpoint_sync_point
      --inoltre non vedo il metodo Get_ArrivalTime
      CrossingTime : FLOAT := 0.0;
      TotalDelay : FLOAT := 0.0;
      MinDelay : FLOAT := -1.0;
      --BestPath : PATH;
      Competitor_Status_Tyre : FLOAT;
      Competitor_Status_Level: FLOAT;
       --manca il metodo per tornare un pathcollection;
      -- Competitor_Strategy : STRATEGY_CAR := Competitor.Get_Strategy();

   begin
      -- loop on paths
      Competitor.Get_Status(driver, Competitor_Status_Tyre, Competitor_Status_Level);
      for Index in 1..Paths2Cross.Get_Size loop --no selector pathcollection for type cheskpoint_synch definded in circuit.ads
         PathTime := F_Segment.Get_Time(Index);
         WaitingTime := PathTime - CompArrivalTime;
         StartingInstant := PathTime;

         if WaitingTime < 0.0 then
            WaitingTime := 0.0;
            StartingInstant := CompArrivalTime;
         end if;

         CrossingTime := CalculateCrossingTime(driver, Index, F_Segment,
                                               Get_Vel_In(driver), Paths2Cross);
         TotalDelay := StartingInstant + CrossingTime; --decidere come calcolare CrossingTime
         if TotalDelay < MinDelay or MinDelay < 0.0 then
            MinDelay := TotalDelay;
         end if;

         -- BestPath := segm[i] dicitura un po alla c++, da correggere.
         -- il significato è quello di cercare il path con tempo di attesa+attraversamento minore.

      end loop;
      return MinDelay;
   end evaluate;


   function Get_pitstopGasolineLevel(str_In : CAR_DRIVER_ACCESS) return FLOAT is
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
