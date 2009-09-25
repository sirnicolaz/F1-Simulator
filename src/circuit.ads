with Queue;
use Queue;

package Circuit is

   subtype ANGLE_GRADE is FLOAT range 0.0..360.00;
   subtype DIFFICULTY_RANGE is FLOAT range 0.0..10.0;
   Segments_Qty : INTEGER := 2;
   MaxCompetitors_Qty : INTEGER := 2;

   procedure Set_SegmentsQty (Qty_In : POSITIVE);
   procedure Set_MaxCompetitorsQty ( Qty_In : POSITIVE);

   -- PATH Structure delaration
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

   --SEGMENT Structure delcaration
   type SEGMENT(Paths_Qty : POSITIVE) is tagged private;
   type POINT_SEGMENT is access SEGMENT;
   procedure Set_Values(Segment_In : in out SEGMENT;
                        SectorID_In : INTEGER;
                        IsGoal_In : BOOLEAN;
                        Length_In : FLOAT;
                        Angle_In : ANGLE_GRADE);
   procedure Set_Goal(Segment_In : in out SEGMENT);
   procedure Set_Next(Segment_In : in out SEGMENT;
                      NextSegment_In : POINT_SEGMENT);
   procedure Go_Through(Segment_In : in out SEGMENT);
   procedure Enter_Segment_Queue(Segment_In : in out SEGMENT);
   procedure Exit_Segment_Queue(Segment_In : in out SEGMENT);

   procedure Set_ArrivalTime(Segment_In : in out SEGMENT;
                             ArrivalTime_In : FLOAT;
                             CompetitorID_In : INTEGER;
                             IsActive_In : BOOLEAN);

   function Get_Path(Segment_In : SEGMENT;
                     Path_Num : INTEGER ) return PATH;
   function Get_Next_Segment(Segment_In : SEGMENT) return POINT_SEGMENT;

   type RACETRACK is private;
   procedure Init_Racetrack(Racetrack_In : in out RACETRACK);
   procedure Set_Segment(Racetrack_In : in out RACETRACK;
                         Segment_In : SEGMENT;
                         Position_In : POSITIVE);

private

   -- MaxCompetitors_Qty è un po' una pezza perchè significa che se
   -- per qualche motivo si iscrivono meno partecipanti di quelli
   -- dichiarati inizialmente, si spreca memoria. Sarebbe bello
   -- trovare un modo settare dinamicamente la grandezza dell'array.
   -- Alla peggio i segmenti vengono inizializzati DOPO che viene dato
   -- il via ufficiale alla gara.
   type SEGMENT(Paths_Qty : POSITIVE) is tagged record
      Queue : SORTED_QUEUE(1..MaxCompetitors_Qty);
      SectorID : INTEGER;
      IsGoal : BOOLEAN;
      Multiplicity : POSITIVE := Paths_Qty;
      PathsCollection : PATHS(1..Paths_Qty);
      NextSegment : POINT_SEGMENT;
   end record;

   type PATH is record
      Length : FLOAT;
      Grip : FLOAT;
      Difficulty : FLOAT range 0.0..10.0;
      Angle : FLOAT range 0.0..360.0;
   end record;

   type RACETRACK is array(POSITIVE range 1..Segments_Qty) of POINT_SEGMENT;


end Circuit;
