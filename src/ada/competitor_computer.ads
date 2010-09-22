with Common;
use Common;

with Ada.Strings.Unbounded;

with Competition_Computer;
use Competition_Computer;

--This package represents the statistics of each competitor.
package Competitor_Computer is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   type UPDATE_RECORD is private;
   type SECTOR_UPDATE_ARRAY is array(1..3) of UPDATE_RECORD;
   type LAP_UPDATE_ARRAY is array(INTEGER range <>) of SECTOR_UPDATE_ARRAY;

   --This resource is accessed only by the box and the competitor, so we can use the "Wait-Notify"
   --+ technique
   protected type SYNCH_INFO_FOR_BOX is

      procedure Init( Laps : INTEGER);
      entry Get_Info( Lap : INTEGER; Sector : INTEGER; Time : out FLOAT; Returns : out Unbounded_String.Unbounded_String; Metres : out FLOAT );
      entry Wait_Info( Lap : INTEGER; Sector : INTEGER; Time : out FLOAT; Returns : out Unbounded_String.Unbounded_String; Metres : out FLOAT  );
      procedure Set_Info( Lap : INTEGER; Sector : INTEGER; Time : FLOAT; Metres : FLOAT; UpdateString : Unbounded_String.Unbounded_String);

   private
      Updated : BOOLEAN := false;
      Info : access LAP_UPDATE_ARRAY;
   end SYNCH_INFO_FOR_BOX;

   type SYNCH_INFO_FOR_BOX_POINT is access SYNCH_INFO_FOR_BOX;

   type COMPUTER is private;
   type COMPUTER_POINT is access COMPUTER;

   -- This method create a brand new COMPUTER whose current_node and last_node
   --+ are set to an empty one.
   procedure Init_Computer(Computer_In : COMPUTER_POINT;
                           CompetitorId_In : INTEGER;
                           Laps : INTEGER);
   -- The method adds new data to the computer. We're sure that data are inserted
   --+ in time-increasing order because internal clock of competitors grows through each
   --+ checkpoint (remember that Computer is updated only once a checkpoint is reached)
   procedure Add_Data(Computer_In : COMPUTER_POINT;
                      Data : in out COMPETITOR_STATS);
   -- It returns the competitor ID related to this Computer

   procedure CompetitorOut(Computer_In : COMPUTER_POINT;
                           Lap           : INTEGER;
                           Data          : COMPETITOR_STATS);

   function Get_Id(Computer_In : COMPUTER_POINT) return INTEGER;

   procedure Get_BoxInfo(Computer_In : COMPUTER_POINT;
                         Lap : INTEGER;
                         Sector : INTEGER;
                         UpdateString_In : out Unbounded_String.Unbounded_String;
                         Time_In : out FLOAT;
                         Metres : out FLOAT);

private

   type COMPUTER is record
      Competitor_Id : INTEGER;

      --Information : access SYNCH_COMPETITOR_STATS_HANDLER_ARRAY;
      BoxInformation : SYNCH_INFO_FOR_BOX_POINT;
      LastSlotAccessed : INTEGER;

      SectorLength_Helper : FLOAT;

      -- These values can be calculated dinamically using COMPETITOR_STATS list,
      --+ but for a matter of efficiency we keep the latest computed values
      --+ here.
      CurrentBestSector_Times : FLOAT_ARRAY(1..3);
      CurrentBestLap_Time : FLOAT;
      CurrentBestLap_Num : INTEGER;
      CurrentMaxSpeed : FLOAT;
   end record;

   type UPDATE_RECORD is record
      UpdateString : Unbounded_String.Unbounded_String;
      Time : FLOAT;
      Metres : FLOAT;
   end record;

end Competitor_Computer;
