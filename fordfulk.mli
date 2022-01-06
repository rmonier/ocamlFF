open Graph
open Tools

(*exception NoPath of string*)

val init_graph : int graph -> int graph

val path : int graph -> id -> id -> id list

val graph_from_path : int graph -> id list -> int graph

(*val resolve_ff : a' graph -> id -> id -> a' graph*)
