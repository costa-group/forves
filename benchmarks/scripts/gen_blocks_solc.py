import gzip
import os
import random
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
                blocks = gen_blocks_from_daniel_format(json_path, smart_contract)
                with open(blocks_path, 'wt', encoding='utf8') as f:
                    f.write(blocks)
                    f.close()
            print()

    print('\n------------------------------')
    print(f'Processed {i} smart contracts')
    print(f'Generated {non_yul} block files from non-YUL optimizations')
    print(f'Generated {yul} block files from YUL optimizations')


if __name__ == "__main__":
    # gen_evm_json_gz(sys.argv[1])
    # gen_blocks_from_json_gz(sys.argv[1])
    gen_blocks_no_json(sys.argv[1], 0.05)  # Random sampling 5%
    # print(get_all_solc(sys.argv[1]))

