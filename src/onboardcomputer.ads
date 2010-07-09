with Common;
use Common;
package OnBoardComputer is

   type COMP_STATS is private;
   type COMP_STATS_POINT is access COMP_STATS; --new, altrimenti come lo usavo?

   procedure Set_Checkpoint(Stats_In : out COMP_STATS_POINT; Checkpoint_In : INTEGER);
   procedure Set_Sector(Stats_In : out COMP_STATS_POINT; Sector_In : INTEGER);
   procedure Set_Lap(Stats_In : out COMP_STATS_POINT; Lap_In : INTEGER);
   procedure Set_Gas(Stats_In : out COMP_STATS_POINT; Gas_In : FLOAT);--PERCENTAGE); --meglio float
   procedure Set_Tyre(Stats_In : out COMP_STATS_POINT; Tyre_In : FLOAT);--PERCENTAGE); -- meglio float
   procedure Set_Time(Stats_In : out COMP_STATS_POINT; Time_In : FLOAT);

   function Get_Checkpoint(Stats_In : COMP_STATS) return INTEGER;
   function Get_Sector(Stats_In : COMP_STATS) return INTEGER;
   function Get_Lap(Stats_In : COMP_STATS) return INTEGER;
   function Get_Gas(Stats_In : COMP_STATS) return FLOAT;--PERCENTAGE;
   function Get_Tyre(Stats_In : COMP_STATS) return FLOAT;--PERCENTAGE;
   function Get_Time(Stats_In : COMP_STATS) return FLOAT;

   type COMP_STATS_NODE is private;
   type COMP_STATS_NODE_POINT is access COMP_STATS_NODE;

   protected type COMPUTER is
      procedure Init_Computer(CompetitorId_In : INTEGER);
      procedure Add_Data(Data : COMP_STATS);
      function Get_Id return INTEGER;
      entry Get_StatsBySect(Sector : INTEGER; Lap : INTEGER; CompStats : out COMP_STATS);
      entry Get_StatsByCheck(Checkpoint : INTEGER; Lap : INTEGER; CompStats : out COMP_STATS);
      entry Wait_ByCheck(Checkpoint : INTEGER; Lap : INTEGER; CompStats: out COMP_STATS);
      entry Wait_BySect(Sector : INTEGER; Lap : INTEGER; CompStats: out COMP_STATS);
   private
      Competitor_Id : INTEGER;
      Current_Node : COMP_STATS_NODE_POINT;
      Last_Node : COMP_STATS_NODE_POINT; -- puntatore all'ultimo per ottimizzare l'inserimento
      Updated : BOOLEAN;
   end COMPUTER;

   type COMPUTER_POINT is access COMPUTER;

private

   type COMP_STATS is record
      Checkpoint : INTEGER;
      LastCheckInSect : BOOLEAN;
      FirstCheckInSect : BOOLEAN;
      Sector : INTEGER;
      Lap : INTEGER;
      Time : FLOAT;
      GasLevel : FLOAT;--PERCENTAGE;
      TyreUsury : FLOAT;--PERCENTAGE;
   end record;

   type COMP_STATS_NODE is record
      Next : COMP_STATS_NODE_POINT;
      Previous : COMP_STATS_NODE_POINT;
      Value : COMP_STATS;
      Index : INTEGER;
   end record;

   end OnBoardComputer;
