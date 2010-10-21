with Ada.Text_IO;

package body Physic_Engine is

   function Evaluate_Strategy_Style(Strategy_Style : Common.Driving_Style; Acceleration : Float) return Float is
      Temp_Acceleration : Float;
   begin
      case Strategy_Style is
      when Common.Aggressive => Temp_Acceleration := Acceleration + 0.008;--serve funzione per Set_MAx_Acceleration
      when Common.Conservative => Temp_Acceleration := Acceleration - 0.008;
      when Common.Normal => Temp_Acceleration := Acceleration;
      end case;
      return Temp_Acceleration;
   end Evaluate_Strategy_Style;

   procedure Evaluate_Tyre_Usury(Acceleration  : in out Float;
                                 Tyre_Usury    : Common.Percentage) is
   begin
      if Tyre_Usury <= 50.0 then Acceleration := Acceleration + (0.001*Tyre_Usury); --al max aumento di 0.005 l'accelerazione
      else Acceleration := Acceleration - (0.001*(Tyre_Usury-50.0)); -- al max diminuisco di 0.005 l'accelerazione
      end if;
   end Evaluate_Tyre_Usury;

   function Calculate_Max_Speed_Reachable(Max_Speed : Float;
                                          Tyre_Usury : Common.Percentage;
                                          Gasoline_Level : Float) return Float is
   begin
      return  Max_Speed - ((( Tyre_Usury / 100.0) * ( Max_Speed ) ) / 10.0) - (((Gasoline_Level * 0.025)*(Max_Speed)) / 100.0);-- con 400 litri(massimo serbatoio esistente) si ha una decadenza del 10% della velocitï¿½ massima raggiungibile
   end Calculate_Max_Speed_Reachable;

   procedure Calculate_Time_And_Speed(Max_Speed_Reachable  : Float;
                                      Last_Speed_Reached   : Float;
                                      Acceleration         : Float;
                                      Length_Path          : Float;
                                      Length_Path_Critical : out Float;
                                      Speed_Out            : out Float;
                                      Time_Critical        : out Float) is
      Time_Critical_Temp : Float;
   begin
      -- sistema di equazione
      --+ formula per il tempo di attraversamento
      --+ caso 1
      --+ tempo di percorrenza= tempo per raggiungere velocitï¿½ massima.
      --+ lunghezza tratto in accelerazione = lunghezza tratto
      --+ velocità finale = velocitï¿½ massima per quel tratto
      Time_Critical_Temp := ((Max_Speed_Reachable/3.6) - (Last_Speed_Reached/3.6)) / Acceleration;
      --+ tempo per arrivare a Vmax partendo da Last_Speed_Reachediziale
      --+ divisione per 3,6 per portare alla stessa unitï¿½ di misura cosi abbiamo la velocitï¿½ in
      --+ m/s e l'accelerazione in m/s^2 per avere cosi un tempo in secondi
      if Max_Speed_Reachable <= 0.0 then Length_Path_Critical:=0.0;
      else Length_Path_Critical := (Last_Speed_Reached/3.6)*Time_Critical_Temp + 0.5*Acceleration*(Time_Critical_Temp*Time_Critical_Temp);
      end if;

      if Length_Path_Critical = Length_Path then
         Speed_Out:=Max_Speed_Reachable;---attenzione TODO se cambio vel in in una traiettoria lo cambio anche per quella dopo...
         Time_Critical := Time_Critical_Temp;-- aggiornare velocità
      elsif Length_Path_Critical < Length_Path then
         Speed_Out:=Max_Speed_Reachable;
         --if Max_Speed_Reachable = 0.0 then Time_CriticalTemp := -1000.0;
         --else
         if Max_Speed_Reachable = 0.0 then Time_Critical := 0.0; -- per evitare di dividere per zero dopo
         else
            Time_Critical := Time_Critical_Temp + ( Length_Path - Length_Path_Critical )/(Max_Speed_Reachable/3.6);
            --moto accelerato + moto uniforme
            -- tempo per arrivare alla velocità max + (spazio/velocità)= tempo moto rettilineo uniforme
         end if;
      elsif Length_Path_Critical> Length_Path  then
         -- Time_Critical := (-1.0) * (Vel_In/Acceleration) + Ada.Numerics.Elementary_Functions.Sqrt(((Vel_In ** 2 ) + (2.0 * Length_Path))/(Acceleration ** 2));--TODO Correggere
         Time_Critical_Temp := (((-1.0) * (Last_Speed_Reached/3.6)) + Ada.Numerics.Elementary_Functions.Sqrt(((Last_Speed_Reached/3.6) ** 2 ) + (2.0 * Length_Path *Acceleration)))/Acceleration;--TODO : controllare correttezza

         Speed_Out:=((Last_Speed_Reached/3.6) + (Acceleration * Time_Critical_Temp))*3.6;
         Time_Critical := Time_Critical_Temp;
      end if;
   end Calculate_Time_And_Speed;
   -----------------------------------
   -----------------------------------
   ------ CALCOLO CROSSING TIME  -----
   -----------------------------------
   -----------------------------------
   procedure Calculate_Crossing_Time (Time_Critical          : out Float;
                                      Paths_Collection_Index : Integer;
                                      F_Segment              : Checkpoint_Synch_Point;
                                      Last_Speed_Reached     : Float;
                                      Paths_2_Cross          : Crossing_Point;
                                      Speed_Out              : out Float;
                                      Strategy_Style         : Common.Driving_Style;
                                      Tyre_Usury             : Common.Percentage;
                                      Gasoline_Level         : Float;
                                      Max_Speed              : Float;
                                      Max_Acceleration       : Float) is

      Length_Path : Float; --lunghezza tratto
      Angle_Path : Float; -- angolo
      Grip_Path : Float; -- attrito
     -- Difficulty_Path : Float; -- difficoltà del tratto
      --Tyre_Usury : Common.Percentage; -- usura delle gomme %
      --Gasoline_Level : Float; -- livello di benzina l
      Max_Speed_Reachable : Float; --velocità massima raggiungibile km/h
      -- Max_Speed : Float := Competitor_In.Get_Max_Speed; -- km/h
      Length_Path_Critical : Float; -- m
      --Time_Critical_Temp: Float; -- s
      Acceleration : Float; -- metri al secondo quadrato
   begin
      --velocità massima scalata per usura gomme e benzina presente.
      --V =velocità massima
      --U =usura gomme (valori da 0 a 100 in percentuale)
      --B =benzina presente (valori da 0 a 100)
      --VR=Velocità Reale (Velocita - %usura)scalato sulla benzina presente,+ benzina + lento..
      --VR= (V - (V*(U / 10)/100))-((0.025*B*V)/100)
      -- B*V/1000 è la formula B/10 * V/100 quindi B=0, la velocità non diminuisce, B=100
      -- la velocità diminuisce di un 10 %
      --++++++++++++++++++++++++++++++++++++--
      -- bisogna prevedere una accelerazione (positiva o negativa) per calcolare il tempo di attraversamento..

      Length_Path := Paths_2_Cross.Get_Length(Paths_Collection_Index); -- trovare dov'è finita questa funzione

      Angle_Path:= Paths_2_Cross.Get_Angle(Paths_Collection_Index);

      Grip_Path:= Paths_2_Cross.Get_Grip(Paths_Collection_Index);

      --Difficulty_Path:= Paths_2_Cross.Get_Difficulty(Paths_Collection_Index);

      --Tyre_Usury := Competitor_In.Get_Tyre_Usury;

