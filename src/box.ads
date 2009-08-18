-- The Declaration of class Box
package Box is
	type PrivateComponent is tagged private;
	type BoxObject is tagged null record;
	type Pointer is access all BoxObject'Class;

private
	type PrivateComponent is tagged null record;

end Box;