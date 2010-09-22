with Common;

package Primes is

   --  this package contains a remote type, which can be
   --+ used to create dynamically-bound calls dispatched
   --+ in accord with the remote access-to-class-wide type
   --+ of their controlling parameter
   pragma Remote_Types;

   type My_Pool_Type is new Common.Pool_Type with null record;

   --  this is a dynamically bound dispatching call
   --+ which any concrete specialization of Pool_Type must realize
   procedure Sieve
     (Pool    : access My_Pool_Type;
      Number  : in     Natural);

end Primes;