--      Gasoline_Level:=Competitor_In.Get_Gasoline_Level;

  --    Max_Speed := Competitor_In.Get_Max_Speed;

      --acc := Get_Max_Acceleration(Car_Driver);
      -- aggiornamento dell'accelerazione in base allo stile di guida
      -- 0.008 ï¿½ un buon valore trovato facendo dei test
      -- oltre allo stile di guida infulirï¿½ sull'accelerazione anche l'usura delle gomme
      -- sommando i due modificatori si arriva a cambiare l'accelerazione al piï¿½ di 0.012 (rispetto al valore
      -- normale che ï¿½ stato fissato in fase di configurazione ) che
      -- secondo i test eseguiti ï¿½ un buon valore che modifica in maniera buona i tempi di percorrenza

      --procedura per valutazione stile di guida
      Acceleration := Evaluate_Strategy_Style(Strategy_Style, Max_Acceleration);
      --procedure per valutazione usura gomme
      Evaluate_Tyre_Usury(Acceleration, Tyre_Usury);
      -- fine aggiornamento accelerazione in base allo stile di guida e all'usura delle gomme
      --calcolo velocità massima
      Max_Speed_Reachable := Calculate_Max_Speed_Reachable(Max_Speed, Tyre_Usury, Gasoline_Level);
      --controllo benzina
