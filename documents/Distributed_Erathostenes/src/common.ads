package Common is
   pragma Pure;

   Search_Limit : constant Positive := 50;
   -- we look at numbers from 2 onward
   subtype Search_Range is Positive range 2 .. Search_Limit;

   type Partition_ID is new Natural;
   --  as many partitions as set in configuration file erat_quater.cfg
   Partitions : constant := 4;

   type Pool_Type is abstract tagged limited private;
   --  the root of a remote derivation type must be defined
   --+ in a Pure package (i.e. one with no state)

   --  this is the abstract specification of the procedure
   --+ which must be implemented by all partitions
   --+ (which we achieve by simply copying the implementing unit
   --+ in each partition)
   --+ the RPC to which body will be dynamically bound to
   --+ one specific implementation instance in one specific partition
   procedure Sieve
     (Pool    : access Pool_Type;
      Number  : in     Natural) is abstract;

private

   type Pool_Type is abstract tagged limited null record;

end Common;
