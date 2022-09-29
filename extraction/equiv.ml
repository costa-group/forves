
type unit0 =
| Tt

(** val negb : bool -> bool **)

let negb = function
| true -> false
| false -> true

type nat =
| O
| S of nat

type 'a option =
| Some of 'a
| None

(** val length : 'a1 list -> nat **)

let rec length = function
| [] -> O
| _::l' -> S (length l')

(** val app : 'a1 list -> 'a1 list -> 'a1 list **)

let rec app l m =
  match l with
  | [] -> m
  | a::l1 -> a::(app l1 m)

type ('a, 'p) sigT =
| ExistT of 'a * 'p

(** val projT1 : ('a1, 'a2) sigT -> 'a1 **)

let projT1 = function
| ExistT (a, _) -> a

(** val projT2 : ('a1, 'a2) sigT -> 'a2 **)

let projT2 = function
| ExistT (_, h) -> h

(** val add : nat -> nat -> nat **)

let rec add n0 m =
  match n0 with
  | O -> m
  | S p -> S (add p m)

(** val sub : nat -> nat -> nat **)

let rec sub n0 m =
  match n0 with
  | O -> n0
  | S k -> (match m with
            | O -> n0
            | S l -> sub k l)

(** val eqb : nat -> nat -> bool **)

let rec eqb n0 m =
  match n0 with
  | O -> (match m with
          | O -> true
          | S _ -> false)
  | S n' -> (match m with
             | O -> false
             | S m' -> eqb n' m')

(** val leb : nat -> nat -> bool **)

let rec leb n0 m =
  match n0 with
  | O -> true
  | S n' -> (match m with
             | O -> false
             | S m' -> leb n' m')

(** val ltb : nat -> nat -> bool **)

let ltb n0 m =
  leb (S n0) m

(** val eqb0 : bool -> bool -> bool **)

let eqb0 b1 b2 =
  if b1 then b2 else if b2 then false else true

type positive =
| XI of positive
| XO of positive
| XH

type n =
| N0
| Npos of positive

module Pos =
 struct
  (** val succ : positive -> positive **)

  let rec succ = function
  | XI p -> XO (succ p)
  | XO p -> XI p
  | XH -> XO XH

  (** val add : positive -> positive -> positive **)

  let rec add x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> XO (add_carry p q)
       | XO q -> XI (add p q)
       | XH -> XO (succ p))
    | XO p ->
      (match y with
       | XI q -> XI (add p q)
       | XO q -> XO (add p q)
       | XH -> XI p)
    | XH -> (match y with
             | XI q -> XO (succ q)
             | XO q -> XI q
             | XH -> XO XH)

  (** val add_carry : positive -> positive -> positive **)

  and add_carry x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> XI (add_carry p q)
       | XO q -> XO (add_carry p q)
       | XH -> XI (succ p))
    | XO p ->
      (match y with
       | XI q -> XO (add_carry p q)
       | XO q -> XI (add p q)
       | XH -> XO (succ p))
    | XH ->
      (match y with
       | XI q -> XI (succ q)
       | XO q -> XO (succ q)
       | XH -> XI XH)

  (** val mul : positive -> positive -> positive **)

  let rec mul x y =
    match x with
    | XI p -> add y (XO (mul p y))
    | XO p -> XO (mul p y)
    | XH -> y
 end

module N =
 struct
  (** val succ : n -> n **)

  let succ = function
  | N0 -> Npos XH
  | Npos p -> Npos (Pos.succ p)

  (** val add : n -> n -> n **)

  let add n0 m =
    match n0 with
    | N0 -> m
    | Npos p -> (match m with
                 | N0 -> n0
                 | Npos q -> Npos (Pos.add p q))

  (** val mul : n -> n -> n **)

  let mul n0 m =
    match n0 with
    | N0 -> N0
    | Npos p -> (match m with
                 | N0 -> N0
                 | Npos q -> Npos (Pos.mul p q))
 end

(** val nth_error : 'a1 list -> nat -> 'a1 option **)

let rec nth_error l = function
| O -> (match l with
        | [] -> None
        | x::_ -> Some x)
| S n1 -> (match l with
           | [] -> None
           | _::l0 -> nth_error l0 n1)

(** val map : ('a1 -> 'a2) -> 'a1 list -> 'a2 list **)

let rec map f = function
| [] -> []
| a::t -> (f a)::(map f t)

(** val firstn : nat -> 'a1 list -> 'a1 list **)

let rec firstn n0 l =
  match n0 with
  | O -> []
  | S n1 -> (match l with
             | [] -> []
             | a::l0 -> a::(firstn n1 l0))

(** val skipn : nat -> 'a1 list -> 'a1 list **)

let rec skipn n0 l =
  match n0 with
  | O -> l
  | S n1 -> (match l with
             | [] -> []
             | _::l0 -> skipn n1 l0)

(** val seq : nat -> nat -> nat list **)

let rec seq start = function
| O -> []
| S len0 -> start::(seq (S start) len0)

type word =
| WO
| WS of bool * nat * word

(** val wordToN : nat -> word -> n **)

let rec wordToN _ = function
| WO -> N0
| WS (b, n0, w') ->
  if b
  then N.succ (N.mul (Npos (XO XH)) (wordToN n0 w'))
  else N.mul (Npos (XO XH)) (wordToN n0 w')

(** val wzero' : nat -> word **)

let rec wzero' = function
| O -> WO
| S sz' -> WS (false, sz', (wzero' sz'))

(** val posToWord : nat -> positive -> word **)

let rec posToWord sz p =
  match sz with
  | O -> WO
  | S sz' ->
    (match p with
     | XI p' -> WS (true, sz', (posToWord sz' p'))
     | XO p' -> WS (false, sz', (posToWord sz' p'))
     | XH -> WS (true, sz', (wzero' sz')))

(** val nToWord : nat -> n -> word **)

let nToWord sz = function
| N0 -> wzero' sz
| Npos p -> posToWord sz p

(** val whd : nat -> word -> bool **)

let whd _ = function
| WO -> Obj.magic Tt
| WS (b, _, _) -> b

(** val wtl : nat -> word -> word **)

let wtl _ = function
| WO -> Obj.magic Tt
| WS (_, _, w') -> w'

(** val weqb : nat -> word -> word -> bool **)

let rec weqb _ x x0 =
  match x with
  | WO -> true
  | WS (b, n0, x') ->
    if eqb0 b (whd n0 x0) then weqb n0 x' (wtl n0 x0) else false

(** val wordBin : (n -> n -> n) -> nat -> word -> word -> word **)

let wordBin f sz x y =
  nToWord sz (f (wordToN sz x) (wordToN sz y))

(** val wplus : nat -> word -> word -> word **)

let wplus =
  wordBin N.add

(** val wmult : nat -> word -> word -> word **)

let wmult =
  wordBin N.mul

(** val wnot : nat -> word -> word **)

let rec wnot _ = function
| WO -> WO
| WS (b, n0, w') -> WS ((negb b), n0, (wnot n0 w'))

module EVM_Def =
 struct
  (** val coq_WLen : nat **)

  let coq_WLen =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      O)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

  type coq_EVMWord = word

  (** val coq_StackLen : nat **)

  let coq_StackLen =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      O)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
 end

module Concrete =
 struct
  type gen_instr =
  | ADD
  | MUL
  | NOT

  type instr =
  | PUSH of nat * EVM_Def.coq_EVMWord
  | POP
  | DUP of nat
  | SWAP of nat
  | Opcode of gen_instr

  type prog = instr list

  type operator =
  | Op of bool * nat
     * (EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option)

  (** val eq_gen_instr : gen_instr -> gen_instr -> bool **)

  let eq_gen_instr a b =
    match a with
    | ADD -> (match b with
              | ADD -> true
              | _ -> false)
    | MUL -> (match b with
              | MUL -> true
              | _ -> false)
    | NOT -> (match b with
              | NOT -> true
              | _ -> false)

  (** val add : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let add = function
  | [] -> None
  | a::l ->
    (match l with
     | [] -> None
     | b::l0 ->
       (match l0 with
        | [] -> Some (wplus EVM_Def.coq_WLen a b)
        | _::_ -> None))

  (** val mul : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let mul = function
  | [] -> None
  | a::l ->
    (match l with
     | [] -> None
     | b::l0 ->
       (match l0 with
        | [] -> Some (wmult EVM_Def.coq_WLen a b)
        | _::_ -> None))

  (** val not : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let not = function
  | [] -> None
  | a::l -> (match l with
             | [] -> Some (wnot EVM_Def.coq_WLen a)
             | _::_ -> None)

  type ('k, 'v) map = 'k -> 'v option

  (** val empty_imap : (gen_instr, 'a1) map **)

  let empty_imap _ =
    None

  (** val updatei :
      (gen_instr, 'a1) map -> gen_instr -> 'a1 -> gen_instr -> 'a1 option **)

  let updatei m x v x' =
    if eq_gen_instr x x' then Some v else m x'

  type opm = (gen_instr, operator) map

  (** val opmap : opm **)

  let opmap =
    updatei
      (updatei (updatei empty_imap NOT (Op (false, (S O), not))) MUL (Op
        (true, (S (S O)), mul))) ADD (Op (true, (S (S O)), add))
 end

module Abstract =
 struct
  type asfs_stack_val =
  | Val of EVM_Def.coq_EVMWord
  | InStackVar of nat
  | FreshVar of nat

  type asfs_map_val =
  | ASFSBasicVal of asfs_stack_val
  | ASFSOp of Concrete.gen_instr * asfs_stack_val list

  type asfs_stack = asfs_stack_val list

  type asfs_map = (nat * asfs_map_val) list

  type asfs =
  | ASFSc of nat * nat * asfs_stack * asfs_map
 end

module Optimizations =
 struct
  type optimization = Abstract.asfs -> Abstract.asfs * bool
 end

(** val firstn_e : nat -> 'a1 list -> 'a1 list option **)

let firstn_e n0 l =
  if leb n0 (length l) then Some (firstn n0 l) else None

(** val skipn_e : nat -> 'a1 list -> 'a1 list option **)

let skipn_e n0 l =
  if leb n0 (length l) then Some (skipn n0 l) else None

module SFS =
 struct
  (** val push : 'a1 -> 'a1 list -> 'a1 list option **)

  let push v sk =
    if ltb (length sk) EVM_Def.coq_StackLen then Some (v::sk) else None

  (** val pop : 'a1 list -> 'a1 list option **)

  let pop = function
  | [] -> None
  | _::sk' -> Some sk'

  (** val dup : nat -> 'a1 list -> 'a1 list option **)

  let dup k sk =
    if if if eqb k O
          then true
          else ltb (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                 O)))))))))))))))) k
       then true
       else leb EVM_Def.coq_StackLen (length sk)
    then None
    else (match nth_error sk k with
          | Some x -> Some (x::sk)
          | None -> None)

  (** val swap : nat -> 'a1 list -> 'a1 list option **)

  let swap k sk =
    if if eqb k O
       then true
       else ltb (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
              O)))))))))))))))) k
    then None
    else let o = nth_error sk k in
         (match o with
          | Some v ->
            (match sk with
             | [] -> None
             | h::t ->
               Some
                 (app (v::[])
                   (app (firstn (sub k (S O)) t)
                     (app (h::[]) (skipn (add k (S O)) sk)))))
          | None -> None)

  (** val get_maxid_asfs : Abstract.asfs -> nat **)

  let get_maxid_asfs = function
  | Abstract.ASFSc (_, i, _, _) -> i

  (** val get_stack_asfs : Abstract.asfs -> Abstract.asfs_stack **)

  let get_stack_asfs = function
  | Abstract.ASFSc (_, _, s, _) -> s

  (** val get_map_asfs : Abstract.asfs -> Abstract.asfs_map **)

  let get_map_asfs = function
  | Abstract.ASFSc (_, _, _, m) -> m

  (** val set_maxid_asfs : Abstract.asfs -> nat -> Abstract.asfs **)

  let set_maxid_asfs a maxid' =
    let Abstract.ASFSc (h, _, s, m) = a in Abstract.ASFSc (h, maxid', s, m)

  (** val set_stack_asfs :
      Abstract.asfs -> Abstract.asfs_stack -> Abstract.asfs **)

  let set_stack_asfs a s' =
    let Abstract.ASFSc (h, maxid, _, m) = a in
    Abstract.ASFSc (h, maxid, s', m)

  (** val set_map_asfs :
      Abstract.asfs -> Abstract.asfs_map -> Abstract.asfs **)

  let set_map_asfs a m' =
    let Abstract.ASFSc (h, maxid, s, _) = a in
    Abstract.ASFSc (h, maxid, s, m')

  (** val gen_initial_stack : nat -> Abstract.asfs_stack_val list **)

  let gen_initial_stack size =
    let ids = seq O size in map (fun x -> Abstract.InStackVar x) ids

  (** val empty_asfs : nat -> Abstract.asfs **)

  let empty_asfs size =
    let s = gen_initial_stack size in Abstract.ASFSc (size, O, s, [])

  (** val asfs_map_add :
      Abstract.asfs_map -> nat -> Abstract.asfs_map_val -> Abstract.asfs_map **)

  let asfs_map_add m id a =
    (id , a)::m

  (** val add_val_asfs :
      Concrete.opm -> Abstract.asfs -> Abstract.asfs_map_val -> Abstract.asfs
      option **)

  let add_val_asfs _ a v =
    let m = get_map_asfs a in
    let s = get_stack_asfs a in
    let mid = get_maxid_asfs a in
    let m' = asfs_map_add m mid v in
    (match push (Abstract.FreshVar mid) s with
     | Some s' ->
       Some
         (set_stack_asfs (set_map_asfs (set_maxid_asfs a (add mid (S O))) m')
           s')
     | None -> None)

  (** val symbolic_exec'' :
      Concrete.instr -> Abstract.asfs -> Concrete.opm -> Abstract.asfs option **)

  let symbolic_exec'' ins a ops =
    let s = get_stack_asfs a in
    (match ins with
     | Concrete.PUSH (_, w) ->
       (match push (Abstract.Val w) s with
        | Some s' -> Some (set_stack_asfs a s')
        | None -> None)
     | Concrete.POP ->
       (match pop s with
        | Some s' -> Some (set_stack_asfs a s')
        | None -> None)
     | Concrete.DUP pos ->
       (match dup pos s with
        | Some s' -> Some (set_stack_asfs a s')
        | None -> None)
     | Concrete.SWAP pos ->
       (match swap pos s with
        | Some s' -> Some (set_stack_asfs a s')
        | None -> None)
     | Concrete.Opcode label ->
       (match ops label with
        | Some o ->
          let Concrete.Op (_, nargs, _) = o in
          (match firstn_e nargs s with
           | Some s1 ->
             (match skipn_e nargs s with
              | Some s2 ->
                let val0 = Abstract.ASFSOp (label, s1) in
                let a' = set_stack_asfs a s2 in add_val_asfs ops a' val0
              | None -> None)
           | None -> None)
        | None -> None))

  (** val symbolic_exec' :
      Concrete.prog -> Abstract.asfs -> Concrete.opm -> Abstract.asfs option **)

  let rec symbolic_exec' p a ops =
    match p with
    | [] -> Some a
    | ins::p' ->
      (match symbolic_exec'' ins a ops with
       | Some a' -> symbolic_exec' p' a' ops
       | None -> None)

  (** val symbolic_exec :
      Concrete.prog -> nat -> Concrete.opm -> Abstract.asfs option **)

  let symbolic_exec p height ops =
    let a = empty_asfs height in symbolic_exec' p a ops

  (** val is_comm_op : Concrete.gen_instr -> Concrete.opm -> bool **)

  let is_comm_op opcode ops =
    match ops opcode with
    | Some o -> let Concrete.Op (comm, _, _) = o in comm
    | None -> false

  (** val asfs_eq_stack_elem_func :
      (Abstract.asfs_stack_val, (Abstract.asfs_stack_val, (Abstract.asfs_map,
      (Abstract.asfs_map, Concrete.opm) sigT) sigT) sigT) sigT -> bool **)

  let rec asfs_eq_stack_elem_func x =
    let e1 = projT1 x in
    let e2 = projT1 (projT2 x) in
    let m1 = projT1 (projT2 (projT2 x)) in
    let m2 = projT1 (projT2 (projT2 (projT2 x))) in
    let ops = projT2 (projT2 (projT2 (projT2 x))) in
    let asfs_eq_stack_elem0 = fun e3 e4 m3 m4 ops0 ->
      asfs_eq_stack_elem_func (ExistT (e3, (ExistT (e4, (ExistT (m3, (ExistT
        (m4, ops0))))))))
    in
    (match e1 with
     | Abstract.Val v1 ->
       (match e2 with
        | Abstract.Val v2 -> weqb EVM_Def.coq_WLen v1 v2
        | _ -> false)
     | Abstract.InStackVar i1 ->
       (match e2 with
        | Abstract.InStackVar i2 -> eqb i1 i2
        | _ -> false)
     | Abstract.FreshVar i1 ->
       (match e2 with
        | Abstract.FreshVar i2 ->
          (match m1 with
           | [] -> false
           | p::rm1 ->
             let idx1 , mv1 = p in
             (match m2 with
              | [] -> false
              | p0::rm2 ->
                let idx2 , mv2 = p0 in
                if if eqb idx1 i1 then eqb idx2 i2 else false
                then (match mv1 with
                      | Abstract.ASFSBasicVal av1 ->
                        (match mv2 with
                         | Abstract.ASFSBasicVal av2 ->
                           asfs_eq_stack_elem0 av1 av2 rm1 rm2 ops
                         | Abstract.ASFSOp (_, _) -> false)
                      | Abstract.ASFSOp (opcode1, args1) ->
                        (match mv2 with
                         | Abstract.ASFSBasicVal _ -> false
                         | Abstract.ASFSOp (opcode2, args2) ->
                           if Concrete.eq_gen_instr opcode1 opcode2
                           then (match args1 with
                                 | [] ->
                                   (match args2 with
                                    | [] -> true
                                    | _::_ -> false)
                                 | a1::l ->
                                   (match l with
                                    | [] ->
                                      (match args2 with
                                       | [] -> false
                                       | b1::l0 ->
                                         (match l0 with
                                          | [] ->
                                            asfs_eq_stack_elem0 a1 b1 rm1 rm2
                                              ops
                                          | _::_ -> false))
                                    | a2::l0 ->
                                      (match l0 with
                                       | [] ->
                                         (match args2 with
                                          | [] -> false
                                          | b1::l1 ->
                                            (match l1 with
                                             | [] -> false
                                             | b2::l2 ->
                                               (match l2 with
                                                | [] ->
                                                  if if asfs_eq_stack_elem0
                                                          a1 b1 rm1 rm2 ops
                                                     then asfs_eq_stack_elem0
                                                            a2 b2 rm1 rm2 ops
                                                     else false
                                                  then true
                                                  else if if is_comm_op
                                                               opcode1 ops
                                                          then asfs_eq_stack_elem0
                                                                 a1 b2 rm1
                                                                 rm2 ops
                                                          else false
                                                       then asfs_eq_stack_elem0
                                                              a2 b1 rm1 rm2
                                                              ops
                                                       else false
                                                | _::_ -> false)))
                                       | _::_ -> false)))
                           else false))
                else if eqb idx1 i1
                     then asfs_eq_stack_elem0 e1 e2 m1 rm2 ops
                     else if eqb idx2 i2
                          then asfs_eq_stack_elem0 e1 e2 rm1 m2 ops
                          else false))
        | _ -> false))

  (** val asfs_eq_stack_elem :
      Abstract.asfs_stack_val -> Abstract.asfs_stack_val -> Abstract.asfs_map
      -> Abstract.asfs_map -> Concrete.opm -> bool **)

  let asfs_eq_stack_elem e1 e2 m1 m2 ops =
    asfs_eq_stack_elem_func (ExistT (e1, (ExistT (e2, (ExistT (m1, (ExistT
      (m2, ops))))))))

  (** val asfs_eq_stack :
      Abstract.asfs_stack -> Abstract.asfs_stack -> Abstract.asfs_map ->
      Abstract.asfs_map -> Concrete.opm -> bool **)

  let rec asfs_eq_stack s1 s2 m1 m2 ops =
    match s1 with
    | [] -> (match s2 with
             | [] -> true
             | _::_ -> false)
    | e1::r1 ->
      (match s2 with
       | [] -> false
       | e2::r2 ->
         if asfs_eq_stack_elem e1 e2 m1 m2 ops
         then asfs_eq_stack r1 r2 m1 m2 ops
         else false)

  (** val asfs_eq : Abstract.asfs -> Abstract.asfs -> Concrete.opm -> bool **)

  let asfs_eq a1 a2 ops =
    let Abstract.ASFSc (height1, _, curr_stack1, amap1) = a1 in
    let Abstract.ASFSc (height2, _, curr_stack2, amap2) = a2 in
    let eq_size = eqb height1 height2 in
    let eq_stack = asfs_eq_stack curr_stack1 curr_stack2 amap1 amap2 ops in
    if eq_size then eq_stack else false
 end

module Checker =
 struct
  (** val equiv_checker :
      Concrete.prog -> Concrete.prog -> nat -> Optimizations.optimization ->
      bool **)

  let equiv_checker p1 p2 height opt =
    match SFS.symbolic_exec p1 height Concrete.opmap with
    | Some sfs1 ->
      (match SFS.symbolic_exec p2 height Concrete.opmap with
       | Some sfs2 ->
         let sfs3 , _ = opt sfs2 in SFS.asfs_eq sfs1 sfs3 Concrete.opmap
       | None -> false)
    | None -> false
 end
