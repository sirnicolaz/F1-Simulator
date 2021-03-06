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
      return  Max_Speed - ((( Tyre_Usury / 100.0) * ( Max_Speed ) ) / 10.0) - (((Gasoline_Level * 0.025)*(Max_Speed)) / 100.0);-- con 400 litri(massimo serbatoio esistente) si ha una decadenza del 10% della velocit� massima raggiungibile
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
      --+ tempo di percorrenza= tempo per raggiungere velocit� massima.
      --+ lunghezza tratto in accelerazione = lunghezza tratto
      --+ velocit� finale = velocit� massima per quel tratto
      Time_Critical_Temp := ((Max_Speed_Reachable/3.6) - (Last_Speed_Reached/3.6)) / Acceleration;
      --+ tempo per arrivare a Vmax partendo da Last_Speed_Reachediziale
      --+ divisione per 3,6 per portare alla stessa unit� di misura cosi abbiamo la velocit� in
      --+ m/s e l'accelerazione in m/s^2 per avere cosi un tempo in secondi
      if Max_Speed_Reachable <= 0.0 then Length_Path_Critical:=0.0;
      else Length_Path_Critical := (Last_Speed_Reached/3.6)*Time_Critical_Temp + 0.5*Acceleration*(Time_Critical_Temp*Time_Critical_Temp);
      end if;

      if Length_Path_Critical = Length_Path then
         Speed_Out:=Max_Speed_Reachable;
         Time_Critical := Time_Critical_Temp;-- aggiornare velocit�
      elsif Length_Path_Critical < Length_Path then
         Speed_Out:=Max_Speed_Reachable;
         if Max_Speed_Reachable = 0.0 then Time_Critical := 0.0; -- per evitare di dividere per zero dopo
         else
            Time_Critical := Time_Critical_Temp + ( Length_Path - Length_Path_Critical )/(Max_Speed_Reachable/3.6);
            --moto accelerato + moto uniforme
            -- tempo per arrivare alla velocit� max + (spazio/velocit�)= tempo moto rettilineo uniforme
         end if;
      elsif Length_Path_Critical> Length_Path  then
         Time_Critical_Temp := (((-1.0) * (Last_Speed_Reached/3.6))
                                + Ada.Numerics.Elementary_Functions.Sqrt(((Last_Speed_Reached/3.6) ** 2 )
                                + (2.0 * Length_Path *Acceleration)))/Acceleration;

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
     -- Difficulty_Path : Float; -- difficolt� del tratto
      --Tyre_Usury : Common.Percentage; -- usura delle gomme %
      --Gasoline_Level : Float; -- livello di benzina l
      Max_Speed_Reachable : Float; --velocit� massima raggiungibile km/h
      -- Max_Speed : Float := Competitor_In.Get_Max_Speed; -- km/h
      Length_Path_Critical : Float; -- m
      --Time_Critical_Temp: Float; -- s
      Acceleration : Float; -- metri al secondo quadrato
   begin
      --velocit� massima scalata per usura gomme e benzina presente.
      --V =velocit� massima
      --U =usura gomme (valori da 0 a 100 in percentuale)
      --B =benzina presente (valori da 0 a 100)
      --VR=Velocit� Reale (Velocita - %usura)scalato sulla benzina presente,+ benzina + lento..
      --VR= (V - (V*(U / 10)/100))-((0.025*B*V)/100)
      -- B*V/1000 � la formula B/10 * V/100 quindi B=0, la velocit� non diminuisce, B=100
      -- la velocit� diminuisce di un 10 %
      --++++++++++++++++++++++++++++++++++++--
      -- bisogna prevedere una accelerazione (positiva o negativa) per calcolare il tempo di attraversamento..

      Length_Path := Paths_2_Cross.Get_Length(Paths_Collection_Index); -- trovare dov'� finita questa funzione

      Angle_Path:= Paths_2_Cross.Get_Angle(Paths_Collection_Index);

      Grip_Path:= Paths_2_Cross.Get_Grip(Paths_Collection_Index);

      --Difficulty_Path:= Paths_2_Cross.Get_Difficulty(Paths_Collection_Index);

      --Tyre_Usury := Competitor_In.Get_Tyre_Usury;

