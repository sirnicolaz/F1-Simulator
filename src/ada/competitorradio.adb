--with CORBA.Object;
with Common;
use Common;

package body CompetitorRadio is

   procedure Init_BoxConnection ( BoxRadio_CorbaLOC : in STRING;
                                 Radio : out BOX_CONNECTION;
                                 ID : in INTEGER;
                                 Success : out BOOLEAN) is
   begin

      Radio.CompetitorID := ID;

      CORBA.ORB.String_To_Object
        (CORBA.To_CORBA_String (BoxRadio_CorbaLOC), Radio.Connection);

      --  Checking if it worked
      if Broker.Radio.BoxRadio.Is_Nil (Radio.Connection) then
         Success := false;
      else
         Success := true;
      end if;

   end Init_BoxConnection;

   procedure Close_BoxConnection ( Radio : out BOX_CONNECTION) is
   begin
      --Release the resource
      Broker.Radio.BoxRadio.Release(Radio.Connection);
   end Close_BoxConnection;

   function Get_Strategy( Radio : BOX_CONNECTION;
                         Lap : in INTEGER) return STRING is
      Strategy : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      File_Name : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   begin
      Ada.Text_IO.Put_Line(INTEGER'IMAGE(Radio.CompetitorID)
                           &" Connecting for strategy");

      Strategy := Unbounded_String.To_Unbounded_String(
                                                       CORBA.To_Standard_String
                                                         (Broker.Radio.BoxRadio.RequestStrategy(Radio.Connection,CORBA.Short(Lap))));

      Ada.Text_IO.Put_Line(INTEGER'IMAGE(Radio.CompetitorID)
                           &" connected succesfully");

      File_Name := Unbounded_String.To_Unbounded_String("Strategy-" & Common.IntegerToString(Radio.CompetitorID));
      --TODO: in the future implement a way to keep the history of strategies
      if Common.SaveToFile(FileName => Unbounded_String.To_String(File_Name),
                        Content  => Unbounded_String.To_String(Strategy),
                           Path     => "") then
         Ada.Text_IO.Put_Line(INTEGER'IMAGE(Radio.CompetitorID)
                           &" saved");
         return Unbounded_String.To_String(File_Name);
      else
         Ada.Text_IO.Put_Line(INTEGER'IMAGE(Radio.CompetitorID)
                           &" fail");
         return "fail";
      end if;
   end Get_Strategy;

begin

   null;
   --This *** statement was producing lots of troubles
   --CORBA.ORB.Initialize ("ORB");

end CompetitorRadio;
