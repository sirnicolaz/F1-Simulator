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

with Competition_Computer;
use Competition_Computer;


with Ada.Exceptions;

package body Competitor is

   --THis value has to be the same for oeveryone
   LastLap : Integer;
   procedure Set_Laps( LapsQty : in Integer) is
   begin
      LastLap := LapsQty;
   end Set_Laps;

   --Get Methods implementation
   function Get_First_Name(Competitor_In : Competitor_Details_Point) return Str.Unbounded_String is
   begin
      return Competitor_In.Racing_Driver.First_Name;
   end Get_First_Name;

   procedure Get_Status(Competitor_In : Competitor_Details_Point; Tyre_Usury_Out : out Float; Gas_Level_Out : out Float) is

   begin
      Tyre_Usury_Out:=Competitor_In.Racing_Car.Tyre_Usury;
      Gas_Level_Out:=Competitor_In.Racing_Car.Gasoline_Level;
   end Get_Status;


   -- Set function - CAR
   procedure Configure_Car(Car_In : in out CAR;
                           Max_Speed_In : Float;
                           Max_Acceleration_In : Float;
                           Gas_Tank_Capacity_In : Float;
                           Engine_In : Str.Unbounded_String;
                           Tyre_Usury_In : Common.PERCENTAGE;
                           Gasoline_Level_In : Float;
                           Mixture_In : Str.Unbounded_String;
                           Model_In : Str.Unbounded_String;
                           Tyre_Type_In : Str.Unbounded_String) is
   begin
      Car_In.Max_Speed := Max_Speed_In;
      Car_In.Max_Acceleration := Max_Acceleration_In;
      Car_In.Gas_Tank_Capacity := Gas_Tank_Capacity_In;
      Car_In.Engine := Engine_In;
      Car_In.Tyre_Usury:=Tyre_Usury_In;
      Car_In.Gasoline_Level:=Gasoline_Level_In;
      Car_In.Mixture:=Mixture_In;
      Car_In.Model:=Model_In;
      Car_In.Tyre_Type:=Tyre_Type_In;
      Car_In.Last_Speed_Reached:= 0.0;
   end Configure_Car;

   -- Function for Calculating Status
   function Calculate_Status(infoLastSeg : in Competitor_Details_Point) return BOOLEAN is
      --questa funzione ritorna un boolean che indica se il concorrente
      --deve tornare o meno ai box
   begin
      if infoLastSeg.Racing_Car.Tyre_Usury <= 10.0 or infoLastSeg.Racing_Car.Gasoline_Level <= 10.0 then
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




   procedure Configure_Driver(Driver_In: in out Driver;
                              Team_In :  Str.Unbounded_String;
                              First_Name_In :  Str.Unbounded_String;
                              Last_Name_In :  Str.Unbounded_String) is
   begin
      Driver_In.Team:=Team_In;
      Driver_In.First_Name:=First_Name_In;
      Driver_In.Last_Name:=Last_Name_In;
   end Configure_Driver;

   function Init_Competitor(Xml_file : String;
                            Current_Circuit_Race_Iterator  : Racetrack_Iterator;
                            Id_In : Integer;
                            Laps_In : Integer;
                            BoxRadio_CorbaLOC : String) return Competitor_Details_Point is
      --parametri
      Doc : Document;
      carDriver_XML : Node_List;
      carDriver_Length : Integer;

      --   carDriver_Out : Competitor_Details_Point;
      carDriver : Competitor_Details_Point := new Competitor_Details;


      procedure Try_OpenFile is--(xml_file : String; Input : in out File_Input; Reader : in out Tree_Reader; Doc : in out Document;
         --carDriver_XML : in out Node_List; carDriver_Length : in out Integer) is
      begin

	 Doc := Common.Get_Document(xml_file);

         carDriver_XML := Get_Elements_By_Tag_Name(Doc,"car_driver");
         carDriver_Length := Length(carDriver_XML);
      exception
         when ADA.IO_EXCEPTIONS.NAME_ERROR => Doc := null;
      end Try_OpenFile;


      function Configure_Car_File(xml_file_In : DOCUMENT) return CAR is
         Max_Speed_In : Float;
         Max_Acceleration_In : Float;
         Gas_Tank_Capacity_In : Float;--Float;
         --Engine_In : String(1..50);
         Tyre_Usury_In : Float;
         Gasoline_Level_In : Float;--Float;
         Mixture_In : Str.Unbounded_String;--access String;
         Model_In : Str.Unbounded_String;-- String(1..20);
         Tyre_Type_In : Str.Unbounded_String;-- String(1..20);
         car_XML : Node_List;
         Current_Node : Node;
         -- Current_Team : String(1..7) :="Ferrari";
         -- Current_First_Name : String(1..8):="Fernando";
         -- Current_Last_Name : String(1..6) :="Alonso";
         Car_In : CAR;
         --Car_Current : CAR;
         Engine_In : Str.Unbounded_String;--String(1..6):="xxxxxx";

         function Get_Feature_Node(Node_In : NODE;
                                   FeatureName_In : String) return NODE is
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

         --If there is a conf file, use it to Racing_Car-init;

         -- if Document_In /= null then

         car_XML := Get_Elements_By_Tag_Name(xml_file_In,"car");

         Current_Node := Item(car_XML, 0);

         car_XML := Child_Nodes(Current_Node);
         Max_Speed_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"maxspeed"))));
         Max_Acceleration_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"maxacceleration"))));
         Gas_Tank_Capacity_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"gastankcapacity"))));
         Engine_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"engine"))));
         Tyre_Usury_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"tyreusury"))));
         Gasoline_Level_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"gasolinelevel"))));

         Mixture_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"mixture"))));

         --Ada.Strings.Unbounded.Text_IO.Put_Line(Mixture_In);
         Model_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"model"))));
         Tyre_Type_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"type_tyre"))));
         --Car_Temp := new CAR;
         --Mixture_In := "morbidaxxxxxxxxxxxxx";
