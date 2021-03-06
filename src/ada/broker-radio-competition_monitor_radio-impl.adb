with Broker.Radio.Competition_Monitor_Radio.Skel;
pragma Warnings (Off, Broker.Radio.Competition_Monitor_Radio.Skel);

--with Stats;
with Competition_Monitor;

with Common;
use Common;
with Ada.Text_IO;

with Ada.Strings.Unbounded;

package body Broker.Radio.Competition_Monitor_Radio.impl is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   function Ready( Self : access Object;
                  CompetitorID : Corba.SHORT) return BOOLEAN is
   begin
      Ada.Text_IO.Put_Line("Ready box " & COmmon.Integer_To_String(INTEGER(CompetitorID)));
      return Competition_Monitor.Ready(INTEGER(CompetitorID));
   end Ready;

   procedure Get_CompetitorInfo(Self : access Object;
				lap : CORBA.Short;
				sector : CORBA.Short ;
				id : CORBA.Short;
				time : out CORBA.FLOAT;
				metres : out CORBA.FLOAT;
				Returns : out CORBA.STRING) is
      ReturnStr : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      ReturnTime : Standard.FLOAT;
      ReturnMetres : Standard.FLOAT;
   begin
      Competition_Monitor.Get_CompetitorInfo(lap       => INTEGER(lap),
                                  sector    => INTEGER(sector),
                                  id        => INTEGER(id),
                                  time      => ReturnTime,
                                  metres    => ReturnMetres,
                                  updString => ReturnStr);
      Returns := CORBA.To_CORBA_String(Unbounded_String.To_String(ReturnStr));
      time := CORBA.Float(ReturnTime);
      metres := CORBA.Float(ReturnMetres);
   end Get_CompetitorInfo;

   procedure Get_CompetitionInfo
     (Self : access Object;
      timeInstant : CORBA.FLOAT;
      xmlInfo : out CORBA.String;
      Returns : out Broker.Radio.Competition_Monitor_Radio.float_sequence) is

      use IDL_SEQUENCE_float;
      Tmp_String : Unbounded_String.Unbounded_String;
      Tmp_TimesArray : FLOAT_ARRAY_POINT;
   begin
      Competition_Monitor.Get_CompetitionInfo(Standard.FLOAT(timeInstant),Tmp_TimesArray,Tmp_String);

      if(Tmp_TimesArray /= null) then
         for Index in Tmp_TimesArray.all'RANGE loop

            Append(Returns,CORBA.FLOAT(Tmp_TimesArray.all(Index)));
         end loop;
      end if;

      xmlInfo := CORBA.To_CORBA_String(Unbounded_String.To_String(Tmp_String));
   end Get_CompetitionInfo;

   procedure Get_CompetitionConfiguration
     (Self : access Object;
      xmlConf :in out CORBA.String;
      Results : out CORBA.FLOAT) is

      XmlInfo_Out : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      CircuitLength_Out : Standard.FLOAT;
   begin
Ada.text_io.put_line("LORY : 0");
      Competition_Monitor.Get_CompetitionConfiguration(XmlInfo_Out,
                                                       CircuitLength_Out);
Ada.text_io.put_line("LORY : 1");
      xmlConf := CORBA.To_CORBA_String(Unbounded_String.To_String(XmlInfo_Out));
Ada.text_io.put_line("LORY : 2");
      Results := CORBA.Float(CircuitLength_Out);
Ada.text_io.put_line("LORY : 3");
  end Get_CompetitionConfiguration;

   function Get_CompetitorConfiguration(Self : access Object;
                                        Id : CORBA.Short) return CORBA.STRING is

      XmlInfo_Out : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   begin
      XmlInfo_Out := Competition_Monitor.Get_CompetitorConfiguration(INTEGER(Id));

      return CORBA.To_CORBA_String(Unbounded_String.To_String(XmlInfo_Out));
   end Get_CompetitorConfiguration;

   procedure Set_Simulation_Speed(Self : access Object;
                                  Simulation_Speed_In : Corba.Float) is
   begin
      Competition_Monitor.Set_Simulation_Speed(Float(Simulation_Speed_In));
   end Set_Simulation_Speed;

   function Get_Latest_Time_Instant(Self : access Object) return Corba.Float is
   begin
      return Corba.Float(Competition_Monitor.Get_Latest_Time_Instant);
   end Get_Latest_Time_Instant;

end Broker.Radio.Competition_Monitor_Radio.impl;
