package body Circuit is

   procedure Set_SegmentsQty (Qty_In : POSITIVE) is
   begin
      Segments_Qty := Qty_In;
   end Set_SegmentsQty;

   procedure Set_MaxCompetitorsQty ( Qty_In : POSITIVE) is
   begin
      MaxCompetitors_Qty := Qty_In;
   end Set_MaxCompetitorsQty;

   --PATH methods implementation
   procedure Set_Values(Path_In : in out PATH;
                        Length_In : FLOAT;
                        Angle_In : ANGLE_GRADE;
                        Grip_In : FLOAT;
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

   function Get_Difficulty(Path_In : PATH) return FLOAT is
   begin
      return Path_In.Difficulty;
   end Get_Difficulty;

   --SEGMENT methods implementation
   procedure Set_Values(Segment_In : in out SEGMENT;
                        SectorID_In : INTEGER;
                        IsGoal_In : BOOLEAN;
                        Length_In : FLOAT;
                        Angle_In : ANGLE_GRADE) is

      procedure Init_Paths(Paths_Collection_In : in out PATHS;
                           Paths_Qty : INTEGER) is
      begin
         for index in 1..Paths_Qty loop
            Set_Values(Paths_Collection_In(index),Length_In,Angle_In,12.00,DIFFICULTY_RANGE(9.8));
         end loop;
         null;
      end Init_Paths;

   begin
      Segment_In.SectorID := SectorID_In;
      Segment_In.IsGoal := IsGoal_In;
      Init_Paths(Segment_In.PathsCollection, Segment_In.Multiplicity);
   end Set_Values;


   procedure Set_Goal(Segment_In : in out SEGMENT) is
   begin
      Segment_In.IsGoal := TRUE;
   end Set_Goal;

   procedure Set_Next(Segment_In : in out SEGMENT;
                      NextSegment_In : POINT_SEGMENT) is
   begin
      Segment_In.NextSegment := NextSegment_In;
   end Set_Next;

   procedure Go_Through(Segment_In : in out SEGMENT) is
   begin
      --Quando � implementato il Competitor, dovr� eseguire:
      --	settare il competitor come attivo nella coda;
      --	se non � primo nella coda, attendere;
      null;
   end Go_Through;

   procedure Set_ArrivalTime(Segment_In : in out SEGMENT;
                             ArrivalTime_In : FLOAT;
                             CompetitorID_In : INTEGER
                             ) is
   begin
      null;
   end Set_ArrivalTime;

   procedure Set_Arrived(Segment_In : in out SEGMENT;
                         CompetitorID_In : INTEGER
                        ) is
   begin
      null;
   end Set_Arrived;

   procedure Unset_Arrived(Segment_In : in out SEGMENT;
                           CompetitorID_In : INTEGER
                          ) is
   begin
      null;
   end Unset_Arrived;


   function Get_Path(Segment_In : SEGMENT;
                     Path_Num : INTEGER ) return PATH is
   begin
      return Segment_In.PathsCollection(Path_Num);
   end Get_Path;

   function Get_Next_Segment(Segment_In : SEGMENT) return POINT_SEGMENT is
   begin
      return Segment_In.NextSegment;
   end Get_Next_Segment;

   function Get_Length(Segment_In : SEGMENT) return FLOAT is
   begin
      return Segment_In.PathsCollection(1).Length;
   end Get_Length;

   protected body CROSSING is
      procedure Set_Arrived(CompetitorID_In : INTEGER) is
      begin
         null;
      end Set_Arrived;

      procedure Unset_Arrived(CompetitorID_In : INTEGER) is
      begin
         null;
      end Unset_Arrived;

      procedure Set_ArrivalTime(CompetitorID_In : INTEGER;
                                Time_In : FLOAT) is
      begin
         null;
      end Set_ArrivalTime;

      entry Wait(CompetitorID_In : INTEGER;
                 NextSegment : in out POINT_SEGMENT) when changed = true is
      begin
         null;
      end Wait;
   end CROSSING;


   --RACETRACK methods implementation

   --TODO: validate input file and verify haandle exceptions
   procedure Init_Racetrack(Racetrack_In : in out RACETRACK_POINT;
                            Document_In : DOCUMENT) is
      SegmentQty_In : INTEGER;
      Angle : ANGLE_GRADE;
      Racetrack_XML : Node_List;
      Segment_XML : Node_List;
      Current_Node : Node;
      Current_Length : FLOAT;
      Current_Mult : INTEGER;
      Current_Angle : FLOAT;

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

      if Document_In /= null then

         Racetrack_XML := Get_Elements_By_Tag_Name(Document_In,"segment");
         SegmentQty_In := Length(Racetrack_XML);
         Racetrack_In := new RACETRACK(1..SegmentQty_In);
         for Index in 1..SegmentQty_In loop
            Current_Node := Item(Racetrack_XML, Index-1);
            Segment_XML := Child_Nodes(Current_Node);
            Current_Length := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"length"))));
            Current_Mult := Integer'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"mult"))));
            Current_Angle := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"angle"))));
            Racetrack_In(Index) := new SEGMENT(Current_Mult);
            Set_Values(Racetrack_In(Index).all,
                       1,
                       false,
                       Current_Length,
                       Current_Angle);
         end loop;

      else
         --else auto configure a default circular N_segments-M_paths track (with N = Segments_Qty and M = MaxCompetitors_Qty -1;
         Angle := 360.00 / FLOAT(Segments_Qty);
         SegmentQty_In := Segments_Qty;
         Racetrack_In := new RACETRACK(1..SegmentQty_In);
         for Index in 1..Segments_Qty loop
            Racetrack_In(Index) := new SEGMENT(MaxCompetitors_Qty-1);
            Set_Values(Racetrack_In(Index).all,1,FALSE,100.00,Angle);
         end loop;

      end if;

      for Index in 1..SegmentQty_In-1 loop
         Set_Next(Racetrack_In(Index).all,Racetrack_In(Index+1));
      end loop;
      Set_Next(Racetrack_In(SegmentQty_In).all,Racetrack_In(1));
      Set_Goal(Racetrack_In(1).all);

   end Init_Racetrack;

   function Get_Racetrack(Racetrack_File : STRING) return RACETRACK_POINT is
      Input : File_Input;
      Reader : Tree_Reader;
      Doc : Document;
      Racetrack_XML : Node_List;
      Racetrack_Length : INTEGER;
      Racetrack_Out : RACETRACK_POINT;

   procedure Try_OpenFile is
      begin

         Open(Racetrack_File,Input);

         Set_Feature(Reader,Validation_Feature,False);
         Set_Feature(Reader,Namespace_Feature,False);

         Parse(Reader,Input);

         Doc := Get_Tree(Reader);
         Racetrack_XML := Get_Elements_By_Tag_Name(Doc,"segment");
         Racetrack_Length := Length(Racetrack_XML);
      exception
            when ADA.IO_EXCEPTIONS.NAME_ERROR => Doc := null;
      end Try_OpenFile;

   begin

      Try_OpenFile;

      Init_Racetrack(Racetrack_Out, Doc);

      return Racetrack_Out;

   end Get_Racetrack;



   procedure Set_Segment(Racetrack_In : in out RACETRACK;
                         Segment_In : SEGMENT;
                         Position_In : POSITIVE) is
   begin
      if Position_In >= Racetrack_In'FIRST and Position_In <= Racetrack_In'LAST then
         Racetrack_In(Position_In).all := Segment_In;
         if Position_In > Racetrack_In'FIRST and Racetrack_In(Position_In - 1) /= null then
            Set_Next(Racetrack_In(Position_In - 1).all, Racetrack_In(Position_In));
         end if;
         if Position_In = Racetrack_In'FIRST and Racetrack_In(Racetrack_In'LAST) /= null then
            Set_Next(Racetrack_In(Racetrack_In'LAST).all, Racetrack_In(Position_In));
         end if;
         if Position_In < Racetrack_In'LAST and Racetrack_In(Position_In + 1) /= null then
            Set_Next(Racetrack_In(Position_In).all, Racetrack_In(Position_In + 1));
         end if;
         if Position_In = Racetrack_In'LAST and Racetrack_In(Racetrack_In'FIRST) /= null then
            Set_Next(Racetrack_In(Position_In).all, Racetrack_In(Racetrack_In'FIRST));
         end if;
      end if;

   end Set_Segment;

   function Get_Segment(Racetrack_In : RACETRACK;
                        Position : POSITIVE) return POINT_SEGMENT is
   begin
      return Racetrack_In(Position);
   end Get_Segment;

   function Print_Racetrack(Racetrack_In : RACETRACK) return INTEGER is
   begin
      return 4;
   end Print_Racetrack;



end Circuit;