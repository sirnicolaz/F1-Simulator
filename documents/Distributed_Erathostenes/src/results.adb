package body Results is

   --  Before testing a new number we have to wait until the analysis
   --+ of the current number has completed.
   --+ To this end we use a protected object (Keeper) and an entry Load to it
   --+ which becomes open when condition Returned holds True
   --+ The condition is asserted when procedure Store is executed
   --+ The procedure is executed by the partition that determines
   --+ the primarity of the current number.

   protected Keeper is
      entry Load
        (Divider : out Natural;
         Where   : out Common.Partition_ID);
      procedure Store
        (Divider : in Natural;
         Where   : in Common.Partition_ID);
   private
      Returned      : Boolean := False;
      Saved_Divider : Natural;
      Saved_Where   : Common.Partition_ID;
   end Keeper;

   protected body Keeper is
      entry Load
        (Divider : out Natural;
         Where   : out Common.Partition_ID) when Returned is
      begin
         Divider  := Saved_Divider;
         Where    := Saved_Where;
         Returned := False;
      end Load;
      --+------
      procedure Store
        (Divider : in Natural;
         Where   : in Common.Partition_ID) is
      begin
         Saved_Divider := Divider;
         Saved_Where   := Where;
         Returned      := True;
      end Store;
   end Keeper;

   --+-----------

   procedure Store
     (Divider : in Natural;
      Where   : in Common.Partition_ID) is
   begin
      Keeper.Store (Divider, Where);
   end Store;

   procedure Load
     (Divider : out Natural;
      Where   : out Common.Partition_ID) is
   begin
      Keeper.Load (Divider, Where);
   end Load;

end Results;

