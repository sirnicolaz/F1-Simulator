with System;
with Ada.Text_IO;
use Ada.Text_IO;
with Competitor;
use Competitor;

procedure Main is
   Ferrari : CAR;
   EngineString : STRING(1..20);
begin
   EngineString := "Ferrari Engine      ";
   Set_Values(Ferrari, 310.10, 50.00 , 20.00 , EngineString);
   Put("Ferrari MaxSpeed = ");
   Put_Line(Float'Image(Get_MaxSpeed(Ferrari)));
   Put("Engine = " & Get_Engine(Ferrari));
   null;
end Main;
