with Corba.Radio.Competition_Monitor_Radio.Skel;
pragma Warnings (Off, Corba.Radio.Competition_Monitor_Radio.Skel);

use Corba.Radio.Competition_Monitor_Radio;

--with Stats;
with Competition_Monitor;

with Common;
use Common;
with Ada.Text_IO;

with Ada.Strings.Unbounded;

package body Corba.Radio.Competition_Monitor_Radio.impl is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   function Ready( Self : access Object;
                  CompetitorID : Corba.SHORT) return BOOLEAN is
   begin
      Ada.Text_IO.Put_Line("Ready box " & COmmon.IntegerToString(INTEGER(CompetitorID)));
      return Competition_Monitor.Ready(INTEGER(CompetitorID));
   end Ready;

   procedure Get_CompetitorInfo(Self : access Object; lap : CORBA.Short; sector : CORBA.Short ; id : CORBA.Short; time : out CORBA.FLOAT; Returns : out CORBA.STRING) is
      ReturnStr : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      ReturnTime : Standard.FLOAT;
   begin
      Ada.Text_IO.Put_Line("Asking for info: lap " & INTEGER'IMAGE(INTEGER(lap)) &
                           ", sector " & INTEGER'IMAGE(INTEGER(sector)));
      Competition_Monitor.Get_CompetitorInfo(lap       => INTEGER(lap),
                                  sector    => INTEGER(sector),
                                  id        => INTEGER(id),
                                  time      => ReturnTime,
                                  updString => ReturnStr);
      Ada.Text_IO.Put_Line("Converting for info");
      Returns := CORBA.To_CORBA_String(Unbounded_String.To_String(ReturnStr));
      time := CORBA.Float(ReturnTime);
   end Get_CompetitorInfo;

   procedure Get_CompetitionInfo
     (Self : access Object;
      timeInstant : CORBA.FLOAT;
      xmlInfo : out CORBA.String;
      Returns : out Competition_Monitor_Radio.float_sequence) is

      use IDL_SEQUENCE_float;
      Tmp_String : Unbounded_String.Unbounded_String;
      Tmp_TimesArray : FLOAT_ARRAY_POINT;
   begin
      Competition_Monitor.Get_CompetitionInfo(Standard.FLOAT(timeInstant),Tmp_TimesArray,Tmp_String);

      if(Tmp_TimesArray /= null) then
         for Index in Tmp_TimesArray.all'RANGE loop
            Ada.Text_IO.Put_Line("DEBUG Taking time");
            Append(Returns,CORBA.FLOAT(Tmp_TimesArray.all(Index)));
         end loop;
      end if;
      Ada.Text_IO.Put_Line("DEBUG xmlInfo " &
                           Unbounded_String.To_String(Tmp_String));
      xmlInfo := CORBA.To_CORBA_String(Unbounded_String.To_String(Tmp_String));
   end Get_CompetitionInfo;

   procedure Get_CompetitionConfiguration
     (Self : access Object;
      circuitLength : out CORBA.Float;
      xmlConf : out CORBA.String) is

      XmlInfo_Out : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      CircuitLength_Out : Standard.FLOAT;
   begin

      Competition_Monitor.Get_CompetitionConfiguration(XmlInfo_Out,
                                                       CircuitLength_Out);

      xmlConf := CORBA.To_CORBA_String(Unbounded_String.To_String(XmlInfo_Out));
      circuitLength := CORBA.Float(CircuitLength_Out);

   end Get_CompetitionConfiguration;

   function Get_CompetitorConfiguration(Self : access Object;
                                        Id : CORBA.Short) return CORBA.STRING is

      XmlInfo_Out : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   begin
      XmlInfo_Out := Competition_Monitor.Get_CompetitorConfiguration(INTEGER(Id));

      return CORBA.To_CORBA_String(Unbounded_String.To_String(XmlInfo_Out));
   end Get_CompetitorConfiguration;

end Corba.Radio.Competition_Monitor_Radio.impl;
