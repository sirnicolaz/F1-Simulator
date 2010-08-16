with BoxRadio;
with Ada.Text_IO;

with CORBA.ORB;
with PolyORB.Setup.Client;
pragma Warnings (Off, PolyORB.Setup.Client);

with PolyORB.Utils.Report;


package CompetitorRadio is

   type BOX_CONNECTION is private;

   procedure Init_BoxConnection ( BoxRadio_CorbaLOC : in STRING;
                                 Radio : out BOX_CONNECTION;
                                 ID : INTEGER;
                                 Success : out BOOLEAN);

   procedure Close_BOxCOnnection ( Radio : out BOX_CONNECTION);

   function Get_Strategy( Radio : BOX_CONNECTION;
                         Lap : in INTEGER) return STRING;

private
   type BOX_CONNECTION is record
      Connection : BoxRadio.Ref;
      CompetitorID : INTEGER;
   end record;


end CompetitorRadio;
