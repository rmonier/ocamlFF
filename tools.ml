open Graph

let clone_nodes (gr:'a graph) = n_fold gr new_node empty_graph ;;

let gmap gr f = 
    let gr2 = clone_nodes gr in
        let arcs gr id1 id2 label = new_arc gr id1 id2 (f label) in
        e_fold gr arcs gr2
;;

let add_arc (g: int graph) id1 id2 n = 
    match find_arc g id1 id2 with
    | Some x -> new_arc g id1 id2 (x + n)
    | None -> new_arc g id1 id2 n
;;