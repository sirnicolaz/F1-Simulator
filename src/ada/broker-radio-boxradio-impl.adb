with Broker.Radio.BoxRadio.Skel;
pragma Warnings (Off, Broker.Radio.BoxRadio.Skel);

use Broker.Radio.BoxRadio;

with Ada.Exceptions;

with Ada.Text_IO;

with Common;
use Common;

package body Broker.Radio.BoxRadio.impl is

   StrategyHistory : Box_Data.SYNCH_STRATEGY_HISTORY_POINT;


   procedure Init( StrategyHistory_Buffer : Box_Data.SYNCH_STRATEGY_HISTORY_POINT ) is
   begin
      StrategyHistory := StrategyHistory_Buffer;
   end Init;

   function RequestStrategy( Self : access Object;
                            lap : CORBA.Short) return CORBA.String is

      pragma Warnings (Off);
      pragma Unreferenced (Self);
      pragma Warnings (On);

      Comunication_Exception : exception;
      Data_Exception : exception;

      NewStrategy : Common.STRATEGY;
      Temp_String : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   begin

      Ada.Text_IO.Put_Line("Requesting strategy for lap: " & Common.IntegerToString(INTEGER(lap)));

      StrategyHistory.Get_Strategy(NewStrategy,INTEGER(lap));


      Ada.Text_IO.Put_Line("Strategy got");

      Temp_String := Temp_String & Unbounded_String.To_Unbounded_String
        ("<?xml version=""1.0""?>" &
         Box_Data.BoxStrategyToXML(NewStrategy));
      return CORBA.To_CORBA_String(Unbounded_String.To_String(Temp_String));

   exception
      when Constraint_Error | Storage_Error =>
         raise Data_Exception with "Received data are corrupted";
      when Error : others =>
         raise Comunication_Exception with "Problems comunicating with Box";
      --return CORBA.To_CORBA_STRING("Merda");
   end RequestStrategy;

end Broker.Radio.BoxRadio.impl;
