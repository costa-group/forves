import re
from typing import List
import sys
import os
import csv
import json

include_identical = False

#
#
bytecode_vocab = [ 'ADD', 'MUL', 'NOT', 'SUB', 'DIV', 'SDIV', 'MOD', 'SMOD', 'ADDMOD', 'MULMOD', 'EXP', 'SIGNEXTEND', 'LT', 'GT', 'SLT', 'SGT', 'EQ', 'ISZERO', 'AND', 'OR', 'XOR', 'BYTE', 'SHL', 'SHR', 'SAR', 'SHA3', 'KECCAK256', 'ADDRESS', 'BALANCE', 'ORIGIN', 'CALLER', 'CALLVALUE', 'CALLDATALOAD', 'CALLDATASIZE ', 'CODESIZE', 'GASPRICE', 'EXTCODESIZE', 'RETURNDATASIZE', 'EXTCODEHASH', 'BLOCKHASH', 'COINBASE', 'TIMESTAMP', 'NUMBER', 'DIFFICULTY', 'GASLIMIT', 'CHAINID', 'SELFBALANCE', 'BASEFEE', 'SLOAD', 'MLOAD', 'PC', 'MSIZE', 'GAS', 'CREATE', 'CREATE2', 'CALLDATASIZE', 'CALLDATALOAD', 'JUMPI', 'JUMPDEST' ]

#
#
def is_pseudo_keyword(opcode: str) -> bool:
    if opcode.find("tag") ==-1 and opcode.find("#") ==-1 and opcode.find("$") ==-1 \
            and opcode.find("data") ==-1:
        return False
    else:
        return True



def split_bytecode(raw_instruction_str: str) -> List[str]:
    raw_instruction_str = raw_instruction_str.replace("PUSH [tag]", "PUSHt" )
    ops = raw_instruction_str.split(' ')
    opcodes = []
    i = 0
    operand = None
    size = None
    while i < len(ops):
        op = ops[i]
        # In theory, they should not appear inside a block, as they are removed beforehand.
        # Nevertheless, we include them just in case
        if op.startswith("JUMPDEST"):
           i += 1
        elif op.startswith("tag"):
           i += 2
        elif op.startswith("ASSIGNIMMUTABLE") or op.startswith("tag"): # or op.startswith("PUSHIMMUTABLE"):
            opcodes.append(op)
            i += 1
        elif not op.startswith("PUSH"):
            opcodes.append(op)
        else:
            # PUSHDEPLOYADDRESS and PUSHSIZE has no value associated
            if op.find("DEPLOYADDRESS") != -1 or op.find("SIZE") != -1:
                final_op = op

            # Just in case PUSHx instructions are included, we assign to them PUSH name instead
            elif re.fullmatch("PUSH([0-9]+)", op) is not None:
                match = re.fullmatch("PUSH([0-9]+)", op)
                final_op = 'PUSH'
                size = match.groups()[0]
                operand = f'0x{ops[i+1]}'
                i = i + 1
            # If position t+1 is a Yul Keyword, then it means we either have a simple PUSH instruction or one of the
            # pseudo PUSH that include a value as a second parameter
            elif not is_pseudo_keyword(ops[i + 1]):
                if op == "PUSH":
                    n =  (len(ops[i+1])+1) // 2
                    assert n >= 1 and n <= 32
                    final_op = 'PUSH'
                    size = f'{n}'
                    operand = f'0x{ops[i+1]}'
                    i = i + 1
                elif op == "PUSHt":
                    hexn = hex(int(ops[i+1]))
                    n =  (len(hexn)+1-2) // 2
                    assert n >= 1 and n <= 32
                    final_op = 'PUSH'
                    size = f'{n}'
                    operand = hexn
                    i = i + 1
                else:
                    final_op = op
                    i = i + 1
            # Otherwise, the opcode name is composed
            else:
                name_keyword = ops[i + 1]
                final_op = f'{op} {name_keyword}'
                i += 2
            
            opcodes.append(final_op)
            if size is not None:
                opcodes.append(size)
                size=None
            if operand is not None:
                opcodes.append(operand)
                operand=None

        i += 1

    return opcodes




def bin_to_word(b : str) :
    word = 'WO'
    for d in b:
        if d == '0':
            word = f'(WS false {word})'
        else:
            word = f'(WS true {word})'
    return word

def encode_num(n_hex : str):
    return f'(NToWord WLen {n_hex}%N)'