--      Gasoline_Level:=Competitor_In.Get_Gasoline_Level;

  --    Max_Speed := Competitor_In.Get_Max_Speed;

      --acc := Get_Max_Acceleration(Car_Driver);
      -- aggiornamento dell'accelerazione in base allo stile di guida
      -- 0.008 � un buon valore trovato facendo dei test
      -- oltre allo stile di guida infulir� sull'accelerazione anche l'usura delle gomme
      -- sommando i due modificatori si arriva a cambiare l'accelerazione al pi� di 0.012 (rispetto al valore
      -- normale che � stato fissato in fase di configurazione ) che
      -- secondo i test eseguiti � un buon valore che modifica in maniera buona i tempi di percorrenza

      --procedura per valutazione stile di guida
      Acceleration := Evaluate_Strategy_Style(Strategy_Style, Max_Acceleration);
      --procedure per valutazione usura gomme
      Evaluate_Tyre_Usury(Acceleration, Tyre_Usury);
      -- fine aggiornamento accelerazione in base allo stile di guida e all'usura delle gomme
      --calcolo velocit� massima
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
      Starting_Instant            : Float := 0.0;
      Waiting_Time                : Float := 0.0;
      Path_Available_Instant      : Float;
      Competitor_Arrival_Time     : Float := F_Segment.Get_Time(Competitor_Id);
      Crossing_Time               : Float := 0.0;
      Crossing_Time_Temp          : Float;
      Exit_Instant                : Float := 0.0;
      Min_Delay                	  : Float := -1.0;
      Speed_Temp                  : Float :=0.0;
      Chosen_Path                 : Integer;
      Speed_Array                 : Float_Array(1..Paths_2_Cross.Get_Size);
      Waiting_Time_Min         	  : Float := 0.0;
      Temp_Usury                  : Float := 0.0;
      Gas_Modifier                : Float := 0.0;
      Minimum_Car_To_Car_Distance : constant Float := 0.2;
   begin
      -- loop on paths
      --loop per valutare le varie traiettorie.
      for Index in 1..Paths_2_Cross.Get_Size loop
         Path_Available_Instant := Paths_2_Cross.Get_PathTime(Index); -- tempo segnato sul path
         Ada.Text_IO.Put_Line(Integer'Image(Competitor_Id)&"DEBUG NOTTURNO : PATH TIME = "&Float'Image(Path_Available_Instant));
         Starting_Instant := Path_Available_Instant; -- momento in cui partire dal path

         Calculate_Crossing_Time (Crossing_Time_Temp,
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

         if( Crossing_Time_Temp + Competitor_Arrival_Time > Path_Available_Instant ) then
            Exit_Instant := Crossing_Time_Temp + Competitor_Arrival_Time;
            Speed_Array(Index):= Speed_Temp;
            Ada.Text_IO.Put_Line("DATI DAL COMPETITOR :  RAMO IF ID "&Integer'Image(Competitor_Id)&
                        " CROSSING_TIME_TEMP = "&Float'Image(Crossing_Time_Temp)&
                        " COMPETITOR_ARRIVAL_TIME = "&Float'Image(Competitor_Arrival_Time)&
                        " EXIT_INSTANT = "&Float'Image(Exit_Instant)&
                        " PATH_AVAILABLE_INSTANT = "&Float'Image(Path_Available_Instant)&
                        " SPEED_TEMP = "&Float'Image(Speed_Temp)&
                        " CHECKPOINT NUM = "&Float'Image(F_Segment.Get_Length));
         else
            if( Paths_2_Cross.Is_Path_Available(Index,Competitor_Arrival_Time)) then
               Exit_Instant := Path_Available_Instant + Minimum_Car_To_Car_Distance;
               Crossing_Time_Temp := Exit_Instant -  Competitor_Arrival_Time;
               Speed_Array(Index):= Paths_2_Cross.Get_Max_Speed(Index);

            Ada.Text_IO.Put_Line("DATI DAL COMPETITOR :  RAMO ELSE ID "&Integer'Image(Competitor_Id)&
                        " CROSSING_TIME_TEMP = "&Float'Image(Crossing_Time_Temp)&
                        " COMPETITOR_ARRIVAL_TIME = "&Float'Image(Competitor_Arrival_Time)&
                        " EXIT_INSTANT = "&Float'Image(Exit_Instant)&
                        " PATH_AVAILABLE_INSTANT = "&Float'Image(Path_Available_Instant)&
                        " SPEED_TEMP = "&Float'Image(Speed_Temp)&
                        " CHECKPOINT NUM = "&Float'Image(F_Segment.Get_Length));
            else
               Exit_Instant := -1.0;
            end if;
         end if;
         if Exit_Instant /= -1.0 and (Exit_Instant < Min_Delay or else Min_Delay < 0.0) then
            Min_Delay	  := Exit_Instant;
            Chosen_Path   := Index;
            Crossing_Time := Crossing_Time_Temp;
            Ada.Text_IO.Put_Line(Integer'Image(Competitor_Id)&"DEBUG NOTTURNO : WAITING TIME = "&Float'Image(Waiting_Time));
         end if;

      end loop;

      if( Min_Delay /= -1.0 ) then
         Paths_2_Cross.Cross(Arriving_Instant => Competitor_Arrival_Time,
                             Exit_Instant     => Min_Delay,
                             Speed_In         => Speed_Array(Chosen_Path),
                             PathIndex        => Chosen_Path);

         Last_Speed_Reached := Speed_Array(Chosen_Path); --aggiorno la velocit� di entrata al tratto successivo

         --aggiorno il lengthPath in modo da averlo poi quando aggiorno l'onboardcomputer
         Length_Path := Paths_2_Cross.Get_Length(Chosen_Path);
         --aggiorno il modificatore in base all'angolo
         Update_Usury_Modifier_Angle(Chosen_Path, Paths_2_Cross, Temp_Usury);
         --aggiorno il modificatore in base alla mescola
         Update_Usury_Modifier_Tyre_Type(Tyre_Type, Temp_Usury);
         --aggiorno il modificatore in base alla velocit� massima raggiunta
         Update_Usury_Modifier_Speed(Chosen_Path, Speed_Array, Temp_Usury, Gas_Modifier);
         -- adesso in Temp_Usury � presente una percentuale da sommare a quella statica calcolata.
         -- al massimo il valore di usura arriva a 0.86, nella peggiore delle ipotesi.
         -- il valore di usura si intende ogni 1000 metri
         -- quindi x = (1000*100)/0.80 = 125 km
         -- x = (1000*100)/0.86 = 116,279 km
         -- in totale quasi due giri (in media 5.5 km al giro) di differenza
         if(Float(Tyre_Usury) + (Paths_2_Cross.Get_Length(Chosen_Path)*(0.8+Temp_Usury)/1000.0) > 100.0) then
            Tyre_Usury := 100.0;
         else
            Tyre_Usury := Tyre_Usury + (Paths_2_Cross.Get_Length(Chosen_Path)*(0.8+Temp_Usury)/1000.0);
         end if;
         --il valore di 0.8 � stato scelto facendo il calcolo che con le gomme si percorrono circa 115 km
         -- calcolo Gas_Modifier

         Gasoline_Level := Gasoline_Level - ((0.6 + Gas_Modifier) * Paths_2_Cross.Get_Length(Chosen_Path)/1000.0);

         -- 0.6 � il valore di  litri al km consumati
         -- questo valore pu� arrivare (in base alla velocit�) fino a 0.75 litri al km
         -- il calcolo � quindi (0.6 + modificatore) * lunghezzaTratto /1000
         -- derivante da (0.6+modificatore): 1000 = x : lunghezzaTratto
         --aggiorno velocit� raggiunta
         Speed_Out := Speed_Array(Chosen_Path);

         Crossing_Time_Out := Crossing_Time;

      else
         --This means that no path where chosen because the segment is over-crowded. In this cas
         --+ the competitor has to retire

         --Time needed for the competitor to get off the circuit
         Crossing_Time_Out := 0.42;

         Length_Path := 0.0;
         Speed_Out := 0.0;

      end if;

      end Evaluate;

end Physic_Engine;
