with Common;
use Common;
  with Stats;
  use Stats;

--This package represents the statistics of each competitor.
package OnBoardComputer is

--     type COMP_STATS is private;
--     type COMP_STATS_POINT is access COMP_STATS; --new, altrimenti come lo usavo?


   --procedure Set_Checkpoint(Stats_In : out COMP_STATS; Checkpoint_In : INTEGER);
   --procedure Set_Sector(Stats_In : out COMP_STATS; Sector_In : INTEGER);
   --procedure Set_Lap(Stats_In : out COMP_STATS; Lap_In : INTEGER);
   --procedure Set_Gas(Stats_In : out COMP_STATS; Gas_In : PERCENTAGE);
   --procedure Set_Tyre(Stats_In : out COMP_STATS; Tyre_In : PERCENTAGE);
   --procedure Set_Time(Stats_In : out COMP_STATS; Time_In : FLOAT);

--     procedure Set_Checkpoint(Stats_In : out COMP_STATS_POINT; Checkpoint_In : INTEGER);
--     procedure Set_Sector(Stats_In : out COMP_STATS_POINT; Sector_In : INTEGER);
--     procedure Set_Lap(Stats_In : out COMP_STATS_POINT; Lap_In : INTEGER);
--     procedure Set_Gas(Stats_In : out COMP_STATS_POINT; Gas_In : FLOAT);--PERCENTAGE); --meglio float
--     procedure Set_Tyre(Stats_In : out COMP_STATS_POINT; Tyre_In : FLOAT);--PERCENTAGE); -- meglio float
--     procedure Set_Time(Stats_In : out COMP_STATS_POINT; Time_In : FLOAT);
--     procedure Update_Stats(compStats : in out COMP_STATS_POINT);
--
--     function Get_Checkpoint(Stats_In : COMP_STATS) return INTEGER;
--     function Get_Sector(Stats_In : COMP_STATS) return INTEGER;
--     function Get_Lap(Stats_In : COMP_STATS) return INTEGER;
--     function Get_Gas(Stats_In : COMP_STATS) return FLOAT;--PERCENTAGE;
--     function Get_Tyre(Stats_In : COMP_STATS) return FLOAT;--PERCENTAGE;
--     function Get_Time(Stats_In : COMP_STATS) return FLOAT;

   type COMP_STATS_NODE is private;
   type COMP_STATS_NODE_POINT is access COMP_STATS_NODE;

   -- This type is used to manage the Computer statistics.
   protected type COMPUTER is
      -- This method create a brand new COMPUTER whose current_node and last_node
      --+ are set to an empty one.
      procedure Init_Computer(CompetitorId_In : INTEGER; tempGlobal : GLOBAL_STATS_HANDLER_POINT);
      -- The method adds new data to the computer. We're sure that data are inserted
      --+ in time-increasing order because internal clock of competitors grows through each
      --+ checkpoint (remember that Computer is updated only once a checkpoint is reached)
      procedure Add_Data(Data : COMP_STATS_POINT);
      -- It returns the competitor ID related to this Computer
      function Get_Id return INTEGER;
      -- It sets the CompStats parameter with the statistics related to the given sector and lap
      entry Get_StatsBySect(Sector : INTEGER; Lap : INTEGER; CompStats : out COMP_STATS_POINT);
      -- It sets the CompStats parameter with the statistics related to the given check-point and lap
      entry Get_StatsByCheck(Checkpoint : INTEGER; Lap : INTEGER; CompStats : out COMP_STATS_POINT);
      -- This method is used when a statistic that has not been inserted yet is asked.
      --+ When the the competitor updates the list after having passed through a check-point,
      --+ the variable "Updated" is set. In this way the statistic requester can procede with
      --+ the method execution checking again if the demanded statistic is available.
      entry Wait_ByCheck(Checkpoint : INTEGER; Lap : INTEGER; CompStats: out COMP_STATS_POINT);
      -- The purpose of this method is the same of the one described above
      --+ (even if it's used for asking waiting on a check-point statistic request instead
      --+ of a sector)
      entry Wait_BySect(Sector : INTEGER; Lap : INTEGER; CompStats: out COMP_STATS_POINT);
   private
      Competitor_Id : INTEGER;
      Current_Node : COMP_STATS_NODE_POINT;
      Last_Node : COMP_STATS_NODE_POINT; -- puntatore all'ultimo per ottimizzare l'inserimento
      Updated : BOOLEAN;
      global : GLOBAL_STATS_HANDLER_POINT;
   end COMPUTER;

   type COMPUTER_POINT is access COMPUTER;

private
   -- This type collects all the statistics for each time instant.
--     type COMP_STATS is record
--        Checkpoint : INTEGER;
--        -- Is this the last check-point in the sector?
--        LastCheckInSect : BOOLEAN;
--        -- Is this the first check-point in the sector?
--        FirstCheckInSect : BOOLEAN;
--        Sector : INTEGER;
--        Lap : INTEGER;
--        Time : FLOAT;
--        GasLevel : FLOAT;--PERCENTAGE;
--        TyreUsury : FLOAT;--PERCENTAGE;
--                          -- GLOBAL_STATS_HANDLER_POINT section
--        sgs_In : S_GLOB_STATS_POINT;
--        updatePeriod_In : FLOAT := 100.0;
--        global : GLOBAL_STATS_HANDLER_POINT; --:= initGlobalStatsHandler(global, sgs_In, updatePeriod_In);
--     end record;

   --This is the structure used to handle the statistic list.
   --+ Each node contains a record with all the information concerning the statistics
   --+ at a given instant.
   type COMP_STATS_NODE is record
      Next : COMP_STATS_NODE_POINT;
      Previous : COMP_STATS_NODE_POINT;
      Value : Common.COMP_STATS_POINT;
      Index : INTEGER;
   end record;

   end OnBoardComputer;
