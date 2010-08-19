with System;
with Ada.Text_IO;
use Ada.Text_IO;
with Competition_Monitor;
package body supporto is
task body prova is
   begin
      Ada.Text_IO.Put_Line("TASK : faccio una getInfo su una cosa che ancora non esiste");
      Ada.Text_IO.Put_Line("TASK : getInfo ... \n"&Competition_Monitor.getInfo(0,2,1));
      Ada.Text_IO.Put_Line("TASK : fine esecuzione");
   end prova;
end supporto;
