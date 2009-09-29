with Circuit;
use Circuit;
with Ada.Calendar;
package Strategy is
   type STRATEGY is private
      record
         pitstopGasolineLevel := INTEGER;
         pitstopLaps := INTEGER;
         pitstopCondition := BOOLEAN; -- correggere il tipo
         trim := INTEGER; -- correggere il tipo
         pitstop := BOOLEAN;
      end record;
      function evaluate(segm : SEGMENT) return TIME;
end Strategy
