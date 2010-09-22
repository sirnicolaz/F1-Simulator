with Common;

package Results is
   pragma Remote_Call_Interface;
   --  this pragma stipulates the subprograms in this unit
   --+ are RPC for which stubs (proxies) must be built
   --+ and copied to the caller side
   --+
   --+ none of the subprograms in this unit allows dispatching calls

   procedure Store
     (Divider : in Natural;
      Where   : in Common.Partition_ID);
   pragma Asynchronous (Store);
   --  pragma Asynchronous can be applied to remote subprograms directly
   --+ and not only to IN parameters

   procedure Load
     (Divider : out Natural;
      Where   : out Common.Partition_ID);

end Results;

