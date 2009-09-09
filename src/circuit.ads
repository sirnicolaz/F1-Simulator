package Circuit is


   type PATH is private;
   type PATHS is array(INTEGER range <>) of PATH;
   type SEGMENT(Paths_Qty : INTEGER) is tagged private;

private

   type SEGMENT(Paths_Qty : INTEGER) is tagged record
      SectorID : INTEGER;
      IsGoal : BOOLEAN;
      Multiplicity : INTEGER;
      PathsCollection : PATHS(1..Paths_Qty);
   end record;

   type PATH is record
      Length : FLOAT;
      Grip : FLOAT;
      Difficulty : FLOAT range 0.0..10.0;
      Angle : FLOAT range 0.0..180.0;
   end record;

end Circuit;
