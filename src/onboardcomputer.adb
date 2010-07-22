with Ada.Text_IO;
use Ada.Text_IO;

package body OnBoardComputer is

--     procedure Set_Checkpoint(Stats_In : out Common.COMP_STATS_POINT; Checkpoint_In : INTEGER) is
--     begin
--        Stats_In.Checkpoint := Checkpoint_In;
--     end Set_Checkpoint;
--
--     procedure Set_Sector(Stats_In : out COMP_STATS_POINT; Sector_In : INTEGER) is
--     begin
--        Stats_In.Sector := Sector_In;
--     end Set_Sector;
--
--     procedure Set_Lap(Stats_In : out COMP_STATS_POINT; Lap_In : INTEGER) is
--     begin
--        Stats_In.Lap := Lap_In;
--     end Set_Lap;
--
--     procedure Set_Gas(Stats_In : out COMP_STATS_POINT; Gas_In : 	FLOAT) is
--     begin
--        Stats_In.GasLevel := Gas_In;
--     end Set_Gas;
--
--     procedure Set_Tyre(Stats_In : out COMP_STATS_POINT; Tyre_In : FLOAT) is
--     begin
--        Stats_In.TyreUsury := Tyre_In;
--     end Set_Tyre;
--
--     procedure Set_Time(Stats_In : out COMP_STATS_POINT; Time_In : FLOAT) is
--     begin
--        Stats_In.Time := Time_In;
--     end Set_Time;
--
--
--     function Get_Checkpoint(Stats_In : COMP_STATS) return INTEGER is
--     begin
--        return Stats_In.Checkpoint;
--     end Get_Checkpoint;
--
--     function Get_Sector(Stats_In : COMP_STATS) return INTEGER is
--     begin
--        return Stats_In.Sector;
--     end Get_Sector;
--
--     function Get_Lap(Stats_In : COMP_STATS) return INTEGER is
--     begin
--        return Stats_In.Lap;
--     end Get_Lap;
--
--     function Get_Gas(Stats_In : COMP_STATS) return FLOAT is
--     begin
--        return Stats_In.GasLevel;
--     end Get_Gas;
--
--     function Get_Tyre(Stats_In : COMP_STATS) return FLOAT is
--     begin
--        return Stats_In.TyreUsury;
--     end Get_Tyre;
--
--     function Get_Time(Stats_In : COMP_STATS) return FLOAT is
--     begin
--        return Stats_In.Time;
--     end Get_Time;




   procedure Reset_Node(Info_Node_Out : in out COMP_STATS_NODE_POINT) is
   begin
      Info_Node_Out.Next := Null;
      Info_Node_Out.Previous := Null;
      --Info_Node_Out.Value.Checkpoint := -1;
      --Info_Node_Out.Value :=
      Set_Checkpoint(Info_Node_Out.Value, -1);
      --Info_Node_Out.Value.Sector := -1;
      Set_Sector(Info_Node_Out.Value, -1);
--        Info_Node_Out.Value.Lap := -1;
--        Info_Node_Out.Value.LastCheckInSect := FALSE; -- Se è l'ultimo del settore o meno dipende da quello che verrà dopo
--        Info_Node_Out.Value.FirstCheckInSect := TRUE; -- Se prima non c'è nulla allora è il primo del settore
        Info_Node_Out.Index := -1;

      Set_Lap(Info_Node_Out.Value, -1);
      Set_LastCheckInSect(Info_Node_Out.Value, False);
      Set_FirstCheckInSect(Info_Node_Out.Value, False);
end Reset_Node;

   function Reset_Data(Data : COMP_STATS_POINT) return COMP_STATS is
      Data_Copy : Common.COMP_STATS_POINT;
   begin
