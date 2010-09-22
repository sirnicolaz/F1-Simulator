with Common;
use Common;

with Ada.Strings.Unbounded;
with Ada.Strings.Fixed;

package Box_Data is

   type INFO_NODE is private;
   type INFO_NODE_POINT is access INFO_NODE;

   type Competition_Update is tagged record
      Gas_Level : Float;
      Tyre_Usury : Percentage;
      Time : Float;
      Lap : Integer;
      Sector : Integer;
      Path_Length : Float;
      Max_Speed : Float;
      --For now it's not necessary. In the future there might be an improvement
      --+ in the Strategy computation considering the classific too.
      --Classific : access COMPETITOR_LIST := new COMPETITOR_LIST(1..competitor_qty);
   end record;

   type Extended_Competition_Update is new Competition_Update
   with
      record
         Mean_Speed : Float; -- km/h
         Mean_Gas_Consumption : Float; -- l/h
         Mean_Tyre_Usury : Percentage;
      end record;

   type Competition_Update_POINT is access Competition_Update;

   type Strategy_History is array(Integer range <>) of Strategy;

   protected type Synch_Competition_Updates is
      procedure Add_Data(CompetitionUpdate_In : Competition_Update_POINT);
      entry Wait(NewInfo : out Competition_Update;
                 Num : in Integer);
      entry Get_Update( NewInfo : out Competition_Update;
                       Num : Integer );
      function IsUpdated return BOOLEAN;
   private
      Updates_Current : Info_Node_Point;
      Updates_Last : Info_Node_Point;
      Updated : BOOLEAN := False;
   end Synch_Competition_UpdateS;

   type Synch_Competition_UpdateS_POINT is access Synch_Competition_UpdateS;

   --The resource handle the mutually exclusive access to the
   --+ Strategy History. The resource is written by the
   --+ Strategy updated that add new strategies to the History
   --+ everytime it calculates a new one.
   --+ The task responsible for the remote interface of the Box
   --+ (used by the competitor to ask for a new Strategy) uses
   --+ this resources to search for the up-to-date Strategy.

   protected type Synch_Strategy_History is

      procedure Init( Lap_Qty : in Integer );

      procedure AddStrategy( Strategy_in : in Strategy );

      entry Get_Strategy( NewStrategy : out Strategy;
                         Lap : in Integer);

      -- It returns the pit stops already done.
      function Get_PitStopDone return Integer;


   private
      History : access Strategy_History;
      History_size : Integer := 0;
      Updated : BOOLEAN := false;
   end Synch_Strategy_History;

   type Synch_Strategy_History_POINT is access Synch_Strategy_History;

   --All the information available packed.
   type ALL_INFO is private;

   type ALL_INFO_ARRAY is array(POSITIVE range <>) of ALL_INFO;

   --This buffer is supposed to be used between Strategy updater and
   --+ the box
   protected type Synch_ALL_INFO_BUFFER is
      procedure Init( Size : POSITIVE);
      entry Get_Info( Num : POSITIVE; Info : out ALL_INFO );
      entry Wait( Num : POSITIVE; Info : out ALL_INFO );

      procedure Add_Info(Update_In : Extended_Competition_Update );
      procedure Add_Info(Update_In : Extended_Competition_Update;
                         Strategy_In : Strategy);

   private
      Updated : BOOLEAN := false;
      Info_Qty : Integer := 0;
      Info_List : access ALL_INFO_ARRAY;
      Ready : BOOLEAN := FALSE;
   end Synch_ALL_INFO_BUFFER;

   type Synch_ALL_INFO_BUFFER_POINT is access Synch_ALL_INFO_BUFFER;

   function Get_StrategyXML( Data : ALL_INFO ) return Unbounded_String.Unbounded_String;

   function Get_UpdateXML( Data : ALL_INFO ) return Unbounded_String.Unbounded_String;

   function Get_Time ( Data : ALL_INFO ) return Float;
   function Get_Metres ( Data : ALL_INFO ) return Float;

   function BoxStrategyToXML(Strategy_in : Strategy) return STRING;

private

    type Info_Node is record
      Index : Integer;
      Previous : INFO_NODE_POINT;
      Next : INFO_NODE_POINT;
      This : Competition_Update_POINT;
   end record;

   type ALL_INFO is record
      Per_Sector_Update : access Extended_Competition_Update;
      Strategy_Update : access Common.Strategy;
   end record;

end Box_Data;
