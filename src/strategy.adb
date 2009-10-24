with Circuit;
use Circuit;
with Competitor;
use Competitor;
with Competitor;

with Ada.Calendar;
use Ada.Calendar;
with Ada.Real_Time;
use Ada.Real_Time;

package body Strategy is

   function evaluate(segm : SEGMENT;
                     driver : comp) return Ada.Calendar.TIME is

   begin
      --qua dentro va effettuata la valutazione della traiettoria migliore e calcolato il tempo di attraversamento
      -- da restituire poi a chi invoca questo metodo.
      --qua credo che vadano eseguite le operazioni per attraversare il tratto
	return Ada.Calendar.Clock; -- per far compilare
   end evaluate;


   function Get_pitstopGasolineLevel(str_In : STRATEGY) return INTEGER is
   begin
      return str_In.pitstopGasolineLevel;
   end Get_pitstopGasolineLevel;

   function Get_pitstopLaps(str_In : STRATEGY) return INTEGER is
   begin
      return str_In.pitstopLaps;
   end Get_pitstopLaps;

   function Get_pitstopCondition (str_In : STRATEGY) return BOOLEAN is
   begin
      return str_In.pitstopCondition;
   end Get_pitstopCondition;

   function Get_trim (str_In : STRATEGY) return INTEGER is
   begin
      return str_In.trim;
   end Get_trim;

   function Get_pitstop (str_In : STRATEGY) return BOOLEAN is
   begin
      return str_In.pitstop;
   end Get_pitstop;

   procedure Configure(Strategy_In : in out STRATEGY;
                       pitstopGasolineLevel_In : INTEGER;
                       pitstopLaps_In: INTEGER;
                       pitstopCondition_In : BOOLEAN;
                       trim_In : INTEGER;
                       pitstop_In : BOOLEAN) is
   begin
      Strategy_In.pitstopGasolineLevel :=  pitstopGasolineLevel_In;
      Strategy_In.pitstopLaps := pitstopLaps_In;
      Strategy_In.pitstopCondition := pitstopCondition_In;
      Strategy_In.trim := trim_In;
      Strategy_In.pitstop := pitstop_In;
   end Configure;
end Strategy;
