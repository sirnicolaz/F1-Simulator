package body Path_Handler is

   --PATH methods implementation
   procedure Set_Values(Path_In : in out PATH;
                        Length_In : FLOAT;
                        Angle_In : ANGLE_GRADE;
                        Grip_In : GRIP_RANGE;
                        Difficulty_In : DIFFICULTY_RANGE) is
   begin
      Path_In.Length := Length_In;
      Path_In.Angle := Angle_In;
      Path_In.Difficulty := Difficulty_In;
      Path_In.Grip := Grip_In;
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

   procedure Set_Release_Instant( Path_In : out Path;
                                Instant : Float ) is
   begin
      Path_In.Release_Instant := Instant;
   end Set_Release_Instant;

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

   begin
      if( AlphaRad = 0.0) then
         r := Shortest_Side;
         AlphaRad := 1.0;
      else
         r := Shortest_Side / AlphaRad;
      end if;
      Current_Path_Length := (r * 1.0) * AlphaRad ;
      Paths_Collection_In := new Paths(1..Paths_Qty);
      for Index in 1..Paths_Qty loop
         Current_Path_Length := (((FLOAT(Index)-1.0) * 1.6) + r ) * AlphaRad;
         Set_Values(Paths_Collection_In.all(index),
                    Current_Path_Length,
                    Innermost_Path_Angle,
                    Innermost_Path_Grip,
                    Innermost_Path_Difficulty);
      end loop;

   end Init_Paths;

   --Method for initialising the Paths of the box
   procedure Init_BoxLanePaths(Paths_Collection_In : in out Paths_Point;
                               Competitor_Qty : INTEGER;
                               Length : FLOAT) is
   begin
      Paths_Collection_In := new Paths(1..Competitor_Qty);
      for index in 1..Competitor_Qty loop
         Set_Values(Paths_Collection_In.all(index),Length ,ANGLE_GRADE(180.0),GRIP_RANGE(5.0),DIFFICULTY_RANGE(1.0));
      end loop;
   end Init_BoxLanePaths;

   protected body CROSSING is

      --This method update the
      procedure Update_Time(Time_In : FLOAT;
                            PathIndex : INTEGER) is
      begin
         Set_Release_Instant(F_Paths(PathIndex), Time_In);
      end Update_Time;


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
   end CROSSING;


end Path_Handler;
