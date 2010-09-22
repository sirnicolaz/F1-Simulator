with Common;

package Controller is
   pragma Remote_Call_Interface;
   --  this pragma turns the subprograms in this unit
   --+ into RPC for which stubs (proxies) will be built
   --+ and copied to the caller's side

   type Pool_Access is access all Common.Pool_Type'Class;
   --  a remote access-to-class-wide type used to construct
   --+ dynamically-bound dispatching calls (which are all those
   --+ that have a controlling parameter of a type in the derivation
   --+ hierarchy of this type)
   pragma Asynchronous (Pool_Access);
   --  pragma Asynchronous is valid only in an RCI package
   --+ hence it cannot be applied to Sieve in package Common or Primes
   --+ when we apply pragma Asynchronous to Pool_Access
   --+ all subprograms that dispatch on Pool_Type'Class and have only
   --+ 'in'-mode parameters become asynchronous RPC

   --  a dynamically-bound dispatching subprogram
   function Register
     (Pool : Pool_Access;
      PID  : Common.Partition_ID)
      return Boolean;

   function  Next
     (PID : Common.Partition_ID)
      return Pool_Access;

end Controller;
