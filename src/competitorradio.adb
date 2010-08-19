--with CORBA.Object;
with COmmon;
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
      if BoxRadio.Is_Nil (Radio.Connection) then
         Success := false;
      else
         Success := true;
      end if;

   end Init_BoxConnection;

   procedure Close_BoxConnection ( Radio : out BOX_CONNECTION) is
   begin
      --Release the resource
      BoxRadio.Release(Radio.Connection);
   end Close_BoxConnection;

   function Get_Strategy( Radio : BOX_CONNECTION;
                         Lap : in INTEGER) return STRING is
      Strategy : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      File_Name : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   begin

      Strategy := Unbounded_String.To_Unbounded_String(
                                                       CORBA.To_Standard_String
                                                         (BoxRadio.RequestStrategy(Radio.Connection,CORBA.Short(Lap))));

      File_Name := Unbounded_String.To_Unbounded_String("Strategy-" & Common.IntegerToString(Radio.CompetitorID));
      --TODO: in the future implement a way to keep the history of strategies
      if Common.SaveToFile(FileName => Unbounded_String.To_String(File_Name),
                        Content  => Unbounded_String.To_String(Strategy),
                           Path     => "") then
         return Unbounded_String.To_String(File_Name);
      else
         return "fail";
      end if;
   end Get_Strategy;

begin

   null;
   --This *** statement was producing lots of troubles
   --CORBA.ORB.Initialize ("ORB");

end CompetitorRadio;