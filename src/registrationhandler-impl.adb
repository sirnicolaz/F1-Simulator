package body RegistrationHandler.impl is

   procedure Join_Competition(Self : access Object;
                              CompetitorDescriptor_File : in CORBA.STRING;
                              BoxCorbaLOC : in CORBA.STRING;
                              MonitorCorbaLOC : out CORBA.STRING;
                              Competitor_ID : out CORBA.Short) is
   begin
      null;
   end Join_COmpetition;

   -- When the box joining request has been accepted, the box wait that
   --+ all the other participants join the competition. After that
   --+ it's possible to have all the information about the competition
   --+ (like the total number of competitors, that could be less
   --+ than the maximum number choosen at the beginning).

   function Wait_Ready(Self : access Object;
                       CompetitorID : CORBA.Short) return CORBA.String is
   begin
      return CORBA.To_CORBA_String("No configuration yet");
   end Wait_Ready;

end RegistrationHandler.impl;
