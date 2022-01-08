open Graph
open Tools

let init_graph (gr: int graph) =
    gmap gr (fun x -> 0)
;;

let rec path (gr : int graph) src dest =
    let rec parcours_out_arcs gr src arcs acu =
        match arcs with
        | [] -> acu
        | (id, lbl)::rst -> if id=dest && lbl > 0 then acu@[src; id] 
        else if not (List.mem id acu) && lbl > 0 then
            (match parcours_out_arcs gr id (out_arcs gr id) acu with
            | [] -> parcours_out_arcs gr src rst acu
            | l -> acu@[src]@l
        )
        else if lbl <= 0 then parcours_out_arcs gr src rst acu
        else []
    in
    parcours_out_arcs gr src (out_arcs gr src) []
;;

let rec find_augmentation (gr:int graph) path =
    let rec aux gr path acu =
        match path with
        | hd::sec::rst -> (match find_arc gr hd sec with
                            | Some x -> if acu == -1 || x < acu then aux gr (sec::rst) x
                            else aux gr (sec::rst) acu
                            | _ -> aux gr (sec::rst) acu)
        | _ -> acu
    in
    aux gr path (-1)
;;

(*let rec residual_graph c_gr path augm =
    let rec forward gr path x =
        match path with
        | hd::sec::rst -> residual_graph (add_arc gr hd sec (x)) (sec::rst) augm
        | _ -> gr
    in
    let rec backward gr path x =
        match List.rev path with
        | hd::sec::rst -> residual_graph (add_arc gr hd sec (-x)) (sec::rst) augm
        | _ -> gr
    in
    backward (forward c_gr path augm) path augm
;;*)

let residual_graph c_gr f_gr path =
    let rec forward c f path =
        match path with
        | hd::sec::rst -> (match find_arc f hd sec with
                            | Some x -> forward (add_arc c hd sec (-x)) f (sec::rst)
                            | _ -> c)
        | _ -> c        
    in
    let rec backward c f path =
        match path with
        | hd::sec::rst -> (match find_arc f hd sec with
                            | Some x -> backward (add_arc c sec hd x) f (sec::rst)
                            | _ -> c)
        | _ -> c
    in
    backward (forward c_gr f_gr path) f_gr path
;;

let empty_flow_graph (c_gr:int graph) =
    gmap c_gr (fun x -> 0)
;;

let rec update_flow f_gr path augm =
    match path with
    | hd::sec::rst -> if find_arc f_gr hd sec != None 
    then update_flow (add_arc f_gr hd sec augm) (sec::rst) augm
    else update_flow (add_arc f_gr sec hd (-augm)) (sec::rst) augm
    | _ -> f_gr
;;

(*
steps:
    - tant qu'il y a un chemin dans le graphe résiduel faire:
        - trouver le chemin
        - trouver la valeur min d'augmentation
        - ajouter les arcs au grave de flot (initialement vide)
        - mettre a jour le graphe de capacité/residuel
        
*)

let resolve_ff c_gr src snk =
    let rec aux gr fl src snk =
        let pathOfArcs = path gr src snk in
        match pathOfArcs with
        | [] -> fl
        | _ -> aux (residual_graph gr (update_flow fl pathOfArcs (find_augmentation gr pathOfArcs)) pathOfArcs) (update_flow fl pathOfArcs (find_augmentation gr pathOfArcs)) src snk
    in
    aux c_gr (empty_flow_graph c_gr) src snk
;;

(* FIXME: with functions above *)
(*
let resolve_ff gr_in src snk =
    let rec resolve_rec gr_in src snk =
        let p = path gr_in src snk in
        match p with
        | [] -> gr_in (* si plus de path on a fini, on renvoit le nouveau graphe *)
        | _ -> (* sinon on soustrait 1 à chaque label du path obtenu pour créer le graphe de sortie *)
            let gr_out = gr_in in
                e_iter gr_out (fun (e_in, e_out, lbl) ->
                    if List.mem e_in p && List.mem e_out (* FIXME: devrait etre le suivant direct *) && lbl > 0 then
                        add_arc gr_out e_in e_out (-1)
                    else
                        gr_out
                )
    in
    resolve_rec gr_in src snk 
;;
*)