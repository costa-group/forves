
type unit0 =
| Tt

(** val xorb : bool -> bool -> bool **)

let xorb b1 b2 =
  if b1 then if b2 then false else true else b2

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

(** val fst : ('a1 * 'a2) -> 'a1 **)

let fst = function
| x , _ -> x

(** val length : 'a1 list -> nat **)

let rec length = function
| [] -> O
| _::l' -> S (length l')

(** val app : 'a1 list -> 'a1 list -> 'a1 list **)

let rec app l m =
  match l with
  | [] -> m
  | a::l1 -> a::(app l1 m)

type comparison =
| Eq
| Lt
| Gt

(** val id : 'a1 -> 'a1 **)

let id x =
  x

type uint =
| Nil
| D0 of uint
| D1 of uint
| D2 of uint
| D3 of uint
| D4 of uint
| D5 of uint
| D6 of uint
| D7 of uint
| D8 of uint
| D9 of uint
| Da of uint
| Db of uint
| Dc of uint
| Dd of uint
| De of uint
| Df of uint

(** val pred : nat -> nat **)

let pred n0 = match n0 with
| O -> n0
| S u -> u

module Coq__1 = struct
 (** val add : nat -> nat -> nat **)
 let rec add n0 m =
   match n0 with
   | O -> m
   | S p -> S (add p m)
end
include Coq__1

(** val mul : nat -> nat -> nat **)

let rec mul n0 m =
  match n0 with
  | O -> O
  | S p -> add m (mul p m)

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

module Nat =
 struct
  (** val add : nat -> nat -> nat **)

  let rec add n0 m =
    match n0 with
    | O -> m
    | S p -> S (add p m)

  (** val leb : nat -> nat -> bool **)

  let rec leb n0 m =
    match n0 with
    | O -> true
    | S n' -> (match m with
               | O -> false
               | S m' -> leb n' m')

  (** val div2 : nat -> nat **)

  let rec div2 = function
  | O -> O
  | S n1 -> (match n1 with
             | O -> O
             | S n' -> S (div2 n'))
 end

type positive =
| XI of positive
| XO of positive
| XH

type n =
| N0
| Npos of positive

module Pos =
 struct
  type mask =
  | IsNul
  | IsPos of positive
  | IsNeg
 end

module Coq_Pos =
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
    | XH -> (match y with
             | XI q -> XI (succ q)
             | XO q -> XO (succ q)
             | XH -> XI XH)

  (** val pred_double : positive -> positive **)

  let rec pred_double = function
  | XI p -> XI (XO p)
  | XO p -> XI (pred_double p)
  | XH -> XH

  type mask = Pos.mask =
  | IsNul
  | IsPos of positive
  | IsNeg

  (** val succ_double_mask : mask -> mask **)

  let succ_double_mask = function
  | IsNul -> IsPos XH
  | IsPos p -> IsPos (XI p)
  | IsNeg -> IsNeg

  (** val double_mask : mask -> mask **)

  let double_mask = function
  | IsPos p -> IsPos (XO p)
  | x0 -> x0

  (** val double_pred_mask : positive -> mask **)

  let double_pred_mask = function
  | XI p -> IsPos (XO (XO p))
  | XO p -> IsPos (XO (pred_double p))
  | XH -> IsNul

  (** val sub_mask : positive -> positive -> mask **)

  let rec sub_mask x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> double_mask (sub_mask p q)
       | XO q -> succ_double_mask (sub_mask p q)
       | XH -> IsPos (XO p))
    | XO p ->
      (match y with
       | XI q -> succ_double_mask (sub_mask_carry p q)
       | XO q -> double_mask (sub_mask p q)
       | XH -> IsPos (pred_double p))
    | XH -> (match y with
             | XH -> IsNul
             | _ -> IsNeg)

  (** val sub_mask_carry : positive -> positive -> mask **)

  and sub_mask_carry x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> succ_double_mask (sub_mask_carry p q)
       | XO q -> double_mask (sub_mask p q)
       | XH -> IsPos (pred_double p))
    | XO p ->
      (match y with
       | XI q -> double_mask (sub_mask_carry p q)
       | XO q -> succ_double_mask (sub_mask_carry p q)
       | XH -> double_pred_mask p)
    | XH -> IsNeg

  (** val mul : positive -> positive -> positive **)

  let rec mul x y =
    match x with
    | XI p -> add y (XO (mul p y))
    | XO p -> XO (mul p y)
    | XH -> y

  (** val iter : ('a1 -> 'a1) -> 'a1 -> positive -> 'a1 **)

  let rec iter f x = function
  | XI n' -> f (iter f (iter f x n') n')
  | XO n' -> iter f (iter f x n') n'
  | XH -> f x

  (** val pow : positive -> positive -> positive **)

  let pow x =
    iter (mul x) XH

  (** val compare_cont : comparison -> positive -> positive -> comparison **)

  let rec compare_cont r x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> compare_cont r p q
       | XO q -> compare_cont Gt p q
       | XH -> Gt)
    | XO p ->
      (match y with
       | XI q -> compare_cont Lt p q
       | XO q -> compare_cont r p q
       | XH -> Gt)
    | XH -> (match y with
             | XH -> r
             | _ -> Lt)

  (** val compare : positive -> positive -> comparison **)

  let compare =
    compare_cont Eq

  (** val eqb : positive -> positive -> bool **)

  let rec eqb p q =
    match p with
    | XI p0 -> (match q with
                | XI q0 -> eqb p0 q0
                | _ -> false)
    | XO p0 -> (match q with
                | XO q0 -> eqb p0 q0
                | _ -> false)
    | XH -> (match q with
             | XH -> true
             | _ -> false)

  (** val iter_op : ('a1 -> 'a1 -> 'a1) -> positive -> 'a1 -> 'a1 **)

  let rec iter_op op p a =
    match p with
    | XI p0 -> op a (iter_op op p0 (op a a))
    | XO p0 -> iter_op op p0 (op a a)
    | XH -> a

  (** val to_nat : positive -> nat **)

  let to_nat x =
    iter_op Coq__1.add x (S O)
 end

module N =
 struct
  (** val succ_double : n -> n **)

  let succ_double = function
  | N0 -> Npos XH
  | Npos p -> Npos (XI p)

  (** val double : n -> n **)

  let double = function
  | N0 -> N0
  | Npos p -> Npos (XO p)

  (** val succ : n -> n **)

  let succ = function
  | N0 -> Npos XH
  | Npos p -> Npos (Coq_Pos.succ p)

  (** val add : n -> n -> n **)

  let add n0 m =
    match n0 with
    | N0 -> m
    | Npos p -> (match m with
                 | N0 -> n0
                 | Npos q -> Npos (Coq_Pos.add p q))

  (** val sub : n -> n -> n **)

  let sub n0 m =
    match n0 with
    | N0 -> N0
    | Npos n' ->
      (match m with
       | N0 -> n0
       | Npos m' ->
         (match Coq_Pos.sub_mask n' m' with
          | Coq_Pos.IsPos p -> Npos p
          | _ -> N0))

  (** val mul : n -> n -> n **)

  let mul n0 m =
    match n0 with
    | N0 -> N0
    | Npos p -> (match m with
                 | N0 -> N0
                 | Npos q -> Npos (Coq_Pos.mul p q))

  (** val compare : n -> n -> comparison **)

  let compare n0 m =
    match n0 with
    | N0 -> (match m with
             | N0 -> Eq
             | Npos _ -> Lt)
    | Npos n' -> (match m with
                  | N0 -> Gt
                  | Npos m' -> Coq_Pos.compare n' m')

  (** val eqb : n -> n -> bool **)

  let eqb n0 m =
    match n0 with
    | N0 -> (match m with
             | N0 -> true
             | Npos _ -> false)
    | Npos p -> (match m with
                 | N0 -> false
                 | Npos q -> Coq_Pos.eqb p q)

  (** val leb : n -> n -> bool **)

  let leb x y =
    match compare x y with
    | Gt -> false
    | _ -> true

  (** val pow : n -> n -> n **)

  let pow n0 = function
  | N0 -> Npos XH
  | Npos p0 -> (match n0 with
                | N0 -> N0
                | Npos q -> Npos (Coq_Pos.pow q p0))

  (** val pos_div_eucl : positive -> n -> n * n **)

  let rec pos_div_eucl a b =
    match a with
    | XI a' ->
      let q , r = pos_div_eucl a' b in
      let r' = succ_double r in
      if leb b r' then (succ_double q) , (sub r' b) else (double q) , r'
    | XO a' ->
      let q , r = pos_div_eucl a' b in
      let r' = double r in
      if leb b r' then (succ_double q) , (sub r' b) else (double q) , r'
    | XH ->
      (match b with
       | N0 -> N0 , (Npos XH)
       | Npos p -> (match p with
                    | XH -> (Npos XH) , N0
                    | _ -> N0 , (Npos XH)))

  (** val div_eucl : n -> n -> n * n **)

  let div_eucl a b =
    match a with
    | N0 -> N0 , N0
    | Npos na -> (match b with
                  | N0 -> N0 , a
                  | Npos _ -> pos_div_eucl na b)

  (** val div : n -> n -> n **)

  let div a b =
    fst (div_eucl a b)

  (** val to_nat : n -> nat **)

  let to_nat = function
  | N0 -> O
  | Npos p -> Coq_Pos.to_nat p
 end

(** val nth_error : 'a1 list -> nat -> 'a1 option **)

let rec nth_error l = function
| O -> (match l with
        | [] -> None
        | x::_ -> Some x)
| S n1 -> (match l with
           | [] -> None
           | _::l0 -> nth_error l0 n1)

(** val rev : 'a1 list -> 'a1 list **)

let rec rev = function
| [] -> []
| x::l' -> app (rev l') (x::[])

(** val map : ('a1 -> 'a2) -> 'a1 list -> 'a2 list **)

let rec map f = function
| [] -> []
| a::t -> (f a)::(map f t)

