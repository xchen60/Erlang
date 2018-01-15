

-type envType() :: dict:dict(atom(),valType()).
-type expType() :: tuple().

-type numValType() :: { num, integer() }.
-type boolValType() :: { bool, boolean() }.
-type procValType() :: { proc, atom(), expType(), envType()}.
-type valType() :: numValType() | boolValType() | procValType().


