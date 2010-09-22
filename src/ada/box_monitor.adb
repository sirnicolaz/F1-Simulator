package body Box_Monitor is

   Buffer : Box_Data.SYNCH_ALL_INFO_BUFFER_POINT;

   procedure Init( CompetitionUpdates_Buffer : Box_Data.SYNCH_ALL_INFO_BUFFER_POINT ) is
   begin
      Buffer := CompetitionUpdates_Buffer;
   end Init;

   procedure GetUpdate(Num : in INTEGER;
                       Time : out FLOAT;
                       PathLength : out FLOAT;
                       Returns : out Unbounded_String.Unbounded_String)
   is

      NewInfo : Box_Data.ALL_INFO;
      Temp_String : Unbounded_String.Unbounded_String;
   begin
      -- Add the new strategy somewhere

      -- The NewInfo is initialised to 1 for construction constraints.
      --+ The get update method will "update" the variable to the right value.
      Buffer.Get_Info(Num  => num,
                      Info => NewInfo);
      Temp_String :=
        Unbounded_String.To_Unbounded_String("<?xml version=""1.0""?><update>") &
      Box_Data.Get_Update_XML(NewInfo) & Box_Data.Get_Strategy_XML(NewInfo) &
      Unbounded_String.To_Unbounded_String("</update>");
      Returns := Temp_String;
      Time := Box_Data.Get_Time(NewInfo);
      PathLength := Box_Data.Get_Metres(NewInfo);

   end GetUpdate;

end Box_Monitor;
