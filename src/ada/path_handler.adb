package body Path_Handler is

   --Minimum space required for a single car
   Minimum_Space : constant Float := 5.0;

   --PATH methods implementation
   procedure Set_Values(Path_In : in out PATH;
                        Length_In : FLOAT;
                        Angle_In : ANGLE_GRADE;
                        Grip_In : GRIP_RANGE;
                        Difficulty_In : DIFFICULTY_RANGE;
                        Max_Cars : Integer) is
   begin
      Path_In.Length := Length_In;
      Path_In.Angle := Angle_In;
      Path_In.Difficulty := Difficulty_In;
      Path_In.Grip := Grip_In;
      Path_In.Release_Instant := -1.0;
      Path_In.Competitor_Exit_Times := new Float_Array(1..Max_Cars);
      Path_In.Max_Speed := -1.0;
   end Set_Values;

   function Get_Length(Path_In : PATH) return FLOAT is
   begin
      return Path_In.Length;
   end Get_Length;

   function Get_Angle(Path_In : PATH) return FLOAT is
   begin
      return Path_In.Angle;
   end Get_Angle;

   function Get_Grip(Path_In : PATH) return FLOAT is
   begin
      return Path_In.Grip;
   end Get_Grip;

   function Get_Release_Instant( Path_In : PATH ) return FLOAT is
   begin
      return Path_In.Release_Instant;
   end Get_Release_Instant;

   function Get_Max_Speed( Path_In : PATH ) return FLOAT is
   begin
      return Path_In.Max_Speed;
   end Get_Max_Speed;

   procedure Set_Release_Instant( Path_In : out Path;
                                Instant : Float ) is
   begin
      Path_In.Release_Instant := Instant;
   end Set_Release_Instant;

   procedure Set_Max_Speed(Path_In : out Path;
                           Max_Speed : Float ) is
   begin
      Path_In.Max_Speed := Max_Speed;
   end Set_Max_Speed;

   -- It initializes the paths within a segment, setting the length depending
   --+ on the angle
   procedure Init_Paths(Paths_Collection_In : in out Paths_Point;
                        Paths_Qty : INTEGER;
                        Innermost_Path_Length : FLOAT; -- y
                        Innermost_Path_Angle : ANGLE_GRADE; -- alpha
                        Innermost_Path_Grip : GRIP_RANGE;
                        Innermost_Path_Difficulty : DIFFICULTY_RANGE) is

      AlphaRad : FLOAT := (3.14 * Innermost_Path_Angle) / 180.0;
      Shortest_Side : FLOAT := Innermost_Path_Length;
      r : FLOAT;
      Current_Path_Length : FLOAT;
      Max_Cars : Integer := 0;

   begin
      if( AlphaRad = 0.0) then
         r := Shortest_Side;
         AlphaRad := 1.0;
      else
         r := Shortest_Side / AlphaRad;
      end if;
      Current_Path_Length := (r * 1.0) * AlphaRad ;
      Paths_Collection_In := new Paths(1..Paths_Qty);

      --Calculate the number of cars that can stay together in the path
      Max_Cars := Integer(Float'Floor(Current_Path_Length / Minimum_Space));

      for Index in 1..Paths_Qty loop
         Current_Path_Length := (((FLOAT(Index)-1.0) * 1.6) + r ) * AlphaRad;
         Set_Values(Paths_Collection_In.all(index),
                    Current_Path_Length,
                    Innermost_Path_Angle,
                    Innermost_Path_Grip,
                    Innermost_Path_Difficulty,
                    Max_Cars);
      end loop;

   end Init_Paths;

   --Method for initialising the Paths of the box
   procedure Init_BoxLanePaths(Paths_Collection_In : in out Paths_Point;
                               Competitor_Qty : INTEGER;
                               Length : FLOAT) is
   begin
      Paths_Collection_In := new Paths(1..Competitor_Qty);
      for index in 1..Competitor_Qty loop
         Set_Values(Paths_Collection_In.all(index),Length ,ANGLE_GRADE(180.0),GRIP_RANGE(5.0),DIFFICULTY_RANGE(1.0),1);
      end loop;
   end Init_BoxLanePaths;

   protected body CROSSING is

      function Get_Size return INTEGER is
      begin
         return F_Paths'LENGTH;
      end Get_Size;

      function Get_Length(PathIndex : INTEGER) return FLOAT is
      begin
         return Get_Length(F_Paths(PathIndex));
      end Get_Length;

      function Get_Angle(PathIndex : INTEGER) return FLOAT is
      begin
         return Get_Angle(F_Paths(PathIndex));
      end Get_Angle;

      function Get_Grip(PathIndex : INTEGER) return FLOAT is
      begin
         return Get_Grip(F_Paths(PathIndex));
      end Get_Grip;

      function Get_PathTime(PathIndex : INTEGER) return FLOAT is
      begin
         return Get_Release_Instant(F_Paths.all(PathIndex));
      end Get_PathTime;

      function Get_Max_Speed(PathIndex : Integer) return Float is
      begin
         return Get_Max_Speed(F_Paths.all(PathIndex));
      end Get_Max_Speed;

      function Is_Path_Available(PathIndex : Integer;
                                 Arriving_Time : Float) return Boolean is
         Path_To_Check : Path := F_Paths.all(PathIndex);
      begin

         for Index in Path_To_Check.Competitor_Exit_Times'Range loop
            if(Path_To_Check.Competitor_Exit_Times(Index) < Arriving_Time) then
               return True;
            end if;
         end loop;

         return False;
      end Is_Path_Available;

      procedure Cross(Arriving_Instant : Float;
                      Exit_Instant     : Float;
                      Speed_In         : Float;
                      PathIndex        : Integer) is
         Path_To_Cross : Path := F_Paths.all(PathIndex);
      begin
         --Update the latest exit time
         Set_Release_Instant(Path_To_Cross, Exit_Instant );

         --Update max speed reachable for the competitors running at the same time through the path
         Set_Max_Speed(Path_To_Cross,Speed_In);

         --Find a position in the Competitor_Exit_Times array that refers to a competitor
         --+ who already left the path and save the new leaving time into it
         for Index in Path_To_Cross.Competitor_Exit_Times'Range loop
            if( Path_To_Cross.Competitor_Exit_Times(Index) < Arriving_Instant ) then
               Path_To_Cross.Competitor_Exit_Times(Index) := Exit_Instant;
               exit;
            end if;
         end loop;
      end Cross;

   end CROSSING;


end Path_Handler;
