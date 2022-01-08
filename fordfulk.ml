open Graph
open Tools

let init_graph (gr: int graph) =
    gmap gr (fun x -> 0)
;;

let rec path (gr : int graph) src dest =
    let rec parcours_out_arcs gr src arcs chemin visited =
        match arcs with
        | [] -> chemin
        | (id, lbl)::rst ->
            if id=dest && lbl > 0 then
                (chemin@[src])@[id]
            else if not (List.mem id visited) && lbl > 0 then (
                match parcours_out_arcs gr id (out_arcs gr id) chemin (visited@[id]) with
                | [] -> parcours_out_arcs gr src rst chemin (visited@[id])
                | l -> (chemin@[src])@l
            ) else if lbl > 0 then (
                parcours_out_arcs gr src rst chemin visited
            ) else
                parcours_out_arcs gr src rst chemin visited
    in
    parcours_out_arcs gr src (out_arcs gr src) [] []
;;

let rec find_augmentation (gr:int graph) path =
    let rec aux gr path acu =
        match path with
        | hd::sec::rst -> (
            match find_arc gr hd sec with
            | Some x ->
                if acu == -1 || x < acu then
                    aux gr (sec::rst) x
                else
                    aux gr (sec::rst) acu
            | _ -> aux gr (sec::rst) acu
        )
        | _ -> acu
    in
    aux gr path (-1)
;;

(* on parcours les nodes dans path, et on applique la différence des arcs du graphe de capacité et du graphe de flot sur les arcs *)
let residual_graph c_gr f_gr path =
    (* on met à jour les arcs du graphe avec les capacités résiduelles (augmentation) *)
    let rec forward c f path =
        match path with
        | hd::sec::rst -> (
            match find_arc f hd sec with
            | Some x -> forward (add_arc c hd sec (-x)) f (sec::rst)
            | _ -> c
        )
        | _ -> c        
    in
    (* on met à jour les arcs du graphe avec les capacités résiduelles dans l'autre sens (diminution) *)
    let rec backward c f path =
        match path with
        | hd::sec::rst -> (
            match find_arc f hd sec with
            | Some x -> backward (add_arc c sec hd x) f (sec::rst)
            | _ -> c
        )
        | _ -> c
    in
    let () = Printf.printf "residual_graph called\n" in
    backward (forward c_gr f_gr path) f_gr path
;;

let empty_flow_graph (c_gr:int graph) =
    gmap c_gr (fun x -> 0)
;;

(* ajoute les valeurs d'augmention et diminution au graphe de flow *)
let rec update_flow f_gr path augm =
    (*let () = List.iter (Printf.printf "path: %d\n") path in*)
    match path with
    | hd::sec::rst -> (
        if find_arc f_gr hd sec <> None then
            update_flow (add_arc f_gr hd sec augm) (sec::rst) augm
        else
            update_flow (add_arc f_gr sec hd (-augm)) (sec::rst) augm
    )
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
        let pathOfArcs = path gr src snk in (
            let () = List.iter (Printf.printf "path:%d\n") pathOfArcs in
            match pathOfArcs with
            | [] -> fl (* si plus de path on a fini, on renvoit le nouveau graphe *)
            | _ -> (* sinon on soustrait le minimum à chaque label du path obtenu pour créer le graphe de sortie *)
                let augm = find_augmentation gr pathOfArcs in
                let () = Printf.printf "augm=%d\n" augm in
                let fl_gr = update_flow fl pathOfArcs augm in
                aux (residual_graph gr fl_gr pathOfArcs) fl_gr src snk
        )
    in
    aux c_gr (empty_flow_graph c_gr) src snk
;;