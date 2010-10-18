with Broker.Radio.BoxRadio;

with Ada.Strings.Unbounded;
with Ada.Text_IO;

with CORBA.ORB;

with Common;
use Common;

package CompetitorRadio is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   type BOX_CONNECTION is private;

   procedure Init_BoxConnection ( BoxRadio_CorbaLOC : in STRING;
                                 Radio : out BOX_CONNECTION;
                                 ID : INTEGER;
                                 Success : out BOOLEAN);

   procedure Close_BoxConnection ( Radio : out BOX_CONNECTION);

   function Get_Strategy( Radio : BOX_CONNECTION;
                         Lap : in INTEGER) return Strategy;

private
   type BOX_CONNECTION is record
      Connection : Broker.Radio.BoxRadio.Ref;
      CompetitorID : INTEGER;
   end record;


end CompetitorRadio;
