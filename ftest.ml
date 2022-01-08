open Gfile
open Tools
open Fordfulk
open Printf

let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf
        "\n ✻  Usage: %s infile source sink outfile\n\n%s%!" Sys.argv.(0)
        ("    🟄  infile  : input file containing a graph\n" ^
         "    🟄  source  : identifier of the source vertex (used by the ford-fulkerson algorithm)\n" ^
         "    🟄  sink    : identifier of the sink vertex (ditto)\n" ^
         "    🟄  outfile : output file in which the result should be written.\n\n") ;
      exit 0
    end ;


  (* Arguments are : infile(1) source-id(2) sink-id(3) outfile(4) *)
  
  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(4)
  
  (* These command-line arguments are not used for the moment. *)
  and _source = int_of_string Sys.argv.(2)
  and _sink = int_of_string Sys.argv.(3)
  in

  (* FORD FULKERSON -------------- *)

    let graph_str_in = from_file infile in (* open graph *)
    let graph_int_in = gmap graph_str_in int_of_string in (* convert graph labels to int *)
    let graph_int_out = resolve_ff graph_int_in _source _sink in (* apply the ford fulkerson algorithm *)
    let graph_str_out = gmap graph_int_out string_of_int in (* convert the graph labels to string *)
    let () = write_file outfile graph_str_out in (* write graph in outfile *)
    let () = export graph_str_out (outfile ^ ".dot") in (* write graph in dot file *)

  (* ----------------------------- *)
  ()
;;