--        if Gasoline_Level <= 0.0 then
--           Ada.Text_IO.Put_Line("-------------------"&Integer'Image(Car_Competitor_Id)&" : ATTENZIONE - BENZINA FINITA !!!");
--        end if;

      Calculate_Time_And_Speed(Max_Speed_Reachable,
                               Last_Speed_Reached,
                               Acceleration,
                               Length_Path,
                               Length_Path_Critical,
                               Speed_Out,
                               Time_Critical);
   end Calculate_Crossing_Time;


   procedure Update_Usury_Modifier_Angle(Choosen_Path  : Integer;
                                         Paths_2_Cross : Crossing_Point;
                                         Temp_Usury    : in out Float) is
   begin
      if Paths_2_Cross.Get_Angle(Choosen_Path) < 45.0 then Temp_Usury := Temp_Usury + 0.005;
      elsif Paths_2_Cross.Get_Angle(Choosen_Path) > 45.0 and Paths_2_Cross.Get_Angle(Choosen_Path) < 90.0 then Temp_Usury := Temp_Usury + 0.0035;
      else Temp_Usury := Temp_Usury + 0.0015;
      end if;
   end Update_Usury_Modifier_Angle;

   procedure Update_Usury_Modifier_Tyre_Type(Tyre_Type  : String_Unb.Unbounded_String;
                                             Temp_Usury : in out Float) is
   begin
      if Tyre_Type = "Soft" then temp_usury := temp_usury + 0.03;
      else temp_usury := temp_usury + 0.01;
      end if;
   end Update_Usury_Modifier_Tyre_Type;

   procedure Update_Usury_Modifier_Speed(Choosen_Path : Integer;
                                         Speed_Array  : Float_Array;
                                         Temp_Usury   : in out Float;
                                         Gas_Modifier : in out Float) is
   begin
      if Speed_Array(Choosen_Path) >= 300.0 then
         Temp_Usury   := Temp_Usury + 0.02;
         Gas_Modifier := 0.15;
      elsif Speed_Array(Choosen_Path) >= 200.0 and Speed_Array(Choosen_Path) < 300.0 then
         Temp_Usury   := Temp_Usury + 0.01;
         Gas_Modifier := 0.10;
      elsif Speed_Array(Choosen_Path) >= 100.0 and Speed_Array(Choosen_Path) < 200.0 then
         Temp_Usury   := Temp_Usury + 0.007;
         Gas_Modifier := 0.05;
      else
         Temp_Usury   := Temp_Usury + 0.005;
         Gas_Modifier := 0.0;
      end if;
   end Update_Usury_Modifier_Speed;

   -----------------------------------
   -----------------------------------
   ------------ EVALUATE  ------------
   -----------------------------------
   -----------------------------------
   procedure Evaluate(F_Segment          : Checkpoint_Synch_Point;
                      Paths_2_Cross      : Crossing_Point;
                      Competitor_Id      : Integer;
                      Strategy_Style     : Common.Driving_Style;
                      Max_Speed          : Float;
                      Max_Acceleration   : Float;
                      Tyre_Type          : String_Unb.Unbounded_String;
                      Tyre_Usury         : in out Float;
                      Gasoline_Level     : in out Float;
                      Length_Path        : out Float;
                      Crossing_Time_Out  : out Float;
                      Speed_Out          : out Float;
                      Last_Speed_Reached : in out Float) is
      --qua dentro va effettuata la valutazione della traiettoria migliore e calcolato il tempo di attraversamento
      -- da restituire poi a chi invoca questo metodo.
      --qua credo che vadano eseguite le operazioni per attraversare il tratto
      Starting_Instant         : Float := 0.0;
      Waiting_Time             : Float := 0.0;
      Path_Time                : Float;
      Competitor_Arrival_Time  : Float := F_Segment.Get_Time(Competitor_Id);
      --ho bisogno di avere metodi per il ritorno dei campi dati del checkpoint_sync_point
      --inoltre non vedo il metodo Get_ArrivalTime
      Crossing_Time            : Float := 0.0;
      Crossing_Time_Temp       : Float;
      Total_Delay              : Float := 0.0;
      Min_Delay                : Float := -1.0;
      --Path_Time_Min            : Float;
      Speed_Temp               : Float :=0.0;
      Choosen_Path       : Integer;
      Speed_Array              : Float_Array(1..Paths_2_Cross.Get_Size);
      Waiting_Time_Min         : Float := 0.0;
      Temp_Usury               : Float := 0.0;
      Gas_Modifier             : Float := 0.0;
      Time_Critical_Temp       : Float;
   begin

      -- loop on paths
      --Competitor.Get_Status(Driver, Competitor_Status_Tyre, Competitor_Status_Level);-- ?
      --loop per valutare le varie traiettorie.
      for Index in 1..Paths_2_Cross.Get_Size loop
         Path_Time := Paths_2_Cross.Get_PathTime(Index); -- tempo segnato sul path
         Waiting_Time := Path_Time - Competitor_Arrival_Time; -- tempo di attesa sul path
         Starting_Instant := Path_Time; -- momento in cui partire dal path
         if Waiting_Time < 0.0 then -- se non ho tempo di attesa posso partire subito
            Waiting_Time := 0.0;
            Starting_Instant := Competitor_Arrival_Time; -- momento di partenza uguale al momento di arrivo sul path
         end if;

         Calculate_Crossing_Time (Time_Critical_Temp,
                                  Index,
                                  F_Segment,
                                  Last_Speed_Reached,
                                  Paths_2_Cross,
                                  Speed_Temp,
                                  Strategy_Style,
                                  Tyre_Usury,
                                  Gasoline_Level,
                                  Max_Speed,
                                  Max_Acceleration);
         --CalculateCrossingTime(CrossingTimeTemp, driver, Index, F_Segment, Driver.Racing_Car.Last_Speed_Reached, Paths2Cross, velTemp);
         Speed_Array(Index):= Speed_Temp;
         Crossing_Time_Temp := Time_Critical_Temp + Waiting_Time;--StartingInstant;

         if Crossing_Time > Crossing_Time_Temp or else  Crossing_Time <= 0.0 then
            Crossing_Time := Crossing_Time_Temp;
            Choosen_Path := Index;
            --Path_Time_Min := Path_Time;
            --Waiting_Time_Min := Waiting_Time;
         end if;

         Total_Delay := Starting_Instant + Crossing_Time_Temp - Waiting_Time;

         if Total_Delay < Min_Delay or else Min_Delay < 0.0 then
            Min_Delay := Total_Delay;
         end if;

      end loop;

      Paths_2_Cross.Update_Time(Min_Delay, Choosen_Path);
      Last_Speed_Reached := Speed_Array(Choosen_Path); --aggiorno la velocità di entrata al tratto successivo

      --aggiorno il lengthPath in modo da averlo poi quando aggiorno l'onboardcomputer
      Length_Path := Paths_2_Cross.Get_Length(Choosen_Path);
      --aggiorno il modificatore in base all'angolo
      Update_Usury_Modifier_Angle(Choosen_Path, Paths_2_Cross, Temp_Usury);
      --aggiorno il modificatore in base alla mescola
      Update_Usury_Modifier_Tyre_Type(Tyre_Type, Temp_Usury);
      --aggiorno il modificatore in base alla velocitï¿½ massima raggiunta
      Update_Usury_Modifier_Speed(Choosen_Path, Speed_Array, Temp_Usury, Gas_Modifier);
      -- adesso in Temp_Usury è presente una percentuale da sommare a quella statica calcolata.
      -- al massimo il valore di usura arriva a 0.86, nella peggiore delle ipotesi.
      -- il valore di usura si intende ogni 1000 metri
      -- quindi x = (1000*100)/0.80 = 125 km
      -- x = (1000*100)/0.86 = 116,279 km
      -- in totale quasi due giri (in media 5.5 km al giro) di differenza
      if(Float(Tyre_Usury) + (Paths_2_Cross.Get_Length(Choosen_Path)*(0.8+Temp_Usury)/1000.0) > 100.0) then
         Tyre_Usury := 100.0;
      else
         Tyre_Usury := Tyre_Usury + (Paths_2_Cross.Get_Length(Choosen_Path)*(0.8+Temp_Usury)/1000.0);
      end if;
      --il valore di 0.8 è stato scelto facendo il calcolo che con le gomme si percorrono circa 115 km
      -- calcolo Gas_Modifier
      Gasoline_Level := Gasoline_Level - ((0.6 + Gas_Modifier) * Paths_2_Cross.Get_Length(Choosen_Path)/1000.0);
      -- 0.6 è il valore di  litri al km consumati
      -- questo valore può arrivare (in base alla velocità) fino a 0.75 litri al km
      -- il calcolo è quindi (0.6 + modificatore) * lunghezzaTratto /1000
      -- derivante da (0.6+modificatore): 1000 = x : lunghezzaTratto
      --aggiorno velocità  raggiunta
      Speed_Out := Speed_Array(Choosen_Path);
      --if(driver.Racing_Car.Gasoline_Level > 0.0 and driver.Racing_Car.Tyre_Usury < 100.0)  then
      --end if;
      Crossing_Time_Out := Crossing_Time;
      --ricordarsi di ritornare usura delle gomme, livello della benzina, velocità in uscita e tempo di attraversamento.
   end Evaluate;

end Physic_Engine;
