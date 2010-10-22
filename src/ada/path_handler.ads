with Common;
use Common;

package Path_Handler is

   -- PATH Structure delaration
   --+ A PATH is one of the possible ways the competitor can take
   --+ in a circuit segment.
   type PATH is private;


   procedure Set_Values(Path_In : in out PATH;
                        Length_In : FLOAT;
                        Angle_In : ANGLE_GRADE;
                        Grip_In : GRIP_RANGE;
                        Difficulty_In : DIFFICULTY_RANGE;
                        Max_Cars : Integer);

   -- The Paths within a segment can have different lengths. For instance
   --+ in a turn the innermost path is shorter than the others.
   function Get_Length(Path_In : PATH) return FLOAT;

   -- The angle of the bending angle of the path
   function Get_Angle(Path_In : PATH) return FLOAT;

   -- The grip of the path
   function Get_Grip(Path_In : PATH) return FLOAT;

   -- The time instant when the path is supposed to be released by the last
   --+ racer crossing it.
   function Get_Release_Instant( Path_In : PATH ) return FLOAT;
   procedure Set_Release_Instant( Path_In : out Path;
                                 Instant : Float );

   -- The upper bound max speed due to a competitor already in the path
   function Get_Max_Speed(Path_In : PATH ) return FLOAT;
   procedure Set_Max_Speed(Path_In : out Path;
                           Max_Speed : Float );

   --This array represents the set of Paths a segment of the
   --+ circuit has.
   type Paths is array(Integer range <>) of PATH;
   type Paths_Point is access Paths;

   -- It initializes the paths within a segment, setting the length depending
   --+ on the angle
   procedure Init_Paths(Paths_Collection_In : in out Paths_Point;
                        Paths_Qty : INTEGER;
                        Innermost_Path_Length : FLOAT; -- y
                        Innermost_Path_Angle : ANGLE_GRADE; -- alpha
                        Innermost_Path_Grip : GRIP_RANGE;
                        Innermost_Path_Difficulty : DIFFICULTY_RANGE);

   --Method for initialising the Paths of the box
   procedure Init_BoxLanePaths(Paths_Collection_In : in out Paths_Point;
                               Competitor_Qty : INTEGER;
                               Length : FLOAT);

   protected type CROSSING(Paths_In : Paths_Point) is

      function Get_Size return Integer;
      function Get_Length(PathIndex : Integer) return FLOAT;
      function Get_Angle(PathIndex : Integer) return FLOAT;
      function Get_Grip(PathIndex : Integer) return FLOAT;
      function Get_PathTime(PathIndex : Integer) return FLOAT;
      function Get_Max_Speed(PathIndex : Integer) return Float;
      function Is_Path_Available(PathIndex     : Integer;
                                 Arriving_Time : Float) return Boolean;

      procedure Cross(Arriving_Instant : Float;
                      Exit_Instant     : Float;
                      Speed_In         : Float;
                      PathIndex        : Integer);

   private
      F_Paths : Paths_Point := Paths_In;
   end CROSSING;

   type CROSSING_POINT is access CROSSING;



private

    type PATH is record
      Length : FLOAT;
      Grip : GRIP_RANGE;
      Difficulty : DIFFICULTY_RANGE;
      Angle : ANGLE_GRADE;
      Release_Instant : FLOAT;
      Max_Speed : Float;
      Competitor_Exit_Times : Float_Array_Point;
   end record;

end Path_Handler;