--           Model_In := "michelinxxxxxxxxxxxx";
--         Tyre_Type_In := "rainxxxxxxxxxxxxxxxx";
         --Racetrack_In(Index) := CheckpointSynch_Current;


         -- end if;



         Configure_Car(Car_In,
                       Max_Speed_In,
                       Max_Acceleration_In,
                       Gas_Tank_Capacity_In,
                       Engine_In,
                       Tyre_Usury_In,
                       Gasoline_Level_In,
                       Mixture_In ,
                       Model_In ,
                       Tyre_Type_In);
         return Car_In;
      end Configure_Car_File;

      function Configure_Driver_File(xml_file_In : DOCUMENT) return DRIVER is
         Team_In : Str.Unbounded_String;--String(1..7):="xxxxxxx";
         First_Name_In : Str.Unbounded_String;-- String(1..8):="xxxxxxxx";
         Last_Name_In : Str.Unbounded_String;-- String(1..6):="xxxxxx";
         Last_Speed_Reached : Float :=0.0;
         driver_XML : Node_List;
         Current_Node : Node;
         Car_In : DRIVER;
         --global : GLOBAL_STATS_HANDLER_POINT;-- global stats handler - "singleton"
         function Get_Feature_Node(Node_In : NODE;
                                   FeatureName_In : String) return NODE is
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

         --If there is a conf file, use it to Racing_Car-init;

         --if Document_In /= null then

         driver_XML := Get_Elements_By_Tag_Name(xml_file_In,"driver");
         Current_Node := Item(driver_XML, 0);
         driver_XML := Child_Nodes(Current_Node);
         Team_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"team"))));
         First_Name_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"firstname"))));
         Last_Name_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"lastname"))));
         --Car_Temp := new CAR;
         --Team_In := "Ferrari";
         --First_Name_In := "Fernando";
         --Last_Name_In := "Alonso";
         --Racetrack_In(Index) := CheckpointSynch_Current;
         --end loop;
         --end if;

         --lettura parametri, Last_Speed_Reached esclusa
         Configure_Driver(Car_In,
                          Team_In,
                          First_Name_In,
                          Last_Name_In);
         return Car_In;
      end Configure_Driver_File;


      --TODO: try to remove this stuff
      --remote communication declaration section
      --use PolyORB.Utils.Report;
      --boxCorbaLoc : Str.Unbounded_String := Str.Null_Unbounded_String;

      RadioConnection_Success : BOOLEAN := false;
   begin

      Ada.Text_IO.Put_Line("Begin");
      --apertura del file
      Try_OpenFile;
      --configurazione parametri

      --Teoricamente non serve pi� perch� la Current_Strategy viene presa su giusto
      --+ prima di iniziare la gare
      --carDriver.Current_Strategy := Configure_Strategy_File(doc);

      Ada.Text_IO.Put_Line("Configure car");
      carDriver.Racing_Car := Configure_Car_File(doc);

      Ada.Text_IO.Put_Line("Configure Racing driver");
      carDriver.Racing_Driver := Configure_Driver_File(doc);
      Ada.Text_IO.Put_Line("Configure Race iterator");
      carDriver.Current_Circuit_Race_Iterator :=Current_Circuit_Race_Iterator ;
      Ada.Text_IO.Put_Line("Configure id");
      carDriver.Id:=id_In;

      --Init onboard computer
      Ada.Text_IO.Put_Line("Init Computer");
      Competitor_Computer.Init_Computer(Computer_In     => carDriver.On_Board_Computer ,
                                    CompetitorId_In => id_in,
                                    Laps            => laps_in);

      --Adding minimal information to stats (for presentation purspose)
      Ada.Text_IO.Put_Line("Adding min info");
      Competition_Computer.Add_CompetitorMinInfo(Id      => id_in,
                                                Name    => carDriver.Racing_Driver.First_Name,
                                                Surname => carDriver.Racing_Driver.Last_Name,
                                                Team    => carDriver.Racing_Driver.Team);

      --Initializing onboard computer references in the Competition Monitor
      Ada.Text_IO.Put_Line("Add obc");
      Competition_Monitor.AddOBC(carDriver.On_Board_Computer ,carDriver.Id);
      --Try to initialize the competitor radio. If it's still down, retry in 5 seconds
      --+ (probably other problems are occured in such a case)
      Ada.Text_IO.Put_Line("Connecting to box");
      loop CompetitorRadio.Init_BoxConnection(BoxRadio_CorbaLOC => BoxRadio_CorbaLOC,
                                            Radio             => carDriver.Radio,
                                            ID                => carDriver.Id,
                                              Success           => RadioConnection_Success);
         exit when RadioConnection_Success = true;
         Ada.Text_IO.Put_Line("Connection to box failed for competitor n. " &
                              Common.Integer_To_String(id_In));
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
   procedure CalculateCrossingTime (TimeCriticalTemp : out Float; CarDriver : Competitor_Details_Point; PathsCollection_Index : Integer;
                                    F_Segment : CHECKPOINT_SYNCH_POINT ; Last_Speed_Reached : Float;
                                    Paths2Cross : CROSSING_POINT; Vel_Out : out Float) is
      length_path : Float; --lunghezza tratto
      --size_path : Integer; -- molteplicit� tratto
      angle_path : Float; -- angolo
      grip_path : Float; -- attrito
      tyre_usury : Common.PERCENTAGE; -- usura delle gomme %
      gasoline_level : Float; -- livello di benzina l
      vel_max_reale : Float; --velocit� massima raggiungibile km/h
      vel_max : Float := carDriver.Racing_Car.Max_Speed; -- km/h
      lc : Float; -- m
      timeCritical: Float; -- s
      acc: Float; -- metri al secondo quadrato

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

      tyre_usury := CarDriver.Racing_Car.Tyre_Usury;

      gasoline_level:=CarDriver.Racing_Car.Gasoline_Level;

      vel_max := CarDriver.Racing_Car.Max_Speed;

      --acc := Get_Max_Acceleration(carDriver);
      -- aggiornamento dell'accelerazione in base allo stile di guida
      -- 0.008 � un buon valore trovato facendo dei test
      -- oltre allo stile di guida infulir� sull'accelerazione anche l'usura delle gomme
      -- sommando i due modificatori si arriva a cambiare l'accelerazione al pi� di 0.012 (rispetto al valore
      -- normale che � stato fissato in fase di configurazione ) che
      -- secondo i test eseguiti � un buon valore che modifica in maniera buona i tempi di percorrenza
      case carDriver.Current_Strategy.Style is
      when Common.AGGRESSIVE => acc:= CarDriver.Racing_Car.Max_Acceleration + 0.008;
      when Common.CONSERVATIVE => acc := CarDriver.Racing_Car.Max_Acceleration - 0.008;
      when Common.NORMAL => acc := CarDriver.Racing_Car.Max_Acceleration;
      end case;

      if tyre_usury <= 50.0 then acc:= acc + (0.001*tyre_usury); --al max aumento di 0.005 l'accelerazione
      else acc:= acc - (0.001*(tyre_usury-50.0)); -- al max diminuisco di 0.005 l'accelerazione
      end if;
      -- fine aggiornamento accelerazione in base allo stile di guida e all'usura delle gomme

      vel_max_reale := vel_max-(((tyre_usury/100.0) * (vel_max))/10.0)-(((gasoline_level*0.025)*(vel_max))/100.0);-- con 400 litri(massimo serbatoio esistente) si ha una decadenza del 10% della velocit� massima raggiungibile

      if gasoline_level <= 0.0 then
         Ada.Text_IO.Put_Line("-------------------"&Integer'Image(CarDriver.Id)&" : ATTENZIONE - BENZINA FINITA !!!");
      end if;

      -- formula per il tempo di attraversamento
      -- caso 1
      -- tempo di percorrenza= tempo per raggiungere velocit� massima.
      -- lunghezza tratto in accelerazione = lunghezza tratto
      -- velocit� finale = velocit� massima per quel tratto
      timeCritical := ((vel_max_reale/3.6) - (Last_Speed_Reached/3.6)) / acc;
      -- tempo per arrivare a Vmax partendo da Last_Speed_Reachediziale
      -- divisione per 3,6 per portare alla stessa unit� di misura cosi abbiamo la velocit� in
      -- m/s e l'accelerazione in m/s^2 per avere cosi un tempo in secondi
      if vel_max_reale <= 0.0 then lc:=0.0;
      else lc := (Last_Speed_Reached/3.6)*timeCritical + 0.5*acc*(timeCritical*timeCritical);
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
           timeCritical := (((-1.0) * (Last_Speed_Reached/3.6)) + Ada.Numerics.Elementary_Functions.Sqrt(((Last_Speed_Reached/3.6) ** 2 ) + (2.0 * length_path *acc)))/acc;--TODO : controllare correttezza

         Vel_Out:=((CarDriver.Racing_Car.Last_Speed_Reached/3.6) + (acc * timeCritical))*3.6;
         TimeCriticalTemp := timeCritical;
      end if;

   end CalculateCrossingTime;

   -----------------------------------
   -----------------------------------
   ------------ EVALUATE  ------------
   -----------------------------------
   -----------------------------------
   procedure Evaluate(driver : Competitor_Details_Point ;
                     F_Segment : CHECKPOINT_SYNCH_POINT; Paths2Cross : CROSSING_POINT;
                     lengthPath : out Float ;
                     crossingTime_Out : out Float;
                     vel_out : out Float) is

      --qua dentro va effettuata la valutazione della traiettoria migliore e calcolato il tempo di attraversamento
      -- da restituire poi a chi invoca questo metodo.
      --qua credo che vadano eseguite le operazioni per attraversare il tratto


      --driver dovr� salvarsi la velocit� che ha raggiunto.

      StartingInstant : Float := 0.0;
      WaitingTime : Float := 0.0;
      PathTime : Float;
      CompArrivalTime : Float := F_Segment.Get_Time(driver.Id);
      --ho bisogno di avere metodi per il ritorno dei campi dati del checkpoint_sync_point
      --inoltre non vedo il metodo Get_ArrivalTime
      CrossingTime : Float:= 0.0;
      CrossingTimeTemp : Float;
      TotalDelay : Float := 0.0;
      MinDelay : Float := -1.0;
      pathTimeMinore : Float;
      --BestPath : PATH;
      Competitor_Status_Tyre : Float;
      Competitor_Status_Level: Float;
      --manca il metodo per tornare un pathcollection;
      -- Competitor_Strategy : STRATEGY_CAR := Competitor.Get_Strategy();
      velTemp : Float :=0.0;
      traiettoriaScelta : Integer;
      vel_array : VEL(1..Paths2Cross.Get_Size);
      waitingTimeMinore : Float := 0.0;
      temp_usury : Float := 0.0;
      gas_modifier : Float := 0.0;
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

	 CalculateCrossingTime(CrossingTimeTemp, driver, Index, F_Segment, Driver.Racing_Car.Last_Speed_Reached, Paths2Cross, velTemp);

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
      driver.Racing_Car.Last_Speed_Reached := vel_array(traiettoriaScelta); --aggiorno la velocit� di entrata al tratto successivo


      --aggiorno il lengthPath in modo da averlo poi quando aggiorno l'Competitor_Computer
      lengthPath := Paths2Cross.Get_Length(traiettoriaScelta);

      --aggiorno il modificatore in base all'angolo
      if Paths2Cross.Get_Angle(traiettoriaScelta) < 45.0 then temp_usury := temp_usury + 0.005;
      elsif Paths2Cross.Get_Angle(traiettoriaScelta) > 45.0 and Paths2Cross.Get_Angle(traiettoriaScelta) < 90.0 then temp_usury := temp_usury + 0.0035;
      else temp_usury := temp_usury + 0.0015;
      end if;

      --aggiorno il modificatore in base alla mescola
      if driver.Racing_Car.Tyre_Type = "Soft" then temp_usury := temp_usury + 0.03;
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
      if(Float(driver.Racing_Car.Tyre_Usury) + (Paths2Cross.Get_Length(traiettoriaScelta)*(0.8+temp_usury)/1000.0) > 100.0) then
          driver.Racing_Car.Tyre_Usury := 100.0;
      else
          driver.Racing_Car.Tyre_Usury := driver.Racing_Car.Tyre_Usury + (Paths2Cross.Get_Length(traiettoriaScelta)*(0.8+temp_usury)/1000.0);
      end if;

      --il valore di 0.8 � stato scelto facendo il calcolo che con le gomme si percorrono circa 115 km
      -- calcolo gas_modifier
      if vel_array(traiettoriaScelta) >= 300.0 then gas_modifier := 0.15;
      elsif vel_array(traiettoriaScelta) >= 200.0 and vel_array(traiettoriaScelta) <300.0 then gas_modifier := 0.10;
      elsif vel_array(traiettoriaScelta) >= 100.0 and vel_array(traiettoriaScelta) <200.0 then gas_modifier := 0.05;
      else gas_modifier := 0.0;
      end if;

      driver.Racing_Car.Gasoline_Level := driver.Racing_Car.Gasoline_Level - ((0.6 + gas_modifier) * Paths2Cross.Get_Length(traiettoriaScelta)/1000.0);
      -- 0.6 � il valore di  litri al km consumati
      -- questo valore pu� arrivare (in base alla velocit� ) fino a 0.75 litri al km
      -- il calcolo � quindi (0.6 + modificatore) * lunghezzaTratto /1000
      -- derivante da (0.6+modificatore): 1000 = x : lunghezzaTratto

      --aggiorno velocità raggiunta
      vel_out := vel_array(traiettoriaScelta);

      --if(driver.Racing_Car.Gasoline_Level > 0.0 and driver.Racing_Car.Tyre_Usury < 100.0)  then
      --end if;


      crossingTime_Out := CrossingTime;
   end evaluate;

   -----------------------------------
   -----------------------------------
   -- TASKCOMPETITOR IMPLEMENTATION --
   -----------------------------------
   -----------------------------------



   task body TASKCOMPETITOR is
      C_Checkpoint : CHECKPOINT_SYNCH_POINT;
      PredictedTime : Float := 0.0;
      DelayTime : Float := 1.0;
      Paths2Cross : CROSSING_POINT;
      MinSegTime : Float :=1.0;-- <minima quantit� di tempo per attraversare un tratto>
      lengthPath : Float := 0.0;
      --<minima quantit� di tempo per attraversare la pista>
      carDriver : Competitor_Details_Point := carDriver_In;--
      MinRaceTime : Float := MinSegTime * Float(Get_RaceLength(carDriver.Current_Circuit_Race_Iterator ));
      CurrentCheckpoint : Integer := 1;
      ActualTime : Float;
      Finished : BOOLEAN := FALSE;
      Index : Integer := 0;
      id : Integer := carDriver.Id;
      StartingPosition :Integer;
      Speed : Float;
      CrossingTime : Float;
      endWait : Boolean :=False;
      j: Integer:=0;
      tempoTotale : Float := 0.0;
      valore:BOOLEAN :=False;
      --statistiche COMPETITOR_STATS
      compStats : COMPETITOR_STATS;
      SectorID : Integer;
      PitStop : BOOLEAN := false;  -- NEW, indica se fermarsi o meno ai box

      -- The lap count is kept in this variable
      --TODO: chiedere a lorenzo se non era gi� da qualche altra parte
      CurrentLap : Integer := 0;

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

         Tmp_Strategy.Tyre_Type := Str.To_Unbounded_String(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"tyreType"))));
         Tmp_Strategy.Gas_Level := Float'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"gasLevel"))));
         Tmp_Strategy.Laps_To_Pitstop := Integer'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"Laps_To_Pitstop"))));
         Tmp_Strategy.Pit_Stop_Delay := Float'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"Pit_Stop_Delay"))));

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
                                          Competitor_ID : Integer) is
         StartingPosition_P : Integer;
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




      Get_CurrentCheckPoint(carDriver.Current_Circuit_Race_Iterator ,C_Checkpoint); -- NEW


                                                                  --end loop;
      -- Ask the box for the starting strategy
      Strategy_FileName := Str.To_Unbounded_String(CompetitorRadio.Get_Strategy(carDriver.Radio, CurrentLap));

      BrandNewStrategy := XML2Strategy(Strategy_FileName);

      --Updating the driver strategy with the first strategy given
      --+ by the box. TODO: verify wheter to set the gas level with
      --+ the one given by the box.
      carDriver.Current_Strategy.Tyre_Type := BrandNewStrategy.Tyre_Type;
      carDriver.Current_Strategy.Laps_To_Pitstop := BrandNewStrategy.Laps_To_Pitstop;
      carDriver.Current_Strategy.Gas_Level := BrandNewStrategy.Gas_Level;
      carDriver.Current_Strategy.Style := BrandNewStrategy.Style;

      loop



         --Istante di tempo segnato nel checkpoint attuale per il competitor
         ActualTime := C_Checkpoint.Get_Time(id);


         Ada.Text_IO.Put_Line(Integer'Image(carDriver.Id)& Integer'Image(id)&
                              ": SUMMURY lap : " & Integer'IMAGE(CurrentLap) &
                              ", actual time : " & Float'Image(ActualTime) &
                              ", gas " & Float'IMAGE(carDriver.Racing_Car.Gasoline_Level) &
                              ", tyre " & Float'IMAGE(carDriver.Racing_Car.Tyre_Usury) &
                              ", pit stop done " & BOOLEAN'IMAGE(PitStopDone));
         --Viene segnalato l'arrivo effettivo al checkpoint. In caso risulti primo,
         --viene subito assegnata la collezione  di path per la scelta della traiettoria

         if( C_Checkpoint.Is_PreBox = true ) then -- If true, the check point is a prebox

            begin
               --Box comunication section
               -- Ask for the box strategy once the prebox checkpoint is reached

               Strategy_FileName := Str.To_Unbounded_String(CompetitorRadio.Get_Strategy(carDriver.Radio,CurrentLap+1));

	       --Get the strategy object from the file
               BrandNewStrategy := XML2Strategy(Strategy_FileName);

            exception
               when Error : others =>
                  Ada.Text_IO.Put_Line("Exception: " & Ada.Exceptions.Exception_Message(Error));
                  if( carDriver.Current_Strategy.Laps_To_Pitstop = 0) then
                     --To avoid another pitstop if done before
                     carDriver.Current_Strategy.Laps_To_Pitstop := 1;
                  end if;
                  --Reuse the same strategy as a new one
                  BrandNewStrategy := carDriver.Current_Strategy;
            end;


	    --Bisogna verificare se la Current_Strategy dice di tornare ai box, in tal caso:
            if(BrandNewStrategy.Laps_To_Pitstop = 0) then
               PitStop := true;
            end if;

	    carDriver.Current_Strategy.Style := BrandNewStrategy.Style;
            carDriver.Current_Strategy.Laps_To_Pitstop := BrandNewStrategy.Laps_To_Pitstop;
         end if;




         C_Checkpoint.Signal_Arrival(id);

         --When the competitor will be at the top of the list, he will be notified to
         --+ go ahead

         C_Checkpoint.Wait_Ready(carDriver.Id);

         --Now the competitor is for sure first and he can pick up the paths collection
         --+ evaluate the best way to take

         C_Checkpoint.Get_Paths(Paths2Cross,
                                Go2Box      => PitStop);


         StartingPosition := Get_Position(carDriver.Current_Circuit_Race_Iterator );

         --NEW: Moved. It was just before the crossing time calculation.
         SectorID:=C_Checkpoint.Get_SectorID;

         --Inizio sezione dedicata alla scelta della traiettoria
         --questa � la soluzione attuale. Il crossing time e il choosenpath
         --sono valori restituiti dalla funzione
         --Path2Cross.ChooseBestPath(ID,CrossingTime,ChoosenPath,ActualTime);

         -- CrossingTime � il tempo effettivo di attraversamento del
         --tratto, compreso il tempo di attesa nella traiettoria.
         --Fine sezione  per la scelta della traiettoria

	 --If the competitor is in the box lane, set up the maximum speed
	 if(PitStop = true or PitStopDone = true) then

         declare
           OriginalSpeed : Float := CarDriver.Racing_Car.Max_Speed;
          begin
	    carDriver.Racing_Car.Max_Speed := 80.0;
	    Evaluate(carDriver,C_Checkpoint, Paths2Cross, lengthPath, CrossingTime, Speed); -- NEW aggiunto parametro lunghezza del path scelto
	    --original driver speed restored.
	    carDriver.Racing_Car.Max_Speed := OriginalSpeed;
	  end;
	 else
          Evaluate(carDriver,C_Checkpoint, Paths2Cross, lengthPath, CrossingTime, Speed); -- NEW aggiunto parametro lunghezza del path scelto
	 end if;
         Ada.Text_IO.Put_Line(Integer'Image(carDriver.Id) & ": evaluate done:" &
                              " length path " & Float'IMAGE(lengthPath) &
                              " crossing time " & Float'IMAGE(CrossingTime) &
                              " speed " & Float'IMAGE(Speed));
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

            CrossingTime := CrossingTime + BrandNewStrategy.Pit_Stop_Delay;

         end if;

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
               Iterator_InitialPosition : Integer := Get_Position(carDriver.Current_Circuit_Race_Iterator );
               Step : Float := 0.0001;
               UpdatedCheckpoints : Float := 1.0;
            begin
               Get_CurrentCheckpoint( carDriver.Current_Circuit_Race_Iterator ,Temp_Checkpoint);--NEW
               --Update all the statistics up to the goal checkpoint
               while Get_Position(carDriver.Current_Circuit_Race_Iterator ) /= Circuit.Checkpoints_Qty  loop
                  --Update the statistic to send to the Competitor_Computer
                  compStats.Checkpoint := CurrentCheckpoint;
                  CurrentCheckpoint := CurrentCheckpoint + 1;
                  compStats.LastCheckInSect := FALSE;
                  compStats.FirstCheckInSect := FALSE;
                  compStats.Sector := Temp_Checkpoint.Get_SectorID;
                  compStats.Gas_Level := carDriver.Racing_Car.Gasoline_Level;
                  compStats.Tyre_Usury := carDriver.Racing_Car.Tyre_Usury;
                  compStats.Max_Speed := Speed;
                  compStats.IsPitStop := false;
                  compStats.Time := PredictedTime + Step*UpdatedCheckpoints;

                  UpdatedCheckpoints := UpdatedCheckpoints + 1.0;
                  compStats.Lap := CurrentLap;
                  compStats.PathLength := 0.0;

                  Competitor_Computer.Add_Data(Computer_In => carDriver.On_Board_Computer ,
                                           Data        => compStats);

                  Get_NextCheckpoint(carDriver.Current_Circuit_Race_Iterator ,Temp_Checkpoint);
               end loop;
               CurrentCheckpoint := Circuit.Checkpoints_Qty;
               --Restore the iterator initial position
               while Get_Position(carDriver.Current_Circuit_Race_Iterator ) /= Circuit.Checkpoints_Qty loop
                  Get_NextCheckpoint(carDriver.Current_Circuit_Race_Iterator , Temp_Checkpoint );
               end loop;
            end;

         end if;



         --Update the statistic to send to the Competitor_Computer
         compStats.Checkpoint := CurrentCheckpoint;
         compStats.LastCheckInSect := C_Checkpoint.Is_LastOfTheSector;
         compStats.FirstCheckInSect := C_Checkpoint.Is_FirstOfTheSector;
         compStats.Sector := SectorID;
         compStats.Gas_Level := carDriver.Racing_Car.Gasoline_Level;
         compStats.Tyre_Usury := carDriver.Racing_Car.Tyre_Usury;
         compStats.Time := PredictedTime;
         compStats.Lap := CurrentLap;
         compStats.PathLength := lengthPath;
         compStats.IsPitStop := FALSE;
         compStats.Max_Speed := Speed;

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

	 Ada.Text_IO.Put_Line(Integer'Image(carDriver.Id) & ": updaitng pc: " &
                              " check " & Integer'IMAGE(CurrentCheckpoint) &
                              " gas level " & Float'IMAGE(compStats.Gas_Level) &
                              " tyre usury " & Float'IMAGE(compStats.Tyre_Usury) &
                              " path length " & Float'IMAGE(lengthPath) &
                              " speed " & Float'IMAGE(Speed));
         Competitor_Computer.Add_Data(Computer_In => carDriver.On_Board_Computer ,
                                  Data        => compStats);

         --If the checkpoint is the box, it's necessary to update all
         --+ the statistics from the box to the exit-box
         if(PitStopDone = true) then

            declare
               Temp_Checkpoint : CHECKPOINT_SYNCH_POINT;
               Iterator_InitialPosition : Integer := 1;
               ExitBox_Position : Integer;
               Step : Float := 0.0001;
               UpdatedCheckpoints : Float := 1.0;
            begin
               --Find the exit box positino
               Get_ExitBoxCheckpoint(carDriver.Current_Circuit_Race_Iterator ,Temp_Checkpoint);
               ExitBox_Position := Get_Position(carDriver.Current_Circuit_Race_Iterator );

               --Put che iterator in position number one
               while Get_Position(carDriver.Current_Circuit_Race_Iterator ) /= 2 loop
                  Get_NextCheckpoint(carDriver.Current_Circuit_Race_Iterator ,Temp_Checkpoint);
               end loop;
               CurrentCheckpoint := 2;

               --Update all the statistics up to the goal checkpoint
               while Get_Position(carDriver.Current_Circuit_Race_Iterator ) /= ExitBox_Position loop
                  --Update the statistic to send to the Competitor_Computer
                  compStats.Checkpoint := CurrentCheckpoint;
                  CurrentCheckpoint := CurrentCheckpoint + 1;
                  compStats.LastCheckInSect := FALSE;
                  compStats.FirstCheckInSect := FALSE;
                  compStats.Sector := Temp_Checkpoint.Get_SectorID;
                  compStats.Gas_Level := carDriver.Racing_Car.Gasoline_Level;
                  compStats.Tyre_Usury := carDriver.Racing_Car.Tyre_Usury;
                  compStats.IsPitStop := TRUE;
                  compStats.Time := PredictedTime - (Step * UpdatedCheckpoints);
                  UpdatedCheckpoints := UpdatedCheckpoints + 1.0;
                  compStats.Max_Speed := Speed;
                  compStats.Lap := CurrentLap;
                  compStats.PathLength := 0.0;

                  Competitor_Computer.Add_Data(Computer_In => carDriver.On_Board_Computer ,
                                           Data        => compStats);

                  Get_NextCheckpoint(carDriver.Current_Circuit_Race_Iterator ,Temp_Checkpoint);
               end loop;
               CurrentCheckpoint := ExitBox_Position-1;
               --Restore the iterator initial position
               Get_BoxCheckpoint(carDriver.Current_Circuit_Race_Iterator ,Temp_Checkpoint);

            end;

         end if;


         if(carDriver.Racing_Car.Gasoline_Level <= 0.0 or else carDriver.Racing_Car.Tyre_Usury >= 100.0) then

            --Update all the remaining information in the stats
            declare
               Temp_Checkpoint : CHECKPOINT_SYNCH_POINT;
               Temp_CheckpointPos : Integer;
               Temp_Lap : Integer := CurrentLap;
            begin
               Ada.Text_IO.Put_Line(Integer'IMAGE(carDriver.Id) & ": Sendin away competitor at " & Float'IMAGE(compStats.Time) & " last lap " & Integer'IMAGE(LastLap));
               CompetitorOut(Computer_In => carDriver.On_Board_Computer ,
                             Lap         => CUrrentLap,
                             Data        => compStats);

               loop


                  Get_NextCheckpoint(carDriver.Current_Circuit_Race_Iterator ,Temp_Checkpoint);
                  Temp_CheckpointPos := Get_Position(CarDriver.Current_Circuit_Race_Iterator );

                  if(Temp_Checkpoint.Is_Goal) then
                     Temp_Lap := Temp_Lap + 1;
                  end if;

                  exit when Temp_Lap = LastLap;

                  compStats.Checkpoint := Temp_CheckpointPos;
                  compStats.LastCheckInSect := Temp_Checkpoint.Is_LastOfTheSector;
                  compStats.FirstCheckInSect := Temp_Checkpoint.Is_FirstOfTheSector;
                  compStats.Sector := Temp_Checkpoint.Get_SectorID;
                  compStats.Gas_Level := carDriver.Racing_Car.Gasoline_Level;
                  compStats.Tyre_Usury := carDriver.Racing_Car.Tyre_Usury;
                  compStats.IsPitStop := FALSE;
                  compStats.Time := PredictedTime;
                  compStats.Lap := Temp_Lap;
                  compStats.PathLength := 0.0;

                  Competitor_Computer.Add_Data(Computer_In => carDriver.On_Board_Computer ,
                                           Data        => compStats);

               end loop;

            end;

            Remove_CompetitorFromRace(Iterator_In    => carDriver.Current_Circuit_Race_Iterator ,
                                      PitStopDone_In => PitStopDone,
                                      Competitor_ID => carDriver.Id);

            Finished := TRUE;
         end if;
         exit when Finished = TRUE;

         -- UPdate the time signed in the checkpoint queues. The first
         --+ one with the predicted time (the time the car will arrive)
         --+ and the other ones with that time increased with the minimum
         --+ time to cross a segment of the track.
         loop
            Circuit.Get_NextCheckpoint(carDriver.Current_Circuit_Race_Iterator ,C_Checkpoint);
            C_Checkpoint.Set_ArrivalTime(id,PredictedTime);
            PredictedTime := PredictedTime + 0.001;--MinRaceTime - MinSegTime * Float(Index);
            Index := Index + 1;

            exit when Get_Position(carDriver.Current_Circuit_Race_Iterator ) = StartingPosition;
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
               StartingPosition := Get_Position(carDriver.Current_Circuit_Race_Iterator )-1;
            end if;
         end loop;

         if(PitStopDone) then
            Get_BoxCheckpoint(carDriver.Current_Circuit_Race_Iterator ,C_Checkpoint);
         end if;

         -- If it was a pitstop, get the checkpoint following the one of the boxes
         if( PitStop = true) then

            PitStop := false;
            PitStopDone := true;
            Get_BoxCheckpoint(carDriver.Current_Circuit_Race_Iterator ,C_Checkpoint);
            --HACK: in this way we add the competitor to the box queue (that is empty
            --+ by default)
            C_Checkpoint.Set_ArrivalTime(carDriver.Id, predictedTime);

            --Those updates will be effective in the next loop, so
            --+ they'll be used while doing the after-box path.
            if(BrandNewStrategy.Gas_Level /= -1.0) then
                carDriver.Current_Strategy.Gas_Level := BrandNewStrategy.Gas_Level;
                carDriver.Racing_Car.Gasoline_Level := BrandNewStrategy.Gas_Level;
            end if;
            carDriver.Current_Strategy.Tyre_Type := BrandNewStrategy.Tyre_Type;
            carDriver.Racing_Car.Tyre_Type := BrandNewStrategy.Tyre_Type;
            --We assume che every pitstop the tyre are replaced
            carDriver.Racing_Car.Tyre_Usury := 0.0;

         else

            if(PitStopDone = true) then
               PitStopDone := false;
               C_Checkpoint.Remove_Competitor(carDriver.Id);
            end if;

            Get_NextCheckPoint(carDriver.Current_Circuit_Race_Iterator ,C_Checkpoint); --NEW
         end if;


         if(C_CheckPoint.Is_Goal) then

            -- later on, at the end of the loop it will be updated to 1
            CurrentCheckpoint := 0;
            CurrentLap := CurrentLap + 1;
         end if;

         -- Just for simulation purpose
         delay until(Ada.Calendar.Clock + Standard.Duration(CrossingTime));
         --Delay(1.0);
         --If the checkpoint is the goal, get the race over
         if C_CheckPoint.Is_Goal and CurrentLap = LastLap then
            Ada.Text_IO.Put_Line(Integer'Image(carDriver.Id)&" Last lap reached");
            Finished := true;

            Remove_CompetitorFromRace(Iterator_In    => carDriver.Current_Circuit_Race_Iterator ,
                                      PitStopDone_In => PitStopDone,
                                      Competitor_ID => carDriver.Id);

            --Not necessary to send last information to box because it should
            --+ already know that the last lap has been reached


         end if;

         exit when Finished = true;

         CurrentCheckpoint := CurrentCheckpoint + 1;

      end loop;

      --+Path2Cross.ChooseBestPath(ID,CrossingTime,ChoosenPath,ActualTime);
      --+come parametri bisogna che in entrata ci sia la Current_Strategy, altrimenti non
      --+abbiamo niente con cui poterla usare.
      --+come metodo non � male solo che credo stia meglio nella strategy in modo da
      --+poter essere disponibile anche per "l'oggetto" di StrategyBox.
      --+ultima cosa, � corretto chiamare path2cross quando noi invece abbiamo
      --+il segmento su cui poi scegliere il path giusto?
      --quando esco dal loop devo togliere il concorrente dalla coda altrimeni si pianta tutto, ovviamente perch� il suo segnaposto
      --rimane nelle code

      CompetitorRadio.Close_BOxCOnnection(Radio => carDriver.Radio);
   end TASKCOMPETITOR;

   function Get_Tyre_Usury(Competitor_In : Competitor_Details_Point) return Common.Percentage is
   begin
      return Competitor_In.Racing_Car.Tyre_Usury;
   end Get_Tyre_Usury;

   function Get_Gasoline_Level(Competitor_In : Competitor_Details_Point) return Float is
   begin
      return Competitor_In.Racing_Car.Gasoline_Level;
   end Get_Gasoline_Level;

   function Get_Max_Acceleration(Competitor_In : Competitor_Details_Point) return Float is
   begin
      return Competitor_In.Racing_Car.Max_Acceleration;
   end Get_Max_Acceleration;

   function Get_Last_Speed_Reached(Competitor_In : Competitor_Details_Point) return Float is
   begin
      return Competitor_In.Racing_Car.Last_Speed_Reached;
   end Get_Last_Speed_Reached;

   function Get_Strategy_Style(Competitor_In : Competitor_Details_Point) return Common.Driving_Style is
   begin
      return Competitor_In.Current_Strategy.Style;
   end Get_Strategy_Style;


end Competitor;

