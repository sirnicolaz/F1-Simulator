with Common;
use Common;

with Ada.Strings.Unbounded;
with Ada.Strings.Fixed;

package Box_Data is

   type Info_Node is private;
   type Info_Node_Point is access Info_Node;

   type Competition_Update is tagged record
      Gas_Level   : Float;
      Tyre_Usury  : Percentage;
      Time        : Float;
      Lap         : Integer;
      Sector      : Integer;
      Path_Length : Float;
      Max_Speed   : Float;
   end record;

   type Extended_Competition_Update is new Competition_Update
   with
      record
         Mean_Speed           : Float; -- km/h
         Mean_Gas_Consumption : Float; -- l/h
         Mean_Tyre_Usury      : Percentage;
      end record;

   type Competition_Update_Point is access Competition_Update;

   type Strategy_History is array(Integer range <>) of Strategy;

   protected type Synch_Competition_Updates is

      procedure Add_Data(CompetitionUpdate_In : Competition_Update_Point);

      entry Wait(NewInfo : out Competition_Update;
                 Num : in Integer);

      entry Get_Update( NewInfo : out Competition_Update;
                       Num : Integer );

      function IsUpdated return Boolean;

   private
      Updates_Current : Info_Node_Point;
      Updates_Last    : Info_Node_Point;
      Updated         : Boolean := False;
   end Synch_Competition_UpdateS;

   type Synch_Competition_UpdateS_Point is access Synch_Competition_UpdateS;

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

      entry Get_Strategy( New_Strategy : out Strategy;
                          Lap : in Integer);

   private
      History      : access Strategy_History;
      History_size : Integer := 0;
      Updated      : Boolean := False;
   end Synch_Strategy_History;

   type Synch_Strategy_History_Point is access Synch_Strategy_History;

   --All the information available packed.
   type All_Info is private;

   type All_Info_Array is array(Positive range <>) of All_Info;

   --This buffer is supposed to be used between Strategy updater and
   --+ the box
   protected type Synch_All_Info_Buffer is
      procedure Init( Size : Positive);
      entry Get_Info( Num : Positive; Info : out All_Info );
      entry Wait( Num : Positive; Info : out All_Info );

      procedure Add_Info(Update_In : Extended_Competition_Update );
      procedure Add_Info(Update_In : Extended_Competition_Update;
                         Strategy_In : Strategy);

   private
      Updated : Boolean := False;
      Info_Qty : Integer := 0;
      Info_List : access All_Info_Array;
      Ready : Boolean := False;
   end Synch_All_Info_Buffer;

   type Synch_All_Info_Buffer_Point is access Synch_All_Info_Buffer;

   function Get_Strategy_XML( Data : All_Info ) return Unbounded_String.Unbounded_String;

   function Get_Update_XML( Data : All_Info ) return Unbounded_String.Unbounded_String;

   function Get_Time ( Data : All_Info ) return Float;
   function Get_Metres ( Data : All_Info ) return Float;

   function Box_Strategy_To_XML(Strategy_in : Strategy) return String;

private

    type Info_Node is record
      Index    : Integer;
      Previous : Info_Node_Point;
      Next     : Info_Node_Point;
      This     : Competition_Update_Point;
   end record;

   type All_Info is record
      Per_Sector_Update : access Extended_Competition_Update;
      Strategy_Update   : access Common.Strategy;
   end record;

end Box_Data;
