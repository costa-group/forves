
type unit0 =
| Tt

val xorb : bool -> bool -> bool

val negb : bool -> bool

type nat =
| O
| S of nat

type 'a option =
| Some of 'a
| None

val length : 'a1 list -> nat

val app : 'a1 list -> 'a1 list -> 'a1 list

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

val pred : nat -> nat

val add : nat -> nat -> nat

val mul : nat -> nat -> nat

val sub : nat -> nat -> nat

val eqb : nat -> nat -> bool

val leb : nat -> nat -> bool

val ltb : nat -> nat -> bool

val eqb0 : bool -> bool -> bool

module Nat :
 sig
  val leb : nat -> nat -> bool

  val div2 : nat -> nat
 end

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

  val eqb : positive -> positive -> bool

  val iter_op : ('a1 -> 'a1 -> 'a1) -> positive -> 'a1 -> 'a1

  val to_nat : positive -> nat
 end

module N :
 sig
  val succ : n -> n

  val add : n -> n -> n

  val mul : n -> n -> n

  val eqb : n -> n -> bool

  val to_nat : n -> nat
 end

val nth_error : 'a1 list -> nat -> 'a1 option

val rev : 'a1 list -> 'a1 list

val map : ('a1 -> 'a2) -> 'a1 list -> 'a2 list

val fold_right : ('a2 -> 'a1 -> 'a1) -> 'a1 -> 'a2 list -> 'a1

val firstn : nat -> 'a1 list -> 'a1 list

val skipn : nat -> 'a1 list -> 'a1 list

val seq : nat -> nat -> nat list

val n_of_digits : bool list -> n

val n_of_ascii : char -> n

val nat_of_ascii : char -> nat

val mod2 : nat -> bool

type word =
| WO
| WS of bool * nat * word

val natToWord : nat -> nat -> word

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

val bitwp : (bool -> bool -> bool) -> nat -> word -> word -> word

val wor : nat -> word -> word -> word

val wand : nat -> word -> word -> word

val wxor : nat -> word -> word -> word

module EVM_Def :
 sig
  val coq_WLen : nat

  type coq_EVMWord = word

  val coq_StackLen : nat

  val coq_WZero : coq_EVMWord

  val coq_WOne : coq_EVMWord
 end

module Concrete :
 sig
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
  | Op of bool * nat
     * (EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option)

  val eq_oper_label : oper_label -> oper_label -> bool

  val add : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val mul : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val not : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val eq : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val coq_and : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val coq_or : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val xor : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val uninterp0 : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val uninterp1 : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val uninterp2 : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val uninterp3 : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val uninterp4 : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  type ('k, 'v) map = 'k -> 'v option

  val empty_imap : (oper_label, 'a1) map

  val updatei :
    (oper_label, 'a1) map -> oper_label -> 'a1 -> oper_label -> 'a1 option

  type opm = (oper_label, operator) map

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
    Concrete.block -> Abstract.asfs -> Concrete.opm -> Abstract.asfs option

  val symbolic_exec :
    Concrete.block -> nat -> Concrete.opm -> Abstract.asfs option

  val is_comm_op : Concrete.oper_label -> Concrete.opm -> bool

  val apply_f_opt_list : ('a1 -> 'a2 option) -> 'a1 list -> 'a2 list option

  val flat_stack_elem :
    Abstract.asfs_stack_val -> Abstract.asfs_map -> Abstract.stack_expr
    option

  val compare_lists_pred :
    ('a1 -> 'a2 -> bool) -> 'a1 list -> 'a2 list -> bool

  val compare_flat_asfs_map_val :
    Abstract.stack_expr -> Abstract.stack_expr -> Concrete.opm -> bool

  val asfs_eq_stack_elem :
    Abstract.asfs_stack_val -> Abstract.asfs_stack_val -> Abstract.asfs_map
    -> Abstract.asfs_map -> Concrete.opm -> bool

  val asfs_eq_stack :
    Abstract.asfs_stack -> Abstract.asfs_stack -> Abstract.asfs_map ->
    Abstract.asfs_map -> Concrete.opm -> bool

  val eq_sstate_chkr : Abstract.asfs -> Abstract.asfs -> Concrete.opm -> bool
 end

module Coq_Optimizations :
 sig
  val optimize_id : Abstract.asfs -> Abstract.asfs * bool
 end

module Checker :
 sig
  val evm_eq_block_chkr' :
    Optimizations.optimization -> Concrete.block -> Concrete.block -> nat ->
    bool
 end

module Parser :
 sig
  val isWhite : char -> bool

  type chartype =
  | Coq_white
  | Coq_other

  val chartype_rect : 'a1 -> 'a1 -> chartype -> 'a1

  val chartype_rec : 'a1 -> 'a1 -> chartype -> 'a1

  val classifyChar : char -> chartype

  val list_of_string : char list -> char list

  val string_of_list : char list -> char list

  type token = char list

  val tokenize_helper : chartype -> char list -> char list -> char list list

  val tokenize : char list -> char list list

  val uint_to_N : uint -> n

  val parseHexNumber' : char list -> uint -> uint option

  val parseHexNumber : char list -> n option

  val parseDecNumber' : char list -> nat -> nat option

  val parseDecNumber : char list -> nat option

  val is_push : char list -> nat option

  val is_dup : char list -> nat option

  val is_swap : char list -> nat option

  val parse_non_push_instr : char list -> Concrete.instr option

  val parse_block' : char list list -> Concrete.instr list option

  val parse_block : char list -> Concrete.instr list option

  val block_eq : char list -> char list -> char list -> bool option
 end
