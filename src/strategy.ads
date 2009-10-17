with Circuit;
use Circuit;
with Competitor;
use Competitor;
with Competitor;

with Ada.Calendar;
use Ada.Calendar;
with Ada.Real_Time;
use Ada.Real_Time;

package Strategy is
   subtype comp is Competitor.CAR;
   function evaluate(segm : SEGMENT;
                     driver : comp) return Ada.Calendar.TIME;
   procedure Configure (Strategy_In : in out STRATEGY;
                        pitstopGasolineLevel_In : INTEGER;
                        pitstopLaps_In: INTEGER;
                        str.pitstopCondition_In : BOOLEAN;
                        str.trim_In : INTEGER;
                        str.pitstop_In : BOOLEAN);
   type STRATEGY is
      record
         pitstopGasolineLevel : INTEGER;
         pitstopLaps : INTEGER;
         pitstopCondition : BOOLEAN; -- correggere il tipo
         trim : INTEGER; -- correggere il tipo
         pitstop : BOOLEAN;
      end record;


end Strategy;
