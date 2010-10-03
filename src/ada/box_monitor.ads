with Box;
with Box_Data;

with Ada.Strings.Unbounded;

package Box_Monitor is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   procedure Init( CompetitionUpdates_Buffer : Box_Data.SYNCH_ALL_INFO_BUFFER_POINT);

   procedure Force_Pitstop ( Force : Boolean);

   procedure GetUpdate(Num : in INTEGER;
                       Time : out FLOAT;
                       PathLength : out FLOAT;
                       Returns : out Unbounded_String.Unbounded_String);

end Box_Monitor;
