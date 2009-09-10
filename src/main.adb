with System;
with Ada.Text_IO;
use Ada.Text_IO;
with Competitor;
use Competitor;
with Circuit;
use Circuit;

procedure Main is
   Ferrari : CAR;
   EngineString : STRING(1..20);
   Segment_1 : SEGMENT(3);
   Path_1_1 : PATH;
begin
   --EngineString := "Ferrari Engine      ";
   --Set_Values(Ferrari, 310.10, 50.00 , 20.00 , EngineString);
   --Put("Ferrari MaxSpeed = ");
   --Put_Line(Float'Image(Get_MaxSpeed(Ferrari)));
   --Put("Engine = " & Get_Engine(Ferrari));

   Set_Values(Segment_1,1,FALSE,42.00);
   Path_1_1 := Get_Path(Segment_1,1);
   Put_Line("Path 1 in Segment 1 has length = " & Float'Image(Get_Length(Path_1_1)));
   null;
end Main;
