with Controller;
with Results;
with Ada.Text_IO;

package body Primes is
   use Common;

   type Index is range 0 .. Common.Search_Limit;

   --  STATIC VARIABLES

   --  Sifter records the prime numbers known to this partition
   Sifter  : array (Index) of Natural;
   --  Tail is the index in Sifter of the latest prime inserted
   Tail    : Index := 0;
   --  Current points to the index in Sifter to begin testing againt Number
   --+ (we don't want to divide by 0)
   Current : Index := 1;

   --  Item records which number we are testing so as to reset Current
   --+ when a new number is to be tested against the values in Sifter
   Item     : Natural := 1;

   --  attribute 'Partition_ID of unit U returns an integer
   --+ which is the unique id that identifies the partition
   --+ on which unit U is located
   Self : Common.Partition_ID := Primes'Partition_ID;

   --  distributed objects for the current and next partition
   --+ (note that Pool_Access is a class-wide type)
   Own_Pool  : aliased My_Pool_Type;

   --  in order that mutiple instances of this unit may be identified
   --+ by the Main unit that invokes procedure Sieve we register
   --  the distributed object Own_Pool that belongs to the current partition
   --+ to the care of the Controller unit.
   --+ We do so by using a dynamically bound call dispatched according
   --+ to the value of its controlling parameter (Own_Pool'access)
   --+ which is of an access-to-class-wide type
   --+ (this statement is executed during the elaboration of the partition)
   Touch_Base   : constant Boolean := Controller.Register (Own_Pool'Access, Self);

   My_Neighbour    : Controller.Pool_Access := null;

   --  END STATIC VARIABLES

   procedure Initialize (Number: in Natural) is
      --  to gain visibility of the operator on Pool_Type
      use Controller;
   begin
      --  we reset Current in case we received a new Number to test
      if Item /= Number then
         Item := Number;
         Current := 1;
      end if;
      --  if we don't know yet we determine our neighbouring partition
      if My_Neighbour = null then
         My_Neighbour := Controller.Next (Self);
      end if;
   end Initialize;

   procedure Sieve
     (Pool     : access My_Pool_Type;
      Number   : in Natural) is
   begin
      Initialize (Number);
      --  we check whether there is any other prime in Sifter to test againt Number
      if Current <= Tail then
         if (Number mod Sifter (Current)) = 0 then
            --  since the current divisor divides Number
            --+ we record it in Store
	    Results.Store (Sifter (Current), Self);
            Ada.Text_IO.Put_Line 
              ("Partition " 
               & Partition_ID'Image (Self) 
               & " stored "
               & Natural'Image (Sifter (Current))
               & " at position "
               & Index'Image (Current));
         else
            --  we ask our neighbour partition to continue checking
            --+ Number against its own current divisor
            --+ by making a dynamically-bound RPC to that partition
            Sieve (My_Neighbour, Number);
            --  as the inquiry can return back to this partition 
            --+ we must increment Current so that we can progress
            --+ our search
            Current := Current + 1;
         end if;
      else
         --  at the first invocation of Sieve in the partition
         --+ Number is certainly a prime
         --+ otherwise when the call to Sieve has returned back to this partition
         --+ and we have no divisor for Number hence it is a prime
         --+ so we add it to Sifter and record it in Store
	 Tail := Tail + 1;
         Sifter (Tail) := Number;
	 Results.Store (Sifter (Current), Self);
         Ada.Text_IO.Put_Line 
           ("Partition " 
            & Partition_ID'Image (Self) 
            & " stored "
            & Natural'Image (Sifter (Current))
            & " at position "
            & Index'Image (Current));
      end if;
   end Sieve;

end Primes;