def str_to_list(bytecode_str):
    bytecode_seq =  split_bytecode(bytecode_str)
    n = len(bytecode_seq)
    if n == 0:
        raise Exception("zero length")
    
    out_seq=[]
    i = 0;
    while i<n:
        instr = bytecode_seq[i]
        if instr == "POP":
            out_seq.append(f'POP')
        elif instr == "PUSH":
            size = bytecode_seq[i+1]
            value = bytecode_seq[i+2]
            out_seq.append(f'PUSH{size} {value}')
            i = i + 2
        elif re.fullmatch("DUP([0-9]+)",instr):
            match = re.fullmatch("DUP([0-9]+)",instr)
            size = match.groups()[0]
            out_seq.append(f'DUP{size}')
        elif instr.startswith("SWAP"):
            match = re.fullmatch("SWAP([0-9]+)",instr)
            size = match.groups()[0]
            out_seq.append(f'SWAP{size}')
        else:
            idx = bytecode_vocab.index(instr) # just check the instruction is supported
            out_seq.append(instr)

        i = i + 1
    return out_seq

#
#
def print_test(bench_id,block_info, block_sfs):
    try:
        if not block_info["model_found"]=="True":
            return

        if not include_identical and block_info["previous_solution"].lower() == block_info["solution_found"].lower():
            return
        
        bytecode_as_list = str_to_list(block_info["previous_solution"])
        opt_bytecode_as_list = str_to_list(block_info["solution_found"])

        bytecode = ' '.join(bytecode_as_list)
        opt_bytecode = ' '.join(opt_bytecode_as_list)
        stack_size = len(block_sfs["src_ws"])

        print(f'# serial number: {block_info["sn"]}')
        print(f'# csv: {block_info["csv"]}')
        print(f'# block id: {block_info["block_id"]}')
        print(f'# rules applied: {block_sfs["rules"]}')
        print(opt_bytecode)
        print(bytecode)
        print(stack_size)
        print()
        return (len(bytecode_as_list),len(opt_bytecode_as_list))
    except Exception as e:
        print(e,file=sys.stderr)
        return None

#
#
def gen_tests(paths):
    total_p = 0
    total_opt_p = 0
    all_ex = []
    i = 0
    for path in paths:
        csv_dir = f'{path}/csv'
        for csv_filename in os.listdir(csv_dir):
            csv_filename_noext = os.path.splitext(csv_filename)[0]
            with open(f'{csv_dir}/{csv_filename}', newline='') as csvfile:
                csv_reader = csv.DictReader(csvfile)
                for block_info in csv_reader:
                    block_info["csv"] = csv_filename
                    block_info["sn"] = i
                    block_id = block_info['block_id']
                    with open(f'{path}/jsons/{csv_filename_noext}/{block_id}_input.json', 'r') as f:
                        block_sfs = json.load(f)
                        r = print_test(i, block_info, block_sfs)
                        if r is not None:
                            total_p = total_p + r[0]
                            total_opt_p = total_p + r[1]
                            i = i + 1
    print(f'{total_p/i:.2f},{total_opt_p/i:.2f}',file=sys.stderr)



def solc_json_block_to_str(b):
    s = ""
    for o in b:
        if 'value' in o:
            v = f" {o['value']}"
        else:
            v = ""
        if o["name"] != "JUMP":
            s += f'{o["name"]}{v} '
    return s[:-1]

def print_test_2(bstr1, bstr2):
    try:
        
        bytecode_as_list = str_to_list(bstr1)
        opt_bytecode_as_list = str_to_list(bstr2)

        bytecode = ' '.join(bytecode_as_list)
        opt_bytecode = ' '.join(opt_bytecode_as_list)
        stack_size = 500

        print('#')
        print(opt_bytecode)
        print(bytecode)
        print(stack_size)
        print()
    except Exception as e:
        print(e,file=sys.stderr)

def gen_tests_from_daniel_format(paths):
    for path in paths:
        with open(path, 'r') as f:
            bs = json.load(f)
            for b in bs:
                b1 = solc_json_block_to_str(b["pre"][".code"])
                b2 = solc_json_block_to_str(b["post"][".code"])
                print_test_2(b1,b2)

# Usage example:
#
#   python3 gen_tests.py /path-to/results_coq_evm/no_rl_gas_opt > no_rl_gas_opt_tests.v
#
if __name__ == "__main__":
    paths=sys.argv[1:]
    #gen_tests(paths)
    gen_tests_from_daniel_format(paths)
