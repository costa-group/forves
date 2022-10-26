
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

val fst : ('a1 * 'a2) -> 'a1

val length : 'a1 list -> nat

val app : 'a1 list -> 'a1 list -> 'a1 list

type comparison =
| Eq
| Lt
| Gt

val id : 'a1 -> 'a1

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
  val add : nat -> nat -> nat

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
  type mask =
  | IsNul
  | IsPos of positive
  | IsNeg
 end

module Coq_Pos :
 sig
  val succ : positive -> positive

  val add : positive -> positive -> positive

  val add_carry : positive -> positive -> positive

  val pred_double : positive -> positive

  type mask = Pos.mask =
  | IsNul
  | IsPos of positive
  | IsNeg

  val succ_double_mask : mask -> mask

  val double_mask : mask -> mask

  val double_pred_mask : positive -> mask

  val sub_mask : positive -> positive -> mask

  val sub_mask_carry : positive -> positive -> mask

  val mul : positive -> positive -> positive

  val iter : ('a1 -> 'a1) -> 'a1 -> positive -> 'a1

  val pow : positive -> positive -> positive

  val compare_cont : comparison -> positive -> positive -> comparison

  val compare : positive -> positive -> comparison

  val eqb : positive -> positive -> bool

  val iter_op : ('a1 -> 'a1 -> 'a1) -> positive -> 'a1 -> 'a1

  val to_nat : positive -> nat
 end

module N :
 sig
  val succ_double : n -> n

  val double : n -> n

  val succ : n -> n

  val add : n -> n -> n

  val sub : n -> n -> n

  val mul : n -> n -> n

  val compare : n -> n -> comparison

  val eqb : n -> n -> bool

  val leb : n -> n -> bool

  val ltb : n -> n -> bool

  val pow : n -> n -> n

  val pos_div_eucl : positive -> n -> n * n

  val div_eucl : n -> n -> n * n

  val div : n -> n -> n

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

val npow2 : nat -> n

val nat_cast : nat -> nat -> 'a1 -> 'a1

type word =
| WO
| WS of bool * nat * word

val wordToNat : nat -> word -> nat

val natToWord : nat -> nat -> word

val wordToN : nat -> word -> n

val wzero : nat -> word

val wzero' : nat -> word

val posToWord : nat -> positive -> word

val nToWord : nat -> n -> word

val whd : nat -> word -> bool

val wtl : nat -> word -> word

val weqb : nat -> word -> word -> bool

val combine : nat -> word -> nat -> word -> word

val split1 : nat -> nat -> word -> word

val split2 : nat -> nat -> word -> word

val wneg : nat -> word -> word

val wordBin : (n -> n -> n) -> nat -> word -> word -> word

val wplus : nat -> word -> word -> word

val wmult : nat -> word -> word -> word

val wdiv : nat -> word -> word -> word

val wminus : nat -> word -> word -> word

val wnot : nat -> word -> word

val bitwp : (bool -> bool -> bool) -> nat -> word -> word -> word

val wor : nat -> word -> word -> word

val wand : nat -> word -> word -> word

val wxor : nat -> word -> word -> word

val wlshift' : nat -> word -> nat -> word

val wrshift' : nat -> word -> nat -> word

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

  type instr =
  | PUSH of nat * EVM_Def.coq_EVMWord
  | POP
  | DUP of nat
  | SWAP of nat
  | Opcode of oper_label

  type block = instr list

  type operator =
  | Op of bool * nat * (EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option)

  val eq_oper_label : oper_label -> oper_label -> bool

  val evm_add : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val evm_mul : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val evm_not : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val evm_eq : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val evm_iszero : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val evm_and : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val evm_or : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val evm_xor : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val evm_shl : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val evm_shr : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val evm_sub : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val evm_exp : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val evm_div : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val evm_lt : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val evm_gt : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val uninterp0 : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val uninterp1 : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val uninterp2 : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  val uninterp3 : EVM_Def.coq_EVMWord list -> EVM_Def.coq_EVMWord option

  type ('k, 'v) map = 'k -> 'v option

  val empty_imap : (oper_label, 'a1) map

  val updatei : (oper_label, 'a1) map -> oper_label -> 'a1 -> oper_label -> 'a1 option

  type opm = (oper_label, operator) map

  val fully_defined : oper_label list

  val is_fully_defined : oper_label -> bool

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

  val asfs_map_add : Abstract.asfs_map -> nat -> Abstract.asfs_map_val -> Abstract.asfs_map

  val add_val_asfs : Concrete.opm -> Abstract.asfs -> Abstract.asfs_map_val -> Abstract.asfs option

  val symbolic_exec'' : Concrete.instr -> Abstract.asfs -> Concrete.opm -> Abstract.asfs option

  val symbolic_exec' : Concrete.block -> Abstract.asfs -> Concrete.opm -> Abstract.asfs option

  val symbolic_exec : Concrete.block -> nat -> Concrete.opm -> Abstract.asfs option

  val is_comm_op : Concrete.oper_label -> Concrete.opm -> bool

  val apply_f_opt_list : ('a1 -> 'a2 option) -> 'a1 list -> 'a2 list option

  val flat_stack_elem : Abstract.asfs_stack_val -> Abstract.asfs_map -> Abstract.stack_expr option

  val compare_lists_pred : ('a1 -> 'a2 -> bool) -> 'a1 list -> 'a2 list -> bool

  val compare_flat_asfs_map_val : Abstract.stack_expr -> Abstract.stack_expr -> Concrete.opm -> bool

  val asfs_eq_stack_elem : Abstract.asfs_stack_val -> Abstract.asfs_stack_val -> Abstract.asfs_map -> Abstract.asfs_map -> Concrete.opm -> bool

  val asfs_eq_stack : Abstract.asfs_stack -> Abstract.asfs_stack -> Abstract.asfs_map -> Abstract.asfs_map -> Concrete.opm -> bool

  val eq_sstate_chkr : Abstract.asfs -> Abstract.asfs -> Concrete.opm -> bool
 end

module Coq_Optimizations :
 sig
  val stack_val_is_oper_suffix :
    Concrete.oper_label -> Abstract.asfs_stack_val -> Abstract.asfs_map -> ((Abstract.asfs_stack_val list * Abstract.asfs_map) * nat) option

  val stack_val_is_oper : Concrete.oper_label -> Abstract.asfs_stack_val -> Abstract.asfs_map -> Abstract.asfs_stack_val list option

  val optimize_fresh_var2 : Abstract.asfs -> Abstract.asfs_map -> (nat -> Abstract.asfs -> Abstract.asfs option) -> Abstract.asfs * bool

  val optimize_fresh_var : (nat -> Abstract.asfs -> Abstract.asfs option) -> Abstract.asfs -> Abstract.asfs * bool

  val stack_val_has_value' : Abstract.asfs_stack_val -> Abstract.asfs_map -> EVM_Def.coq_EVMWord -> bool

  val optimize_func_map : (nat -> Abstract.asfs_map -> Abstract.asfs_map option) -> nat -> Abstract.asfs -> Abstract.asfs option

  val optimize_map_add_zero : nat -> Abstract.asfs_map -> Abstract.asfs_map option

  val optimize_add_zero_fvar : nat -> Abstract.asfs -> Abstract.asfs option

  val optimize_add_zero : Abstract.asfs -> Abstract.asfs * bool

  val optimize_map_mul_one : nat -> Abstract.asfs_map -> Abstract.asfs_map option

  val optimize_mul_one_fvar : nat -> Abstract.asfs -> Abstract.asfs option

  val optimize_mul_one : Abstract.asfs -> Abstract.asfs * bool

  val optimize_map_mul_zero : nat -> Abstract.asfs_map -> Abstract.asfs_map option

  val optimize_mul_zero_fvar : nat -> Abstract.asfs -> Abstract.asfs option

  val optimize_mul_zero : Abstract.asfs -> Abstract.asfs * bool

  val optimize_map_not_not : nat -> Abstract.asfs_map -> Abstract.asfs_map option

  val optimize_not_not_fvar : nat -> Abstract.asfs -> Abstract.asfs option

  val optimize_not_not : Abstract.asfs -> Abstract.asfs * bool

  val flat_extract_const : Abstract.asfs_stack_val -> Abstract.asfs_map -> EVM_Def.coq_EVMWord option

  val const_list : Abstract.asfs_stack_val list -> Abstract.asfs_map -> EVM_Def.coq_EVMWord list option

  val optimize_map_eval : Concrete.opm -> nat -> Abstract.asfs_map -> Abstract.asfs_map option

  val optimize_eval_fvar : nat -> Abstract.asfs -> Abstract.asfs option

  val optimize_eval : Abstract.asfs -> Abstract.asfs * bool

  val optimize_map_div_one : nat -> Abstract.asfs_map -> Abstract.asfs_map option

  val optimize_div_one_fvar : nat -> Abstract.asfs -> Abstract.asfs option

  val optimize_div_one : Abstract.asfs -> Abstract.asfs * bool

  val optimize_map_eq_zero : nat -> Abstract.asfs_map -> Abstract.asfs_map option

  val optimize_eq_zero_fvar : nat -> Abstract.asfs -> Abstract.asfs option

  val optimize_eq_zero : Abstract.asfs -> Abstract.asfs * bool

  val optimize_map_gt_one : nat -> Abstract.asfs_map -> Abstract.asfs_map option

  val optimize_gt_one_fvar : nat -> Abstract.asfs -> Abstract.asfs option

  val optimize_gt_one : Abstract.asfs -> Abstract.asfs * bool

  val optimize_map_lt_one : nat -> Abstract.asfs_map -> Abstract.asfs_map option

  val optimize_lt_one_fvar : nat -> Abstract.asfs -> Abstract.asfs option

  val optimize_lt_one : Abstract.asfs -> Abstract.asfs * bool

  val optimize_map_or_zero : nat -> Abstract.asfs_map -> Abstract.asfs_map option

  val optimize_or_zero_fvar : nat -> Abstract.asfs -> Abstract.asfs option

  val optimize_or_zero : Abstract.asfs -> Abstract.asfs * bool

  val optimize_map_sub_x_x : nat -> Abstract.asfs_map -> Abstract.asfs_map option

  val optimize_sub_x_x_fvar : nat -> Abstract.asfs -> Abstract.asfs option

  val optimize_sub_x_x : Abstract.asfs -> Abstract.asfs * bool

  val optimize_map_iszero3 : nat -> Abstract.asfs_map -> Abstract.asfs_map option

  val optimize_iszero3_fvar : nat -> Abstract.asfs -> Abstract.asfs option

  val optimize_iszero3 : Abstract.asfs -> Abstract.asfs * bool

  val optimize_map_and_and_l : nat -> Abstract.asfs_map -> Abstract.asfs_map option

  val optimize_and_and_l_fvar : nat -> Abstract.asfs -> Abstract.asfs option

  val optimize_and_and_l : Abstract.asfs -> Abstract.asfs * bool

  val optimize_map_and_and_r : nat -> Abstract.asfs_map -> Abstract.asfs_map option

  val optimize_and_and_r_fvar : nat -> Abstract.asfs -> Abstract.asfs option

  val optimize_and_and_r : Abstract.asfs -> Abstract.asfs * bool

  val apply_n_times : Optimizations.optimization -> nat -> Abstract.asfs -> Abstract.asfs * bool

  val apply_all_possible_opt : Optimizations.optimization list -> Abstract.asfs -> Abstract.asfs * bool

  val apply_pipeline_n_times : Optimizations.optimization list -> nat -> Abstract.asfs -> Abstract.asfs * bool

  val our_optimization_pipeline : (Abstract.asfs -> Abstract.asfs * bool) list
 end

module Checker :
 sig
  val evm_eq_block_chkr : Concrete.block -> Concrete.block -> nat -> bool

  val evm_eq_block_chkr' : Optimizations.optimization -> Concrete.block -> Concrete.block -> nat -> bool

  val evm_eq_block_chkr'' : Optimizations.optimization -> Concrete.block -> Concrete.block -> nat -> bool
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

  val opt : Abstract.asfs -> Abstract.asfs * bool

  val str_to_opt : char list -> Optimizations.optimization option

  val strs_to_opts : char list list -> Optimizations.optimization list option

  val parse_opts : char list list -> Optimizations.optimization option

  val block_eq_0 : char list -> char list -> char list -> Optimizations.optimization -> bool option

  val block_eq_1 : char list -> char list -> char list -> Optimizations.optimization -> bool option

  val block_eq_2 : char list -> char list -> char list -> Optimizations.optimization -> bool option
 end