(** val fold_right : ('a2 -> 'a1 -> 'a1) -> 'a1 -> 'a2 list -> 'a1 **)

let rec fold_right f a0 = function
| [] -> a0
| b::t -> f b (fold_right f a0 t)

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

(** val n_of_digits : bool list -> n **)

let rec n_of_digits = function
| [] -> N0
| b::l' ->
  N.add (if b then Npos XH else N0) (N.mul (Npos (XO XH)) (n_of_digits l'))

(** val n_of_ascii : char -> n **)

let n_of_ascii a =
  (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
    (fun a0 a1 a2 a3 a4 a5 a6 a7 ->
    n_of_digits (a0::(a1::(a2::(a3::(a4::(a5::(a6::(a7::[])))))))))
    a

(** val nat_of_ascii : char -> nat **)

let nat_of_ascii a =
  N.to_nat (n_of_ascii a)

(** val mod2 : nat -> bool **)

let rec mod2 = function
| O -> false
| S n1 -> (match n1 with
           | O -> true
           | S n' -> mod2 n')

(** val npow2 : nat -> n **)

let rec npow2 = function
| O -> Npos XH
| S n' -> N.mul (Npos (XO XH)) (npow2 n')

(** val nat_cast : nat -> nat -> 'a1 -> 'a1 **)

let rec nat_cast n0 m x =
  match n0 with
  | O -> (match m with
          | O -> id x
          | S _ -> assert false (* absurd case *))
  | S n1 ->
    (match m with
     | O -> assert false (* absurd case *)
     | S m0 -> nat_cast n1 m0 x)

type word =
| WO
| WS of bool * nat * word

(** val wordToNat : nat -> word -> nat **)

let rec wordToNat _ = function
| WO -> O
| WS (b, n0, w') ->
  if b
  then S (mul (wordToNat n0 w') (S (S O)))
  else mul (wordToNat n0 w') (S (S O))

(** val natToWord : nat -> nat -> word **)

let rec natToWord sz n0 =
  match sz with
  | O -> WO
  | S sz' -> WS ((mod2 n0), sz', (natToWord sz' (Nat.div2 n0)))

(** val wordToN : nat -> word -> n **)

let rec wordToN _ = function
| WO -> N0
| WS (b, n0, w') ->
  if b
  then N.succ (N.mul (Npos (XO XH)) (wordToN n0 w'))
  else N.mul (Npos (XO XH)) (wordToN n0 w')

(** val wzero : nat -> word **)

let wzero sz =
  natToWord sz O

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

(** val combine : nat -> word -> nat -> word -> word **)

let rec combine _ w sz2 w' =
  match w with
  | WO -> w'
  | WS (b, n0, w'0) -> WS (b, (add n0 sz2), (combine n0 w'0 sz2 w'))

(** val split1 : nat -> nat -> word -> word **)

let rec split1 sz1 sz2 x =
  match sz1 with
  | O -> WO
  | S sz1' ->
    WS
      ((whd
         (let rec add0 n0 m =
            match n0 with
            | O -> m
            | S p -> S (add0 p m)
          in add0 sz1' sz2) x), sz1',
      (split1 sz1' sz2
        (wtl
          (let rec add0 n0 m =
             match n0 with
             | O -> m
             | S p -> S (add0 p m)
           in add0 sz1' sz2) x)))

(** val split2 : nat -> nat -> word -> word **)

let rec split2 sz1 sz2 w =
  match sz1 with
  | O -> w
  | S sz1' ->
    split2 sz1' sz2
      (wtl
        (let rec add0 n0 m =
           match n0 with
           | O -> m
           | S p -> S (add0 p m)
         in add0 sz1' sz2) w)

(** val wneg : nat -> word -> word **)

let wneg sz x =
  nToWord sz (N.sub (npow2 sz) (wordToN sz x))

(** val wordBin : (n -> n -> n) -> nat -> word -> word -> word **)

let wordBin f sz x y =
  nToWord sz (f (wordToN sz x) (wordToN sz y))

(** val wplus : nat -> word -> word -> word **)

let wplus =
  wordBin N.add

(** val wmult : nat -> word -> word -> word **)

let wmult =
  wordBin N.mul

(** val wdiv : nat -> word -> word -> word **)

let wdiv =
  wordBin N.div

(** val wminus : nat -> word -> word -> word **)

let wminus sz x y =
  wplus sz x (wneg sz y)

(** val wnot : nat -> word -> word **)

let rec wnot _ = function
| WO -> WO
| WS (b, n0, w') -> WS ((negb b), n0, (wnot n0 w'))

(** val bitwp : (bool -> bool -> bool) -> nat -> word -> word -> word **)

let rec bitwp f _ w1 x =
  match w1 with
  | WO -> WO
  | WS (b, n0, w1') -> WS ((f b (whd n0 x)), n0, (bitwp f n0 w1' (wtl n0 x)))

(** val wor : nat -> word -> word -> word **)

let wor =
  bitwp (fun b1 b2 -> if b1 then true else b2)

(** val wand : nat -> word -> word -> word **)

let wand =
  bitwp (fun b1 b2 -> if b1 then b2 else false)

(** val wxor : nat -> word -> word -> word **)

let wxor =
  bitwp xorb

(** val wlshift' : nat -> word -> nat -> word **)

let wlshift' sz w n0 =
  split1 sz n0
    (nat_cast (Nat.add n0 sz) (add sz n0) (combine n0 (wzero n0) sz w))

(** val wrshift' : nat -> word -> nat -> word **)

let wrshift' sz w n0 =
  split2 n0 sz
    (nat_cast (Nat.add sz n0) (add n0 sz) (combine sz w n0 (wzero n0)))

module EVM_Def =
 struct
  (** val coq_WLen : nat **)

  let coq_WLen =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S
      O)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

  type coq_EVMWord = word

  (** val coq_StackLen : nat **)

  let coq_StackLen =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      O)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

  (** val coq_WZero : coq_EVMWord **)

  let coq_WZero =
    natToWord coq_WLen O

  (** val coq_WOne : coq_EVMWord **)

  let coq_WOne =
    natToWord coq_WLen (S O)
 end

module Concrete =
 struct
  type oper_label =
  | ADD
  | MUL
  | NOT
  | SUB
  | DIV
  | SDIV
  | MOD
  | SMOD
  | ADDMOD
  | MULMOD
  | EXP
  | SIGNEXTEND
  | LT
  | GT
  | SLT
  | SGT
  | EQ
  | ISZERO
  | AND
  | OR
  | XOR
  | BYTE
  | SHL
  | SHR
  | SAR
  | SHA3
  | KECCAK256
  | ADDRESS
  | BALANCE
  | ORIGIN
  | CALLER
  | CALLVALUE
  | CALLDATALOAD
  | CALLDATASIZE
  | CODESIZE
  | GASPRICE
  | EXTCODESIZE
  | RETURNDATASIZE
  | EXTCODEHASH
  | BLOCKHASH
  | COINBASE
  | TIMESTAMP
  | NUMBER
  | DIFFICULTY
  | GASLIMIT
  | CHAINID
  | SELFBALANCE
  | BASEFEE
  | SLOAD
  | MLOAD
  | PC
  | MSIZE
  | GAS
  | CREATE
  | CREATE2

  type instr =
  | PUSH of nat * EVM_Def.coq_EVMWord
  | POP
  | DUP of nat
  | SWAP of nat
  | Opcode of oper_label

  type block = instr list

  type operator =
  | Op of bool * nat * (EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option)

  (** val eq_oper_label : oper_label -> oper_label -> bool **)

  let eq_oper_label a b =
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
    | SUB -> (match b with
              | SUB -> true
              | _ -> false)
    | DIV -> (match b with
              | DIV -> true
              | _ -> false)
    | SDIV -> (match b with
               | SDIV -> true
               | _ -> false)
    | MOD -> (match b with
              | MOD -> true
              | _ -> false)
    | SMOD -> (match b with
               | SMOD -> true
               | _ -> false)
    | ADDMOD -> (match b with
                 | ADDMOD -> true
                 | _ -> false)
    | MULMOD -> (match b with
                 | MULMOD -> true
                 | _ -> false)
    | EXP -> (match b with
              | EXP -> true
              | _ -> false)
    | SIGNEXTEND -> (match b with
                     | SIGNEXTEND -> true
                     | _ -> false)
    | LT -> (match b with
             | LT -> true
             | _ -> false)
    | GT -> (match b with
             | GT -> true
             | _ -> false)
    | SLT -> (match b with
              | SLT -> true
              | _ -> false)
    | SGT -> (match b with
              | SGT -> true
              | _ -> false)
    | EQ -> (match b with
             | EQ -> true
             | _ -> false)
    | ISZERO -> (match b with
                 | ISZERO -> true
                 | _ -> false)
    | AND -> (match b with
              | AND -> true
              | _ -> false)
    | OR -> (match b with
             | OR -> true
             | _ -> false)
    | XOR -> (match b with
              | XOR -> true
              | _ -> false)
    | BYTE -> (match b with
               | BYTE -> true
               | _ -> false)
    | SHL -> (match b with
              | SHL -> true
              | _ -> false)
    | SHR -> (match b with
              | SHR -> true
              | _ -> false)
    | SAR -> (match b with
              | SAR -> true
              | _ -> false)
    | SHA3 -> (match b with
               | SHA3 -> true
               | _ -> false)
    | KECCAK256 -> (match b with
                    | KECCAK256 -> true
                    | _ -> false)
    | ADDRESS -> (match b with
                  | ADDRESS -> true
                  | _ -> false)
    | BALANCE -> (match b with
                  | BALANCE -> true
                  | _ -> false)
    | ORIGIN -> (match b with
                 | ORIGIN -> true
                 | _ -> false)
    | CALLER -> (match b with
                 | CALLER -> true
                 | _ -> false)
    | CALLVALUE -> (match b with
                    | CALLVALUE -> true
                    | _ -> false)
    | CALLDATALOAD -> (match b with
                       | CALLDATALOAD -> true
                       | _ -> false)
    | CALLDATASIZE -> (match b with
                       | CALLDATASIZE -> true
                       | _ -> false)
    | CODESIZE -> (match b with
                   | CODESIZE -> true
                   | _ -> false)
    | GASPRICE -> (match b with
                   | GASPRICE -> true
                   | _ -> false)
    | EXTCODESIZE -> (match b with
                      | EXTCODESIZE -> true
                      | _ -> false)
    | RETURNDATASIZE -> (match b with
                         | RETURNDATASIZE -> true
                         | _ -> false)
    | EXTCODEHASH -> (match b with
                      | EXTCODEHASH -> true
                      | _ -> false)
    | BLOCKHASH -> (match b with
                    | BLOCKHASH -> true
                    | _ -> false)
    | COINBASE -> (match b with
                   | COINBASE -> true
                   | _ -> false)
    | TIMESTAMP -> (match b with
                    | TIMESTAMP -> true
                    | _ -> false)
    | NUMBER -> (match b with
                 | NUMBER -> true
                 | _ -> false)
    | DIFFICULTY -> (match b with
                     | DIFFICULTY -> true
                     | _ -> false)
    | GASLIMIT -> (match b with
                   | GASLIMIT -> true
                   | _ -> false)
    | CHAINID -> (match b with
                  | CHAINID -> true
                  | _ -> false)
    | SELFBALANCE -> (match b with
                      | SELFBALANCE -> true
                      | _ -> false)
    | BASEFEE -> (match b with
                  | BASEFEE -> true
                  | _ -> false)
    | SLOAD -> (match b with
                | SLOAD -> true
                | _ -> false)
    | MLOAD -> (match b with
                | MLOAD -> true
                | _ -> false)
    | PC -> (match b with
             | PC -> true
             | _ -> false)
    | MSIZE -> (match b with
                | MSIZE -> true
                | _ -> false)
    | GAS -> (match b with
              | GAS -> true
              | _ -> false)
    | CREATE -> (match b with
                 | CREATE -> true
                 | _ -> false)
    | CREATE2 -> (match b with
                  | CREATE2 -> true
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

  (** val eq : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let eq = function
  | [] -> None
  | a::l ->
    (match l with
     | [] -> None
     | b::l0 ->
       (match l0 with
        | [] ->
          Some
            (if weqb EVM_Def.coq_WLen a b
             then EVM_Def.coq_WOne
             else EVM_Def.coq_WZero)
        | _::_ -> None))

  (** val iszero : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let iszero = function
  | [] -> None
  | a::l -> (match l with
             | [] -> eq (a::(EVM_Def.coq_WZero::[]))
             | _::_ -> None)

  (** val coq_and : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let coq_and = function
  | [] -> None
  | a::l ->
    (match l with
     | [] -> None
     | b::l0 ->
       (match l0 with
        | [] -> Some (wand EVM_Def.coq_WLen a b)
        | _::_ -> None))

  (** val coq_or : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let coq_or = function
  | [] -> None
  | a::l ->
    (match l with
     | [] -> None
     | b::l0 ->
       (match l0 with
        | [] -> Some (wor EVM_Def.coq_WLen a b)
        | _::_ -> None))

  (** val xor : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let xor = function
  | [] -> None
  | a::l ->
    (match l with
     | [] -> None
     | b::l0 ->
       (match l0 with
        | [] -> Some (wxor EVM_Def.coq_WLen a b)
        | _::_ -> None))

  (** val shl : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let shl = function
  | [] -> None
  | a::l ->
    (match l with
     | [] -> None
     | b::l0 ->
       (match l0 with
        | [] -> Some (wlshift' EVM_Def.coq_WLen b (wordToNat EVM_Def.coq_WLen a))
        | _::_ -> None))

  (** val shr : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let shr = function
  | [] -> None
  | a::l ->
    (match l with
     | [] -> None
     | b::l0 ->
       (match l0 with
        | [] -> Some (wrshift' EVM_Def.coq_WLen b (wordToNat EVM_Def.coq_WLen a))
        | _::_ -> None))

  (** val sub : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let sub = function
  | [] -> None
  | a::l ->
    (match l with
     | [] -> None
     | b::l0 ->
       (match l0 with
        | [] -> Some (wminus EVM_Def.coq_WLen a b)
        | _::_ -> None))

  (** val exp : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let exp = function
  | [] -> None
  | a::l ->
    (match l with
     | [] -> None
     | b::l0 ->
       (match l0 with
        | [] ->
          Some
            (nToWord EVM_Def.coq_WLen
              (N.pow (wordToN EVM_Def.coq_WLen a) (wordToN EVM_Def.coq_WLen b)))
        | _::_ -> None))

  (** val div : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let div = function
  | [] -> None
  | a::l ->
    (match l with
     | [] -> None
     | b::l0 ->
       (match l0 with
        | [] -> Some (wdiv EVM_Def.coq_WLen a b)
        | _::_ -> None))

  (** val uninterp0 : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let uninterp0 = function
  | [] -> Some EVM_Def.coq_WZero
  | _::_ -> None

  (** val uninterp1 : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let uninterp1 = function
  | [] -> None
  | _::l -> (match l with
             | [] -> Some EVM_Def.coq_WZero
             | _::_ -> None)

  (** val uninterp2 : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let uninterp2 = function
  | [] -> None
  | _::l ->
    (match l with
     | [] -> None
     | _::l0 -> (match l0 with
                 | [] -> Some EVM_Def.coq_WZero
                 | _::_ -> None))

  (** val uninterp3 : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let uninterp3 = function
  | [] -> None
  | _::l ->
    (match l with
     | [] -> None
     | _::l0 ->
       (match l0 with
        | [] -> None
        | _::l1 -> (match l1 with
                    | [] -> Some EVM_Def.coq_WZero
                    | _::_ -> None)))

  (** val uninterp4 : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option **)

  let uninterp4 = function
  | [] -> None
  | _::l ->
    (match l with
     | [] -> None
     | _::l0 ->
       (match l0 with
        | [] -> None
        | _::l1 ->
          (match l1 with
           | [] -> None
           | _::l2 -> (match l2 with
                       | [] -> Some EVM_Def.coq_WZero
                       | _::_ -> None))))

  type ('k, 'v) map = 'k -> 'v option

  (** val empty_imap : (oper_label, 'a1) map **)

  let empty_imap _ =
    None

  (** val updatei :
      (oper_label, 'a1) map -> oper_label -> 'a1 -> oper_label -> 'a1 option **)

  let updatei m x v x' =
    if eq_oper_label x x' then Some v else m x'

  type opm = (oper_label, operator) map

  (** val fully_defined : oper_label list **)

  let fully_defined =
    ADD::(MUL::(NOT::(SUB::(DIV::(EXP::(EQ::(ISZERO::(AND::(OR::(XOR::(SHL::(SHR::[]))))))))))))

  (** val is_fully_defined : oper_label -> bool **)

  let is_fully_defined i =
    let rec f = function
    | [] -> false
    | x::xs -> if eq_oper_label i x then true else f xs
    in f fully_defined

  (** val opmap : opm **)

  let opmap =
    updatei
      (updatei
        (updatei
          (updatei
            (updatei
              (updatei
                (updatei
                  (updatei
                    (updatei
                      (updatei
                        (updatei
                          (updatei
                            (updatei
                              (updatei
                                (updatei
                                  (updatei
                                    (updatei
                                      (updatei
                                        (updatei
                                          (updatei
                                            (updatei
                                              (updatei
                                                (updatei
                                                  (updatei
                                                    (updatei
                                                      (updatei
                                                        (updatei
                                                          (updatei
                                                            (updatei
                                                              (updatei
                                                                (updatei
                                                                  (updatei
                                                                    (updatei
                                                                      (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       (updatei
                                                                       empty_imap
                                                                       CREATE2
                                                                       (Op
                                                                       (false,
                                                                       (S (S (S
                                                                       (S O)))),
                                                                       uninterp4)))
                                                                       CREATE
                                                                       (Op
                                                                       (false,
                                                                       (S (S (S
                                                                       O))),
                                                                       uninterp3)))
                                                                       GAS (Op
                                                                       (false,
                                                                       O,
                                                                       uninterp0)))
                                                                       MSIZE (Op
                                                                       (false,
                                                                       O,
                                                                       uninterp0)))
                                                                       PC (Op
                                                                       (false,
                                                                       O,
                                                                       uninterp0)))
                                                                       MLOAD (Op
                                                                       (false,
                                                                       (S O),
                                                                       uninterp1)))
                                                                       SLOAD (Op
                                                                       (false,
                                                                       (S O),
                                                                       uninterp1)))
                                                                       BASEFEE
                                                                       (Op
                                                                       (false,
                                                                       O,
                                                                       uninterp0)))
                                                                       SELFBALANCE
                                                                       (Op
                                                                       (false,
                                                                       O,
                                                                       uninterp0)))
                                                                       CHAINID
                                                                       (Op
                                                                       (false,
                                                                       O,
                                                                       uninterp0)))
                                                                       GASLIMIT
                                                                       (Op
                                                                       (false,
                                                                       O,
                                                                       uninterp0)))
                                                                       DIFFICULTY
                                                                       (Op
                                                                       (false,
                                                                       O,
                                                                       uninterp0)))
                                                                       NUMBER
                                                                       (Op
                                                                       (false,
                                                                       O,
                                                                       uninterp0)))
                                                                       TIMESTAMP
                                                                       (Op
                                                                       (false,
                                                                       O,
                                                                       uninterp0)))
                                                                       COINBASE
                                                                       (Op
                                                                       (false,
                                                                       O,
                                                                       uninterp0)))
                                                                       BLOCKHASH
                                                                       (Op
                                                                       (false,
                                                                       O,
                                                                       uninterp0)))
                                                                       EXTCODEHASH
                                                                       (Op
                                                                       (false,
                                                                       (S O),
                                                                       uninterp1)))
                                                                       RETURNDATASIZE
                                                                       (Op
                                                                       (false,
                                                                       O,
                                                                       uninterp0)))
                                                                       EXTCODESIZE
                                                                       (Op
                                                                       (false,
                                                                       (S O),
                                                                       uninterp1)))
                                                                       GASPRICE
                                                                       (Op
                                                                       (false,
                                                                       O,
                                                                       uninterp0)))
                                                                       CODESIZE
                                                                       (Op
                                                                       (false,
                                                                       O,
                                                                       uninterp0)))
                                                                       CALLDATASIZE
                                                                       (Op
                                                                       (false,
                                                                       O,
                                                                       uninterp0)))
                                                                      CALLDATALOAD
                                                                      (Op
                                                                      (false, (S
                                                                      O),
                                                                      uninterp1)))
                                                                    CALLVALUE
                                                                    (Op (false,
                                                                    O,
                                                                    uninterp0)))
                                                                  CALLER (Op
                                                                  (false, O,
                                                                  uninterp0)))
                                                                ORIGIN (Op
                                                                (false, O,
                                                                uninterp0)))
                                                              BALANCE (Op
                                                              (false, (S O),
                                                              uninterp1)))
                                                            ADDRESS (Op (false,
                                                            O, uninterp0)))
                                                          KECCAK256 (Op (false,
                                                          (S (S O)), uninterp2)))
                                                        SHA3 (Op (false, (S (S
                                                        O)), uninterp2))) SAR
                                                      (Op (false, (S (S O)),
                                                      uninterp2))) SHR (Op
                                                    (false, (S (S O)), shr)))
                                                  SHL (Op (false, (S (S O)),
                                                  shl))) BYTE (Op (false, (S (S
                                                O)), uninterp2))) XOR (Op (true,
                                              (S (S O)), xor))) OR (Op (true, (S
                                            (S O)), coq_or))) AND (Op (true, (S
                                          (S O)), coq_and))) ISZERO (Op (false,
                                        (S O), iszero))) EQ (Op (true, (S (S
                                      O)), eq))) SGT (Op (false, (S (S O)),
                                    uninterp2))) SLT (Op (false, (S (S O)),
                                  uninterp2))) GT (Op (false, (S (S O)),
                                uninterp2))) LT (Op (false, (S (S O)),
                              uninterp2))) SIGNEXTEND (Op (false, (S (S O)),
                            uninterp2))) EXP (Op (false, (S (S O)), exp)))
                        MULMOD (Op (false, (S (S (S O))), uninterp3))) ADDMOD
                      (Op (false, (S (S (S O))), uninterp3))) SMOD (Op (false,
                    (S (S O)), uninterp2))) MOD (Op (false, (S (S O)),
                  uninterp2))) SDIV (Op (false, (S (S O)), uninterp2))) DIV (Op
              (false, (S (S O)), div))) SUB (Op (false, (S (S O)), sub))) NOT
          (Op (false, (S O), not))) MUL (Op (true, (S (S O)), mul))) ADD (Op
      (true, (S (S O)), add))
 end

module Abstract =
 struct
  type asfs_stack_val =
  | Val of EVM_Def.coq_EVMWord
  | InStackVar of nat
  | FreshVar of nat

  type asfs_map_val =
  | ASFSBasicVal of asfs_stack_val
  | ASFSOp of Concrete.oper_label * asfs_stack_val list

  type stack_expr =
  | UVal of EVM_Def.coq_EVMWord
  | UInStackVar of nat
  | UOp of Concrete.oper_label * stack_expr list

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
    else (match nth_error sk (pred k) with
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
    let Abstract.ASFSc (h, maxid, _, m) = a in Abstract.ASFSc (h, maxid, s', m)

  (** val set_map_asfs : Abstract.asfs -> Abstract.asfs_map -> Abstract.asfs **)

  let set_map_asfs a m' =
    let Abstract.ASFSc (h, maxid, s, _) = a in Abstract.ASFSc (h, maxid, s, m')

  (** val gen_initial_stack : nat -> Abstract.asfs_stack_val list **)

  let gen_initial_stack size =
    let ids = seq O size in map (fun x -> Abstract.InStackVar x) ids

  (** val empty_asfs : nat -> Abstract.asfs **)

  let empty_asfs size =
    let s = gen_initial_stack size in Abstract.ASFSc (size, O, s, [])

  (** val asfs_map_add :
      Abstract.asfs_map -> nat -> Abstract.asfs_map_val -> Abstract.asfs_map **)

  let asfs_map_add m id0 a =
    (id0 , a)::m

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
         (set_stack_asfs (set_map_asfs (set_maxid_asfs a (add mid (S O))) m') s')
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
      Concrete.block -> Abstract.asfs -> Concrete.opm -> Abstract.asfs option **)

  let rec symbolic_exec' p a ops =
    match p with
    | [] -> Some a
    | ins::p' ->
      (match symbolic_exec'' ins a ops with
       | Some a' -> symbolic_exec' p' a' ops
       | None -> None)

  (** val symbolic_exec :
      Concrete.block -> nat -> Concrete.opm -> Abstract.asfs option **)

  let symbolic_exec p height ops =
    let a = empty_asfs height in symbolic_exec' p a ops

  (** val is_comm_op : Concrete.oper_label -> Concrete.opm -> bool **)

  let is_comm_op opcode ops =
    match ops opcode with
    | Some o -> let Concrete.Op (comm, _, _) = o in comm
    | None -> false

  (** val apply_f_opt_list :
      ('a1 -> 'a2 option) -> 'a1 list -> 'a2 list option **)

  let apply_f_opt_list f = function
  | [] -> Some []
  | a1::l0 ->
    (match l0 with
     | [] -> (match f a1 with
              | Some v1 -> Some (v1::[])
              | None -> None)
     | a2::l1 ->
       (match l1 with
        | [] ->
          (match f a1 with
           | Some v1 ->
             (match f a2 with
              | Some v2 -> Some (v1::(v2::[]))
              | None -> None)
           | None -> None)
        | a3::l2 ->
          (match l2 with
           | [] ->
             (match f a1 with
              | Some v1 ->
                (match f a2 with
                 | Some v2 ->
                   (match f a3 with
                    | Some v3 -> Some (v1::(v2::(v3::[])))
                    | None -> None)
                 | None -> None)
              | None -> None)
           | a4::l3 ->
             (match l3 with
              | [] ->
                (match f a1 with
                 | Some v1 ->
                   (match f a2 with
                    | Some v2 ->
                      (match f a3 with
                       | Some v3 ->
                         (match f a4 with
                          | Some v4 -> Some (v1::(v2::(v3::(v4::[]))))
                          | None -> None)
                       | None -> None)
                    | None -> None)
                 | None -> None)
              | _::_ -> None))))

  (** val flat_stack_elem :
      Abstract.asfs_stack_val -> Abstract.asfs_map -> Abstract.stack_expr option **)

  let rec flat_stack_elem e m =
    match e with
    | Abstract.Val v -> Some (Abstract.UVal v)
    | Abstract.InStackVar n0 -> Some (Abstract.UInStackVar n0)
    | Abstract.FreshVar n0 ->
      (match m with
       | [] -> None
       | p::rm ->
         let idx , mv = p in
         if eqb idx n0
         then (match mv with
               | Abstract.ASFSBasicVal val0 ->
                 (match val0 with
                  | Abstract.Val v -> Some (Abstract.UVal v)
                  | Abstract.InStackVar n1 -> Some (Abstract.UInStackVar n1)
                  | Abstract.FreshVar n1 ->
                    flat_stack_elem (Abstract.FreshVar n1) rm)
               | Abstract.ASFSOp (opcode, args) ->
                 let f = fun elem' -> flat_stack_elem elem' rm in
                 (match apply_f_opt_list f args with
                  | Some fargs -> Some (Abstract.UOp (opcode, fargs))
                  | None -> None))
         else flat_stack_elem e rm)

  (** val compare_lists_pred :
      ('a1 -> 'a2 -> bool) -> 'a1 list -> 'a2 list -> bool **)

  let compare_lists_pred f l1 l2 =
    match l1 with
    | [] -> (match l2 with
             | [] -> true
             | _::_ -> false)
    | h1::l ->
      (match l with
       | [] ->
         (match l2 with
          | [] -> false
          | h1'::l0 -> (match l0 with
                        | [] -> f h1 h1'
                        | _::_ -> false))
       | h2::l0 ->
         (match l0 with
          | [] ->
            (match l2 with
             | [] -> false
             | h1'::l3 ->
               (match l3 with
                | [] -> false
                | h2'::l4 ->
                  (match l4 with
                   | [] -> if f h1 h1' then f h2 h2' else false
                   | _::_ -> false)))
          | h3::l3 ->
            (match l3 with
             | [] ->
               (match l2 with
                | [] -> false
                | h1'::l4 ->
                  (match l4 with
                   | [] -> false
                   | h2'::l5 ->
                     (match l5 with
                      | [] -> false
                      | h3'::l6 ->
                        (match l6 with
                         | [] ->
                           if if f h1 h1' then f h2 h2' else false
                           then f h3 h3'
                           else false
                         | _::_ -> false))))
             | h4::l4 ->
               (match l4 with
                | [] ->
                  (match l2 with
                   | [] -> false
                   | h1'::l5 ->
                     (match l5 with
                      | [] -> false
                      | h2'::l6 ->
                        (match l6 with
                         | [] -> false
                         | h3'::l7 ->
                           (match l7 with
                            | [] -> false
                            | h4'::l8 ->
                              (match l8 with
                               | [] ->
                                 if if if f h1 h1' then f h2 h2' else false
                                    then f h3 h3'
                                    else false
                                 then f h4 h4'
                                 else false
                               | _::_ -> false)))))
                | _::_ -> false))))

  (** val compare_flat_asfs_map_val :
      Abstract.stack_expr -> Abstract.stack_expr -> Concrete.opm -> bool **)

  let rec compare_flat_asfs_map_val e1 e2 ops =
    match e1 with
    | Abstract.UVal v1 ->
      (match e2 with
       | Abstract.UVal v2 -> weqb EVM_Def.coq_WLen v1 v2
       | _ -> false)
    | Abstract.UInStackVar var1 ->
      (match e2 with
       | Abstract.UInStackVar var2 -> eqb var1 var2
       | _ -> false)
    | Abstract.UOp (opcode1, args1) ->
      (match args1 with
       | [] ->
         (match e2 with
          | Abstract.UOp (opcode2, args2) ->
            if Concrete.eq_oper_label opcode1 opcode2
            then compare_lists_pred (fun a b ->
                   compare_flat_asfs_map_val a b ops) args1 args2
            else false
          | _ -> false)
       | a1::l ->
         (match l with
          | [] ->
            (match e2 with
             | Abstract.UOp (opcode2, args2) ->
               if Concrete.eq_oper_label opcode1 opcode2
               then compare_lists_pred (fun a b ->
                      compare_flat_asfs_map_val a b ops) args1 args2
               else false
             | _ -> false)
          | a2::l0 ->
            (match l0 with
             | [] ->
               (match e2 with
                | Abstract.UOp (opcode2, args2) ->
                  (match args2 with
                   | [] ->
                     if Concrete.eq_oper_label opcode1 opcode2
                     then compare_lists_pred (fun a b ->
                            compare_flat_asfs_map_val a b ops) args1 args2
                     else false
                   | a1'::l1 ->
                     (match l1 with
                      | [] ->
                        if Concrete.eq_oper_label opcode1 opcode2
                        then compare_lists_pred (fun a b ->
                               compare_flat_asfs_map_val a b ops) args1 args2
                        else false
                      | a2'::l2 ->
                        (match l2 with
                         | [] ->
                           if Concrete.eq_oper_label opcode1 opcode2
                           then if if compare_flat_asfs_map_val a1 a1' ops
                                   then compare_flat_asfs_map_val a2 a2' ops
                                   else false
                                then true
                                else if if is_comm_op opcode1 ops
                                        then compare_flat_asfs_map_val a1 a2' ops
                                        else false
                                     then compare_flat_asfs_map_val a2 a1' ops
                                     else false
                           else false
                         | _::_ ->
                           if Concrete.eq_oper_label opcode1 opcode2
                           then compare_lists_pred (fun a b ->
                                  compare_flat_asfs_map_val a b ops) args1 args2
                           else false)))
                | _ -> false)
             | _::_ ->
               (match e2 with
                | Abstract.UOp (opcode2, args2) ->
                  if Concrete.eq_oper_label opcode1 opcode2
                  then compare_lists_pred (fun a b ->
                         compare_flat_asfs_map_val a b ops) args1 args2
                  else false
                | _ -> false))))

  (** val asfs_eq_stack_elem :
      Abstract.asfs_stack_val -> Abstract.asfs_stack_val -> Abstract.asfs_map ->
      Abstract.asfs_map -> Concrete.opm -> bool **)

  let asfs_eq_stack_elem e1 e2 m1 m2 ops =
    let o = flat_stack_elem e1 m1 in
    let o0 = flat_stack_elem e2 m2 in
    (match o with
     | Some fe1 ->
       (match o0 with
        | Some fe2 -> compare_flat_asfs_map_val fe1 fe2 ops
        | None -> false)
     | None -> false)

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

  (** val eq_sstate_chkr :
      Abstract.asfs -> Abstract.asfs -> Concrete.opm -> bool **)

  let eq_sstate_chkr a1 a2 ops =
    let Abstract.ASFSc (height1, _, curr_stack1, amap1) = a1 in
    let Abstract.ASFSc (height2, _, curr_stack2, amap2) = a2 in
    let eq_size = eqb height1 height2 in
    let eq_stack = asfs_eq_stack curr_stack1 curr_stack2 amap1 amap2 ops in
    if eq_size then eq_stack else false
 end

module Coq_Optimizations =
 struct
  (** val stack_val_is_oper :
      Concrete.oper_label -> Abstract.asfs_stack_val -> Abstract.asfs_map ->
      Abstract.asfs_stack_val list option **)

  let rec stack_val_is_oper oper val0 m =
    match val0 with
    | Abstract.FreshVar fvar ->
      (match m with
       | [] -> None
       | p::t ->
         let k , v = p in
         if eqb k fvar
         then (match v with
               | Abstract.ASFSBasicVal val1 ->
                 (match val1 with
                  | Abstract.FreshVar fv ->
                    stack_val_is_oper oper (Abstract.FreshVar fv) t
                  | _ -> None)
               | Abstract.ASFSOp (opcode, args) ->
                 if Concrete.eq_oper_label oper opcode then Some args else None)
         else stack_val_is_oper oper val0 t)
    | _ -> None

  (** val optimize_fresh_var2 :
      Abstract.asfs -> Abstract.asfs_map -> (nat -> Abstract.asfs ->
      Abstract.asfs option) -> Abstract.asfs * bool **)

  let rec optimize_fresh_var2 a m opt0 =
    match m with
    | [] -> a , false
    | p::t ->
      let n0 , _ = p in
      (match opt0 n0 a with
       | Some a' -> a' , true
       | None -> optimize_fresh_var2 a t opt0)

  (** val optimize_fresh_var :
      (nat -> Abstract.asfs -> Abstract.asfs option) -> Abstract.asfs ->
      Abstract.asfs * bool **)

  let optimize_fresh_var opt0 a = match a with
  | Abstract.ASFSc (_, _, _, m) -> optimize_fresh_var2 a m opt0

  (** val stack_val_has_value' :
      Abstract.asfs_stack_val -> Abstract.asfs_map -> EVM_Def.coq_EVMWord -> bool **)

  let stack_val_has_value' av m v =
    match SFS.flat_stack_elem av m with
    | Some s ->
      (match s with
       | Abstract.UVal x -> weqb EVM_Def.coq_WLen x v
       | _ -> false)
    | None -> false

  (** val optimize_func_map :
      (nat -> Abstract.asfs_map -> Abstract.asfs_map option) -> nat ->
      Abstract.asfs -> Abstract.asfs option **)

  let optimize_func_map f fresh_var = function
  | Abstract.ASFSc (height, maxid, stack, map0) ->
    (match f fresh_var map0 with
     | Some map' -> Some (Abstract.ASFSc (height, maxid, stack, map'))
     | None -> None)

  (** val optimize_id : Abstract.asfs -> Abstract.asfs * bool **)

  let optimize_id a =
    a , false

  (** val optimize_map_add_zero :
      nat -> Abstract.asfs_map -> Abstract.asfs_map option **)

  let rec optimize_map_add_zero fresh_var map0 = match map0 with
  | [] -> None
  | p::t ->
    let n0 , val0 = p in
    if eqb n0 fresh_var
    then (match val0 with
          | Abstract.ASFSBasicVal _ -> None
          | Abstract.ASFSOp (opcode, args) ->
            (match opcode with
             | Concrete.ADD ->
               (match args with
                | [] -> None
                | arg1::l ->
                  (match l with
                   | [] -> None
                   | arg2::l0 ->
                     (match l0 with
                      | [] ->
                        if stack_val_has_value' arg1 map0 EVM_Def.coq_WZero
                        then Some ((n0 , (Abstract.ASFSBasicVal arg2))::t)
                        else if stack_val_has_value' arg2 map0 EVM_Def.coq_WZero
                             then Some ((n0 , (Abstract.ASFSBasicVal arg1))::t)
                             else None
                      | _::_ -> None)))
             | _ -> None))
    else (match optimize_map_add_zero fresh_var t with
          | Some map' -> Some ((n0 , val0)::map')
          | None -> None)

  (** val optimize_add_zero_fvar :
      nat -> Abstract.asfs -> Abstract.asfs option **)

  let optimize_add_zero_fvar fresh_var s =
    optimize_func_map optimize_map_add_zero fresh_var s

  (** val optimize_add_zero : Abstract.asfs -> Abstract.asfs * bool **)

  let optimize_add_zero a =
    optimize_fresh_var optimize_add_zero_fvar a

  (** val optimize_map_mul_one :
      nat -> Abstract.asfs_map -> Abstract.asfs_map option **)

  let rec optimize_map_mul_one fresh_var map0 = match map0 with
  | [] -> None
  | p::t ->
    let n0 , val0 = p in
    if eqb n0 fresh_var
    then (match val0 with
          | Abstract.ASFSBasicVal _ -> None
          | Abstract.ASFSOp (opcode, args) ->
            (match opcode with
             | Concrete.MUL ->
               (match args with
                | [] -> None
                | arg1::l ->
                  (match l with
                   | [] -> None
                   | arg2::l0 ->
                     (match l0 with
                      | [] ->
                        if stack_val_has_value' arg1 map0 EVM_Def.coq_WOne
                        then Some ((n0 , (Abstract.ASFSBasicVal arg2))::t)
                        else if stack_val_has_value' arg2 map0 EVM_Def.coq_WOne
                             then Some ((n0 , (Abstract.ASFSBasicVal arg1))::t)
                             else None
                      | _::_ -> None)))
             | _ -> None))
    else (match optimize_map_mul_one fresh_var t with
          | Some map' -> Some ((n0 , val0)::map')
          | None -> None)

  (** val optimize_mul_one_fvar :
      nat -> Abstract.asfs -> Abstract.asfs option **)

  let optimize_mul_one_fvar fresh_var s =
    optimize_func_map optimize_map_mul_one fresh_var s

  (** val optimize_mul_one : Abstract.asfs -> Abstract.asfs * bool **)

  let optimize_mul_one a =
    optimize_fresh_var optimize_mul_one_fvar a

  (** val optimize_map_mul_zero :
      nat -> Abstract.asfs_map -> Abstract.asfs_map option **)

  let rec optimize_map_mul_zero fresh_var map0 = match map0 with
  | [] -> None
  | p::t ->
    let n0 , val0 = p in
    if eqb n0 fresh_var
    then (match val0 with
          | Abstract.ASFSBasicVal _ -> None
          | Abstract.ASFSOp (opcode, args) ->
            (match opcode with
             | Concrete.MUL ->
               (match args with
                | [] -> None
                | arg1::l ->
                  (match l with
                   | [] -> None
                   | arg2::l0 ->
                     (match l0 with
                      | [] ->
                        if stack_val_has_value' arg1 map0 EVM_Def.coq_WZero
                        then Some ((n0 , (Abstract.ASFSBasicVal (Abstract.Val
                               EVM_Def.coq_WZero)))::t)
                        else if stack_val_has_value' arg2 map0 EVM_Def.coq_WZero
                             then Some ((n0 , (Abstract.ASFSBasicVal
                                    (Abstract.Val EVM_Def.coq_WZero)))::t)
                             else None
                      | _::_ -> None)))
             | _ -> None))
    else (match optimize_map_mul_zero fresh_var t with
          | Some map' -> Some ((n0 , val0)::map')
          | None -> None)

  (** val optimize_mul_zero_fvar :
      nat -> Abstract.asfs -> Abstract.asfs option **)

  let optimize_mul_zero_fvar fresh_var s =
    optimize_func_map optimize_map_mul_zero fresh_var s

  (** val optimize_mul_zero : Abstract.asfs -> Abstract.asfs * bool **)

  let optimize_mul_zero =
    optimize_fresh_var optimize_mul_zero_fvar

  (** val optimize_map_not_not :
      nat -> Abstract.asfs_map -> Abstract.asfs_map option **)

  let rec optimize_map_not_not fresh_var = function
  | [] -> None
  | p::t ->
    let n0 , val0 = p in
    if eqb n0 fresh_var
    then (match val0 with
          | Abstract.ASFSBasicVal _ -> None
          | Abstract.ASFSOp (opcode, args) ->
            (match opcode with
             | Concrete.NOT ->
               (match args with
                | [] -> None
                | arg::l ->
                  (match l with
                   | [] ->
                     (match stack_val_is_oper Concrete.NOT arg t with
                      | Some l0 ->
                        (match l0 with
                         | [] -> None
                         | arg'::l1 ->
                           (match l1 with
                            | [] -> Some ((n0 , (Abstract.ASFSBasicVal arg'))::t)
                            | _::_ -> None))
                      | None -> None)
                   | _::_ -> None))
             | _ -> None))
    else (match optimize_map_not_not fresh_var t with
          | Some map' -> Some ((n0 , val0)::map')
          | None -> None)

  (** val optimize_not_not_fvar :
      nat -> Abstract.asfs -> Abstract.asfs option **)

  let optimize_not_not_fvar fresh_var s =
    optimize_func_map optimize_map_not_not fresh_var s

  (** val optimize_not_not : Abstract.asfs -> Abstract.asfs * bool **)

  let optimize_not_not =
    optimize_fresh_var optimize_not_not_fvar

  (** val flat_extract_const :
      Abstract.asfs_stack_val -> Abstract.asfs_map -> EVM_Def.coq_EVMWord option **)

  let flat_extract_const v m =
    match SFS.flat_stack_elem v m with
    | Some s -> (match s with
                 | Abstract.UVal x -> Some x
                 | _ -> None)
    | None -> None

  (** val const_list :
      Abstract.asfs_stack_val list -> Abstract.asfs_map -> EVM_Def.coq_EVMWord
      list option **)

  let const_list l m =
    SFS.apply_f_opt_list (fun e -> flat_extract_const e m) l

  (** val optimize_map_eval :
      Concrete.opm -> nat -> Abstract.asfs_map -> Abstract.asfs_map option **)

  let rec optimize_map_eval ops fresh_var = function
  | [] -> None
  | p::t ->
    let n0 , val0 = p in
    if eqb n0 fresh_var
    then (match val0 with
          | Abstract.ASFSBasicVal _ -> None
          | Abstract.ASFSOp (oper, args) ->
            if Concrete.is_fully_defined oper
            then (match const_list args t with
                  | Some wargs ->
                    (match ops oper with
                     | Some o ->
                       let Concrete.Op (_, _, f) = o in
                       (match f wargs with
                        | Some v ->
                          Some ((n0 , (Abstract.ASFSBasicVal (Abstract.Val
                            v)))::t)
                        | None -> None)
                     | None -> None)
                  | None -> None)
            else None)
    else (match optimize_map_eval ops fresh_var t with
          | Some map' -> Some ((n0 , val0)::map')
          | None -> None)

  (** val optimize_eval_fvar : nat -> Abstract.asfs -> Abstract.asfs option **)

  let optimize_eval_fvar fresh_var s =
    optimize_func_map (optimize_map_eval Concrete.opmap) fresh_var s

  (** val optimize_eval : Abstract.asfs -> Abstract.asfs * bool **)

  let optimize_eval =
    optimize_fresh_var optimize_eval_fvar

  (** val optimize_map_div_one :
      nat -> Abstract.asfs_map -> Abstract.asfs_map option **)

  let rec optimize_map_div_one fresh_var map0 = match map0 with
  | [] -> None
  | p::t ->
    let n0 , val0 = p in
    if eqb n0 fresh_var
    then (match val0 with
          | Abstract.ASFSBasicVal _ -> None
          | Abstract.ASFSOp (opcode, args) ->
            (match opcode with
             | Concrete.DIV ->
               (match args with
                | [] -> None
                | arg1::l ->
                  (match l with
                   | [] -> None
                   | arg2::l0 ->
                     (match l0 with
                      | [] ->
                        if stack_val_has_value' arg2 map0 EVM_Def.coq_WOne
                        then Some ((n0 , (Abstract.ASFSBasicVal arg1))::t)
                        else None
                      | _::_ -> None)))
             | _ -> None))
    else (match optimize_map_div_one fresh_var t with
          | Some map' -> Some ((n0 , val0)::map')
          | None -> None)

  (** val optimize_div_one_fvar :
      nat -> Abstract.asfs -> Abstract.asfs option **)

  let optimize_div_one_fvar fresh_var s =
    optimize_func_map optimize_map_div_one fresh_var s

  (** val optimize_div_one : Abstract.asfs -> Abstract.asfs * bool **)

  let optimize_div_one a =
    optimize_fresh_var optimize_div_one_fvar a

  (** val optimize_map_eq_zero :
      nat -> Abstract.asfs_map -> Abstract.asfs_map option **)

  let rec optimize_map_eq_zero fresh_var map0 = match map0 with
  | [] -> None
  | p::t ->
    let n0 , val0 = p in
    if eqb n0 fresh_var
    then (match val0 with
          | Abstract.ASFSBasicVal _ -> None
          | Abstract.ASFSOp (opcode, args) ->
            (match opcode with
             | Concrete.EQ ->
               (match args with
                | [] -> None
                | arg1::l ->
                  (match l with
                   | [] -> None
                   | arg2::l0 ->
                     (match l0 with
                      | [] ->
                        if stack_val_has_value' arg1 map0 EVM_Def.coq_WZero
                        then Some ((n0 , (Abstract.ASFSOp (Concrete.ISZERO,
                               (arg2::[]))))::t)
                        else if stack_val_has_value' arg2 map0 EVM_Def.coq_WZero
                             then Some ((n0 , (Abstract.ASFSOp (Concrete.ISZERO,
                                    (arg1::[]))))::t)
                             else None
                      | _::_ -> None)))
             | _ -> None))
    else (match optimize_map_eq_zero fresh_var t with
          | Some map' -> Some ((n0 , val0)::map')
          | None -> None)

  (** val optimize_eq_zero_fvar :
      nat -> Abstract.asfs -> Abstract.asfs option **)

  let optimize_eq_zero_fvar fresh_var s =
    optimize_func_map optimize_map_eq_zero fresh_var s

  (** val optimize_eq_zero : Abstract.asfs -> Abstract.asfs * bool **)

  let optimize_eq_zero a =
    optimize_fresh_var optimize_eq_zero_fvar a

  (** val optimize_map_gt_one :
      nat -> Abstract.asfs_map -> Abstract.asfs_map option **)

  let rec optimize_map_gt_one fresh_var map0 = match map0 with
  | [] -> None
  | p::t ->
    let n0 , val0 = p in
    if eqb n0 fresh_var
    then (match val0 with
          | Abstract.ASFSBasicVal _ -> None
          | Abstract.ASFSOp (opcode, args) ->
            (match opcode with
             | Concrete.GT ->
               (match args with
                | [] -> None
                | arg1::l ->
                  (match l with
                   | [] -> None
                   | arg2::l0 ->
                     (match l0 with
                      | [] ->
                        if stack_val_has_value' arg1 map0 EVM_Def.coq_WOne
                        then Some ((n0 , (Abstract.ASFSOp (Concrete.ISZERO,
                               (arg2::[]))))::t)
                        else None
                      | _::_ -> None)))
             | _ -> None))
    else (match optimize_map_gt_one fresh_var t with
          | Some map' -> Some ((n0 , val0)::map')
          | None -> None)

  (** val optimize_gt_one_fvar : nat -> Abstract.asfs -> Abstract.asfs option **)

  let optimize_gt_one_fvar fresh_var s =
    optimize_func_map optimize_map_gt_one fresh_var s

  (** val optimize_gt_one : Abstract.asfs -> Abstract.asfs * bool **)

  let optimize_gt_one a =
    optimize_fresh_var optimize_gt_one_fvar a

  (** val optimize_map_lt_one :
      nat -> Abstract.asfs_map -> Abstract.asfs_map option **)

  let rec optimize_map_lt_one fresh_var map0 = match map0 with
  | [] -> None
  | p::t ->
    let n0 , val0 = p in
    if eqb n0 fresh_var
    then (match val0 with
          | Abstract.ASFSBasicVal _ -> None
          | Abstract.ASFSOp (opcode, args) ->
            (match opcode with
             | Concrete.LT ->
               (match args with
                | [] -> None
                | arg1::l ->
                  (match l with
                   | [] -> None
                   | arg2::l0 ->
                     (match l0 with
                      | [] ->
                        if stack_val_has_value' arg2 map0 EVM_Def.coq_WOne
                        then Some ((n0 , (Abstract.ASFSOp (Concrete.ISZERO,
                               (arg1::[]))))::t)
                        else None
                      | _::_ -> None)))
             | _ -> None))
    else (match optimize_map_lt_one fresh_var t with
          | Some map' -> Some ((n0 , val0)::map')
          | None -> None)

  (** val optimize_lt_one_fvar : nat -> Abstract.asfs -> Abstract.asfs option **)

  let optimize_lt_one_fvar fresh_var s =
    optimize_func_map optimize_map_lt_one fresh_var s

  (** val optimize_lt_one : Abstract.asfs -> Abstract.asfs * bool **)

  let optimize_lt_one a =
    optimize_fresh_var optimize_lt_one_fvar a

  (** val optimize_map_or_zero :
      nat -> Abstract.asfs_map -> Abstract.asfs_map option **)

  let rec optimize_map_or_zero fresh_var map0 = match map0 with
  | [] -> None
  | p::t ->
    let n0 , val0 = p in
    if eqb n0 fresh_var
    then (match val0 with
          | Abstract.ASFSBasicVal _ -> None
          | Abstract.ASFSOp (opcode, args) ->
            (match opcode with
             | Concrete.OR ->
               (match args with
                | [] -> None
                | arg1::l ->
                  (match l with
                   | [] -> None
                   | arg2::l0 ->
                     (match l0 with
                      | [] ->
                        if stack_val_has_value' arg1 map0 EVM_Def.coq_WZero
                        then Some ((n0 , (Abstract.ASFSBasicVal arg2))::t)
                        else if stack_val_has_value' arg2 map0 EVM_Def.coq_WZero
                             then Some ((n0 , (Abstract.ASFSBasicVal arg1))::t)
                             else None
                      | _::_ -> None)))
             | _ -> None))
    else (match optimize_map_or_zero fresh_var t with
          | Some map' -> Some ((n0 , val0)::map')
          | None -> None)

  (** val optimize_or_zero_fvar :
      nat -> Abstract.asfs -> Abstract.asfs option **)

  let optimize_or_zero_fvar fresh_var s =
    optimize_func_map optimize_map_or_zero fresh_var s

  (** val optimize_or_zero : Abstract.asfs -> Abstract.asfs * bool **)

  let optimize_or_zero a =
    optimize_fresh_var optimize_or_zero_fvar a

  (** val optimize_map_sub_x_x :
      nat -> Abstract.asfs_map -> Abstract.asfs_map option **)

  let rec optimize_map_sub_x_x fresh_var map0 = match map0 with
  | [] -> None
  | p::t ->
    let n0 , val0 = p in
    if eqb n0 fresh_var
    then (match val0 with
          | Abstract.ASFSBasicVal _ -> None
          | Abstract.ASFSOp (opcode, args) ->
            (match opcode with
             | Concrete.SUB ->
               (match args with
                | [] -> None
                | arg1::l ->
                  (match l with
                   | [] -> None
                   | arg2::l0 ->
                     (match l0 with
                      | [] ->
                        (match SFS.flat_stack_elem arg1 map0 with
                         | Some v1 ->
                           (match SFS.flat_stack_elem arg2 map0 with
                            | Some v2 ->
                              if SFS.compare_flat_asfs_map_val v1 v2
                                   Concrete.opmap
                              then Some ((n0 , (Abstract.ASFSBasicVal
                                     (Abstract.Val EVM_Def.coq_WZero)))::t)
                              else None
                            | None -> None)
                         | None -> None)
                      | _::_ -> None)))
             | _ -> None))
    else (match optimize_map_sub_x_x fresh_var t with
          | Some map' -> Some ((n0 , val0)::map')
          | None -> None)

  (** val optimize_sub_x_x_fvar :
      nat -> Abstract.asfs -> Abstract.asfs option **)

  let optimize_sub_x_x_fvar fresh_var s =
    optimize_func_map optimize_map_sub_x_x fresh_var s

  (** val optimize_sub_x_x : Abstract.asfs -> Abstract.asfs * bool **)

  let optimize_sub_x_x a =
    optimize_fresh_var optimize_sub_x_x_fvar a

  (** val optimize_map_iszero3 :
      nat -> Abstract.asfs_map -> Abstract.asfs_map option **)

  let rec optimize_map_iszero3 fresh_var = function
  | [] -> None
  | p::t ->
    let n0 , val0 = p in
    if eqb n0 fresh_var
    then (match val0 with
          | Abstract.ASFSBasicVal _ -> None
          | Abstract.ASFSOp (opcode, args) ->
            (match opcode with
             | Concrete.ISZERO ->
               (match args with
                | [] -> None
                | arg1::l ->
                  (match l with
                   | [] ->
                     (match stack_val_is_oper Concrete.ISZERO arg1 t with
                      | Some l0 ->
                        (match l0 with
                         | [] -> None
                         | arg2::l1 ->
                           (match l1 with
                            | [] ->
                              (match stack_val_is_oper Concrete.ISZERO arg2 t with
                               | Some l2 ->
                                 (match l2 with
                                  | [] -> None
                                  | arg3::l3 ->
                                    (match l3 with
                                     | [] ->
                                       Some ((n0 , (Abstract.ASFSOp
                                         (Concrete.ISZERO, (arg3::[]))))::t)
                                     | _::_ -> None))
                               | None -> None)
                            | _::_ -> None))
                      | None -> None)
                   | _::_ -> None))
             | _ -> None))
    else (match optimize_map_iszero3 fresh_var t with
          | Some map' -> Some ((n0 , val0)::map')
          | None -> None)

  (** val optimize_iszero3_fvar :
      nat -> Abstract.asfs -> Abstract.asfs option **)

  let optimize_iszero3_fvar fresh_var s =
    optimize_func_map optimize_map_iszero3 fresh_var s

  (** val optimize_iszero3 : Abstract.asfs -> Abstract.asfs * bool **)

  let optimize_iszero3 =
    optimize_fresh_var optimize_iszero3_fvar

  (** val optimize_map_and_and_l :
      nat -> Abstract.asfs_map -> Abstract.asfs_map option **)

  let rec optimize_map_and_and_l fresh_var = function
  | [] -> None
  | p::t ->
    let n0 , val0 = p in
    if eqb n0 fresh_var
    then (match val0 with
          | Abstract.ASFSBasicVal _ -> None
          | Abstract.ASFSOp (opcode, args) ->
            (match opcode with
             | Concrete.AND ->
               (match args with
                | [] -> None
                | arg1::l ->
                  (match l with
                   | [] -> None
                   | arg2::l0 ->
                     (match l0 with
                      | [] ->
                        (match stack_val_is_oper Concrete.AND arg1 t with
                         | Some l1 ->
                           (match l1 with
                            | [] -> None
                            | arg11::l2 ->
                              (match l2 with
                               | [] -> None
                               | arg12::l3 ->
                                 (match l3 with
                                  | [] ->
                                    (match SFS.flat_stack_elem arg2 t with
                                     | Some farg2 ->
                                       (match SFS.flat_stack_elem arg11 t with
                                        | Some farg11 ->
                                          (match SFS.flat_stack_elem arg12 t with
                                           | Some farg12 ->
                                             if if SFS.compare_flat_asfs_map_val
                                                     farg11 farg2 Concrete.opmap
                                                then true
                                                else SFS.compare_flat_asfs_map_val
                                                       farg12 farg2
                                                       Concrete.opmap
                                             then Some ((n0 , (Abstract.ASFSOp
                                                    (Concrete.AND,
                                                    (arg11::(arg12::[])))))::t)
                                             else None
                                           | None -> None)
                                        | None -> None)
                                     | None -> None)
                                  | _::_ -> None)))
                         | None -> None)
                      | _::_ -> None)))
             | _ -> None))
    else (match optimize_map_and_and_l fresh_var t with
          | Some map' -> Some ((n0 , val0)::map')
          | None -> None)

  (** val optimize_and_and_l_fvar :
      nat -> Abstract.asfs -> Abstract.asfs option **)

  let optimize_and_and_l_fvar fresh_var s =
    optimize_func_map optimize_map_and_and_l fresh_var s

  (** val optimize_and_and_l : Abstract.asfs -> Abstract.asfs * bool **)

  let optimize_and_and_l =
    optimize_fresh_var optimize_and_and_l_fvar

  (** val optimize_map_and_and_r :
      nat -> Abstract.asfs_map -> Abstract.asfs_map option **)

  let rec optimize_map_and_and_r fresh_var = function
  | [] -> None
  | p::t ->
    let n0 , val0 = p in
    if eqb n0 fresh_var
    then (match val0 with
          | Abstract.ASFSBasicVal _ -> None
          | Abstract.ASFSOp (opcode, args) ->
            (match opcode with
             | Concrete.AND ->
               (match args with
                | [] -> None
                | arg1::l ->
                  (match l with
                   | [] -> None
                   | arg2::l0 ->
                     (match l0 with
                      | [] ->
                        (match stack_val_is_oper Concrete.AND arg2 t with
                         | Some l1 ->
                           (match l1 with
                            | [] -> None
                            | arg21::l2 ->
                              (match l2 with
                               | [] -> None
                               | arg22::l3 ->
                                 (match l3 with
                                  | [] ->
                                    (match SFS.flat_stack_elem arg1 t with
                                     | Some farg1 ->
                                       (match SFS.flat_stack_elem arg21 t with
                                        | Some farg21 ->
                                          (match SFS.flat_stack_elem arg22 t with
                                           | Some farg22 ->
                                             if if SFS.compare_flat_asfs_map_val
                                                     farg1 farg21 Concrete.opmap
                                                then true
                                                else SFS.compare_flat_asfs_map_val
                                                       farg1 farg22
                                                       Concrete.opmap
                                             then Some ((n0 , (Abstract.ASFSOp
                                                    (Concrete.AND,
                                                    (arg21::(arg22::[])))))::t)
                                             else None
                                           | None -> None)
                                        | None -> None)
                                     | None -> None)
                                  | _::_ -> None)))
                         | None -> None)
                      | _::_ -> None)))
             | _ -> None))
    else (match optimize_map_and_and_r fresh_var t with
          | Some map' -> Some ((n0 , val0)::map')
          | None -> None)

  (** val optimize_and_and_r_fvar :
      nat -> Abstract.asfs -> Abstract.asfs option **)

  let optimize_and_and_r_fvar fresh_var s =
    optimize_func_map optimize_map_and_and_r fresh_var s

  (** val optimize_and_and_r : Abstract.asfs -> Abstract.asfs * bool **)

  let optimize_and_and_r =
    optimize_fresh_var optimize_and_and_r_fvar

  (** val apply_n_times :
      Optimizations.optimization -> nat -> Abstract.asfs -> Abstract.asfs * bool **)

  let rec apply_n_times opt0 n0 a =
    match n0 with
    | O -> a , true
    | S n' -> let a' , _ = opt0 a in apply_n_times opt0 n' a'

  (** val apply_all_possible_opt :
      Optimizations.optimization list -> Abstract.asfs -> Abstract.asfs * bool **)

  let rec apply_all_possible_opt l_opt a =
    match l_opt with
    | [] -> a , true
    | opt0::ropts -> let a' , _ = opt0 a in apply_all_possible_opt ropts a'

  (** val apply_pipeline_n_times :
      Optimizations.optimization list -> nat -> Abstract.asfs ->
      Abstract.asfs * bool **)

  let apply_pipeline_n_times l_opt n0 a =
    apply_n_times (apply_all_possible_opt l_opt) n0 a

  (** val our_optimization_pipeline :
      (Abstract.asfs -> Abstract.asfs * bool) list **)

  let our_optimization_pipeline =
    optimize_eval::(optimize_add_zero::(optimize_mul_one::(optimize_mul_zero::(optimize_not_not::(optimize_div_one::(optimize_eq_zero::(optimize_gt_one::(optimize_lt_one::(optimize_or_zero::(optimize_sub_x_x::(optimize_iszero3::(optimize_and_and_l::(optimize_and_and_r::[])))))))))))))
 end

module Checker =
 struct
  (** val evm_eq_block_chkr' :
      Optimizations.optimization -> Concrete.block -> Concrete.block -> nat ->
      bool **)

  let evm_eq_block_chkr' opt0 opt_p p height =
    match SFS.symbolic_exec opt_p height Concrete.opmap with
    | Some sfs1 ->
      (match SFS.symbolic_exec p height Concrete.opmap with
       | Some sfs2 ->
         let sfs3 , _ = opt0 sfs2 in SFS.eq_sstate_chkr sfs1 sfs3 Concrete.opmap
       | None -> false)
    | None -> false

  (** val evm_eq_block_chkr'' :
      Optimizations.optimization -> Concrete.block -> Concrete.block -> nat ->
      bool **)

  let evm_eq_block_chkr'' opt0 opt_p p height =
    match SFS.symbolic_exec opt_p height Concrete.opmap with
    | Some sfs1 ->
      (match SFS.symbolic_exec p height Concrete.opmap with
       | Some sfs2 ->
         let sfs3 , _ = opt0 sfs2 in
         let sfs4 , _ = opt0 sfs1 in SFS.eq_sstate_chkr sfs4 sfs3 Concrete.opmap
       | None -> false)
    | None -> false
 end

module Parser =
 struct
  (** val isWhite : char -> bool **)

  let isWhite c =
    let n0 = n_of_ascii c in
    if if N.eqb n0 (Npos (XO (XO (XO (XO (XO XH))))))
       then true
       else N.eqb n0 (Npos (XI (XO (XO XH))))
    then true
    else if N.eqb n0 (Npos (XO (XI (XO XH))))
         then true
         else N.eqb n0 (Npos (XI (XO (XI XH))))

  type chartype =
  | Coq_white
  | Coq_other

  (** val chartype_rect : 'a1 -> 'a1 -> chartype -> 'a1 **)

  let chartype_rect f f0 = function
  | Coq_white -> f
  | Coq_other -> f0

  (** val chartype_rec : 'a1 -> 'a1 -> chartype -> 'a1 **)

  let chartype_rec f f0 = function
  | Coq_white -> f
  | Coq_other -> f0

  (** val classifyChar : char -> chartype **)

  let classifyChar c =
    if isWhite c then Coq_white else Coq_other

  (** val list_of_string : char list -> char list **)

  let rec list_of_string = function
  | [] -> []
  | c::s0 -> c::(list_of_string s0)

  (** val string_of_list : char list -> char list **)

  let string_of_list xs =
    fold_right (fun x x0 -> x::x0) [] xs

  type token = char list

  (** val tokenize_helper :
      chartype -> char list -> char list -> char list list **)

  let rec tokenize_helper cls acc xs =
    let tk = match acc with
             | [] -> []
             | _::_ -> (rev acc)::[] in
    (match xs with
     | [] -> tk
     | x::xs' ->
       (match cls with
        | Coq_white ->
          (match classifyChar x with
           | Coq_white -> app tk (tokenize_helper Coq_white [] xs')
           | Coq_other -> app tk (tokenize_helper Coq_other (x::[]) xs'))
        | Coq_other ->
          (match classifyChar x with
           | Coq_white -> app tk (tokenize_helper Coq_white [] xs')
           | Coq_other -> tokenize_helper Coq_other (x::acc) xs')))

  (** val tokenize : char list -> char list list **)

  let tokenize s =
    map string_of_list (tokenize_helper Coq_white [] (list_of_string s))

  (** val uint_to_N : uint -> n **)

  let rec uint_to_N = function
  | Nil -> N0
  | D0 d0 -> N.mul (Npos (XO (XO (XO (XO XH))))) (uint_to_N d0)
  | D1 d0 -> N.add (Npos XH) (N.mul (Npos (XO (XO (XO (XO XH))))) (uint_to_N d0))
  | D2 d0 ->
    N.add (Npos (XO XH)) (N.mul (Npos (XO (XO (XO (XO XH))))) (uint_to_N d0))
  | D3 d0 ->
    N.add (Npos (XI XH)) (N.mul (Npos (XO (XO (XO (XO XH))))) (uint_to_N d0))
  | D4 d0 ->
    N.add (Npos (XO (XO XH)))
      (N.mul (Npos (XO (XO (XO (XO XH))))) (uint_to_N d0))
  | D5 d0 ->
    N.add (Npos (XI (XO XH)))
      (N.mul (Npos (XO (XO (XO (XO XH))))) (uint_to_N d0))
  | D6 d0 ->
    N.add (Npos (XO (XI XH)))
      (N.mul (Npos (XO (XO (XO (XO XH))))) (uint_to_N d0))
  | D7 d0 ->
    N.add (Npos (XI (XI XH)))
      (N.mul (Npos (XO (XO (XO (XO XH))))) (uint_to_N d0))
  | D8 d0 ->
    N.add (Npos (XO (XO (XO XH))))
      (N.mul (Npos (XO (XO (XO (XO XH))))) (uint_to_N d0))
  | D9 d0 ->
    N.add (Npos (XI (XO (XO XH))))
      (N.mul (Npos (XO (XO (XO (XO XH))))) (uint_to_N d0))
  | Da d0 ->
    N.add (Npos (XO (XI (XO XH))))
      (N.mul (Npos (XO (XO (XO (XO XH))))) (uint_to_N d0))
  | Db d0 ->
    N.add (Npos (XI (XI (XO XH))))
      (N.mul (Npos (XO (XO (XO (XO XH))))) (uint_to_N d0))
  | Dc d0 ->
    N.add (Npos (XO (XO (XI XH))))
      (N.mul (Npos (XO (XO (XO (XO XH))))) (uint_to_N d0))
  | Dd d0 ->
    N.add (Npos (XI (XO (XI XH))))
      (N.mul (Npos (XO (XO (XO (XO XH))))) (uint_to_N d0))
  | De d0 ->
    N.add (Npos (XO (XI (XI XH))))
      (N.mul (Npos (XO (XO (XO (XO XH))))) (uint_to_N d0))
  | Df d0 ->
    N.add (Npos (XI (XI (XI XH))))
      (N.mul (Npos (XO (XO (XO (XO XH))))) (uint_to_N d0))

  (** val parseHexNumber' : char list -> uint -> uint option **)

  let rec parseHexNumber' x acc =
    match x with
    | [] -> Some acc
    | a::xs ->
      (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
        (fun b b0 b1 b2 b3 b4 b5 b6 ->
        if b
        then if b0
             then if b1
                  then if b2
                       then None
                       else if b3
                            then if b4
                                 then if b5
                                      then None
                                      else if b6
                                           then None
                                           else parseHexNumber' xs (D7 acc)
                                 else None
                            else None
                  else if b2
                       then None
                       else if b3
                            then if b4
                                 then if b5
                                      then None
                                      else if b6
                                           then None
                                           else parseHexNumber' xs (D3 acc)
                                 else None
                            else if b5
                                 then if b6
                                      then None
                                      else parseHexNumber' xs (Dc acc)
                                 else None
             else if b1
                  then if b2
                       then None
                       else if b3
                            then if b4
                                 then if b5
                                      then None
                                      else if b6
                                           then None
                                           else parseHexNumber' xs (D5 acc)
                                 else None
                            else if b5
                                 then if b6
                                      then None
                                      else parseHexNumber' xs (De acc)
                                 else None
                  else if b2
                       then if b3
                            then if b4
                                 then if b5
                                      then None
                                      else if b6
                                           then None
                                           else parseHexNumber' xs (D9 acc)
                                 else None
                            else None
                       else if b3
                            then if b4
                                 then if b5
                                      then None
                                      else if b6
                                           then None
                                           else parseHexNumber' xs (D1 acc)
                                 else None
                            else if b5
                                 then if b6
                                      then None
                                      else parseHexNumber' xs (Da acc)
                                 else None
        else if b0
             then if b1
                  then if b2
                       then None
                       else if b3
                            then if b4
                                 then if b5
                                      then None
                                      else if b6
                                           then None
                                           else parseHexNumber' xs (D6 acc)
                                 else None
                            else if b5
                                 then if b6
                                      then None
                                      else parseHexNumber' xs (Df acc)
                                 else None
                  else if b2
                       then None
                       else if b3
                            then if b4
                                 then if b5
                                      then None
                                      else if b6
                                           then None
                                           else parseHexNumber' xs (D2 acc)
                                 else None
                            else if b5
                                 then if b6
                                      then None
                                      else parseHexNumber' xs (Db acc)
                                 else None
             else if b1
                  then if b2
                       then None
                       else if b3
                            then if b4
                                 then if b5
                                      then None
                                      else if b6
                                           then None
                                           else parseHexNumber' xs (D4 acc)
                                 else None
                            else if b5
                                 then if b6
                                      then None
                                      else parseHexNumber' xs (Dd acc)
                                 else None
                  else if b2
                       then if b3
                            then if b4
                                 then if b5
                                      then None
                                      else if b6
                                           then None
                                           else parseHexNumber' xs (D8 acc)
                                 else None
                            else None
                       else if b3
                            then if b4
                                 then if b5
                                      then None
                                      else if b6
                                           then None
                                           else parseHexNumber' xs (D0 acc)
                                 else None
                            else None)
        a

  (** val parseHexNumber : char list -> n option **)

  let parseHexNumber x =
    let xl = list_of_string x in
    (match xl with
     | [] -> None
     | a::l ->
       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
         (fun b b0 b1 b2 b3 b4 b5 b6 ->
         if b
         then None
         else if b0
              then None
              else if b1
                   then None
                   else if b2
                        then None
                        else if b3
                             then if b4
                                  then if b5
                                       then None
                                       else if b6
                                            then None
                                            else (match l with
                                                  | [] -> None
                                                  | a0::xs ->
                                                    (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                      (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                      if b7
                                                      then None
                                                      else if b8
                                                           then None
                                                           else if b9
                                                                then None
                                                                else if b10
                                                                     then 
                                                                       if b11
                                                                       then 
                                                                       if b12
                                                                       then 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match 
                                                                       parseHexNumber'
                                                                       xs Nil with
                                                                       | Some n0 ->
                                                                       Some
                                                                       (uint_to_N
                                                                       n0)
                                                                       | None ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                     else None)
                                                      a0)
                                  else None
                             else None)
         a)

  (** val parseDecNumber' : char list -> nat -> nat option **)

  let rec parseDecNumber' x acc =
    match x with
    | [] -> Some acc
    | d::ds ->
      let n0 = nat_of_ascii d in
      if if Nat.leb (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
              (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
              (S (S (S (S (S (S
              O)))))))))))))))))))))))))))))))))))))))))))))))) n0
         then Nat.leb n0 (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                O)))))))))))))))))))))))))))))))))))))))))))))))))))))))))
         else false
      then parseDecNumber' ds
             (add (mul (S (S (S (S (S (S (S (S (S (S O)))))))))) acc)
               (sub n0 (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                 (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                 (S (S (S (S (S (S (S (S
                 O))))))))))))))))))))))))))))))))))))))))))))))))))
      else None

  (** val parseDecNumber : char list -> nat option **)

  let parseDecNumber x =
    parseDecNumber' (list_of_string x) O

  (** val is_push : char list -> nat option **)

  let is_push s =
    match list_of_string s with
    | [] -> None
    | a::l ->
      (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
        (fun b b0 b1 b2 b3 b4 b5 b6 ->
        if b
        then None
        else if b0
             then None
             else if b1
                  then None
                  else if b2
                       then None
                       else if b3
                            then if b4
                                 then None
                                 else if b5
                                      then if b6
                                           then None
                                           else (match l with
                                                 | [] -> None
                                                 | a0::l0 ->
                                                   (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                     (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                     if b7
                                                     then if b8
                                                          then None
                                                          else if b9
                                                               then if b10
                                                                    then None
                                                                    else 
                                                                      if b11
                                                                      then 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match l0 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::l1 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match l1 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::xs ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then None
                                                                       else 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then None
                                                                       else 
                                                                       if b26
                                                                       then 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match 
                                                                       parseDecNumber'
                                                                       xs O with
                                                                       | Some n0 ->
                                                                       if 
                                                                       if 
                                                                       Nat.leb
                                                                       (S O) n0
                                                                       then 
                                                                       Nat.leb
                                                                       n0 (S (S
                                                                       (S (S (S
                                                                       (S (S (S
                                                                       (S (S (S
                                                                       (S (S (S
                                                                       (S (S (S
                                                                       (S (S (S
                                                                       (S (S (S
                                                                       (S (S (S
                                                                       (S (S (S
                                                                       (S (S (S
                                                                       O))))))))))))))))))))))))))))))))
                                                                       else false
                                                                       then 
                                                                       Some n0
                                                                       else None
                                                                       | None ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                      else None
                                                               else None
                                                     else None)
                                                     a0)
                                      else None
                            else None)
        a

  (** val is_dup : char list -> nat option **)

  let is_dup s =
    match list_of_string s with
    | [] -> None
    | a::l ->
      (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
        (fun b b0 b1 b2 b3 b4 b5 b6 ->
        if b
        then None
        else if b0
             then None
             else if b1
                  then if b2
                       then None
                       else if b3
                            then None
                            else if b4
                                 then None
                                 else if b5
                                      then if b6
                                           then None
                                           else (match l with
                                                 | [] -> None
                                                 | a0::l0 ->
                                                   (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                     (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                     if b7
                                                     then if b8
                                                          then None
                                                          else if b9
                                                               then if b10
                                                                    then None
                                                                    else 
                                                                      if b11
                                                                      then 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match l0 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::xs ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match 
                                                                       parseDecNumber'
                                                                       xs O with
                                                                       | Some n0 ->
                                                                       if 
                                                                       if 
                                                                       Nat.leb
                                                                       (S O) n0
                                                                       then 
                                                                       Nat.leb
                                                                       n0 (S (S
                                                                       (S (S (S
                                                                       (S (S (S
                                                                       (S (S (S
                                                                       (S (S (S
                                                                       (S (S
                                                                       O))))))))))))))))
                                                                       else false
                                                                       then 
                                                                       Some n0
                                                                       else None
                                                                       | None ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                      else None
                                                               else None
                                                     else None)
                                                     a0)
                                      else None
                  else None)
        a

  (** val is_swap : char list -> nat option **)

  let is_swap s =
    match list_of_string s with
    | [] -> None
    | a::l ->
      (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
        (fun b b0 b1 b2 b3 b4 b5 b6 ->
        if b
        then if b0
             then if b1
                  then None
                  else if b2
                       then None
                       else if b3
                            then if b4
                                 then None
                                 else if b5
                                      then if b6
                                           then None
                                           else (match l with
                                                 | [] -> None
                                                 | a0::l0 ->
                                                   (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                     (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                     if b7
                                                     then if b8
                                                          then if b9
                                                               then if b10
                                                                    then None
                                                                    else 
                                                                      if b11
                                                                      then 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match l0 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::l1 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match l1 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::xs ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then None
                                                                       else 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then None
                                                                       else 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match 
                                                                       parseDecNumber'
                                                                       xs O with
                                                                       | Some n0 ->
                                                                       if 
                                                                       if 
                                                                       Nat.leb
                                                                       (S O) n0
                                                                       then 
                                                                       Nat.leb
                                                                       n0 (S (S
                                                                       (S (S (S
                                                                       (S (S (S
                                                                       (S (S (S
                                                                       (S (S (S
                                                                       (S (S
                                                                       O))))))))))))))))
                                                                       else false
                                                                       then 
                                                                       Some n0
                                                                       else None
                                                                       | None ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                      else None
                                                               else None
                                                          else None
                                                     else None)
                                                     a0)
                                      else None
                            else None
             else None
        else None)
        a

  (** val parse_non_push_instr : char list -> Concrete.instr option **)

  let parse_non_push_instr s =
    match is_dup s with
    | Some n0 -> Some (Concrete.DUP n0)
    | None ->
      (match is_swap s with
       | Some n0 -> Some (Concrete.SWAP n0)
       | None ->
         (match s with
          | [] -> None
          | a::s0 ->
            (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
              (fun b b0 b1 b2 b3 b4 b5 b6 ->
              if b
              then if b0
                   then if b1
                        then if b2
                             then if b3
                                  then None
                                  else if b4
                                       then None
                                       else if b5
                                            then if b6
                                                 then None
                                                 else (match s0 with
                                                       | [] -> None
                                                       | a0::s1 ->
                                                         (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                           (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                           if b7
                                                           then None
                                                           else if b8
                                                                then if b9
                                                                     then None
                                                                     else 
                                                                       if b10
                                                                       then None
                                                                       else 
                                                                       if b11
                                                                       then 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.OR)
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then 
                                                                       if b25
                                                                       then 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then 
                                                                       if b32
                                                                       then None
                                                                       else 
                                                                       if b33
                                                                       then None
                                                                       else 
                                                                       if b34
                                                                       then 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then None
                                                                       else 
                                                                       if b40
                                                                       then 
                                                                       if b41
                                                                       then 
                                                                       if b42
                                                                       then 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.ORIGIN)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                                else None)
                                                           a0)
                                            else None
                             else if b3
                                  then None
                                  else if b4
                                       then None
                                       else if b5
                                            then if b6
                                                 then None
                                                 else (match s0 with
                                                       | [] -> None
                                                       | a0::s1 ->
                                                         (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                           (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                           if b7
                                                           then if b8
                                                                then None
                                                                else if b9
                                                                     then None
                                                                     else 
                                                                       if b10
                                                                       then None
                                                                       else 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.GAS)
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then None
                                                                       else 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then 
                                                                       if b26
                                                                       then 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then 
                                                                       if b32
                                                                       then None
                                                                       else 
                                                                       if b33
                                                                       then None
                                                                       else 
                                                                       if b34
                                                                       then 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then 
                                                                       if b40
                                                                       then None
                                                                       else 
                                                                       if b41
                                                                       then 
                                                                       if b42
                                                                       then 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then 
                                                                       if b48
                                                                       then None
                                                                       else 
                                                                       if b49
                                                                       then None
                                                                       else 
                                                                       if b50
                                                                       then 
                                                                       if b51
                                                                       then None
                                                                       else 
                                                                       if b52
                                                                       then None
                                                                       else 
                                                                       if b53
                                                                       then 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       None
                                                                       | a6::s7 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b55 b56 b57 b58 b59 b60 b61 b62 ->
                                                                       if b55
                                                                       then None
                                                                       else 
                                                                       if b56
                                                                       then None
                                                                       else 
                                                                       if b57
                                                                       then 
                                                                       if b58
                                                                       then None
                                                                       else 
                                                                       if b59
                                                                       then 
                                                                       if b60
                                                                       then None
                                                                       else 
                                                                       if b61
                                                                       then 
                                                                       if b62
                                                                       then None
                                                                       else 
                                                                       (match s7 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.GASLIMIT)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a6)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then None
                                                                       else 
                                                                       if b32
                                                                       then 
                                                                       if b33
                                                                       then None
                                                                       else 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then 
                                                                       if b40
                                                                       then None
                                                                       else 
                                                                       if b41
                                                                       then None
                                                                       else 
                                                                       if b42
                                                                       then 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then 
                                                                       if b48
                                                                       then 
                                                                       if b49
                                                                       then None
                                                                       else 
                                                                       if b50
                                                                       then None
                                                                       else 
                                                                       if b51
                                                                       then None
                                                                       else 
                                                                       if b52
                                                                       then None
                                                                       else 
                                                                       if b53
                                                                       then 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       None
                                                                       | a6::s7 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b55 b56 b57 b58 b59 b60 b61 b62 ->
                                                                       if b55
                                                                       then 
                                                                       if b56
                                                                       then None
                                                                       else 
                                                                       if b57
                                                                       then 
                                                                       if b58
                                                                       then None
                                                                       else 
                                                                       if b59
                                                                       then None
                                                                       else 
                                                                       if b60
                                                                       then None
                                                                       else 
                                                                       if b61
                                                                       then 
                                                                       if b62
                                                                       then None
                                                                       else 
                                                                       (match s7 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.GASPRICE)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a6)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                           else if b8
                                                                then None
                                                                else if b9
                                                                     then 
                                                                       if b10
                                                                       then None
                                                                       else 
                                                                       if b11
                                                                       then 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.GT)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                     else None)
                                                           a0)
                                            else None
                        else if b2
                             then if b3
                                  then None
                                  else if b4
                                       then None
                                       else if b5
                                            then if b6
                                                 then None
                                                 else (match s0 with
                                                       | [] -> None
                                                       | a0::s1 ->
                                                         (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                           (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                           if b7
                                                           then if b8
                                                                then None
                                                                else if b9
                                                                     then 
                                                                       if b10
                                                                       then None
                                                                       else 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then 
                                                                       if b25
                                                                       then None
                                                                       else 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then 
                                                                       if b32
                                                                       then None
                                                                       else 
                                                                       if b33
                                                                       then None
                                                                       else 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then 
                                                                       if b40
                                                                       then 
                                                                       if b41
                                                                       then None
                                                                       else 
                                                                       if b42
                                                                       then 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then None
                                                                       else 
                                                                       if b48
                                                                       then 
                                                                       if b49
                                                                       then None
                                                                       else 
                                                                       if b50
                                                                       then None
                                                                       else 
                                                                       if b51
                                                                       then 
                                                                       if b52
                                                                       then 
                                                                       if b53
                                                                       then None
                                                                       else 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       None
                                                                       | a6::s7 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b55 b56 b57 b58 b59 b60 b61 b62 ->
                                                                       if b55
                                                                       then 
                                                                       if b56
                                                                       then None
                                                                       else 
                                                                       if b57
                                                                       then 
                                                                       if b58
                                                                       then None
                                                                       else 
                                                                       if b59
                                                                       then 
                                                                       if b60
                                                                       then 
                                                                       if b61
                                                                       then None
                                                                       else 
                                                                       if b62
                                                                       then None
                                                                       else 
                                                                       (match s7 with
                                                                       | [] ->
                                                                       None
                                                                       | a7::s8 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b63 b64 b65 b66 b67 b68 b69 b70 ->
                                                                       if b63
                                                                       then None
                                                                       else 
                                                                       if b64
                                                                       then 
                                                                       if b65
                                                                       then 
                                                                       if b66
                                                                       then None
                                                                       else 
                                                                       if b67
                                                                       then 
                                                                       if b68
                                                                       then 
                                                                       if b69
                                                                       then None
                                                                       else 
                                                                       if b70
                                                                       then None
                                                                       else 
                                                                       (match s8 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.KECCAK256)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a7)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a6)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                     else None
                                                           else None)
                                                           a0)
                                            else None
                             else if b3
                                  then if b4
                                       then None
                                       else if b5
                                            then if b6
                                                 then None
                                                 else (match s0 with
                                                       | [] -> None
                                                       | a0::s1 ->
                                                         (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                           (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                           if b7
                                                           then if b8
                                                                then if b9
                                                                     then 
                                                                       if b10
                                                                       then None
                                                                       else 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.SGT)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                     else None
                                                                else if b9
                                                                     then 
                                                                       if b10
                                                                       then 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then None
                                                                       else 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.SMOD)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else 
                                                                       if b11
                                                                       then 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.SUB)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then None
                                                                       else 
                                                                       if b24
                                                                       then 
                                                                       if b25
                                                                       then 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then None
                                                                       else 
                                                                       if b32
                                                                       then 
                                                                       if b33
                                                                       then None
                                                                       else 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then 
                                                                       if b40
                                                                       then None
                                                                       else 
                                                                       if b41
                                                                       then None
                                                                       else 
                                                                       if b42
                                                                       then None
                                                                       else 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then None
                                                                       else 
                                                                       if b48
                                                                       then None
                                                                       else 
                                                                       if b49
                                                                       then 
                                                                       if b50
                                                                       then 
                                                                       if b51
                                                                       then None
                                                                       else 
                                                                       if b52
                                                                       then None
                                                                       else 
                                                                       if b53
                                                                       then 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       None
                                                                       | a6::s7 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b55 b56 b57 b58 b59 b60 b61 b62 ->
                                                                       if b55
                                                                       then 
                                                                       if b56
                                                                       then None
                                                                       else 
                                                                       if b57
                                                                       then None
                                                                       else 
                                                                       if b58
                                                                       then None
                                                                       else 
                                                                       if b59
                                                                       then None
                                                                       else 
                                                                       if b60
                                                                       then None
                                                                       else 
                                                                       if b61
                                                                       then 
                                                                       if b62
                                                                       then None
                                                                       else 
                                                                       (match s7 with
                                                                       | [] ->
                                                                       None
                                                                       | a7::s8 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b63 b64 b65 b66 b67 b68 b69 b70 ->
                                                                       if b63
                                                                       then None
                                                                       else 
                                                                       if b64
                                                                       then 
                                                                       if b65
                                                                       then 
                                                                       if b66
                                                                       then 
                                                                       if b67
                                                                       then None
                                                                       else 
                                                                       if b68
                                                                       then None
                                                                       else 
                                                                       if b69
                                                                       then 
                                                                       if b70
                                                                       then None
                                                                       else 
                                                                       (match s8 with
                                                                       | [] ->
                                                                       None
                                                                       | a8::s9 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b71 b72 b73 b74 b75 b76 b77 b78 ->
                                                                       if b71
                                                                       then 
                                                                       if b72
                                                                       then 
                                                                       if b73
                                                                       then None
                                                                       else 
                                                                       if b74
                                                                       then None
                                                                       else 
                                                                       if b75
                                                                       then None
                                                                       else 
                                                                       if b76
                                                                       then None
                                                                       else 
                                                                       if b77
                                                                       then 
                                                                       if b78
                                                                       then None
                                                                       else 
                                                                       (match s9 with
                                                                       | [] ->
                                                                       None
                                                                       | a9::s10 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b79 b80 b81 b82 b83 b84 b85 b86 ->
                                                                       if b79
                                                                       then 
                                                                       if b80
                                                                       then None
                                                                       else 
                                                                       if b81
                                                                       then 
                                                                       if b82
                                                                       then None
                                                                       else 
                                                                       if b83
                                                                       then None
                                                                       else 
                                                                       if b84
                                                                       then None
                                                                       else 
                                                                       if b85
                                                                       then 
                                                                       if b86
                                                                       then None
                                                                       else 
                                                                       (match s10 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.SELFBALANCE)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a9)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a8)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a7)
                                                                       else None
                                                                       else None)
                                                                       a6)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                     else 
                                                                       if b10
                                                                       then 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then None
                                                                       else 
                                                                       if b24
                                                                       then 
                                                                       if b25
                                                                       then 
                                                                       if b26
                                                                       then 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then 
                                                                       if b32
                                                                       then None
                                                                       else 
                                                                       if b33
                                                                       then 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then None
                                                                       else 
                                                                       if b40
                                                                       then None
                                                                       else 
                                                                       if b41
                                                                       then None
                                                                       else 
                                                                       if b42
                                                                       then 
                                                                       if b43
                                                                       then 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then None
                                                                       else 
                                                                       if b48
                                                                       then None
                                                                       else 
                                                                       if b49
                                                                       then 
                                                                       if b50
                                                                       then None
                                                                       else 
                                                                       if b51
                                                                       then 
                                                                       if b52
                                                                       then None
                                                                       else 
                                                                       if b53
                                                                       then 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       None
                                                                       | a6::s7 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b55 b56 b57 b58 b59 b60 b61 b62 ->
                                                                       if b55
                                                                       then 
                                                                       if b56
                                                                       then None
                                                                       else 
                                                                       if b57
                                                                       then 
                                                                       if b58
                                                                       then None
                                                                       else 
                                                                       if b59
                                                                       then None
                                                                       else 
                                                                       if b60
                                                                       then None
                                                                       else 
                                                                       if b61
                                                                       then 
                                                                       if b62
                                                                       then None
                                                                       else 
                                                                       (match s7 with
                                                                       | [] ->
                                                                       None
                                                                       | a7::s8 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b63 b64 b65 b66 b67 b68 b69 b70 ->
                                                                       if b63
                                                                       then None
                                                                       else 
                                                                       if b64
                                                                       then 
                                                                       if b65
                                                                       then 
                                                                       if b66
                                                                       then 
                                                                       if b67
                                                                       then None
                                                                       else 
                                                                       if b68
                                                                       then None
                                                                       else 
                                                                       if b69
                                                                       then 
                                                                       if b70
                                                                       then None
                                                                       else 
                                                                       (match s8 with
                                                                       | [] ->
                                                                       None
                                                                       | a8::s9 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b71 b72 b73 b74 b75 b76 b77 b78 ->
                                                                       if b71
                                                                       then None
                                                                       else 
                                                                       if b72
                                                                       then None
                                                                       else 
                                                                       if b73
                                                                       then 
                                                                       if b74
                                                                       then None
                                                                       else 
                                                                       if b75
                                                                       then None
                                                                       else 
                                                                       if b76
                                                                       then None
                                                                       else 
                                                                       if b77
                                                                       then 
                                                                       if b78
                                                                       then None
                                                                       else 
                                                                       (match s9 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.SIGNEXTEND)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a8)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a7)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a6)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.SAR)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                           else if b8
                                                                then None
                                                                else if b9
                                                                     then 
                                                                       if b10
                                                                       then 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then None
                                                                       else 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then None
                                                                       else 
                                                                       if b32
                                                                       then None
                                                                       else 
                                                                       if b33
                                                                       then 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.SLOAD)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.SLT)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then None
                                                                       else 
                                                                       if b24
                                                                       then 
                                                                       if b25
                                                                       then 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.SDIV)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                     else 
                                                                       if b10
                                                                       then 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then 
                                                                       if b25
                                                                       then None
                                                                       else 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then 
                                                                       if b28
                                                                       then 
                                                                       if b29
                                                                       then None
                                                                       else 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.SHA3)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else 
                                                                       if b16
                                                                       then 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.SHR)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.SHL)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None)
                                                           a0)
                                            else None
                                  else if b4
                                       then None
                                       else if b5
                                            then if b6
                                                 then None
                                                 else (match s0 with
                                                       | [] -> None
                                                       | a0::s1 ->
                                                         (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                           (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                           if b7
                                                           then if b8
                                                                then if b9
                                                                     then 
                                                                       if b10
                                                                       then 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then None
                                                                       else 
                                                                       if b24
                                                                       then 
                                                                       if b25
                                                                       then 
                                                                       if b26
                                                                       then 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then None
                                                                       else 
                                                                       if b32
                                                                       then 
                                                                       if b33
                                                                       then None
                                                                       else 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then 
                                                                       if b40
                                                                       then None
                                                                       else 
                                                                       if b41
                                                                       then None
                                                                       else 
                                                                       if b42
                                                                       then None
                                                                       else 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then 
                                                                       if b48
                                                                       then 
                                                                       if b49
                                                                       then None
                                                                       else 
                                                                       if b50
                                                                       then None
                                                                       else 
                                                                       if b51
                                                                       then 
                                                                       if b52
                                                                       then None
                                                                       else 
                                                                       if b53
                                                                       then 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       None
                                                                       | a6::s7 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b55 b56 b57 b58 b59 b60 b61 b62 ->
                                                                       if b55
                                                                       then 
                                                                       if b56
                                                                       then None
                                                                       else 
                                                                       if b57
                                                                       then 
                                                                       if b58
                                                                       then None
                                                                       else 
                                                                       if b59
                                                                       then None
                                                                       else 
                                                                       if b60
                                                                       then None
                                                                       else 
                                                                       if b61
                                                                       then 
                                                                       if b62
                                                                       then None
                                                                       else 
                                                                       (match s7 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.COINBASE)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a6)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then 
                                                                       if b32
                                                                       then 
                                                                       if b33
                                                                       then None
                                                                       else 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then 
                                                                       if b40
                                                                       then None
                                                                       else 
                                                                       if b41
                                                                       then None
                                                                       else 
                                                                       if b42
                                                                       then 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then None
                                                                       else 
                                                                       if b48
                                                                       then 
                                                                       if b49
                                                                       then None
                                                                       else 
                                                                       if b50
                                                                       then 
                                                                       if b51
                                                                       then 
                                                                       if b52
                                                                       then None
                                                                       else 
                                                                       if b53
                                                                       then 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       None
                                                                       | a6::s7 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b55 b56 b57 b58 b59 b60 b61 b62 ->
                                                                       if b55
                                                                       then 
                                                                       if b56
                                                                       then None
                                                                       else 
                                                                       if b57
                                                                       then 
                                                                       if b58
                                                                       then None
                                                                       else 
                                                                       if b59
                                                                       then None
                                                                       else 
                                                                       if b60
                                                                       then None
                                                                       else 
                                                                       if b61
                                                                       then 
                                                                       if b62
                                                                       then None
                                                                       else 
                                                                       (match s7 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.CODESIZE)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a6)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                                     else None
                                                                else if b9
                                                                     then None
                                                                     else 
                                                                       if b10
                                                                       then None
                                                                       else 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then None
                                                                       else 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then 
                                                                       if b26
                                                                       then 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then 
                                                                       if b32
                                                                       then None
                                                                       else 
                                                                       if b33
                                                                       then 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then None
                                                                       else 
                                                                       if b40
                                                                       then 
                                                                       if b41
                                                                       then None
                                                                       else 
                                                                       if b42
                                                                       then None
                                                                       else 
                                                                       if b43
                                                                       then 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.CALLER)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else 
                                                                       if b32
                                                                       then 
                                                                       if b33
                                                                       then 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then 
                                                                       if b40
                                                                       then None
                                                                       else 
                                                                       if b41
                                                                       then None
                                                                       else 
                                                                       if b42
                                                                       then None
                                                                       else 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then None
                                                                       else 
                                                                       if b48
                                                                       then None
                                                                       else 
                                                                       if b49
                                                                       then 
                                                                       if b50
                                                                       then 
                                                                       if b51
                                                                       then None
                                                                       else 
                                                                       if b52
                                                                       then None
                                                                       else 
                                                                       if b53
                                                                       then 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       None
                                                                       | a6::s7 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b55 b56 b57 b58 b59 b60 b61 b62 ->
                                                                       if b55
                                                                       then 
                                                                       if b56
                                                                       then None
                                                                       else 
                                                                       if b57
                                                                       then 
                                                                       if b58
                                                                       then None
                                                                       else 
                                                                       if b59
                                                                       then 
                                                                       if b60
                                                                       then None
                                                                       else 
                                                                       if b61
                                                                       then 
                                                                       if b62
                                                                       then None
                                                                       else 
                                                                       (match s7 with
                                                                       | [] ->
                                                                       None
                                                                       | a7::s8 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b63 b64 b65 b66 b67 b68 b69 b70 ->
                                                                       if b63
                                                                       then 
                                                                       if b64
                                                                       then None
                                                                       else 
                                                                       if b65
                                                                       then 
                                                                       if b66
                                                                       then None
                                                                       else 
                                                                       if b67
                                                                       then None
                                                                       else 
                                                                       if b68
                                                                       then None
                                                                       else 
                                                                       if b69
                                                                       then 
                                                                       if b70
                                                                       then None
                                                                       else 
                                                                       (match s8 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.CALLVALUE)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a7)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a6)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else 
                                                                       if b33
                                                                       then 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then 
                                                                       if b40
                                                                       then None
                                                                       else 
                                                                       if b41
                                                                       then None
                                                                       else 
                                                                       if b42
                                                                       then None
                                                                       else 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then None
                                                                       else 
                                                                       if b48
                                                                       then None
                                                                       else 
                                                                       if b49
                                                                       then 
                                                                       if b50
                                                                       then None
                                                                       else 
                                                                       if b51
                                                                       then 
                                                                       if b52
                                                                       then None
                                                                       else 
                                                                       if b53
                                                                       then 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       None
                                                                       | a6::s7 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b55 b56 b57 b58 b59 b60 b61 b62 ->
                                                                       if b55
                                                                       then 
                                                                       if b56
                                                                       then None
                                                                       else 
                                                                       if b57
                                                                       then None
                                                                       else 
                                                                       if b58
                                                                       then None
                                                                       else 
                                                                       if b59
                                                                       then None
                                                                       else 
                                                                       if b60
                                                                       then None
                                                                       else 
                                                                       if b61
                                                                       then 
                                                                       if b62
                                                                       then None
                                                                       else 
                                                                       (match s7 with
                                                                       | [] ->
                                                                       None
                                                                       | a7::s8 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b63 b64 b65 b66 b67 b68 b69 b70 ->
                                                                       if b63
                                                                       then 
                                                                       if b64
                                                                       then 
                                                                       if b65
                                                                       then None
                                                                       else 
                                                                       if b66
                                                                       then None
                                                                       else 
                                                                       if b67
                                                                       then 
                                                                       if b68
                                                                       then None
                                                                       else 
                                                                       if b69
                                                                       then 
                                                                       if b70
                                                                       then None
                                                                       else 
                                                                       (match s8 with
                                                                       | [] ->
                                                                       None
                                                                       | a8::s9 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b71 b72 b73 b74 b75 b76 b77 b78 ->
                                                                       if b71
                                                                       then 
                                                                       if b72
                                                                       then None
                                                                       else 
                                                                       if b73
                                                                       then None
                                                                       else 
                                                                       if b74
                                                                       then 
                                                                       if b75
                                                                       then None
                                                                       else 
                                                                       if b76
                                                                       then None
                                                                       else 
                                                                       if b77
                                                                       then 
                                                                       if b78
                                                                       then None
                                                                       else 
                                                                       (match s9 with
                                                                       | [] ->
                                                                       None
                                                                       | a9::s10 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b79 b80 b81 b82 b83 b84 b85 b86 ->
                                                                       if b79
                                                                       then None
                                                                       else 
                                                                       if b80
                                                                       then 
                                                                       if b81
                                                                       then None
                                                                       else 
                                                                       if b82
                                                                       then 
                                                                       if b83
                                                                       then 
                                                                       if b84
                                                                       then None
                                                                       else 
                                                                       if b85
                                                                       then 
                                                                       if b86
                                                                       then None
                                                                       else 
                                                                       (match s10 with
                                                                       | [] ->
                                                                       None
                                                                       | a10::s11 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b87 b88 b89 b90 b91 b92 b93 b94 ->
                                                                       if b87
                                                                       then 
                                                                       if b88
                                                                       then None
                                                                       else 
                                                                       if b89
                                                                       then 
                                                                       if b90
                                                                       then None
                                                                       else 
                                                                       if b91
                                                                       then None
                                                                       else 
                                                                       if b92
                                                                       then None
                                                                       else 
                                                                       if b93
                                                                       then 
                                                                       if b94
                                                                       then None
                                                                       else 
                                                                       (match s11 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.CALLDATASIZE)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a10)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a9)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a8)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else 
                                                                       if b64
                                                                       then None
                                                                       else 
                                                                       if b65
                                                                       then 
                                                                       if b66
                                                                       then 
                                                                       if b67
                                                                       then None
                                                                       else 
                                                                       if b68
                                                                       then None
                                                                       else 
                                                                       if b69
                                                                       then 
                                                                       if b70
                                                                       then None
                                                                       else 
                                                                       (match s8 with
                                                                       | [] ->
                                                                       None
                                                                       | a8::s9 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b71 b72 b73 b74 b75 b76 b77 b78 ->
                                                                       if b71
                                                                       then 
                                                                       if b72
                                                                       then 
                                                                       if b73
                                                                       then 
                                                                       if b74
                                                                       then 
                                                                       if b75
                                                                       then None
                                                                       else 
                                                                       if b76
                                                                       then None
                                                                       else 
                                                                       if b77
                                                                       then 
                                                                       if b78
                                                                       then None
                                                                       else 
                                                                       (match s9 with
                                                                       | [] ->
                                                                       None
                                                                       | a9::s10 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b79 b80 b81 b82 b83 b84 b85 b86 ->
                                                                       if b79
                                                                       then 
                                                                       if b80
                                                                       then None
                                                                       else 
                                                                       if b81
                                                                       then None
                                                                       else 
                                                                       if b82
                                                                       then None
                                                                       else 
                                                                       if b83
                                                                       then None
                                                                       else 
                                                                       if b84
                                                                       then None
                                                                       else 
                                                                       if b85
                                                                       then 
                                                                       if b86
                                                                       then None
                                                                       else 
                                                                       (match s10 with
                                                                       | [] ->
                                                                       None
                                                                       | a10::s11 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b87 b88 b89 b90 b91 b92 b93 b94 ->
                                                                       if b87
                                                                       then None
                                                                       else 
                                                                       if b88
                                                                       then None
                                                                       else 
                                                                       if b89
                                                                       then 
                                                                       if b90
                                                                       then None
                                                                       else 
                                                                       if b91
                                                                       then None
                                                                       else 
                                                                       if b92
                                                                       then None
                                                                       else 
                                                                       if b93
                                                                       then 
                                                                       if b94
                                                                       then None
                                                                       else 
                                                                       (match s11 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.CALLDATALOAD)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a10)
                                                                       else None
                                                                       else None)
                                                                       a9)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a8)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a7)
                                                                       else None
                                                                       else None)
                                                                       a6)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                           else if b8
                                                                then if b9
                                                                     then None
                                                                     else 
                                                                       if b10
                                                                       then None
                                                                       else 
                                                                       if b11
                                                                       then 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then None
                                                                       else 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then None
                                                                       else 
                                                                       if b32
                                                                       then None
                                                                       else 
                                                                       if b33
                                                                       then 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then 
                                                                       if b40
                                                                       then None
                                                                       else 
                                                                       if b41
                                                                       then 
                                                                       if b42
                                                                       then None
                                                                       else 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.CREATE)
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then None
                                                                       else 
                                                                       if b48
                                                                       then 
                                                                       if b49
                                                                       then None
                                                                       else 
                                                                       if b50
                                                                       then None
                                                                       else 
                                                                       if b51
                                                                       then 
                                                                       if b52
                                                                       then 
                                                                       if b53
                                                                       then None
                                                                       else 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.CREATE2)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                                else if b9
                                                                     then None
                                                                     else 
                                                                       if b10
                                                                       then 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then None
                                                                       else 
                                                                       if b26
                                                                       then 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then None
                                                                       else 
                                                                       if b32
                                                                       then 
                                                                       if b33
                                                                       then 
                                                                       if b34
                                                                       then 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then 
                                                                       if b40
                                                                       then None
                                                                       else 
                                                                       if b41
                                                                       then None
                                                                       else 
                                                                       if b42
                                                                       then 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then None
                                                                       else 
                                                                       if b48
                                                                       then None
                                                                       else 
                                                                       if b49
                                                                       then 
                                                                       if b50
                                                                       then None
                                                                       else 
                                                                       if b51
                                                                       then None
                                                                       else 
                                                                       if b52
                                                                       then None
                                                                       else 
                                                                       if b53
                                                                       then 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.CHAINID)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None)
                                                           a0)
                                            else None
                   else if b1
                        then if b2
                             then if b3
                                  then None
                                  else if b4
                                       then None
                                       else if b5
                                            then if b6
                                                 then None
                                                 else (match s0 with
                                                       | [] -> None
                                                       | a0::s1 ->
                                                         (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                           (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                           if b7
                                                           then if b8
                                                                then if b9
                                                                     then 
                                                                       if b10
                                                                       then 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.MOD)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                                     else 
                                                                       if b10
                                                                       then None
                                                                       else 
                                                                       if b11
                                                                       then 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then None
                                                                       else 
                                                                       if b24
                                                                       then 
                                                                       if b25
                                                                       then None
                                                                       else 
                                                                       if b26
                                                                       then 
                                                                       if b27
                                                                       then 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then 
                                                                       if b32
                                                                       then None
                                                                       else 
                                                                       if b33
                                                                       then 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.MSIZE)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                                else if b9
                                                                     then 
                                                                       if b10
                                                                       then None
                                                                       else 
                                                                       if b11
                                                                       then 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.MUL)
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then 
                                                                       if b26
                                                                       then 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then 
                                                                       if b32
                                                                       then 
                                                                       if b33
                                                                       then 
                                                                       if b34
                                                                       then 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then None
                                                                       else 
                                                                       if b40
                                                                       then None
                                                                       else 
                                                                       if b41
                                                                       then 
                                                                       if b42
                                                                       then None
                                                                       else 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.MULMOD)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                                     else None
                                                           else if b8
                                                                then None
                                                                else if b9
                                                                     then 
                                                                       if b10
                                                                       then 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then None
                                                                       else 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then None
                                                                       else 
                                                                       if b32
                                                                       then None
                                                                       else 
                                                                       if b33
                                                                       then 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.MLOAD)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                                     else None)
                                                           a0)
                                            else None
                             else if b3
                                  then None
                                  else if b4
                                       then None
                                       else if b5
                                            then if b6
                                                 then None
                                                 else (match s0 with
                                                       | [] -> None
                                                       | a0::s1 ->
                                                         (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                           (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                           if b7
                                                           then if b8
                                                                then None
                                                                else if b9
                                                                     then None
                                                                     else 
                                                                       if b10
                                                                       then None
                                                                       else 
                                                                       if b11
                                                                       then 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.EQ)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                           else if b8
                                                                then None
                                                                else if b9
                                                                     then None
                                                                     else 
                                                                       if b10
                                                                       then 
                                                                       if b11
                                                                       then 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then 
                                                                       if b25
                                                                       then None
                                                                       else 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then 
                                                                       if b32
                                                                       then 
                                                                       if b33
                                                                       then 
                                                                       if b34
                                                                       then 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then None
                                                                       else 
                                                                       if b40
                                                                       then None
                                                                       else 
                                                                       if b41
                                                                       then 
                                                                       if b42
                                                                       then None
                                                                       else 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then 
                                                                       if b48
                                                                       then None
                                                                       else 
                                                                       if b49
                                                                       then 
                                                                       if b50
                                                                       then None
                                                                       else 
                                                                       if b51
                                                                       then None
                                                                       else 
                                                                       if b52
                                                                       then None
                                                                       else 
                                                                       if b53
                                                                       then 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       None
                                                                       | a6::s7 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b55 b56 b57 b58 b59 b60 b61 b62 ->
                                                                       if b55
                                                                       then 
                                                                       if b56
                                                                       then 
                                                                       if b57
                                                                       then None
                                                                       else 
                                                                       if b58
                                                                       then None
                                                                       else 
                                                                       if b59
                                                                       then 
                                                                       if b60
                                                                       then None
                                                                       else 
                                                                       if b61
                                                                       then 
                                                                       if b62
                                                                       then None
                                                                       else 
                                                                       (match s7 with
                                                                       | [] ->
                                                                       None
                                                                       | a7::s8 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b63 b64 b65 b66 b67 b68 b69 b70 ->
                                                                       if b63
                                                                       then 
                                                                       if b64
                                                                       then None
                                                                       else 
                                                                       if b65
                                                                       then None
                                                                       else 
                                                                       if b66
                                                                       then 
                                                                       if b67
                                                                       then None
                                                                       else 
                                                                       if b68
                                                                       then None
                                                                       else 
                                                                       if b69
                                                                       then 
                                                                       if b70
                                                                       then None
                                                                       else 
                                                                       (match s8 with
                                                                       | [] ->
                                                                       None
                                                                       | a8::s9 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b71 b72 b73 b74 b75 b76 b77 b78 ->
                                                                       if b71
                                                                       then None
                                                                       else 
                                                                       if b72
                                                                       then 
                                                                       if b73
                                                                       then None
                                                                       else 
                                                                       if b74
                                                                       then 
                                                                       if b75
                                                                       then 
                                                                       if b76
                                                                       then None
                                                                       else 
                                                                       if b77
                                                                       then 
                                                                       if b78
                                                                       then None
                                                                       else 
                                                                       (match s9 with
                                                                       | [] ->
                                                                       None
                                                                       | a9::s10 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b79 b80 b81 b82 b83 b84 b85 b86 ->
                                                                       if b79
                                                                       then 
                                                                       if b80
                                                                       then None
                                                                       else 
                                                                       if b81
                                                                       then 
                                                                       if b82
                                                                       then None
                                                                       else 
                                                                       if b83
                                                                       then None
                                                                       else 
                                                                       if b84
                                                                       then None
                                                                       else 
                                                                       if b85
                                                                       then 
                                                                       if b86
                                                                       then None
                                                                       else 
                                                                       (match s10 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.EXTCODESIZE)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a9)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a8)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a7)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else 
                                                                       if b56
                                                                       then None
                                                                       else 
                                                                       if b57
                                                                       then None
                                                                       else 
                                                                       if b58
                                                                       then 
                                                                       if b59
                                                                       then None
                                                                       else 
                                                                       if b60
                                                                       then None
                                                                       else 
                                                                       if b61
                                                                       then 
                                                                       if b62
                                                                       then None
                                                                       else 
                                                                       (match s7 with
                                                                       | [] ->
                                                                       None
                                                                       | a7::s8 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b63 b64 b65 b66 b67 b68 b69 b70 ->
                                                                       if b63
                                                                       then 
                                                                       if b64
                                                                       then None
                                                                       else 
                                                                       if b65
                                                                       then None
                                                                       else 
                                                                       if b66
                                                                       then None
                                                                       else 
                                                                       if b67
                                                                       then None
                                                                       else 
                                                                       if b68
                                                                       then None
                                                                       else 
                                                                       if b69
                                                                       then 
                                                                       if b70
                                                                       then None
                                                                       else 
                                                                       (match s8 with
                                                                       | [] ->
                                                                       None
                                                                       | a8::s9 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b71 b72 b73 b74 b75 b76 b77 b78 ->
                                                                       if b71
                                                                       then 
                                                                       if b72
                                                                       then 
                                                                       if b73
                                                                       then None
                                                                       else 
                                                                       if b74
                                                                       then None
                                                                       else 
                                                                       if b75
                                                                       then 
                                                                       if b76
                                                                       then None
                                                                       else 
                                                                       if b77
                                                                       then 
                                                                       if b78
                                                                       then None
                                                                       else 
                                                                       (match s9 with
                                                                       | [] ->
                                                                       None
                                                                       | a9::s10 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b79 b80 b81 b82 b83 b84 b85 b86 ->
                                                                       if b79
                                                                       then None
                                                                       else 
                                                                       if b80
                                                                       then None
                                                                       else 
                                                                       if b81
                                                                       then None
                                                                       else 
                                                                       if b82
                                                                       then 
                                                                       if b83
                                                                       then None
                                                                       else 
                                                                       if b84
                                                                       then None
                                                                       else 
                                                                       if b85
                                                                       then 
                                                                       if b86
                                                                       then None
                                                                       else 
                                                                       (match s10 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.EXTCODEHASH)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a9)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a8)
                                                                       else None
                                                                       else None)
                                                                       a7)
                                                                       else None
                                                                       else None)
                                                                       a6)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.EXP)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                           a0)
                                            else None
                        else if b2
                             then if b3
                                  then None
                                  else if b4
                                       then None
                                       else if b5
                                            then if b6
                                                 then None
                                                 else (match s0 with
                                                       | [] -> None
                                                       | a0::s1 ->
                                                         (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                           (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                           if b7
                                                           then if b8
                                                                then if b9
                                                                     then None
                                                                     else 
                                                                       if b10
                                                                       then None
                                                                       else 
                                                                       if b11
                                                                       then 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then 
                                                                       if b19
                                                                       then 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then None
                                                                       else 
                                                                       if b32
                                                                       then 
                                                                       if b33
                                                                       then None
                                                                       else 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then 
                                                                       if b40
                                                                       then 
                                                                       if b41
                                                                       then 
                                                                       if b42
                                                                       then 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.ISZERO)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                                else None
                                                           else None)
                                                           a0)
                                            else None
                             else if b3
                                  then None
                                  else if b4
                                       then None
                                       else if b5
                                            then if b6
                                                 then None
                                                 else (match s0 with
                                                       | [] -> None
                                                       | a0::s1 ->
                                                         (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                           (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                           if b7
                                                           then None
                                                           else if b8
                                                                then if b9
                                                                     then 
                                                                       if b10
                                                                       then 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.AND)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                                     else None
                                                                else if b9
                                                                     then 
                                                                       if b10
                                                                       then None
                                                                       else 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.ADD)
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then 
                                                                       if b26
                                                                       then 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then 
                                                                       if b32
                                                                       then 
                                                                       if b33
                                                                       then 
                                                                       if b34
                                                                       then 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then None
                                                                       else 
                                                                       if b40
                                                                       then None
                                                                       else 
                                                                       if b41
                                                                       then 
                                                                       if b42
                                                                       then None
                                                                       else 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.ADDMOD)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else 
                                                                       if b24
                                                                       then 
                                                                       if b25
                                                                       then None
                                                                       else 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then 
                                                                       if b32
                                                                       then None
                                                                       else 
                                                                       if b33
                                                                       then 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then 
                                                                       if b40
                                                                       then 
                                                                       if b41
                                                                       then None
                                                                       else 
                                                                       if b42
                                                                       then None
                                                                       else 
                                                                       if b43
                                                                       then 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then 
                                                                       if b48
                                                                       then 
                                                                       if b49
                                                                       then None
                                                                       else 
                                                                       if b50
                                                                       then None
                                                                       else 
                                                                       if b51
                                                                       then 
                                                                       if b52
                                                                       then None
                                                                       else 
                                                                       if b53
                                                                       then 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.ADDRESS)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                     else None)
                                                           a0)
                                            else None
              else if b0
                   then if b1
                        then if b2
                             then if b3
                                  then None
                                  else if b4
                                       then None
                                       else if b5
                                            then if b6
                                                 then None
                                                 else (match s0 with
                                                       | [] -> None
                                                       | a0::s1 ->
                                                         (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                           (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                           if b7
                                                           then if b8
                                                                then if b9
                                                                     then 
                                                                       if b10
                                                                       then 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.NOT)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                                     else None
                                                                else if b9
                                                                     then 
                                                                       if b10
                                                                       then None
                                                                       else 
                                                                       if b11
                                                                       then 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then None
                                                                       else 
                                                                       if b24
                                                                       then 
                                                                       if b25
                                                                       then None
                                                                       else 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then 
                                                                       if b32
                                                                       then None
                                                                       else 
                                                                       if b33
                                                                       then 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then None
                                                                       else 
                                                                       if b40
                                                                       then 
                                                                       if b41
                                                                       then None
                                                                       else 
                                                                       if b42
                                                                       then None
                                                                       else 
                                                                       if b43
                                                                       then 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.NUMBER)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                                     else None
                                                           else None)
                                                           a0)
                                            else None
                             else None
                        else if b2
                             then None
                             else if b3
                                  then if b4
                                       then None
                                       else if b5
                                            then if b6
                                                 then None
                                                 else (match s0 with
                                                       | [] -> None
                                                       | a0::s1 ->
                                                         (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                           (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                           if b7
                                                           then if b8
                                                                then None
                                                                else if b9
                                                                     then 
                                                                       if b10
                                                                       then None
                                                                       else 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then None
                                                                       else 
                                                                       if b32
                                                                       then 
                                                                       if b33
                                                                       then None
                                                                       else 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then None
                                                                       else 
                                                                       if b40
                                                                       then 
                                                                       if b41
                                                                       then 
                                                                       if b42
                                                                       then 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then None
                                                                       else 
                                                                       if b48
                                                                       then None
                                                                       else 
                                                                       if b49
                                                                       then 
                                                                       if b50
                                                                       then None
                                                                       else 
                                                                       if b51
                                                                       then None
                                                                       else 
                                                                       if b52
                                                                       then None
                                                                       else 
                                                                       if b53
                                                                       then 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       None
                                                                       | a6::s7 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b55 b56 b57 b58 b59 b60 b61 b62 ->
                                                                       if b55
                                                                       then 
                                                                       if b56
                                                                       then None
                                                                       else 
                                                                       if b57
                                                                       then None
                                                                       else 
                                                                       if b58
                                                                       then None
                                                                       else 
                                                                       if b59
                                                                       then None
                                                                       else 
                                                                       if b60
                                                                       then None
                                                                       else 
                                                                       if b61
                                                                       then 
                                                                       if b62
                                                                       then None
                                                                       else 
                                                                       (match s7 with
                                                                       | [] ->
                                                                       None
                                                                       | a7::s8 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b63 b64 b65 b66 b67 b68 b69 b70 ->
                                                                       if b63
                                                                       then None
                                                                       else 
                                                                       if b64
                                                                       then None
                                                                       else 
                                                                       if b65
                                                                       then 
                                                                       if b66
                                                                       then None
                                                                       else 
                                                                       if b67
                                                                       then 
                                                                       if b68
                                                                       then None
                                                                       else 
                                                                       if b69
                                                                       then 
                                                                       if b70
                                                                       then None
                                                                       else 
                                                                       (match s8 with
                                                                       | [] ->
                                                                       None
                                                                       | a8::s9 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b71 b72 b73 b74 b75 b76 b77 b78 ->
                                                                       if b71
                                                                       then 
                                                                       if b72
                                                                       then None
                                                                       else 
                                                                       if b73
                                                                       then None
                                                                       else 
                                                                       if b74
                                                                       then None
                                                                       else 
                                                                       if b75
                                                                       then None
                                                                       else 
                                                                       if b76
                                                                       then None
                                                                       else 
                                                                       if b77
                                                                       then 
                                                                       if b78
                                                                       then None
                                                                       else 
                                                                       (match s9 with
                                                                       | [] ->
                                                                       None
                                                                       | a9::s10 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b79 b80 b81 b82 b83 b84 b85 b86 ->
                                                                       if b79
                                                                       then 
                                                                       if b80
                                                                       then 
                                                                       if b81
                                                                       then None
                                                                       else 
                                                                       if b82
                                                                       then None
                                                                       else 
                                                                       if b83
                                                                       then 
                                                                       if b84
                                                                       then None
                                                                       else 
                                                                       if b85
                                                                       then 
                                                                       if b86
                                                                       then None
                                                                       else 
                                                                       (match s10 with
                                                                       | [] ->
                                                                       None
                                                                       | a10::s11 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b87 b88 b89 b90 b91 b92 b93 b94 ->
                                                                       if b87
                                                                       then 
                                                                       if b88
                                                                       then None
                                                                       else 
                                                                       if b89
                                                                       then None
                                                                       else 
                                                                       if b90
                                                                       then 
                                                                       if b91
                                                                       then None
                                                                       else 
                                                                       if b92
                                                                       then None
                                                                       else 
                                                                       if b93
                                                                       then 
                                                                       if b94
                                                                       then None
                                                                       else 
                                                                       (match s11 with
                                                                       | [] ->
                                                                       None
                                                                       | a11::s12 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b95 b96 b97 b98 b99 b100 b101 b102 ->
                                                                       if b95
                                                                       then None
                                                                       else 
                                                                       if b96
                                                                       then 
                                                                       if b97
                                                                       then None
                                                                       else 
                                                                       if b98
                                                                       then 
                                                                       if b99
                                                                       then 
                                                                       if b100
                                                                       then None
                                                                       else 
                                                                       if b101
                                                                       then 
                                                                       if b102
                                                                       then None
                                                                       else 
                                                                       (match s12 with
                                                                       | [] ->
                                                                       None
                                                                       | a12::s13 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b103 b104 b105 b106 b107 b108 b109 b110 ->
                                                                       if b103
                                                                       then 
                                                                       if b104
                                                                       then None
                                                                       else 
                                                                       if b105
                                                                       then 
                                                                       if b106
                                                                       then None
                                                                       else 
                                                                       if b107
                                                                       then None
                                                                       else 
                                                                       if b108
                                                                       then None
                                                                       else 
                                                                       if b109
                                                                       then 
                                                                       if b110
                                                                       then None
                                                                       else 
                                                                       (match s13 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.RETURNDATASIZE)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a12)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a11)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a10)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a9)
                                                                       else None
                                                                       else None)
                                                                       a8)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a7)
                                                                       else None
                                                                       else None)
                                                                       a6)
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                     else None
                                                           else None)
                                                           a0)
                                            else None
                                  else if b4
                                       then None
                                       else if b5
                                            then if b6
                                                 then None
                                                 else (match s0 with
                                                       | [] -> None
                                                       | a0::s1 ->
                                                         (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                           (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                           if b7
                                                           then if b8
                                                                then None
                                                                else if b9
                                                                     then None
                                                                     else 
                                                                       if b10
                                                                       then 
                                                                       if b11
                                                                       then 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.BYTE)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                                       else 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then None
                                                                       else 
                                                                       if b32
                                                                       then 
                                                                       if b33
                                                                       then 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then 
                                                                       if b40
                                                                       then None
                                                                       else 
                                                                       if b41
                                                                       then 
                                                                       if b42
                                                                       then None
                                                                       else 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then 
                                                                       if b48
                                                                       then None
                                                                       else 
                                                                       if b49
                                                                       then 
                                                                       if b50
                                                                       then None
                                                                       else 
                                                                       if b51
                                                                       then None
                                                                       else 
                                                                       if b52
                                                                       then None
                                                                       else 
                                                                       if b53
                                                                       then 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.BASEFEE)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then None
                                                                       else 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then None
                                                                       else 
                                                                       if b32
                                                                       then 
                                                                       if b33
                                                                       then 
                                                                       if b34
                                                                       then 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then 
                                                                       if b40
                                                                       then 
                                                                       if b41
                                                                       then None
                                                                       else 
                                                                       if b42
                                                                       then None
                                                                       else 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then 
                                                                       if b48
                                                                       then None
                                                                       else 
                                                                       if b49
                                                                       then 
                                                                       if b50
                                                                       then None
                                                                       else 
                                                                       if b51
                                                                       then None
                                                                       else 
                                                                       if b52
                                                                       then None
                                                                       else 
                                                                       if b53
                                                                       then 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.BALANCE)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                           else if b8
                                                                then None
                                                                else if b9
                                                                     then 
                                                                       if b10
                                                                       then 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then 
                                                                       if b25
                                                                       then None
                                                                       else 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then 
                                                                       if b32
                                                                       then 
                                                                       if b33
                                                                       then None
                                                                       else 
                                                                       if b34
                                                                       then 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then None
                                                                       else 
                                                                       if b40
                                                                       then None
                                                                       else 
                                                                       if b41
                                                                       then None
                                                                       else 
                                                                       if b42
                                                                       then 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then 
                                                                       if b48
                                                                       then None
                                                                       else 
                                                                       if b49
                                                                       then None
                                                                       else 
                                                                       if b50
                                                                       then None
                                                                       else 
                                                                       if b51
                                                                       then None
                                                                       else 
                                                                       if b52
                                                                       then None
                                                                       else 
                                                                       if b53
                                                                       then 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       None
                                                                       | a6::s7 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b55 b56 b57 b58 b59 b60 b61 b62 ->
                                                                       if b55
                                                                       then 
                                                                       if b56
                                                                       then 
                                                                       if b57
                                                                       then None
                                                                       else 
                                                                       if b58
                                                                       then None
                                                                       else 
                                                                       if b59
                                                                       then 
                                                                       if b60
                                                                       then None
                                                                       else 
                                                                       if b61
                                                                       then 
                                                                       if b62
                                                                       then None
                                                                       else 
                                                                       (match s7 with
                                                                       | [] ->
                                                                       None
                                                                       | a7::s8 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b63 b64 b65 b66 b67 b68 b69 b70 ->
                                                                       if b63
                                                                       then None
                                                                       else 
                                                                       if b64
                                                                       then None
                                                                       else 
                                                                       if b65
                                                                       then None
                                                                       else 
                                                                       if b66
                                                                       then 
                                                                       if b67
                                                                       then None
                                                                       else 
                                                                       if b68
                                                                       then None
                                                                       else 
                                                                       if b69
                                                                       then 
                                                                       if b70
                                                                       then None
                                                                       else 
                                                                       (match s8 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.BLOCKHASH)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a7)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a6)
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                                     else None)
                                                           a0)
                                            else None
                   else if b1
                        then if b2
                             then if b3
                                  then None
                                  else if b4
                                       then None
                                       else if b5
                                            then if b6
                                                 then None
                                                 else (match s0 with
                                                       | [] -> None
                                                       | a0::s1 ->
                                                         (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                           (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                           if b7
                                                           then None
                                                           else if b8
                                                                then None
                                                                else if b9
                                                                     then 
                                                                       if b10
                                                                       then None
                                                                       else 
                                                                       if b11
                                                                       then 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.LT)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                     else None)
                                                           a0)
                                            else None
                             else if b3
                                  then if b4
                                       then None
                                       else if b5
                                            then if b6
                                                 then None
                                                 else (match s0 with
                                                       | [] -> None
                                                       | a0::s1 ->
                                                         (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                           (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                           if b7
                                                           then if b8
                                                                then None
                                                                else if b9
                                                                     then None
                                                                     else 
                                                                       if b10
                                                                       then 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then 
                                                                       if b19
                                                                       then None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then 
                                                                       if b24
                                                                       then None
                                                                       else 
                                                                       if b25
                                                                       then 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then 
                                                                       if b32
                                                                       then 
                                                                       if b33
                                                                       then None
                                                                       else 
                                                                       if b34
                                                                       then None
                                                                       else 
                                                                       if b35
                                                                       then 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then None
                                                                       else 
                                                                       if b40
                                                                       then None
                                                                       else 
                                                                       if b41
                                                                       then 
                                                                       if b42
                                                                       then None
                                                                       else 
                                                                       if b43
                                                                       then 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then 
                                                                       if b48
                                                                       then None
                                                                       else 
                                                                       if b49
                                                                       then None
                                                                       else 
                                                                       if b50
                                                                       then None
                                                                       else 
                                                                       if b51
                                                                       then None
                                                                       else 
                                                                       if b52
                                                                       then None
                                                                       else 
                                                                       if b53
                                                                       then 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       None
                                                                       | a6::s7 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b55 b56 b57 b58 b59 b60 b61 b62 ->
                                                                       if b55
                                                                       then 
                                                                       if b56
                                                                       then None
                                                                       else 
                                                                       if b57
                                                                       then 
                                                                       if b58
                                                                       then 
                                                                       if b59
                                                                       then None
                                                                       else 
                                                                       if b60
                                                                       then None
                                                                       else 
                                                                       if b61
                                                                       then 
                                                                       if b62
                                                                       then None
                                                                       else 
                                                                       (match s7 with
                                                                       | [] ->
                                                                       None
                                                                       | a7::s8 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b63 b64 b65 b66 b67 b68 b69 b70 ->
                                                                       if b63
                                                                       then None
                                                                       else 
                                                                       if b64
                                                                       then None
                                                                       else 
                                                                       if b65
                                                                       then None
                                                                       else 
                                                                       if b66
                                                                       then None
                                                                       else 
                                                                       if b67
                                                                       then 
                                                                       if b68
                                                                       then None
                                                                       else 
                                                                       if b69
                                                                       then 
                                                                       if b70
                                                                       then None
                                                                       else 
                                                                       (match s8 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.TIMESTAMP)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a7)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a6)
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                           else None)
                                                           a0)
                                            else None
                                  else if b4
                                       then None
                                       else if b5
                                            then if b6
                                                 then None
                                                 else (match s0 with
                                                       | [] -> None
                                                       | a0::s1 ->
                                                         (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                           (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                           if b7
                                                           then if b8
                                                                then None
                                                                else if b9
                                                                     then None
                                                                     else 
                                                                       if b10
                                                                       then 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then 
                                                                       if b17
                                                                       then 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.DIV)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       None
                                                                       | a2::s3 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b23 b24 b25 b26 b27 b28 b29 b30 ->
                                                                       if b23
                                                                       then None
                                                                       else 
                                                                       if b24
                                                                       then 
                                                                       if b25
                                                                       then 
                                                                       if b26
                                                                       then None
                                                                       else 
                                                                       if b27
                                                                       then None
                                                                       else 
                                                                       if b28
                                                                       then None
                                                                       else 
                                                                       if b29
                                                                       then 
                                                                       if b30
                                                                       then None
                                                                       else 
                                                                       (match s3 with
                                                                       | [] ->
                                                                       None
                                                                       | a3::s4 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b31 b32 b33 b34 b35 b36 b37 b38 ->
                                                                       if b31
                                                                       then 
                                                                       if b32
                                                                       then None
                                                                       else 
                                                                       if b33
                                                                       then None
                                                                       else 
                                                                       if b34
                                                                       then 
                                                                       if b35
                                                                       then None
                                                                       else 
                                                                       if b36
                                                                       then None
                                                                       else 
                                                                       if b37
                                                                       then 
                                                                       if b38
                                                                       then None
                                                                       else 
                                                                       (match s4 with
                                                                       | [] ->
                                                                       None
                                                                       | a4::s5 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b39 b40 b41 b42 b43 b44 b45 b46 ->
                                                                       if b39
                                                                       then 
                                                                       if b40
                                                                       then 
                                                                       if b41
                                                                       then None
                                                                       else 
                                                                       if b42
                                                                       then None
                                                                       else 
                                                                       if b43
                                                                       then None
                                                                       else 
                                                                       if b44
                                                                       then None
                                                                       else 
                                                                       if b45
                                                                       then 
                                                                       if b46
                                                                       then None
                                                                       else 
                                                                       (match s5 with
                                                                       | [] ->
                                                                       None
                                                                       | a5::s6 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b47 b48 b49 b50 b51 b52 b53 b54 ->
                                                                       if b47
                                                                       then 
                                                                       if b48
                                                                       then None
                                                                       else 
                                                                       if b49
                                                                       then 
                                                                       if b50
                                                                       then None
                                                                       else 
                                                                       if b51
                                                                       then 
                                                                       if b52
                                                                       then None
                                                                       else 
                                                                       if b53
                                                                       then 
                                                                       if b54
                                                                       then None
                                                                       else 
                                                                       (match s6 with
                                                                       | [] ->
                                                                       None
                                                                       | a6::s7 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b55 b56 b57 b58 b59 b60 b61 b62 ->
                                                                       if b55
                                                                       then None
                                                                       else 
                                                                       if b56
                                                                       then None
                                                                       else 
                                                                       if b57
                                                                       then 
                                                                       if b58
                                                                       then 
                                                                       if b59
                                                                       then None
                                                                       else 
                                                                       if b60
                                                                       then None
                                                                       else 
                                                                       if b61
                                                                       then 
                                                                       if b62
                                                                       then None
                                                                       else 
                                                                       (match s7 with
                                                                       | [] ->
                                                                       None
                                                                       | a7::s8 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b63 b64 b65 b66 b67 b68 b69 b70 ->
                                                                       if b63
                                                                       then None
                                                                       else 
                                                                       if b64
                                                                       then None
                                                                       else 
                                                                       if b65
                                                                       then 
                                                                       if b66
                                                                       then None
                                                                       else 
                                                                       if b67
                                                                       then 
                                                                       if b68
                                                                       then None
                                                                       else 
                                                                       if b69
                                                                       then 
                                                                       if b70
                                                                       then None
                                                                       else 
                                                                       (match s8 with
                                                                       | [] ->
                                                                       None
                                                                       | a8::s9 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b71 b72 b73 b74 b75 b76 b77 b78 ->
                                                                       if b71
                                                                       then 
                                                                       if b72
                                                                       then None
                                                                       else 
                                                                       if b73
                                                                       then None
                                                                       else 
                                                                       if b74
                                                                       then 
                                                                       if b75
                                                                       then 
                                                                       if b76
                                                                       then None
                                                                       else 
                                                                       if b77
                                                                       then 
                                                                       if b78
                                                                       then None
                                                                       else 
                                                                       (match s9 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.DIFFICULTY)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a8)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a7)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a6)
                                                                       else None
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a5)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a4)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a3)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a2)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                           else None)
                                                           a0)
                                            else None
                        else if b2
                             then if b3
                                  then if b4
                                       then None
                                       else if b5
                                            then if b6
                                                 then None
                                                 else (match s0 with
                                                       | [] -> None
                                                       | a0::s1 ->
                                                         (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                           (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                           if b7
                                                           then if b8
                                                                then if b9
                                                                     then 
                                                                       if b10
                                                                       then 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.XOR)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                                     else None
                                                                else None
                                                           else None)
                                                           a0)
                                            else None
                                  else None
                             else if b3
                                  then if b4
                                       then None
                                       else if b5
                                            then if b6
                                                 then None
                                                 else (match s0 with
                                                       | [] -> None
                                                       | a0::s1 ->
                                                         (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                           (fun b7 b8 b9 b10 b11 b12 b13 b14 ->
                                                           if b7
                                                           then if b8
                                                                then if b9
                                                                     then 
                                                                       if b10
                                                                       then 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       None
                                                                       | a1::s2 ->
                                                                       (* If this appears, you're using Ascii internals. Please don't *)
 (fun f c ->
  let n = Char.code c in
  let h i = (n land (1 lsl i)) <> 0 in
  f (h 0) (h 1) (h 2) (h 3) (h 4) (h 5) (h 6) (h 7))
                                                                       (fun b15 b16 b17 b18 b19 b20 b21 b22 ->
                                                                       if b15
                                                                       then None
                                                                       else 
                                                                       if b16
                                                                       then None
                                                                       else 
                                                                       if b17
                                                                       then None
                                                                       else 
                                                                       if b18
                                                                       then None
                                                                       else 
                                                                       if b19
                                                                       then 
                                                                       if b20
                                                                       then None
                                                                       else 
                                                                       if b21
                                                                       then 
                                                                       if b22
                                                                       then None
                                                                       else 
                                                                       (match s2 with
                                                                       | [] ->
                                                                       Some
                                                                       Concrete.POP
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                       else None)
                                                                       a1)
                                                                       else None
                                                                       else None
                                                                     else 
                                                                       if b10
                                                                       then None
                                                                       else 
                                                                       if b11
                                                                       then None
                                                                       else 
                                                                       if b12
                                                                       then None
                                                                       else 
                                                                       if b13
                                                                       then 
                                                                       if b14
                                                                       then None
                                                                       else 
                                                                       (match s1 with
                                                                       | [] ->
                                                                       Some
                                                                       (Concrete.Opcode
                                                                       Concrete.PC)
                                                                       | _::_ ->
                                                                       None)
                                                                       else None
                                                                else None
                                                           else None)
                                                           a0)
                                            else None
                                  else None)
              a))

  (** val parse_block' : char list list -> Concrete.instr list option **)

  let rec parse_block' = function
  | [] -> Some []
  | x::xs ->
    (match is_push x with
     | Some n0 ->
       (match xs with
        | [] -> None
        | y::ys ->
          (match parseHexNumber y with
           | Some v ->
             (match parse_block' ys with
              | Some bs ->
                Some ((Concrete.PUSH (n0,
                  (nToWord (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                    (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                    (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                    (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                    (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                    (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                    (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                    (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                    (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                    (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                    (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                    (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                    (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
                    O))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
                    v)))::bs)
              | None -> None)
           | None -> None))
     | None ->
       (match parse_non_push_instr x with
        | Some i ->
          (match parse_block' xs with
           | Some bs -> Some (i::bs)
           | None -> None)
        | None -> None))

  (** val parse_block : char list -> Concrete.instr list option **)

  let parse_block block0 =
    parse_block' (tokenize block0)

  (** val block_eq : char list -> char list -> char list -> bool option **)

  let block_eq p_opt p k =
    match parse_block p_opt with
    | Some b1 ->
      (match parse_block p with
       | Some _ ->
         (match parse_block p with
          | Some b2 ->
            (match parseDecNumber k with
             | Some v ->
               Some
                 (Checker.evm_eq_block_chkr' Coq_Optimizations.optimize_id b1 b2
                   v)
             | None -> None)
          | None -> None)
       | None -> None)
    | None -> None

  (** val opt : Abstract.asfs -> Abstract.asfs * bool **)

  let opt =
    Coq_Optimizations.apply_pipeline_n_times
      Coq_Optimizations.our_optimization_pipeline (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      O))))))))))))))))))))))))))))))))))))))))))))))))))

  (** val block_eq_1 : char list -> char list -> char list -> bool option **)

  let block_eq_1 p_opt p k =
    match parse_block p_opt with
    | Some b1 ->
      (match parse_block p with
       | Some _ ->
         (match parse_block p with
          | Some b2 ->
            (match parseDecNumber k with
             | Some v -> Some (Checker.evm_eq_block_chkr' opt b1 b2 v)
             | None -> None)
          | None -> None)
       | None -> None)
    | None -> None

  (** val block_eq_2 : char list -> char list -> char list -> bool option **)

  let block_eq_2 p_opt p k =
    match parse_block p_opt with
    | Some b1 ->
      (match parse_block p with
       | Some _ ->
         (match parse_block p with
          | Some b2 ->
            (match parseDecNumber k with
             | Some v -> Some (Checker.evm_eq_block_chkr'' opt b1 b2 v)
             | None -> None)
          | None -> None)
       | None -> None)
    | None -> None
 end
