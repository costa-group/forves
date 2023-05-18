
type __ = Obj.t

val xorb : bool -> bool -> bool

val negb : bool -> bool

type nat =
| O
| S of nat

val fst : ('a1 * 'a2) -> 'a1

val snd : ('a1 * 'a2) -> 'a2

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

val max : nat -> nat -> nat

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

  val of_succ_nat : nat -> positive
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

  val modulo : n -> n -> n

  val to_nat : n -> nat

  val of_nat : nat -> n
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

val wones : nat -> word

val whd : nat -> word -> bool

val wtl : nat -> word -> word

val weqb : nat -> word -> word -> bool

val combine : nat -> word -> nat -> word -> word

val split1 : nat -> nat -> word -> word

val zext : nat -> word -> nat -> word

val wneg : nat -> word -> word

val wordBin : (n -> n -> n) -> nat -> word -> word -> word

val wplus : nat -> word -> word -> word

val wmult : nat -> word -> word -> word

val wdiv : nat -> word -> word -> word

val wmod : nat -> word -> word -> word

val wminus : nat -> word -> word -> word

val wnot : nat -> word -> word

val bitwp : (bool -> bool -> bool) -> nat -> word -> word -> word

val wor : nat -> word -> word -> word

val wand : nat -> word -> word -> word

val wxor : nat -> word -> word -> word

val wlshift' : nat -> word -> nat -> word

module Program :
 sig
  type stack_op_instr =
  | ADD
  | MUL
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
  | NOT
  | BYTE
  | SHL
  | SHR
  | SAR
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
  | GAS
  | JUMPI

  val eqb_stack_op_instr : stack_op_instr -> stack_op_instr -> bool

  type instr =
  | PUSH of nat * n
  | METAPUSH of n * n
  | POP
  | DUP of nat
  | SWAP of nat
  | MLOAD
  | MSTORE
  | MSTORE8
  | SLOAD
  | SSTORE
  | SHA3
  | KECCAK256
  | OpInstr of stack_op_instr

  type block = instr list
 end

module Constants :
 sig
  val coq_EVMByteSize : nat

  val coq_BytesInEVMWord : nat

  val coq_EVMWordSize : nat

  type coq_EVMWord = word

  val coq_ByteInEVMAddr : nat

  val coq_EVMAddrSize : nat

  type coq_EVMAddr = word

  val coq_WZero : coq_EVMWord

  val coq_WOne : coq_EVMWord

  val coq_AZero : coq_EVMAddr

  val coq_StackSize : nat
 end

module ExecutionState :
 sig
  type code_info =
  | CodeInfo of nat * word * Constants.coq_EVMWord

  type block_info =
  | BlockInfo of nat * word * Constants.coq_EVMWord * Constants.coq_EVMWord

  type chunk =
  | Chunk of nat * word

  type context =
  | Ctx of Constants.coq_EVMAddr
     * (Constants.coq_EVMAddr -> Constants.coq_EVMWord)
     * Constants.coq_EVMAddr * Constants.coq_EVMAddr * Constants.coq_EVMWord
     * chunk * (Constants.coq_EVMAddr -> code_info) * Constants.coq_EVMWord
     * chunk * (Constants.coq_EVMWord -> block_info) * Constants.coq_EVMAddr
     * Constants.coq_EVMWord * Constants.coq_EVMWord * Constants.coq_EVMWord
     * Constants.coq_EVMWord * (nat -> word -> Constants.coq_EVMWord)
     * (n -> n -> Constants.coq_EVMWord) * nat * nat * nat * nat

  val empty_context : context

  val get_address_ctx : context -> Constants.coq_EVMAddr

  val get_balance_ctx :
    context -> Constants.coq_EVMAddr -> Constants.coq_EVMWord

  val get_origin_ctx : context -> Constants.coq_EVMAddr

  val get_caller_ctx : context -> Constants.coq_EVMAddr

  val get_callvalue_ctx : context -> Constants.coq_EVMWord

  val get_data_ctx : context -> chunk

  val get_code_ctx : context -> Constants.coq_EVMAddr -> code_info

  val get_gasprice_ctx : context -> Constants.coq_EVMWord

  val get_outdata_ctx : context -> chunk

  val get_blocks_ctx : context -> Constants.coq_EVMWord -> block_info

  val get_miner_ctx : context -> Constants.coq_EVMAddr

  val get_currblock_ctx : context -> Constants.coq_EVMWord

  val get_gaslimit_ctx : context -> Constants.coq_EVMWord

  val get_chainid_ctx : context -> Constants.coq_EVMWord

  val get_basefee_ctx : context -> Constants.coq_EVMWord
 end

