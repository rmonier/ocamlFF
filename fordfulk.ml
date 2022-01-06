
open Graph
open Tools


let init_graph (gr: int graph) =
    gmap gr (fun x -> 0)
;;

(*
let rec path (gr: int graph) src dest =
    let f (id, lbl) =
        if id <> dest ->
            match path gr id dest with:
            | Some x -> [(id, lbl)] :: x
            | None -> []
        else [(id, lbl)]
    in
    let arcs = out_arcs gr src in
        match arcs with:
        | [] -> None
        | hd :: rest when f hd <> [] -> Some (f hd)
        | _ :: hd :: rest -> path gr hd dest
;;
*)

(* reste une condition à tester : est cyclique (?) *)
let rec path (gr : int graph) src dest =
    let rec parcours_out_arcs gr src arcs =
        match arcs with
        | [] -> []
        | (id, _)::rst -> if id=dest then [src; id] else 
            (match parcours_out_arcs gr id (out_arcs gr id) with
            | [] -> parcours_out_arcs gr src rst
            | l -> src::l
        )
    in
    parcours_out_arcs gr src (out_arcs gr src)
;;
(*
let rec graph_from_path gr arcs =
    let rec aux gr arcs acu =
        match arcs with
        | [] -> acu
        | [hd] -> acu
        (*| [hd; sec] -> aux (new_arc acu hd sec 1) [] acu*)
        | hd::sec::tail -> aux (new_arc acu hd sec 1) (sec::tail) acu
    in
    aux gr arcs (clone_nodes gr)
;;
*)
let rec graph_from_path gr arcs =
    let gr2 = clone_nodes gr in
    match arcs with
    | [] -> gr2
    | [hd] -> gr2
    | [hd; sec] -> new_arc gr2 hd sec 1
    | hd::sec::tail -> graph_from_path (new_arc gr2 hd sec 1) (sec::tail)

;;
(*let resolve_ff (gr: int graph) id id (gr2: int graph) =

;;*)