--      Ada.Text_IO.Put_Line("in Reset_Data");
      Data_Copy := Data;
      --Data_Copy.LastCheckInSect := false;
      Set_LastCheckInSect(Data_Copy, false);
      --Data_Copy.FirstCheckInSect := true;
      Set_FirstCheckInSect(Data_Copy, false);
      return Data_Copy.all;
   end Reset_Data;


   procedure Set_Node(Info_Node_Out : in out COMP_STATS_NODE_POINT; Value : COMP_STATS_POINT) is
   begin
      Info_Node_Out := new COMP_STATS_NODE;
     -- Ada.Text_IO.Put_Line("PRE Info node out : info_node_out.index = " & Integer'Image(Info_Node_Out.Index));
      Info_Node_Out.Value := Value;--
      if(Info_Node_Out.Index = -1) then
         Info_Node_Out.Index := 1;
      end if;
      if (Info_Node_Out.Previous /= null) then
         if (Get_Sector(Info_Node_Out.Previous.Value.all) /= -1) then
            if (Get_Lap(Info_Node_Out.Previous.Value.all) < Get_Lap(Info_Node_Out.Value.all)) or (Get_Sector(Info_Node_Out.Previous.Value.all) < Get_Sector(Info_Node_Out.Value.all)) then
               Set_LastCheckInSect(Info_Node_Out.Previous.Value, true);
               Set_FirstCheckInSect(Info_Node_Out.Previous.Value, true);
            else
--                 Info_Node_Out.Value.FirstCheckInSect := false;
--                 Info_Node_Out.Previous.Value.LastCheckInSect := false;
               Set_LastCheckInSect(Info_Node_Out.Previous.Value, false);
               Set_FirstCheckInSect(Info_Node_Out.Previous.Value, false);
            end if;
         end if;
      end if;
      if (Info_Node_Out.Next /= null) then
         if (Get_Sector(Info_Node_Out.Next.Value.all) /= -1) then
            if (Get_Lap(Info_Node_Out.Next.Value.all) < Get_Lap(Info_Node_Out.Value.all)) or (Get_Sector(Info_Node_Out.Next.Value.all) < Get_Sector(Info_Node_Out.Value.all)) then
               Set_LastCheckInSect(Info_Node_Out.Next.Value, true);
               Set_FirstCheckInSect(Info_Node_Out.Next.Value, true);
            else
--                 Info_Node_Out.Value.FirstCheckInSect := false;
--                 Info_Node_Out.Previous.Value.LastCheckInSect := false;
               Set_LastCheckInSect(Info_Node_Out.Next.Value, false);
               Set_FirstCheckInSect(Info_Node_Out.Next.Value, false);
            end if;
         end if;
      end if;
   end Set_Node;

   procedure Set_PreviousNode(Info_Node_Out : in out COMP_STATS_NODE_POINT ; Value : in out COMP_STATS_NODE_POINT) is
   begin
      if(Value /= null) then
         Info_Node_Out.Previous := Value;
         Info_Node_Out.Previous.Next := Info_Node_Out;
         Info_Node_Out.Index := Info_Node_Out.Previous.Index + 1;
      end if;

--        if(Info_Node_Out.Previous.Value.Sector /= -1) then
--           if (Info_Node_Out.Previous.Value.Lap < Info_Node_Out.Value.Lap) or (Info_Node_Out.Previous.Value.Sector < Info_Node_Out.Value.Sector) then
--              Info_Node_Out.Previous.Value.LastCheckInSect := true;
--              Info_Node_Out.Value.FirstCheckInSect := true;
--           else
--              Info_Node_Out.Value.FirstCheckInSect := false;
--              Info_Node_Out.Previous.Value.LastCheckInSect := false;
--           end if;
--        end if;
      if (Get_Sector(Info_Node_Out.Previous.Value.all) /= -1) then
            if (Get_Lap(Info_Node_Out.Previous.Value.all) < Get_Lap(Info_Node_Out.Value.all)) or (Get_Sector(Info_Node_Out.Previous.Value.all) < Get_Sector(Info_Node_Out.Value.all)) then
               Set_LastCheckInSect(Info_Node_Out.Previous.Value, true);
               Set_FirstCheckInSect(Info_Node_Out.Value, true);
            else
--                 Info_Node_Out.Value.FirstCheckInSect := false;
--                 Info_Node_Out.Previous.Value.LastCheckInSect := false;
               Set_LastCheckInSect(Info_Node_Out.Previous.Value, false);
               Set_FirstCheckInSect(Info_Node_Out.Value, false);
            end if;
         end if;
   end Set_PreviousNode;

   procedure Set_NextNode(Info_Node_Out : in out COMP_STATS_NODE_POINT; Value : in out COMP_STATS_NODE_POINT ) is
   begin
      if(Value /= null) then
         Info_Node_Out.Next := Value;
         Info_Node_Out.Next.Previous := Info_Node_Out;
         Info_Node_Out.Next.Index := Info_Node_Out.Index + 1;
--           if(Info_Node_Out.Next.Value.Sector /= -1) then
--              if (Info_Node_Out.Next.Value.Lap > Info_Node_Out.Value.Lap) or (Info_Node_Out.Next.Value.Sector > Info_Node_Out.Value.Sector) then
--                 Info_Node_Out.Next.Value.FirstCheckInSect := true;
--                 Info_Node_Out.Value.LastCheckInSect := true;
--              else
--                 Info_Node_Out.Value.LastCheckInSect := false;
--                 Info_Node_Out.Next.Value.FirstCheckInSect := false;
--              end if;
--           end if;
if (Get_Sector(Info_Node_Out.Next.Value.all) /= -1) then
            if (Get_Lap(Info_Node_Out.Next.Value.all) > Get_Lap(Info_Node_Out.Value.all)) or (Get_Sector(Info_Node_Out.Next.Value.all) > Get_Sector(Info_Node_Out.Value.all)) then
               Set_LastCheckInSect(Info_Node_Out.Value, true);
               Set_FirstCheckInSect(Info_Node_Out.Next.Value, true);
            else
--                 Info_Node_Out.Value.FirstCheckInSect := false;
--                 Info_Node_Out.Previous.Value.LastCheckInSect := false;
               Set_LastCheckInSect(Info_Node_Out.Value, false);
               Set_FirstCheckInSect(Info_Node_Out.Next.Value, false);
            end if;
         end if;
      end if;

   end Set_NextNode;


   protected body COMPUTER is

      procedure Init_Computer(CompetitorId_In : INTEGER;  tempGlobal : GLOBAL_STATS_HANDLER_POINT) is
      begin
         Competitor_Id := CompetitorId_In;
         Current_Node := new COMP_STATS_NODE;
         Reset_Node(Current_Node);
         Last_Node := Current_Node;
         Updated := false;
         global := tempGlobal;
         Ada.Text_IO.Put_Line(Integer'Image(Competitor_Id)&" : COMPUTER DI BORDO AVVIATO");
      end Init_Computer;

      procedure Add_Data(Data : COMP_STATS_POINT) is
         NewNode : COMP_STATS_NODE_POINT := new COMP_STATS_NODE;
      begin
         Ada.Text_IO.Put_Line("inizio add_data");
         Set_Node(Last_Node,Reset_Data(Data));
         Reset_Node(NewNode);
         Set_NextNode(Last_Node,NewNode);
         Last_Node := NewNode;
         Updated := true;
         Ada.Text_IO.Put_Line("fine add_data");
         --sezione di controllo nel caso debba aggiornare le statistiche globali
      end Add_Data;

      function Get_Id return INTEGER is
      begin
         return Competitor_Id;
      end Get_Id;

      entry Get_StatsBySect(Sector : INTEGER; Lap : INTEGER; CompStats : out COMP_STATS) when true is

         Iterator : COMP_STATS_NODE_POINT;

         procedure Get_LastCheckPoint(Found : out BOOLEAN) is
         begin
            Found := true;
            if (Iterator.Value.LastCheckInSect = true) then
               CompStats := Iterator.Value;
            else
               loop
                  if (Iterator.Next = null) then
                     Found := false;
                     exit;
                  end if;
                  Iterator := Iterator.Next;
                  if (Iterator.Value.Sector > Iterator.Previous.Value.Sector) then
                     Found := false;
                     exit;
                  end if;
                  exit when (Iterator.Value.LastCheckInSect = true);
               end loop;
               if(Found /= false) then
                  CompStats := Iterator.Value;
               end if;
            end if;
         end Get_LastCheckPoint;

         StatFound : BOOLEAN;

      begin
         Iterator := Current_Node;
         if (Iterator.Index = -1) then
            Updated := false;
            requeue Wait_BySect; -- La lista è ancora vuota;
         end if;

         if (Iterator.Value.Lap /= Lap) then
            if (Iterator.Value.Lap < Lap) then
               loop
                  if(Iterator.Next = null) then
                     Updated := false;
                     requeue Wait_BySect;
                  end if;
                  Iterator := Iterator.Next;
                  exit when Iterator.Value.Lap = Lap;
               end loop;
            else
               loop
                  if(Iterator.Previous = null) then
                     CompStats.Checkpoint := -1;
                     exit;
                  end if;
                  Iterator := Iterator.Previous;
                  exit when Iterator.Value.Lap = Lap;
               end loop;
            end if;
         end if;

         if(CompStats.Checkpoint /= -1) then
            if (Iterator.Value.Sector /= Sector) then
               if (Iterator.Value.Sector < Sector) then
                  loop
                     if(Iterator.Next = null) then
                        Updated := false;
                        requeue Wait_BySect;
                     end if;
                     Iterator := Iterator.Next;
                     exit when Iterator.Value.Sector = Sector;
                  end loop;
               else
                  loop
                     if(Iterator.Previous = null) then
                        CompStats.Checkpoint := -1;
                        exit;
                     end if;
                     Iterator := Iterator.Previous;
                     exit when Iterator.Value.Sector = Sector;
                  end loop;
               end if;
            end if;
         end if;

         if CompStats.Checkpoint /= -1 then
            Updated := false;
            Get_LastCheckpoint(StatFound);
            if(StatFound = true) then
               Current_Node := Iterator;
            else
               requeue Wait_BySect;
            end if;
         end if;

      end Get_StatsBySect;

      entry Get_StatsByCheck(Checkpoint : INTEGER; Lap : INTEGER; CompStats : out COMP_STATS) when true is
         Position : INTEGER := Lap * Checkpoint;
         Iterator : COMP_STATS_NODE_POINT;
      begin

         Iterator := Current_Node;

         if(Current_Node.Index = -1) then
            Updated := false;
            requeue Wait_ByCheck;
         end if;

         if( Current_Node.Index = Position ) then
            CompStats := Current_Node.Value;
         elsif( Current_Node.Index < Position ) then
            while Iterator.Index /= Position loop
               if(Iterator.Next = null) then

                  Updated := false;
                  requeue Wait_ByCheck;
               end if;
               Iterator := Iterator.Next;
            end loop;
         else
            while Iterator.Index /= Position loop
               Iterator := Iterator.Previous;
            end loop;
         end if;
         Current_Node := Iterator; -- normalmente il nodo rischiesto da più clienti di fila è lo stesso
         CompStats := Iterator.Value;
         Updated := false;
      end Get_StatsByCheck;

      entry Wait_BySect(Sector : INTEGER; Lap : INTEGER; CompStats: out COMP_STATS) when Updated is
      begin
         requeue Get_StatsBySect;
      end Wait_BySect;


      entry Wait_ByCheck(Checkpoint : INTEGER; Lap : INTEGER; CompStats: out COMP_STATS) when Updated is
      begin
         requeue Get_StatsByCheck;
      end Wait_ByCheck;

   end COMPUTER;

end OnBoardComputer;
