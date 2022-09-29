
type unit0 =
| Tt

val negb : bool -> bool

type nat =
| O
| S of nat

type 'a option =
| Some of 'a
| None

val length : 'a1 list -> nat

val app : 'a1 list -> 'a1 list -> 'a1 list

type ('a, 'p) sigT =
| ExistT of 'a * 'p

val projT1 : ('a1, 'a2) sigT -> 'a1

val projT2 : ('a1, 'a2) sigT -> 'a2

val add : nat -> nat -> nat

val sub : nat -> nat -> nat

val eqb : nat -> nat -> bool

val leb : nat -> nat -> bool

val ltb : nat -> nat -> bool

val eqb0 : bool -> bool -> bool

type positive =
| XI of positive
| XO of positive
| XH

type n =
| N0
| Npos of positive

module Pos :
 sig
  val succ : positive -> positive

  val add : positive -> positive -> positive

  val add_carry : positive -> positive -> positive

  val mul : positive -> positive -> positive
 end

module N :
 sig
  val succ : n -> n

  val add : n -> n -> n

  val mul : n -> n -> n
 end

val nth_error : 'a1 list -> nat -> 'a1 option

val map : ('a1 -> 'a2) -> 'a1 list -> 'a2 list

val firstn : nat -> 'a1 list -> 'a1 list

val skipn : nat -> 'a1 list -> 'a1 list

val seq : nat -> nat -> nat list

type word =
| WO
| WS of bool * nat * word

val wordToN : nat -> word -> n

val wzero' : nat -> word

val posToWord : nat -> positive -> word

val nToWord : nat -> n -> word

val whd : nat -> word -> bool

val wtl : nat -> word -> word

val weqb : nat -> word -> word -> bool

val wordBin : (n -> n -> n) -> nat -> word -> word -> word

val wplus : nat -> word -> word -> word

val wmult : nat -> word -> word -> word

val wnot : nat -> word -> word

module EVM_Def :
 sig
  val coq_WLen : nat

  type coq_EVMWord = word

  val coq_StackLen : nat
 end

module Concrete :
 sig
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

  val eq_gen_instr : gen_instr -> gen_instr -> bool

  val add : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val mul : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val not : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  type ('k, 'v) map = 'k -> 'v option

  val empty_imap : (gen_instr, 'a1) map

  val updatei :
    (gen_instr, 'a1) map -> gen_instr -> 'a1 -> gen_instr -> 'a1 option

  type opm = (gen_instr, operator) map

  val opmap : opm
 end

module Abstract :
 sig
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

module Optimizations :
 sig
  type optimization = Abstract.asfs -> Abstract.asfs * bool
 end

val firstn_e : nat -> 'a1 list -> 'a1 list option

val skipn_e : nat -> 'a1 list -> 'a1 list option

module SFS :
 sig
  val push : 'a1 -> 'a1 list -> 'a1 list option

  val pop : 'a1 list -> 'a1 list option

  val dup : nat -> 'a1 list -> 'a1 list option

  val swap : nat -> 'a1 list -> 'a1 list option

  val get_maxid_asfs : Abstract.asfs -> nat

  val get_stack_asfs : Abstract.asfs -> Abstract.asfs_stack

  val get_map_asfs : Abstract.asfs -> Abstract.asfs_map

  val set_maxid_asfs : Abstract.asfs -> nat -> Abstract.asfs

  val set_stack_asfs : Abstract.asfs -> Abstract.asfs_stack -> Abstract.asfs

  val set_map_asfs : Abstract.asfs -> Abstract.asfs_map -> Abstract.asfs

  val gen_initial_stack : nat -> Abstract.asfs_stack_val list

  val empty_asfs : nat -> Abstract.asfs

  val asfs_map_add :
    Abstract.asfs_map -> nat -> Abstract.asfs_map_val -> Abstract.asfs_map

  val add_val_asfs :
    Concrete.opm -> Abstract.asfs -> Abstract.asfs_map_val -> Abstract.asfs
    option

  val symbolic_exec'' :
    Concrete.instr -> Abstract.asfs -> Concrete.opm -> Abstract.asfs option

  val symbolic_exec' :
    Concrete.prog -> Abstract.asfs -> Concrete.opm -> Abstract.asfs option

  val symbolic_exec :
    Concrete.prog -> nat -> Concrete.opm -> Abstract.asfs option

  val is_comm_op : Concrete.gen_instr -> Concrete.opm -> bool

  val asfs_eq_stack_elem_func :
    (Abstract.asfs_stack_val, (Abstract.asfs_stack_val, (Abstract.asfs_map,
    (Abstract.asfs_map, Concrete.opm) sigT) sigT) sigT) sigT -> bool

  val asfs_eq_stack_elem :
    Abstract.asfs_stack_val -> Abstract.asfs_stack_val -> Abstract.asfs_map
    -> Abstract.asfs_map -> Concrete.opm -> bool

  val asfs_eq_stack :
    Abstract.asfs_stack -> Abstract.asfs_stack -> Abstract.asfs_map ->
    Abstract.asfs_map -> Concrete.opm -> bool

  val asfs_eq : Abstract.asfs -> Abstract.asfs -> Concrete.opm -> bool
 end

module Checker :
 sig
  val equiv_checker :
    Concrete.prog -> Concrete.prog -> nat -> Optimizations.optimization ->
    bool
 end
