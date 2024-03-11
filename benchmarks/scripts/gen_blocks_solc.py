import gzip
import os
import random
import re
import shutil
import subprocess
import sys

from gen_tests_for_ocaml import gen_blocks_from_daniel_format

# solc compiler that generates pre and post optimizations bytecode
# https://github.com/ethereum/solidity/compare/develop...forves
SOLC_PATH = '/tmp/solc'


def copy_gz_json(dest_gz):
    # Copy the file /tmp/blockTrace.json as the GZ file 'dest_gz'
    with open('/tmp/blockTrace.json', 'rb') as json_file:
        content = json_file.read()
        with gzip.open(dest_gz, 'wb') as f:
            f.write(content)
    print(f'Generated {dest_gz}')


def gen_evm_json_gz(dir):
    i = 0
    for dirpath, _, filenames in os.walk(dir):
        dirname = os.path.basename(dirpath)
        if dirname.startswith('0x') and f"{dirname}.sol" in filenames:
            i += 1
            print(f"Compiling {dirpath}")
            proc = subprocess.run([SOLC_PATH, '--bin', '--optimize', '--optimize-runs', '4294967295',
                                   f'{dirname}.sol'], shell=False, capture_output=True, cwd=dirpath)
            print(proc.returncode)
            if proc.returncode == 0:
                dest_gz = os.path.join(dirpath, 'blockTrace.json.gz')
                copy_gz_json(dest_gz)
                # dest = os.path.join(dirpath, 'blockTrace.json')
                # dest_check = shutil.copyfile('/tmp/blockTrace.json', dest)
                # print(f'Generated  {dest_check}')

            proc = subprocess.run([SOLC_PATH, '--bin', '--via-ir', '--optimize', '--optimize-runs', '4294967295',
                                   f'{dirname}.sol'], shell=False,
                                  capture_output=True, cwd=dirpath)
            print(proc.returncode)
            if proc.returncode == 0:
                dest_gz = os.path.join(dirpath, 'blockTrace_yul.json.gz')
                copy_gz_json(dest_gz)
                # dest = os.path.join(dirpath, 'blockTrace_yul.json')
                # dest_check = shutil.copyfile('/tmp/blockTrace.json', dest)
                # print(f'Generated  {dest_check}')
            print('\n\n')
    print(i)


# def gen_blocks_from_json_gz(directory):
#     for dirpath, _, filenames in os.walk(directory):
#         smart_contract = os.path.basename(dirpath)
#         if 'blockTrace.json.gz' in filenames:
#             json_path = os.path.join(dirpath, 'blockTrace.json.gz')
#             blocks_path = os.path.join(dirpath, 'blocks.txt')
#             print(f'Extracting blocks from {json_path}', flush=True)
#             blocks = gen_blocks_from_daniel_format_gz(json_path, smart_contract)
#             with open(blocks_path, 'wt', encoding='utf8') as f:
#                 f.write(blocks)
#         if 'blockTrace_yul.json.gz' in filenames:
#             json_path = os.path.join(dirpath, 'blockTrace_yul.json.gz')
#             blocks_path = os.path.join(dirpath, 'blocks_yul.txt')
#             print(f'Extracting blocks from {json_path}', flush=True)
#             blocks = gen_blocks_from_daniel_format_gz(json_path, smart_contract)
#             with open(blocks_path, 'wt', encoding='utf8') as f:
#                 f.write(blocks)


def gen_blocks_from_json(dir):
    for dirpath, _, filenames in os.walk(dir):
        smart_contract = os.path.basename(dirpath)
        if 'blockTrace.json' in filenames:
            json_path = os.path.join(dirpath, 'blockTrace.json')
            blocks_path = os.path.join(dirpath, 'blocks.txt')
            print(f'Processing {json_path}', flush=True)
            blocks = gen_blocks_from_daniel_format(json_path, smart_contract)
            with open(blocks_path, 'w', encoding='utf8') as f:
                f.write(blocks)
        if 'blockTrace_yul.json' in filenames:
            json_path = os.path.join(dirpath, 'blockTrace_yul.json')
            blocks_path = os.path.join(dirpath, 'blocks_yul.txt')
            print(f'Processing {json_path}', flush=True)
            blocks = gen_blocks_from_daniel_format(json_path, smart_contract)
            with open(blocks_path, 'w', encoding='utf8') as f:
                f.write(blocks)


# def get_all_solc(dir):
#     l = []
#     for dirpath, _, filenames in os.walk(dir):
#         dirname = os.path.basename(dirpath)
#         if dirname.startswith('0x') and f"{dirname}.sol" in filenames:
#             l.append((dirpath, dirname))
#     return l


