open Graph
open Tools

(*exception NoPath of string*)

val init_graph : int graph -> int graph

val path : int graph -> id -> id -> id list

val find_augmentation : int graph -> id list -> int

val residual_graph : int graph -> id list -> int -> int graph

val update_flow : int graph -> id list -> int -> int graph

(*val resolve_ff : a' graph -> id -> id -> a' graph*)
