--with Circuit;
--use Circuit;
--with Strategy;
--use Strategy;
with Ada.Float_Text_IO;
 use Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions;
with Queue; use Queue;

with Common;

with CORBA.ORB;
with PolyORB.Setup.Client;
pragma Warnings (Off, PolyORB.Setup.Client);

with PolyORB.Utils.Report;

package body Competitor is

   -- Set function - CAR
   procedure Configure_Car(Car_In : in out CAR;
                           MaxSpeed_In : FLOAT;
                           MaxAcceleration_In : FLOAT;
                           GasTankCapacity_In : INTEGER;
                           Engine_In : Str.Unbounded_String;
                           TyreUsury_In : FLOAT;
                           GasolineLevel_In : INTEGER;
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
   function Get_GasTankCapacity(Car_In : CAR_DRIVER_ACCESS) return INTEGER is
   begin
      return Car_In.auto.GasTankCapacity;
   end Get_GasTankCapacity;

   -- Get function - CAR ENGINE
   function Get_Engine(Car_In : CAR_DRIVER_ACCESS) return Str.Unbounded_String is
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
   function Get_Team(Competitor_In : CAR_DRIVER_ACCESS) return Str.Unbounded_String is
   begin
      return Competitor_In.pilota.Team;
   end Get_Team;

   -- Get function - COMPETITOR_INFO FIRSTNAME
   function Get_FirstName(Competitor_In : CAR_DRIVER_ACCESS) return Str.Unbounded_String is
   begin
      return Competitor_In.pilota.FirstName;
   end Get_FirstName;

   -- Get function - COMPETITOR_INFO LASTNAME
   function Get_LastName(Competitor_In : CAR_DRIVER_ACCESS) return Str.Unbounded_String is
   begin
      return Competitor_In.pilota.LastName;
   end Get_LastName;

   -- Set function - COMPETITOR_INFO TEAM
   procedure Set_Team(Competitor_In: in out CAR_DRIVER_ACCESS;
                      Team_In : in Str.Unbounded_String) is
   begin
      Competitor_In.pilota.Team := Team_In;
   end Set_Team;

   -- Set function - COMPETITOR_INFO FIRSTNAME
   procedure Set_FirstName(Competitor_In: in out CAR_DRIVER_ACCESS;
                           FirstName_In : in Str.Unbounded_String) is
   begin
      Competitor_In.pilota.FirstName := FirstName_In;
   end Set_FirstName;

   -- Set function - COMPETITOR_INFO LASTNAME
   procedure Set_LastName(Competitor_In: in out CAR_DRIVER_ACCESS;
                          LastName_In : in Str.Unbounded_String) is
   begin
      Competitor_In.pilota.LastName := LastName_In;
   end Set_LastName;

   -- Get function - TYRE MIXTURE
   function Get_Mixture(Car_In : CAR_DRIVER_ACCESS) return Str.Unbounded_String is
   begin
      return Car_In.auto.Mixture;
   end Get_Mixture;

   -- Get function - TYRE TYPETYRE
   function Get_TypeTyre(Car_In : CAR_DRIVER_ACCESS) return Str.Unbounded_String is
   begin
      return Car_In.auto.Type_Tyre;
   end Get_TypeTyre;

   -- Get function - TYRE MODEL
   function Get_Model(Car_In : CAR_DRIVER_ACCESS) return Str.Unbounded_String is
   begin
      return Car_In.auto.Model;
   end Get_Model;

   -- Set function - TYRE MIXTURE
   procedure Set_Mixture(Car_In : in out CAR_DRIVER_ACCESS;
                         Mixture_In : in Str.Unbounded_String) is
   begin
      Car_In.auto.Mixture := Mixture_In;
   end Set_Mixture;

   -- Set function - TYRE TYPETYRE
   procedure Set_TypeTyre(Car_In : in out CAR_DRIVER_ACCESS;
                          TypeTyre_In: in Str.Unbounded_String) is
   begin
      Car_In.auto.Type_Tyre := TypeTyre_In;
   end Set_TypeTyre;

   procedure Set_Model(Car_In : in out CAR_DRIVER_ACCESS;
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

   procedure Get_Status(Car_In : CAR_DRIVER_ACCESS; Usury_Out : out FLOAT; Level_Out : out INTEGER) is

   begin
      Usury_Out:=Get_Usury(Car_In);
      Level_Out:=Get_GasLevel(Car_In);
   end Get_Status;

   function Init_Competitor(xml_file : STRING; RaceIterator : RACETRACK_ITERATOR; id_In : INTEGER) return CAR_DRIVER_ACCESS is
      --parametri
      Input : File_Input;
      Reader : Tree_Reader;
      Doc : Document;
      carDriver_XML : Node_List;
      carDriver_Length : INTEGER;

      --   carDriver_Out : CAR_DRIVER_ACCESS;
      carDriver : CAR_DRIVER_ACCESS := new CAR_DRIVER;


      procedure Try_OpenFile is--(xml_file : STRING; Input : in out File_Input; Reader : in out Tree_Reader; Doc : in out Document;
         --carDriver_XML : in out Node_List; carDriver_Length : in out INTEGER) is
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

      function Configure_Strategy_File(xml_file_In : DOCUMENT) return STRATEGY_CAR is -- metodo per la configurazione della strategia a partire da un file
         pitstopGasolineLevel_In : FLOAT;
         pitstopLaps_In : INTEGER;
         pitstopCondition_In : BOOLEAN;
         trim_In : INTEGER;
         pitstop_In : BOOLEAN;
         strategy_XML : Node_List;
         Current_Node : Node;

         Car_In : STRATEGY_CAR;
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

         strategy_XML := Get_Elements_By_Tag_Name(xml_file_In,"strategy_car");

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
         return Car_In;
      end Configure_Strategy_File;


      function Configure_Car_File(xml_file_In : DOCUMENT) return CAR is
         MaxSpeed_In : FLOAT;
         MaxAcceleration_In : FLOAT;
         GasTankCapacity_In : INTEGER;--FLOAT;
         --Engine_In : STRING(1..50);
         TyreUsury_In : FLOAT;
         GasolineLevel_In : INTEGER;--FLOAT;
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
--  Ada.Text_IO.Put_Line("parser xml");
         --If there is a conf file, use it to auto-init;

         -- if Document_In /= null then

         car_XML := Get_Elements_By_Tag_Name(xml_file_In,"car");

         Current_Node := Item(car_XML, 0);

         car_XML := Child_Nodes(Current_Node);
         MaxSpeed_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"maxspeed"))));
         MaxAcceleration_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"maxacceleration"))));
         GasTankCapacity_In := Integer'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"gastankcapacity"))));
         Engine_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"engine"))));
         TyreUsury_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"tyreusury"))));
         GasolineLevel_In := Integer'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"gasolinelevel"))));
         --Ada.Text_IO.Put_Line("prima ");
         Mixture_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"mixture"))));
         --Ada.Text_IO.Put_Line("mixture type----------------------");
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

      function Configure_BoxCorbaLoc_File(xml_file_In : DOCUMENT) return Str.Unbounded_String is
         BoxCorbaLoc_ElementsList : Node_List;
         Current_Node : Node;
         CorbaLoc : Str.Unbounded_String := Str.Null_Unbounded_String;
      begin
         BoxCorbaLoc_ElementsList := Get_Elements_By_Tag_Name(xml_file_In,"boxCorbaLoc");
         Current_Node := Item(BoxCorbaLoc_ElementsList, 0);
         CorbaLoc := Str.To_Unbounded_String(Node_Value(First_Child(Current_Node)));
         return CorbaLoc;
      end Configure_BoxCorbaLoc_File;

      --remote communication declaration section
      use PolyORB.Utils.Report;
      boxCorbaLoc : Str.Unbounded_String := Str.Null_Unbounded_String;

   begin

      --apertura del file
      Try_OpenFile;
      --configurazione parametri
      Ada.Text_IO.Put_Line(Integer'Image(id_In)&" : strategia...");
      carDriver.strategia := Configure_Strategy_File(doc);
      Ada.Text_IO.Put_Line(Integer'Image(id_In)&" : ...auto...");
      carDriver.auto := Configure_Car_File(doc);
      Ada.Text_IO.Put_Line(Integer'Image(id_In)&" : ...pilota...");
      carDriver.pilota := Configure_Driver_File(doc);
      carDriver.RaceIterator:=RaceIterator;
      carDriver.Id:=id_In;

      --Init communication with the box
      boxCorbaLoc := Configure_BoxCorbaLoc_File(doc);

      CORBA.ORB.Initialize ("ORB");

      --  Getting the CORBA.Object
      CORBA.ORB.String_To_Object
        (CORBA.To_CORBA_String (Str.To_String(boxCorbaLoc)), carDriver.Radio);

      --  Checking if it worked

      if BoxRadio.Is_Nil (carDriver.Radio) then
         Put_Line ("Competitor " & INTEGER'IMAGE(carDriver.Id) & " : cannot invoke on a nil reference");
      end if;

      --carDriver.statsComputer.Init_Computer(carDriver.Id, global);
      --carDriver:= new CAR_DRIVER(Configure_Car_File(doc),Configure_Driver_File(doc),Configure_Strategy_File(doc));
      return carDriver;
   end Init_Competitor;


   -----------------------------------
   -----------------------------------
   ------ CALCOLO CROSSING TIME  -----
   -----------------------------------
   -----------------------------------
   procedure CalculateCrossingTime (TimeCriticalTemp : out FLOAT; CarDriver : CAR_DRIVER_ACCESS; PathsCollection_Index : INTEGER;
                                    F_Segment : CHECKPOINT_SYNCH_POINT ; Vel_In : FLOAT;
                                    Paths2Cross : CROSSING_POINT; Vel_Out : out FLOAT) is
      length_path : FLOAT; --lunghezza tratto
      --size_path : INTEGER; -- molteplicità tratto
      angle_path : FLOAT; -- angolo
      grip_path : FLOAT; -- attrito
      difficulty_path : FLOAT; -- difficoltà del tratto
      tyre_usury : FLOAT; -- usura delle gomme
      gasoline_level : INTEGER; -- livello di benzina
      vel_max_reale : FLOAT; --velocità massima raggiungibile
      vel_max : FLOAT := carDriver.auto.MaxSpeed;
      lc : FLOAT;
      timeCritical: FLOAT;
      acc: FLOAT;

   begin
      --++++++Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : in CalculateCrossingTime");
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
      --++++++Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : length_path = "&Float'Image(length_path));
      angle_path:= Paths2Cross.Get_Angle(PathsCollection_Index);
      --++++++      Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : angle_path = "&Float'Image(angle_path));
      grip_path:= Paths2Cross.Get_Grip(PathsCollection_Index);
      --++++++      Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : grip_path = "&Float'Image(grip_path));
      difficulty_path:= Paths2Cross.Get_Difficulty(PathsCollection_Index);
      --++++++      Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : difficulty_path = "&Float'Image(difficulty_path));
      tyre_usury := Get_Usury(CarDriver);
      Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : tyre_usury = "&Float'Image(tyre_usury));
      gasoline_level:=Get_GasLevel(CarDriver);
      Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : gasoline_level = "&Integer'Image(gasoline_level));
      vel_max := Get_MaxSpeed(CarDriver); --
      --++++++      Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : vel_max*((Float(gasoline_level)*10.0)/100.0)) = "&Float'Image(vel_max*((Float(gasoline_level)*10.0)/100.0)));
      acc := 1.2; -- cercare un valora buono per l'accelerazione da impostare nell'auto
      Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : vel max : "&Float'Image(vel_max)
                           &" , (tyre_usury * (vel_max)/10.0) : "&Float'Image((tyre_usury * (vel_max)/10.0))
                          &" , (gasoline_level/10.00)*(vel_max)/100.0) : "&Float'Image((Float(gasoline_level/10)*(vel_max)/100.0)));

      vel_max_reale := vel_max-((tyre_usury * (vel_max)/10.0))-((Float(gasoline_level/10)*(vel_max)/100.0));

     -- tyre_usury := CarDriver.auto.TyreUsury; --(25 giri per una gomma circa)

     -- gasoline_level := CarDriver.auto.GasolineLevel;
      if gasoline_level <= 0 then
         -- vel_max_reale:=0.0; da rimettere..va aggiunto un metodo nella competizione RITIRATO
         Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : ATTENZIONE - BENZINA FINITA !!!");
      else
         Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : tyre_usury = "&Float'Image(tyre_usury));
         Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : gasoline_level = "&Integer'Image(gasoline_level));
      end if;

      --V - (V*(U x 10)/100))-((B*V)/1000)
      -- formula per il tempo di attraversamento
      -- caso 1
      -- tempo di percorrenza= tempo per raggiungere velocità massima.
      -- lunghezza tratto in accelerazione = lunghezza tratto
      -- velocità finale = velocità massima per quel tratto
      Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : vel max : "&Float'Image(vel_max));
      Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : vel max reale : "&Float'Image(vel_max_reale));
      --++++++      Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : vel in : "&Float'Image(Vel_In));
      timeCritical := (vel_max_reale - Vel_In) / acc; -- tempo per arrivare a Vmax partendo da Vel_iniziale
      if vel_max_reale <= 0.0 then lc:=0.0;
      else lc := Vel_In*timeCritical + 0.5*acc*timeCritical*timeCritical;
      end if;
      --++++++      Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : time critical = "&Float'Image(timeCritical));
      --++++++      Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : lc = "&Float'Image(lc));
      --return 10.0;

      if lc = length_path then
         --++++++         Ada.Text_IO.Put_Line("-------------------"&Integer'Image(carDriver.Id)&" : CASO 1 - lc=length_path, return "&Float'Image(timeCritical));
         Vel_Out:=vel_max_reale;---attenzione TODO se cambio vel in in una traiettoria lo cambio anche per quella dopo...
         TimeCriticalTemp := timeCritical;-- aggiornare velocità
      elsif lc < length_path then
         --++++++ Ada.Text_IO.Put_Line("-------------------"&Integer'Image(carDriver.Id)&" : CASO 2 - lc<length_path, return "&Float'Image(timeCritical + ( length_path - lc )/vel_max_reale));
         Vel_Out:=vel_max_reale;
         --if vel_max_reale = 0.0 then timeCriticalTemp := -1000.0;
         --else
         if vel_max_reale = 0.0 then timeCriticalTemp := 0.0;
         else
            TimeCriticalTemp := timeCritical + ( length_path - lc )/vel_max_reale;
         end if;
      elsif lc> length_path  then
         --++++++ Ada.Text_IO.Put_Line("-------------------"&Integer'Image(carDriver.Id)&" : CASO 3 - lc>length_path, return "&Float'Image((-1.0) * (Vel_In/acc) + 25.0));
         timeCritical := (-1.0) * (Vel_In/acc) + Ada.Numerics.Elementary_Functions.Sqrt(((Vel_In ** 2 ) + (2.0 * length_path))/(acc ** 2));--TODO Correggere
         Vel_Out:=CarDriver.pilota.Vel_In + (acc * timeCritical);
         TimeCriticalTemp := timeCritical;
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
      CrossingTime : FLOAT:= 0.0;
      CrossingTimeTemp : FLOAT;
      TotalDelay : FLOAT := 0.0;
      MinDelay : FLOAT := -1.0;
      pathTimeMinore : FLOAT;
      --BestPath : PATH;
      Competitor_Status_Tyre : FLOAT;
      Competitor_Status_Level: INTEGER;
      --manca il metodo per tornare un pathcollection;
      -- Competitor_Strategy : STRATEGY_CAR := Competitor.Get_Strategy();
      velTemp : FLOAT :=0.0;
      traiettoriaScelta : INTEGER;
      vel_array : VEL(1..Paths2Cross.Get_Size);
   begin
      -- Ada.Text_IO.Put_Line(Integer'Image(driver.Id)&" : In evaluate");
      -- loop on paths
      Competitor.Get_Status(driver, Competitor_Status_Tyre, Competitor_Status_Level);
      --++++++   Ada.Text_IO.Put_Line("-------------------"&Integer'Image(driver.Id)&" : dopo get status");
      for Index in 1..Paths2Cross.Get_Size loop
         --CrossingTime:= 0.0;
         --++++++         Ada.Text_IO.Put_Line(Integer'Image(driver.Id)&" : Paths2Cross.Get_Size = "&Integer'Image(Paths2Cross.Get_Size));
         PathTime := Paths2Cross.Get_PathTime(Index);
         WaitingTime := PathTime - CompArrivalTime;
         -- Ada.Text_IO.Put_Line(Integer'Image(driver.Id)& " : @@@@^^^^^¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿ path time: " &Float'Image(PathTime));
         StartingInstant := PathTime;
         --++++++         Ada.Text_IO.Put_Line("-------------------"&Integer'Image(driver.Id)&" :scorro il path2cross, index = "&Integer'Image(Index));
         if WaitingTime < 0.0 then
            WaitingTime := 0.0;
            StartingInstant := CompArrivalTime;
         end if;
         --CrossingTime:=CrossingTime+StartingInstant;
         --++++++         Ada.Text_IO.Put_Line("-------------------"&Integer'Image(driver.Id)&" : before crossing time");
         --   Ada.Text_IO.Put_Line(Integer'Image(driver.Id)& " : @@@@^^^^^¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿ waiting time DOPO: " &Float'Image(WaitingTime));

         CalculateCrossingTime(CrossingTimeTemp, driver, Index, F_Segment, Get_Vel_In(driver), Paths2Cross, velTemp);
         vel_array(Index):=velTemp;
         CrossingTimeTemp := CrossingTimeTemp + WaitingTime;--StartingInstant;
         Ada.Text_IO.Put_Line(Integer'Image(driver.Id)& " : CrossingTime ="&Float'Image(CrossingTime)&" CrossingTimeTemp = "&Float'Image(CrossingTimeTemp));
         if CrossingTimeTemp = -1000.0 then
            Ada.Text_IO.Put_Line("-------------------"&Integer'Image(driver.Id)&" : RITIRATO. ");
         end if; -- else if
         if CrossingTime > CrossingTimeTemp or else  CrossingTime <= 0.0 then
            CrossingTime := CrossingTimeTemp;
            traiettoriaScelta := Index;
            pathTimeMinore := PathTime;
         end if;
         -- traiettoriaScelta := Index;
         --++++++  Ada.Text_IO.Put_Line("-------------------"&Integer'Image(driver.Id)&" : after crossing time");
         TotalDelay := StartingInstant + CrossingTime; --
         Ada.Text_IO.Put_Line("-------------------"&Integer'Image(driver.Id)&" : total delay = "&Float'Image(TotalDelay));
         if TotalDelay < MinDelay or else MinDelay < 0.0 then
            MinDelay := TotalDelay;
            --  Paths2Cross.Update_Time(PathTime+MinDelay, Index);--aggiorno i tempi sulla pista

            --else Paths2Cross.Update_Time(PathTime+TotalDelay, Index); --aggiorno i tempi sulla pista
         end if;
         --BestPath := segm[i] dicitura un po alla c++, da correggere.
         -- il significato è quello di cercare il path con tempo di attesa+attraversamento minore.

      end loop;
      --Ada.Text_IO.Put_Line(Integer'Image(driver.Id)& " : $$$$$$$$$$$$$$$$$$size array velocità = "&Integer'Image(vel_array'LENGTH));
      --for i in 1..vel_array'LENGTH loop
      --  Ada.Text_IO.Put_Line(Integer'Image(driver.Id)& " : $$$$$$$$$$$$$$$$$$velocità path[ "&Integer'Image(i)&" ]= "&Float'Image(vel_array(i)));
      --end loop;
      --++++++      Ada.Text_IO.Put_Line("-------------------"&Integer'Image(driver.Id)&" : min delay = "&Float'Image(MinDelay));
      Paths2Cross.Update_Time(pathTimeMinore+TotalDelay, traiettoriaScelta);
      driver.pilota.Vel_In := vel_array(traiettoriaScelta); --aggiorno la velocità di entrata al tratto successivo
      Ada.Text_IO.Put_Line(Integer'Image(driver.Id)& " : path scelto = "&Integer'Image(traiettoriaScelta));
      for Index in 1..Paths2Cross.Get_Size loop
         PathTime := Paths2Cross.Get_PathTime(Index);
         --Ada.Text_IO.Put_Line(Integer'Image(driver.Id)& " : @@@@^^^^^¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿ path time di indice "&Integer'Image(Index)&": " &Float'Image(PathTime));
      end loop;
      return MinDelay;
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
      MinSegTime : FLOAT :=1.0;-- <minima quantità di tempo per attraversare un tratto>

      --<minima quantità di tempo per attraversare la pista>
      carDriver : CAR_DRIVER_ACCESS := carDriver_In;--
      MinRaceTime : FLOAT := MinSegTime * FLOAT(Get_RaceLength(carDriver.RaceIterator));
      i : INTEGER := 0;
      ActualTime : FLOAT;
      Finished : BOOLEAN := FALSE;
      Index : INTEGER := 0;
      id : INTEGER := carDriver.Id;
      StartingPosition :INTEGER;
      --Path2Cross : carDriver.RaceIterator;
      CrossingTime : FLOAT;
      endWait : Boolean :=False;
      j: INTEGER:=0;
      tempoTotale : FLOAT := 0.0;
      valore:BOOLEAN :=False;
      --statistiche COMP_STATS
      compStats : Common.COMP_STATS_POINT := new Common.COMP_STATS;
      SectorID : INTEGER;

      PitStop : BOOLEAN := false;  -- NEW, indica se fermarsi o meno ai box
   begin

      Ada.Text_IO.Put_Line("init task");--sincronizzazione task iniziale
      loop exit when endWait=true;
         accept Start do
            Ada.Text_IO.Put_Line(Integer'Image(carDriver.Id)&" : Start task");
            endWait := True;
            --TODO: Contattare il Box e chiedergli la strategia
         end Start;
      end loop;


      Ada.Text_IO.Put_Line(Integer'Image(carDriver.Id)&" : body of competitor task, ID = "&Integer'Image(id));--&" , mixture = "&Str.To_String(carDriver.auto.Mixture));
      --Get_NextCheckPoint(carDriver.RaceIterator,C_Checkpoint);
      --Ada.Text_IO.Put_Line(Integer'Image(carDriver.Id)&" : body of competitor task, firstName = "&carDriver.pilota.FirstName);
      --Ada.Text_IO.Put_Line(Integer'Image(carDriver.Id)&" : body of competitor task, lastName = "&carDriver.pilota.LastName);
      --Ada.Text_IO.Put_Line(Integer'Image(carDriver.Id)&" : body of competitor task, Team = "&carDriver.pilota.Team);
      --Ada.Text_IO.Put_Line(Integer'Image(carDriver.Id)&" : car max speed = "&Float'Image(carDriver.auto.MaxSpeed));
      --Ada.Text_IO.Put_Line(Integer'Image(carDriver.Id)&" : driver vel in = "&Float'Image(carDriver.pilota.Vel_In));
      Get_CurrentCheckPoint(carDriver.RaceIterator,C_Checkpoint); -- NEW
      --valore := Sincronizza(carDriver.Id, C_Checkpoint);
      --loop exit when C_Checkpoint.getContaConcorrenti = 4;
      -- Ada.Text_IO.Put_Line("asasaasaasasasasasasasasasasasasasasasasasasasasasasasasasasasasasasasasasas");
      --Ada.Text_IO.Put_Line("concorrente "&Integer'Image(carDriver.Id)&", contaconcorrenti = "&Integer'Image(C_Checkpoint.getContaConcorrenti));
      --end loop;
      loop
         -- CONTROLLO STRATEGIA CON I BOX


         -- FINE CONTROLLO STRATEGIA CON I BOX

         Ada.Text_IO.Put_Line("______-------****** ITERAZIONE : "&Integer'Image(i)&" , TASK "&Integer'Image(Id)&"******-------______");
--Ada.Float_Text_IO.Put(tempoTotale);
         --Istante di tempo segnato nel checkpoint attuale per il competitor
         ActualTime := C_Checkpoint.Get_Time(id);
         Ada.Text_IO.Put_Line(Integer'Image(id)&" : 2- actual time : "&Float'Image(ActualTime));
         --Viene segnalato l'arrivo effettivo al checkpoint. In caso risulti primo,
         --viene subito assegnata la collezione  di path per la scelta della traiettoria
         if( C_Checkpoint.Set_Arrived(id) = true ) then -- NEW: se torna true, significa che è un prebox

            --Bisogna richiedere la nuova strategia al box
            --dichiara una stringa e assegnaci il valore di ritorno della box radio
            --BoxRadio.RequestStrategy(carDriver.Radio,1);
            --prendi quella stringa e tramite un qualche metodo salvala su file
            --e poi parsala per prendere su l'oggetto strategia corrispondente
            --Bisogna verificare se la strategia dice di tornare ai box, in tal caso:
            -- PitStop := true;
            --Dopodichè copia i nuovi valori di strategia e memorizza il tempo di pitstop
            --in caso sia necessario farlo
            null;
         end if;


         C_Checkpoint.Signal_Arrival(id,Paths2Cross,PitStop);--arrived
         --altrimenti si comincia ad attendere il proprio turno
                                                             --era while ... loop

         --NEW, ovunque sia che bisogna usarlo, il checkpoint successivo ai box
         --+ si ottiene con Get_ExitBoxCheckpoint invece che Get_NextCheckpoint

         -- NEW, prima non era commentato. Ora è stato cambiato il checkpoint
--           while Paths2Cross = null loop
--              C_Checkpoint.Wait(id,Paths2Cross);
--           end loop;

         --Ogni volta che si taglia il traguardo, bisogna controllare se le gara è finita.
         --Probabilmente bisognerà sistemare la procedura perchè le auto si fermino
         --anche prima di tagliare il traguardo nel caso il vincitore sia arrivato da un pezzo
         StartingPosition := Get_Position(carDriver.RaceIterator);
         if StartingPosition = 1 then
            Finished := Get_IsFinished(carDriver.RaceIterator);
         end if;
         -- METODO INSERITO SOLO PER FAR "FERMARE LE AUTO", solo per scopo di test
         if i=7 then
            Finished := true;
            Ada.Text_IO.Put_Line(Integer'Image(id)&" : Finished = true, esco dal loop");
         end if;
         --Se la gara è finita non è necessario effettuare la valutazione della traiettoria
         exit when Finished = true;

         i:=i+1;
         --Inizio sezione dedicata alla scelta della traiettoria
         --questa è la soluzione attuale. Il crossing time e il choosenpath
         --sono valori restituiti dalla funzione
         --Path2Cross.ChooseBestPath(ID,CrossingTime,ChoosenPath,ActualTime);
         CrossingTime:= Evaluate(carDriver,C_Checkpoint, Paths2Cross); -- CrossingTime è il tempo effettivo di attraversamento del
         --tratto, compreso il tempo di attesa nella traiettoria.
         --Fine sezione  per la scelta della traiettoria

         --aggiorno tyreusury e gasoline _level
         CarDriver.auto.TyreUsury := CarDriver.auto.TyreUsury+0.04;
         CarDriver.auto.GasolineLevel := CarDriver.auto.GasolineLevel - 4;
         --Ora non c'è più rischio di race condition sulla scelta delle traiettorie
         --quindi può essere segnalato il passaggio del checkpoint per permettere agli
         --altri thread di eseguire finchè vengono aggiornati i tempi di arrivo negli
         --altri checkpoint

         C_Checkpoint.Signal_Leaving(id);


         --Da adesso in poi, essendo state  rilasciate tutte le risorse, si possono
         --aggiornare i tempi di arrivo sui vari checkpoint senza rallentare il
         --procedere degli altri competitor
         SectorID:=C_Checkpoint.Get_SectorID;
         PredictedTime := ActualTime + CrossingTime;
         --NEW, Ricordarsi del tempo di stop ai box in caso ci sia
         Ada.Text_IO.Put_Line("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"&Integer'Image(carDriver.Id)&" : 11- TEMPO DI GARA = "&Float'Image(PredictedTime));

         Ada.Text_IO.Put_Line("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"&Integer'Image(carDriver.Id)&" : 11- sectorID = "&Integer'Image(sectorID));
         j:=0;
         loop
            Ada.Text_IO.Put_Line("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"&Integer'Image(carDriver.Id)&" : loop j= "&Integer'Image(j));
            Circuit.Get_PreviousCheckpoint(carDriver.RaceIterator,C_Checkpoint);
            Ada.Text_IO.Put_Line("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"&Integer'Image(carDriver.Id)&" : metà loop j= "&Integer'Image(j));
            PredictedTime := PredictedTime + 1.0;--MinRaceTime - MinSegTime * Float(Index);
            C_Checkpoint.Set_ArrivalTime(id,PredictedTime);
            Index := Index + 1;
            j:=j+1;
            Ada.Text_IO.Put_Line("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"&Integer'Image(carDriver.Id)&" : fine loop j= "&Integer'Image(j));
            exit when Get_Position(carDriver.RaceIterator) = StartingPosition;--NEW, tolto il +1
         end loop;
         --AGGIORNAMENTO ONBOARDCOMPUTER
         -- qua va creata la statistica da aggiungere al computer di bordo
         -- per poi invocare il metodo Add_Data
         Common.Set_Checkpoint(compStats, i-1);
         Common.Set_Sector(compStats, SectorID); -- TODO, non abbiamo definito i sector, ritorna sempre uno.
         -- ONBOARDCOMPUTER.Set_Lap(); -- TODO, non ho ancora un modo per sapere il numero di giro
                                                 --commentato- da correggere il ripo di gaslevel
         Common.Set_Gas(compStats, carDriver.auto.GasolineLevel);
         Common.Set_Tyre(compStats, carDriver.auto.TyreUsury);
         Common.Set_Time(compStats, predictedTime);
         carDriver.statsComputer.Add_Data(compStats);

         --FINE AGGIORNAMENTO ONBOARDCOMPUTER

         Get_NextCheckPoint(carDriver.RaceIterator,C_Checkpoint); --NEW
         --tempoTotale := tempoTotale + PredictedTime;
         --Ada.Text_IO.Put_Line(Integer'Image(carDriver.Id)&" @@@@@@ tempoTotale : "&Float'Image(PredictedTime));--Delay(DELAY_TIME);
         --++++++Ada.Text_IO.Put_Line("&%$&%$&%$&%$&%$&%$&%$&%$__________------_________---------"&Integer'Image(carDriver.Id)&" : prima di delay");
         Delay(Standard.Duration(CrossingTime/100.0));
         --Delay(1.0);
         --++++++Ada.Text_IO.Put_Line("***********--------******************"&Integer'Image(carDriver.Id)&" : dopo delay("&Float'Image(PredictedTime)&")");
         --tempoTotale := tempoTotale +
      end loop;

      --+Path2Cross.ChooseBestPath(ID,CrossingTime,ChoosenPath,ActualTime);
      --+come parametri bisogna che in entrata ci sia la strategia, altrimenti non
      --+abbiamo niente con cui poterla usare.
      --+come metodo non è male solo che credo stia meglio nella strategy in modo da
      --+poter essere disponibile anche per "l'oggetto" di StrategyBox.
      --+ultima cosa, è corretto chiamare path2cross quando noi invece abbiamo
      --+il segmento su cui poi scegliere il path giusto?
      --quando esco dal loop devo togliere il concorrente dalla coda altrimeni si pianta tutto, ovviamente perchè il suo segnaposto
      --rimane nelle code
   end TASKCOMPETITOR;


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

