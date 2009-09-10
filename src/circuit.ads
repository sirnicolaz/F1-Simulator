package Circuit is

   subtype ANGLE_GRADE is FLOAT range 0.0..360.00;
   subtype DIFFICULTY_RANGE is FLOAT range 0.0..10.0;

   type PATH is private;
   procedure Set_Values(Path_In : in out PATH;
                        Length_In : FLOAT;
                        Angle_In : ANGLE_GRADE;
                        Grip_In : FLOAT;
                        Difficulty_In : DIFFICULTY_RANGE);
   function Get_Length(Path_In : PATH) return FLOAT;
   function Get_Angle(Path_In : PATH) return FLOAT;
   function Get_Grip(Path_In : PATH) return FLOAT;
   function Get_Difficulty(Path_In : PATH) return FLOAT;


   type PATHS is array(INTEGER range <>) of PATH;

   type SEGMENT(Paths_Qty : INTEGER) is tagged private;
   type POINT_SEGMENT is access SEGMENT;
   procedure Set_Values(Segment_In : in out SEGMENT;
                        SectorID_In : INTEGER;
                        IsGoal_In : BOOLEAN;
                        Length_In : FLOAT);
   procedure Go_Through(Segment_In : in out SEGMENT);
   procedure Enter_Segment_Queue(Segment_In : in out SEGMENT);
   procedure Exit_Segment_Queue(Segment_In : in out SEGMENT);
   procedure Set_Arrival_Time(Segment_In : in out SEGMENT;
                              Time_In : FLOAT;
                              CompetitorID : INTEGER);
   function Get_Path(Segment_In : SEGMENT;
                     Path_Num : INTEGER ) return PATH;
   function Get_Next_Segment(Segment_In : SEGMENT) return SEGMENT;

private

   type SEGMENT(Paths_Qty : INTEGER) is tagged record
      SectorID : INTEGER;
      IsGoal : BOOLEAN;
      Multiplicity : INTEGER := Paths_Qty;
      PathsCollection : PATHS(1..Paths_Qty);
      NextSegment : POINT_SEGMENT;
   end record;

   type PATH is record
      Length : FLOAT;
      Grip : FLOAT;
      Difficulty : FLOAT range 0.0..10.0;
      Angle : FLOAT range 0.0..360.0;
   end record;

end Circuit;
