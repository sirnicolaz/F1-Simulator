with BoxRadio.Skel;
pragma Warnings (Off, BoxRadio.Skel);

with Ada.Text_IO;

with Common;
use Common;

package body BoxRadio.impl is

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

      NewStrategy : Common.STRATEGY;
      Temp_String : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   begin
      Ada.Text_IO.Put_Line("Requesting strategy for lap: " & Common.IntegerToString(INTEGER(lap)));
      StrategyHistory.Get_Strategy(NewStrategy,INTEGER(lap));
      Temp_String := Temp_String & Unbounded_String.To_Unbounded_String
        ("<?xml version=""1.0""?>" &
         Box_Data.BoxStrategyToXML(NewStrategy));
      return CORBA.To_CORBA_String(Unbounded_String.To_String(Temp_String));
      --return CORBA.To_CORBA_STRING("Merda");
   end RequestStrategy;

end BoxRadio.impl;