# def gen_blocks_one_file_no_json(file_info):
#     json_path = '/tmp/blockTrace.json'
#     dirpath = file_info[0]
#     dirname = file_info[1]
#
#     proc = subprocess.run([SOLC_PATH, '--bin', '--optimize', '--optimize-runs', '4294967295',
#                            f'{dirname}.sol'], shell=False, capture_output=True, cwd=dirpath)
#     print(proc.returncode)
#     if proc.returncode == 0:
#         print(f"Compiled OPT {dirpath}")
#         blocks_path = os.path.join(dirpath, 'blocks.txt')
#         blocks = gen_blocks_from_daniel_format(json_path, dirname)
#         with open(blocks_path, 'wt', encoding='ascii') as f:
#             f.write(blocks)
#
#     proc = subprocess.run([SOLC_PATH, '--bin', '--via-ir', '--optimize', '--optimize-runs', '4294967295',
#                          f'{dirname}.sol'], shell=False,
#                          capture_output=True, cwd=dirpath)
#     print(proc.returncode)
#     if proc.returncode == 0:
#         print(f"Compiled YUL {dirpath}")
#         blocks_path = os.path.join(dirpath, 'blocks_yul.txt')
#         blocks = gen_blocks_from_daniel_format(json_path, dirname)
#         with open(blocks_path, 'wt', encoding='ascii') as f:
#             f.write(blocks)
#     print('\n\n')


def gen_blocks_no_json(directory, sample=1.0):
    json_path = '/tmp/blockTrace.json'
    i = 0
    non_yul = 0
    yul = 0
    for dir_path, _, filenames in os.walk(directory):
        dir_name = os.path.basename(dir_path)
        smart_contract = os.path.basename(dir_path)
        if dir_name.startswith('0x') and f"{dir_name}.sol" in filenames and random.random() <= sample:
            i += 1
            print(f"{i}) Compiling {dir_path}")
            proc = subprocess.run([SOLC_PATH, '--bin', '--optimize', '--optimize-runs', '4294967295',
                                   f'{dir_name}.sol'], shell=False, capture_output=True, cwd=dir_path)
            if proc.returncode == 0:
                non_yul += 1
                blocks_path = os.path.join(dir_path, 'blocks.txt')
                print(f'    * Processing non-YUL {json_path}', flush=True)
                # TODO: pass a list of previous blocks to avoid the generation of equivalent blocks modulo constants
                # TODO: in PUSHx and METAPUSHx
                blocks = gen_blocks_from_daniel_format(json_path, smart_contract)
                with open(blocks_path, 'wt', encoding='utf8') as f:
                    f.write(blocks)
                    f.close()

            proc = subprocess.run([SOLC_PATH, '--bin', '--via-ir', '--optimize', '--optimize-runs', '4294967295',
                                   f'{dir_name}.sol'], shell=False,
                                  capture_output=True, cwd=dir_path)
            if proc.returncode == 0:
                yul += 1
                blocks_path = os.path.join(dir_path, 'blocks_yul.txt')
                print(f'    * Processing YUL {json_path}', flush=True)
                # TODO: pass a list of previous blocks to avoid the generation of equivalent blocks modulo constants
                # TODO: in PUSHx and METAPUSHx
                blocks = gen_blocks_from_daniel_format(json_path, smart_contract)
                with open(blocks_path, 'wt', encoding='utf8') as f:
                    f.write(blocks)
                    f.close()
            print()

    print('\n------------------------------')
    print(f'Processed {i} smart contracts')
    print(f'Generated {non_yul} block files from non-YUL optimizations')
    print(f'Generated {yul} block files from YUL optimizations')


def equiv_blocks(b1, b2):
    """ Checks if b1 and b2 are equivalente blocks modulo constants in PUSHx or 'METAPUSH x' opcodes """
    b1_plain = re.sub(r"METAPUSH (\d)", r"PUSH\1", b1)  # Replaces "METAPUSH x" by "PUSHx"
    b2_plain = re.sub(r"METAPUSH (\d)", r"PUSH\1", b2)
    b1_l = b1_plain.split()
    b2_l = b2_plain.split()
    if len(b1_l) != len(b2_l):
        return False

    ignore_next = False
    for op1, op2 in zip(b1_l, b2_l):
        if ignore_next:
            # We're reading constants 0x...
            ignore_next = False
            continue

        if op1 != op2:
            return False

        if op1.startswith('PUSH'):
            ignore_next = True

    return True


# def new_block(previous, b):
#     return all(map(lambda x: not equiv_blocks(x, b)), previous)


if __name__ == "__main__":
    # b1 = "PUSH1 0x0 SLOAD PUSH20 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1"
    # b2 = "PUSH1 0xFF SLOAD PUSH20 0xF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1"
    # b3 = "PUSH1 0xFF SLOAD PUSH20 0xF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1 ADD"
    # b4 = "METAPUSH 5 0x9 METAPUSH 5 0x10 CALLDATASIZE PUSH1 0x4 METAPUSH 5 0x11"
    # b5 = "METAPUSH 5 0xAA METAPUSH 5 0x0 CALLDATASIZE PUSH1 0x66 METAPUSH 5 0x22"
    # b6 = "METAPUSH 5 0xAA PUSH5 0x0 CALLDATASIZE PUSH1 0x66 METAPUSH 5 0x22"
    # b7 = "PUSH5 0xBB METAPUSH 5 0x0F CALLDATASIZE PUSH1 0x66 PUSH5 0x22"
    # print(equiv_blocks(b1, b2))  # True
    # print(equiv_blocks(b2, b3))  # False
    # print(equiv_blocks(b4, b5))  # True
    # print(equiv_blocks(b4, b6))  # True
    # print(equiv_blocks(b4, b7))  # True

    # gen_evm_json_gz(sys.argv[1])
    # gen_blocks_from_json_gz(sys.argv[1])
    gen_blocks_no_json(sys.argv[1], 0.05)  # Random sampling 5%
    # print(get_all_solc(sys.argv[1]))