module Misc :
 sig
  type ('k, 'v) map = 'k -> 'v

  val map_option : ('a1 -> 'a2 option) -> 'a1 list -> 'a2 list option

  val fold_right_two_lists :
    ('a1 -> 'a2 -> bool) -> 'a1 list -> 'a2 list -> bool

  val firstn_e : nat -> 'a1 list -> 'a1 list option

  val skipn_e : nat -> 'a1 list -> 'a1 list option

  val push : 'a1 -> 'a1 list -> 'a1 list option

  val pop : 'a1 list -> 'a1 list option

  val dup : nat -> 'a1 list -> 'a1 list option

  val swap : nat -> 'a1 list -> 'a1 list option
 end

module StackOpInstrs :
 sig
  type stack_op_impl =
  | OpImp of nat
     * (ExecutionState.context -> Constants.coq_EVMWord list ->
       Constants.coq_EVMWord) * __ option * __ option

  type stack_op_instr_map = (Program.stack_op_instr, stack_op_impl) Misc.map

  val empty_imap : 'a1 -> (Program.stack_op_instr, 'a1) Misc.map

  val updatei :
    (Program.stack_op_instr, 'a1) Misc.map -> Program.stack_op_instr -> 'a1
    -> Program.stack_op_instr -> 'a1

  val evm_add :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_mul :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_sub :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_div :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_sdiv :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_mod :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_smod :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_addmod :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_mulmod :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_exp :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_signextend :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_lt :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_gt :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_slt :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_sgt :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_eq :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_iszero :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_and :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_or :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_xor :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_not :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_byte :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_shl :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_shr :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_sar :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_address :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_balance :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_origin :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_caller :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_callvalue :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_calldataload :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_calldatasize :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_codesize :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_gasprice :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_extcodesize :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_returndatasize :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_extcodehash :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_blockhash :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_coinbase :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_timestamp :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_number :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_difficulty :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_gaslimit :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_chainid :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_selfbalance :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_basefee :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_gas :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_jumpi :
    ExecutionState.context -> Constants.coq_EVMWord list ->
    Constants.coq_EVMWord

  val evm_stack_opm : stack_op_instr_map
 end

module SymbolicState :
 sig
  type sstack_val =
  | Val of Constants.coq_EVMWord
  | InStackVar of nat
  | FreshVar of nat

  type sstack = sstack_val list

  type 'a memory_update =
  | U_MSTORE of 'a * 'a
  | U_MSTORE8 of 'a * 'a

  type 'a memory_updates = 'a memory_update list

  type smemory = sstack_val memory_updates

  val empty_smemory : smemory

  type 'a storage_update =
  | U_SSTORE of 'a * 'a

  type 'a storage_updates = 'a storage_update list

  type sstorage = sstack_val storage_updates

  val empty_sstorage : sstorage

  type smap_value =
  | SymBasicVal of sstack_val
  | SymMETAPUSH of n * n
  | SymOp of Program.stack_op_instr * sstack_val list
  | SymMLOAD of sstack_val * smemory
  | SymSLOAD of sstack_val * sstorage
  | SymSHA3 of sstack_val * sstack_val * smemory

  type sbinding = nat * smap_value

  type sbindings = sbinding list

  type smap =
  | SymMap of nat * sbindings

  val get_maxidx_smap : smap -> nat

  val get_bindings_smap : smap -> sbindings

  val empty_smap : smap

  val add_to_smap : smap -> smap_value -> nat * smap

  type follow_in_smap_ret_t =
  | FollowSmapVal of smap_value * nat * sbindings

  val is_fresh_var_smv : smap_value -> nat option

  val follow_in_smap :
    sstack_val -> nat -> sbindings -> follow_in_smap_ret_t option

  type sstate =
  | SymExState of nat * sstack * smemory * sstorage * smap

  val make_sst : nat -> sstack -> smemory -> sstorage -> smap -> sstate

  val gen_empty_sstate : nat -> sstate

  val get_instk_height_sst : sstate -> nat

  val get_stack_sst : sstate -> sstack

  val set_stack_sst : sstate -> sstack -> sstate

  val get_memory_sst : sstate -> smemory

  val set_memory_sst : sstate -> smemory -> sstate

  val get_storage_sst : sstate -> sstorage

  val set_storage_sst : sstate -> sstorage -> sstate

  val get_smap_sst : sstate -> smap

  val set_smap_sst : sstate -> smap -> sstate
 end

module SymbolicStateCmp :
 sig
  type sstack_val_cmp_t =
    SymbolicState.sstack_val -> SymbolicState.sstack_val -> nat ->
    SymbolicState.sbindings -> nat -> SymbolicState.sbindings -> nat ->
    StackOpInstrs.stack_op_instr_map -> bool

  type smemory_cmp_t =
    SymbolicState.smemory -> SymbolicState.smemory -> nat ->
    SymbolicState.sbindings -> nat -> SymbolicState.sbindings -> nat ->
    StackOpInstrs.stack_op_instr_map -> bool

  type smemory_cmp_ext_t = sstack_val_cmp_t -> smemory_cmp_t

  type sstorage_cmp_t =
    SymbolicState.sstorage -> SymbolicState.sstorage -> nat ->
    SymbolicState.sbindings -> nat -> SymbolicState.sbindings -> nat ->
    StackOpInstrs.stack_op_instr_map -> bool

  type sstorage_cmp_ext_t = sstack_val_cmp_t -> sstorage_cmp_t

  type sha3_cmp_t =
    SymbolicState.sstack_val -> SymbolicState.sstack_val ->
    SymbolicState.smemory -> SymbolicState.sstack_val ->
    SymbolicState.sstack_val -> SymbolicState.smemory -> nat ->
    SymbolicState.sbindings -> nat -> SymbolicState.sbindings -> nat ->
    StackOpInstrs.stack_op_instr_map -> bool

  type sha3_cmp_ext_t = sstack_val_cmp_t -> sha3_cmp_t

  type sstack_val_cmp_ext_1_t = nat -> sstack_val_cmp_t

  type sstack_val_cmp_ext_2_t =
    smemory_cmp_ext_t -> sstorage_cmp_ext_t -> sha3_cmp_ext_t ->
    sstack_val_cmp_ext_1_t
 end

module SymbolicStateCmpImpl :
 sig
  val compare_sstack :
    SymbolicStateCmp.sstack_val_cmp_t -> SymbolicState.sstack ->
    SymbolicState.sstack -> nat -> SymbolicState.sbindings -> nat ->
    SymbolicState.sbindings -> nat -> StackOpInstrs.stack_op_instr_map -> bool

  val compare_smemory :
    SymbolicStateCmp.smemory_cmp_t -> SymbolicState.smemory ->
    SymbolicState.smemory -> nat -> SymbolicState.sbindings -> nat ->
    SymbolicState.sbindings -> nat -> StackOpInstrs.stack_op_instr_map -> bool

  val compare_sstorage :
    SymbolicStateCmp.sstorage_cmp_t -> SymbolicState.sstorage ->
    SymbolicState.sstorage -> nat -> SymbolicState.sbindings -> nat ->
    SymbolicState.sbindings -> nat -> StackOpInstrs.stack_op_instr_map -> bool

  val sstate_cmp :
    SymbolicStateCmp.sstack_val_cmp_t -> SymbolicStateCmp.smemory_cmp_t ->
    SymbolicStateCmp.sstorage_cmp_t -> SymbolicState.sstate ->
    SymbolicState.sstate -> StackOpInstrs.stack_op_instr_map -> bool
 end

module Optimizations_Common :
 sig
  val follow_to_val :
    SymbolicState.sstack_val -> nat -> SymbolicState.sbindings ->
    Constants.coq_EVMWord option

  val follow_to_val_args :
    SymbolicState.sstack -> nat -> SymbolicState.sbindings ->
    Constants.coq_EVMWord list option

  val two_exp_160_minus_1 : Constants.coq_EVMWord
 end

module Optimizations_Def :
 sig
  type opt_smap_value_type =
    SymbolicState.smap_value -> SymbolicStateCmp.sstack_val_cmp_t ->
    SymbolicState.sbindings -> nat -> nat -> StackOpInstrs.stack_op_instr_map
    -> SymbolicState.smap_value * bool

  val optimize_first_sbindings :
    opt_smap_value_type -> SymbolicStateCmp.sstack_val_cmp_t ->
    SymbolicState.sbindings -> nat -> SymbolicState.sbindings * bool

  val optimize_first_sstate :
    opt_smap_value_type -> SymbolicStateCmp.sstack_val_cmp_t ->
    SymbolicState.sstate -> SymbolicState.sstate * bool

  type opt_entry =
    opt_smap_value_type
    (* singleton inductive, whose constructor was OpEntry *)

  type opt_pipeline = opt_entry list

  val optimize_first_opt_entry_sstate :
    opt_entry -> SymbolicStateCmp.sstack_val_cmp_t -> SymbolicState.sstate ->
    SymbolicState.sstate * bool

  val apply_opt_n_times :
    opt_entry -> SymbolicStateCmp.sstack_val_cmp_t -> nat ->
    SymbolicState.sstate -> SymbolicState.sstate * bool

  val apply_opt_n_times_pipeline_once :
    opt_pipeline -> SymbolicStateCmp.sstack_val_cmp_t -> nat ->
    SymbolicState.sstate -> SymbolicState.sstate * bool

  val apply_opt_n_times_pipeline_k :
    opt_pipeline -> SymbolicStateCmp.sstack_val_cmp_t -> nat -> nat ->
    SymbolicState.sstate -> SymbolicState.sstate * bool
 end

module Opt_add_zero :
 sig
  val optimize_add_zero_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_eval :
 sig
  val optimize_eval_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_not_not :
 sig
  val optimize_not_not_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_and_and1 :
 sig
  val optimize_and_and1_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_and_and2 :
 sig
  val optimize_and_and2_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_and_origin :
 sig
  val is_origin_mask :
    SymbolicState.sstack_val -> SymbolicState.sstack_val ->
    SymbolicStateCmp.sstack_val_cmp_t -> nat -> nat ->
    SymbolicState.sbindings -> StackOpInstrs.stack_op_instr_map -> bool

  val optimize_and_origin_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_mul_shl :
 sig
  val is_shl_1 :
    SymbolicState.sstack_val -> SymbolicStateCmp.sstack_val_cmp_t -> nat ->
    nat -> SymbolicState.sbindings -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.sstack_val option

  val optimize_mul_shl_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_div_shl :
 sig
  val is_shl_1 :
    SymbolicState.sstack_val -> SymbolicStateCmp.sstack_val_cmp_t -> nat ->
    nat -> SymbolicState.sbindings -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.sstack_val option

  val optimize_div_shl_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_shr_zero_x :
 sig
  val optimize_shr_zero_x_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_shr_x_zero :
 sig
  val optimize_shr_x_zero_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_eq_zero :
 sig
  val optimize_eq_zero_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_sub_x_x :
 sig
  val optimize_sub_x_x_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_and_zero :
 sig
  val optimize_and_zero_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_div_one :
 sig
  val optimize_div_one_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_lt_one :
 sig
  val optimize_lt_one_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_gt_one :
 sig
  val optimize_gt_one_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_and_address :
 sig
  val is_address_mask :
    SymbolicState.sstack_val -> SymbolicState.sstack_val ->
    SymbolicStateCmp.sstack_val_cmp_t -> nat -> nat ->
    SymbolicState.sbindings -> StackOpInstrs.stack_op_instr_map -> bool

  val optimize_and_address_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_mul_one :
 sig
  val optimize_mul_one_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_iszero_gt :
 sig
  val is_gt_zero :
    SymbolicState.sstack_val -> SymbolicStateCmp.sstack_val_cmp_t -> nat ->
    nat -> SymbolicState.sbindings -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.sstack_val option

  val optimize_iszero_gt_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_eq_iszero :
 sig
  val is_iszero :
    SymbolicState.sstack_val -> SymbolicStateCmp.sstack_val_cmp_t -> nat ->
    nat -> SymbolicState.sbindings -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.sstack_val option

  val optimize_eq_iszero_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_and_caller :
 sig
  val is_caller_mask :
    SymbolicState.sstack_val -> SymbolicState.sstack_val ->
    SymbolicStateCmp.sstack_val_cmp_t -> nat -> nat ->
    SymbolicState.sbindings -> StackOpInstrs.stack_op_instr_map -> bool

  val optimize_and_caller_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_iszero3 :
 sig
  val optimize_iszero3_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_add_sub :
 sig
  val is_sub_x :
    SymbolicState.sstack_val -> SymbolicState.sstack_val ->
    SymbolicStateCmp.sstack_val_cmp_t -> nat -> nat ->
    SymbolicState.sbindings -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.sstack_val option

  val optimize_add_sub_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_shl_zero_x :
 sig
  val optimize_shl_zero_x_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_sub_zero :
 sig
  val optimize_sub_zero_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_shl_x_zero :
 sig
  val optimize_shl_x_zero_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_mul_zero :
 sig
  val optimize_mul_zero_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_div_x_x :
 sig
  val eq_and_diff_zero :
    SymbolicState.sstack_val -> SymbolicState.sstack_val ->
    SymbolicStateCmp.sstack_val_cmp_t -> nat -> SymbolicState.sbindings ->
    nat -> StackOpInstrs.stack_op_instr_map -> bool

  val optimize_div_x_x_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_div_zero :
 sig
  val optimize_div_zero_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_mod_one :
 sig
  val optimize_mod_one_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_mod_zero :
 sig
  val optimize_mod_zero_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_mod_x_x :
 sig
  val optimize_mod_x_x_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_exp_x_zero :
 sig
  val optimize_exp_x_zero_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_exp_x_one :
 sig
  val optimize_exp_x_one_sbinding : Optimizations_Def.opt_smap_value_type
 end

module Opt_exp_one_x :
 sig
  val optimize_exp_one_x_sbinding : Optimizations_Def.opt_smap_value_type
 end

module MemoryOpsSolvers :
 sig
  type mload_solver_type =
    SymbolicState.sstack_val -> SymbolicState.smemory -> nat ->
    SymbolicState.smap -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.smap_value

  type mload_solver_ext_type =
    SymbolicStateCmp.sstack_val_cmp_ext_1_t -> SymbolicState.sstack_val ->
    SymbolicState.smemory -> nat -> SymbolicState.smap ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.smap_value

  type smemory_updater_type =
    SymbolicState.sstack_val SymbolicState.memory_update ->
    SymbolicState.smemory -> nat -> SymbolicState.smap ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.smemory

  type smemory_updater_ext_type =
    SymbolicStateCmp.sstack_val_cmp_ext_1_t -> SymbolicState.sstack_val
    SymbolicState.memory_update -> SymbolicState.smemory -> nat ->
    SymbolicState.smap -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.smemory
 end

module StorageOpsSolvers :
 sig
  type sload_solver_type =
    SymbolicState.sstack_val -> SymbolicState.sstorage -> nat ->
    SymbolicState.smap -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.smap_value

  type sload_solver_ext_type =
    SymbolicStateCmp.sstack_val_cmp_ext_1_t -> SymbolicState.sstack_val ->
    SymbolicState.sstorage -> nat -> SymbolicState.smap ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.smap_value

  type sstorage_updater_type =
    SymbolicState.sstack_val SymbolicState.storage_update ->
    SymbolicState.sstorage -> nat -> SymbolicState.smap ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.sstorage

  type sstorage_updater_ext_type =
    SymbolicStateCmp.sstack_val_cmp_ext_1_t -> SymbolicState.sstack_val
    SymbolicState.storage_update -> SymbolicState.sstorage -> nat ->
    SymbolicState.smap -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.sstorage
 end

module SymbolicExecution :
 sig
  val push_s :
    Constants.coq_EVMWord -> SymbolicState.sstate ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.sstate option

  val metapush_s :
    n -> n -> SymbolicState.sstate -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.sstate option

  val pop_s :
    SymbolicState.sstate -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.sstate option

  val dup_s :
    nat -> SymbolicState.sstate -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.sstate option

  val swap_s :
    nat -> SymbolicState.sstate -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.sstate option

  val mload_s :
    MemoryOpsSolvers.mload_solver_type -> SymbolicState.sstate ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.sstate option

  val sload_s :
    StorageOpsSolvers.sload_solver_type -> SymbolicState.sstate ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.sstate option

  val sha3_s :
    SymbolicState.sstate -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.sstate option

  val mstore8_s :
    MemoryOpsSolvers.smemory_updater_type -> SymbolicState.sstate ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.sstate option

  val mstore_s :
    MemoryOpsSolvers.smemory_updater_type -> SymbolicState.sstate ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.sstate option

  val sstore_s :
    StorageOpsSolvers.sstorage_updater_type -> SymbolicState.sstate ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.sstate option

  val exec_stack_op_intsr_s :
    Program.stack_op_instr -> SymbolicState.sstate ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.sstate option

  val evm_exec_instr_s :
    MemoryOpsSolvers.smemory_updater_type ->
    StorageOpsSolvers.sstorage_updater_type ->
    MemoryOpsSolvers.mload_solver_type -> StorageOpsSolvers.sload_solver_type
    -> Program.instr -> SymbolicState.sstate ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.sstate option

  val evm_exec_block_s :
    MemoryOpsSolvers.smemory_updater_type ->
    StorageOpsSolvers.sstorage_updater_type ->
    MemoryOpsSolvers.mload_solver_type -> StorageOpsSolvers.sload_solver_type
    -> Program.block -> SymbolicState.sstate ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.sstate option

  val evm_sym_exec :
    MemoryOpsSolvers.smemory_updater_type ->
    StorageOpsSolvers.sstorage_updater_type ->
    MemoryOpsSolvers.mload_solver_type -> StorageOpsSolvers.sload_solver_type
    -> Program.block -> nat -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.sstate option
 end

module StorageOpsSolversImpl :
 sig
  val trivial_sload_solver :
    SymbolicStateCmp.sstack_val_cmp_ext_1_t -> SymbolicState.sstack_val ->
    SymbolicState.sstorage -> nat -> SymbolicState.smap ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.smap_value

  val trivial_sstorage_updater :
    SymbolicStateCmp.sstack_val_cmp_ext_1_t -> SymbolicState.sstack_val
    SymbolicState.storage_update -> SymbolicState.sstorage -> nat ->
    SymbolicState.smap -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.sstack_val SymbolicState.storage_update list

  val not_eq_keys :
    SymbolicState.sstack_val -> SymbolicState.sstack_val -> bool

  val basic_sload_solver :
    SymbolicStateCmp.sstack_val_cmp_ext_1_t -> SymbolicState.sstack_val ->
    SymbolicState.sstorage -> nat -> SymbolicState.smap ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.smap_value

  val basic_sload_updater_remove_dups :
    SymbolicStateCmp.sstack_val_cmp_ext_1_t -> SymbolicState.sstack_val ->
    SymbolicState.sstorage -> nat -> SymbolicState.smap ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.sstack_val
    SymbolicState.storage_update list

  val basic_sstorage_updater :
    SymbolicStateCmp.sstack_val_cmp_ext_1_t -> SymbolicState.sstack_val
    SymbolicState.storage_update -> SymbolicState.sstorage -> nat ->
    SymbolicState.smap -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.sstack_val SymbolicState.storage_update list
 end

module MemoryOpsSolversImpl :
 sig
  val trivial_mload_solver :
    SymbolicStateCmp.sstack_val_cmp_ext_1_t -> SymbolicState.sstack_val ->
    SymbolicState.smemory -> nat -> SymbolicState.smap ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.smap_value

  val trivial_smemory_updater :
    SymbolicStateCmp.sstack_val_cmp_ext_1_t -> SymbolicState.sstack_val
    SymbolicState.memory_update -> SymbolicState.smemory -> nat ->
    SymbolicState.smap -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.sstack_val SymbolicState.memory_update list

  val memory_slots_do_not_overlap :
    SymbolicState.sstack_val -> SymbolicState.sstack_val -> n -> n -> bool

  val basic_mload_solver :
    SymbolicStateCmp.sstack_val_cmp_ext_1_t -> SymbolicState.sstack_val ->
    SymbolicState.smemory -> nat -> SymbolicState.smap ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.smap_value

  val mstore8_is_included_in_mstore :
    SymbolicState.sstack_val -> SymbolicState.sstack_val -> bool

  val basic_smemory_updater_remove_mstore_dups :
    SymbolicStateCmp.sstack_val_cmp_ext_1_t -> SymbolicState.sstack_val ->
    SymbolicState.smemory -> nat -> SymbolicState.smap ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.sstack_val
    SymbolicState.memory_update list

  val basic_smemory_updater_remove_mstore8_dups :
    SymbolicStateCmp.sstack_val_cmp_ext_1_t -> SymbolicState.sstack_val ->
    SymbolicState.smemory -> nat -> SymbolicState.smap ->
    StackOpInstrs.stack_op_instr_map -> SymbolicState.sstack_val
    SymbolicState.memory_update list

  val basic_smemory_updater :
    SymbolicStateCmp.sstack_val_cmp_ext_1_t -> SymbolicState.sstack_val
    SymbolicState.memory_update -> SymbolicState.smemory -> nat ->
    SymbolicState.smap -> StackOpInstrs.stack_op_instr_map ->
    SymbolicState.sstack_val SymbolicState.memory_update list
 end

module SStackValCmpImpl :
 sig
  val trivial_compare_sstack_val :
    SymbolicStateCmp.smemory_cmp_ext_t -> SymbolicStateCmp.sstorage_cmp_ext_t
    -> SymbolicStateCmp.sha3_cmp_ext_t -> nat -> SymbolicState.sstack_val ->
    SymbolicState.sstack_val -> nat -> SymbolicState.sbindings -> nat ->
    SymbolicState.sbindings -> nat -> StackOpInstrs.stack_op_instr_map -> bool

  val basic_compare_sstack_val :
    SymbolicStateCmp.smemory_cmp_ext_t -> SymbolicStateCmp.sstorage_cmp_ext_t
    -> SymbolicStateCmp.sha3_cmp_ext_t -> nat -> SymbolicState.sstack_val ->
    SymbolicState.sstack_val -> nat -> SymbolicState.sbindings -> nat ->
    SymbolicState.sbindings -> nat -> StackOpInstrs.stack_op_instr_map -> bool
 end

module MemoryCmpImpl :
 sig
  val trivial_memory_cmp :
    SymbolicStateCmp.sstack_val_cmp_t -> SymbolicState.smemory ->
    SymbolicState.smemory -> nat -> SymbolicState.sbindings -> nat ->
    SymbolicState.sbindings -> nat -> StackOpInstrs.stack_op_instr_map -> bool

  val basic_memory_cmp :
    SymbolicStateCmp.sstack_val_cmp_t -> SymbolicState.smemory ->
    SymbolicState.smemory -> nat -> SymbolicState.sbindings -> nat ->
    SymbolicState.sbindings -> nat -> StackOpInstrs.stack_op_instr_map -> bool

  val swap_memory_update :
    SymbolicState.sstack_val SymbolicState.memory_update ->
    SymbolicState.sstack_val SymbolicState.memory_update -> nat ->
    SymbolicState.sbindings -> bool

  val reorder_updates' :
    nat -> SymbolicState.smemory -> nat -> SymbolicState.sbindings ->
    bool * SymbolicState.smemory

  val reorder_memory_updates :
    nat -> nat -> SymbolicState.smemory -> nat -> SymbolicState.sbindings ->
    SymbolicState.smemory

  val po_memory_cmp :
    SymbolicStateCmp.sstack_val_cmp_t -> SymbolicState.smemory ->
    SymbolicState.smemory -> nat -> SymbolicState.sbindings -> nat ->
    SymbolicState.sbindings -> nat -> StackOpInstrs.stack_op_instr_map -> bool
 end

module SHA3CmpImplSoundness :
 sig
  val trivial_sha3_cmp :
    SymbolicStateCmp.sstack_val_cmp_t -> SymbolicState.sstack_val ->
    SymbolicState.sstack_val -> SymbolicState.smemory ->
    SymbolicState.sstack_val -> SymbolicState.sstack_val ->
    SymbolicState.smemory -> nat -> SymbolicState.sbindings -> nat ->
    SymbolicState.sbindings -> nat -> StackOpInstrs.stack_op_instr_map -> bool
 end

module StorageCmpImpl :
 sig
  type sstorage_cmp_t =
    SymbolicState.sstorage -> SymbolicState.sstorage -> nat ->
    SymbolicState.sbindings -> nat -> SymbolicState.sbindings -> nat ->
    StackOpInstrs.stack_op_instr_map -> bool

  type sstorage_cmp_ext_t =
    SymbolicStateCmp.sstack_val_cmp_t -> sstorage_cmp_t

  val trivial_storage_cmp :
    SymbolicStateCmp.sstack_val_cmp_t -> SymbolicState.sstorage ->
    SymbolicState.sstorage -> nat -> SymbolicState.sbindings -> nat ->
    SymbolicState.sbindings -> nat -> StackOpInstrs.stack_op_instr_map -> bool

  val basic_storage_cmp :
    SymbolicStateCmp.sstack_val_cmp_t -> SymbolicState.sstorage ->
    SymbolicState.sstorage -> nat -> SymbolicState.sbindings -> nat ->
    SymbolicState.sbindings -> nat -> StackOpInstrs.stack_op_instr_map -> bool

  val swap_storage_update :
    SymbolicState.sstack_val SymbolicState.storage_update ->
    SymbolicState.sstack_val SymbolicState.storage_update -> nat ->
    SymbolicState.sbindings -> bool

  val reorder_updates' :
    nat -> SymbolicState.sstorage -> nat -> SymbolicState.sbindings ->
    bool * SymbolicState.sstorage

  val reorder_storage_updates :
    nat -> nat -> SymbolicState.sstorage -> nat -> SymbolicState.sbindings ->
    SymbolicState.sstorage

  val po_storage_cmp :
    SymbolicStateCmp.sstack_val_cmp_t -> SymbolicState.sstorage ->
    SymbolicState.sstorage -> nat -> SymbolicState.sbindings -> nat ->
    SymbolicState.sbindings -> nat -> StackOpInstrs.stack_op_instr_map -> bool
 end

module BlockEquivChecker :
 sig
  type mload_solver_v =
    MemoryOpsSolvers.mload_solver_ext_type
    (* singleton inductive, whose constructor was MLoadSolver *)

  type available_mload_solvers =
  | MLoadSolver_Trivial
  | MLoadSolver_Basic

  val get_mload_solver : available_mload_solvers -> mload_solver_v

  type sload_solver_v =
    StorageOpsSolvers.sload_solver_ext_type
    (* singleton inductive, whose constructor was SLoadSolver *)

  type available_sload_solvers =
  | SLoadSolver_Trivial
  | SLoadSolver_Basic

  val get_sload_solver : available_sload_solvers -> sload_solver_v

  type smemory_updater_v =
    MemoryOpsSolvers.smemory_updater_ext_type
    (* singleton inductive, whose constructor was SMemUpdater *)

  type available_smemory_updaters =
  | SMemUpdater_Trivial
  | SMemUpdater_Basic

  val get_smemory_updater : available_smemory_updaters -> smemory_updater_v

  type sstorage_updater_v =
    StorageOpsSolvers.sstorage_updater_ext_type
    (* singleton inductive, whose constructor was SStrgUpdater *)

  type available_sstorage_updaters =
  | SStrgUpdater_Trivial
  | SStrgUpdater_Basic

  val get_sstorage_updater : available_sstorage_updaters -> sstorage_updater_v

  type smemory_cmp_v =
    SymbolicStateCmp.smemory_cmp_ext_t
    (* singleton inductive, whose constructor was SMemCmp *)

  type available_memory_cmp =
  | SMemCmp_Trivial
  | SMemCmp_Basic
  | SMemCmp_PO

  val get_memory_cmp : available_memory_cmp -> smemory_cmp_v

  type sstorage_cmp_v =
    StorageCmpImpl.sstorage_cmp_ext_t
    (* singleton inductive, whose constructor was SStrgCmp *)

  type available_storage_cmp =
  | SStrgCmp_Trivial
  | SStrgCmp_Basic
  | SStrgCmp_PO

  val get_storage_cmp : available_storage_cmp -> sstorage_cmp_v

  type sha3_cmp_v =
    SymbolicStateCmp.sha3_cmp_ext_t
    (* singleton inductive, whose constructor was SHA3Cmp *)

  val get_sha3_cmp : __ -> sha3_cmp_v

  type sstack_val_cmp_v =
    SymbolicStateCmp.sstack_val_cmp_ext_2_t
    (* singleton inductive, whose constructor was SStackValCmp *)

  type available_sstack_val_cmp =
  | SStackValCmp_Trivial
  | SStackValCmp_Basic

  val get_sstack_val_cmp : available_sstack_val_cmp -> sstack_val_cmp_v

  type available_optimization_step =
  | OPT_eval
  | OPT_add_zero
  | OPT_not_not
  | OPT_and_and1
  | OPT_and_and2
  | OPT_and_origin
  | OPT_mul_shl
  | OPT_div_shl
  | OPT_shr_zero_x
  | OPT_shr_x_zero
  | OPT_eq_zero
  | OPT_sub_x_x
  | OPT_and_zero
  | OPT_div_one
  | OPT_lt_one
  | OPT_gt_one
  | OPT_and_address
  | OPT_mul_one
  | OPT_iszero_gt
  | OPT_eq_iszero
  | OPT_and_caller
  | OPT_iszero3
  | OPT_add_sub
  | OPT_shl_zero_x
  | OPT_sub_zero
  | OPT_shl_x_zero
  | OPT_mul_zero
  | OPT_div_x_x
  | OPT_div_zero
  | OPT_mod_one
  | OPT_mod_zero
  | OPT_mod_x_x
  | OPT_exp_x_zero
  | OPT_exp_x_one
  | OPT_exp_one_x

  type list_opt_steps = available_optimization_step list

  val get_optimization_step :
    available_optimization_step -> Optimizations_Def.opt_entry

  val all_optimization_steps : available_optimization_step list

  val all_optimization_steps' : available_optimization_step list

  val get_pipeline : list_opt_steps -> Optimizations_Def.opt_pipeline

  val evm_eq_block_chkr' :
    MemoryOpsSolvers.smemory_updater_ext_type ->
    StorageOpsSolvers.sstorage_updater_ext_type ->
    MemoryOpsSolvers.mload_solver_ext_type ->
    StorageOpsSolvers.sload_solver_ext_type ->
    SymbolicStateCmp.sstack_val_cmp_ext_2_t ->
    SymbolicStateCmp.smemory_cmp_ext_t -> StorageCmpImpl.sstorage_cmp_ext_t
    -> SymbolicStateCmp.sha3_cmp_ext_t -> Optimizations_Def.opt_pipeline ->
    nat -> nat -> Program.block -> Program.block -> nat -> bool

  val evm_eq_block_chkr_lazy :
    available_smemory_updaters -> available_sstorage_updaters ->
    available_mload_solvers -> available_sload_solvers ->
    available_sstack_val_cmp -> available_memory_cmp -> available_storage_cmp
    -> list_opt_steps -> nat -> nat -> Program.block -> Program.block -> nat
    -> bool
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

  val is_metapush : char list -> bool

  val is_dup : char list -> nat option

  val is_swap : char list -> nat option

  val parse_non_push_instr : char list -> Program.instr option

  val parse_block' : char list list -> Program.block option

  val parse_block : char list -> Program.block option

  val str_to_opt :
    char list -> BlockEquivChecker.available_optimization_step option

  val strs_to_opts : char list list -> BlockEquivChecker.list_opt_steps option

  val parse_opts_arg :
    char list list -> BlockEquivChecker.list_opt_steps option

  val parse_memory_updater :
    char list -> BlockEquivChecker.available_smemory_updaters option

  val parse_storage_updater :
    char list -> BlockEquivChecker.available_sstorage_updaters option

  val parse_mload_solver :
    char list -> BlockEquivChecker.available_mload_solvers option

  val parse_sload_solver :
    char list -> BlockEquivChecker.available_sload_solvers option

  val parse_sstack_value_cmp :
    char list -> BlockEquivChecker.available_sstack_val_cmp option

  val parse_memory_cmp :
    char list -> BlockEquivChecker.available_memory_cmp option

  val parse_storage_cmp :
    char list -> BlockEquivChecker.available_storage_cmp option

  val parse_sha3_cmp : char list -> __ option

  val block_eq :
    char list -> char list -> char list -> char list -> char list ->
    char list -> char list -> char list -> char list -> char list ->
    char list list -> (char list -> char list -> char list -> bool option)
    option
 end
