import gzip
import os
import shutil
import subprocess
import sys

from gen_tests_for_ocaml import gen_blocks_from_daniel_format_gz, gen_blocks_from_daniel_format

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


def gen_blocks_from_json_gz(directory):
    for dirpath, _, filenames in os.walk(directory):
        smart_contract = os.path.basename(dirpath)
        if 'blockTrace.json.gz' in filenames:
            json_path = os.path.join(dirpath, 'blockTrace.json.gz')
            blocks_path = os.path.join(dirpath, 'blocks.txt')
            print(f'Extracting blocks from {json_path}', flush=True)
            blocks = gen_blocks_from_daniel_format_gz(json_path, smart_contract)
            with open(blocks_path, 'wt', encoding='utf8') as f:
                f.write(blocks)
        if 'blockTrace_yul.json.gz' in filenames:
            json_path = os.path.join(dirpath, 'blockTrace_yul.json.gz')
            blocks_path = os.path.join(dirpath, 'blocks_yul.txt')
            print(f'Extracting blocks from {json_path}', flush=True)
            blocks = gen_blocks_from_daniel_format_gz(json_path, smart_contract)
            with open(blocks_path, 'wt', encoding='utf8') as f:
                f.write(blocks)


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


def gen_blocks_no_json(dir):
    json_path = '/tmp/blockTrace.json'
    i = 0
    for dirpath, _, filenames in os.walk(dir):
        dirname = os.path.basename(dirpath)
        smart_contract = os.path.basename(dirpath)
        if dirname.startswith('0x') and f"{dirname}.sol" in filenames:
            i += 1
            print(f"Compiling {dirpath}")
            proc = subprocess.run([SOLC_PATH, '--bin', '--optimize', '--optimize-runs', '4294967295',
                                   f'{dirname}.sol'], shell=False, capture_output=True, cwd=dirpath)
            print(proc.returncode)
            if proc.returncode == 0:
                blocks_path = os.path.join(dirpath, 'blocks.txt')
                print(f'Processing {json_path}', flush=True)
                blocks = gen_blocks_from_daniel_format(json_path, smart_contract)
                with open(blocks_path, 'wt', encoding='utf8') as f:
                    f.write(blocks)
                    f.close()

            proc = subprocess.run([SOLC_PATH, '--bin', '--via-ir', '--optimize', '--optimize-runs', '4294967295',
                                   f'{dirname}.sol'], shell=False,
                                  capture_output=True, cwd=dirpath)
            print(proc.returncode)
            if proc.returncode == 0:
                blocks_path = os.path.join(dirpath, 'blocks_yul.txt')
                print(f'Processing {json_path}', flush=True)
                blocks = gen_blocks_from_daniel_format(json_path, smart_contract)
                with open(blocks_path, 'wt', encoding='utf8') as f:
                    f.write(blocks)
                    f.close()
            print('\n\n')
    print(i)


if __name__ == "__main__":
    # gen_evm_json_gz(sys.argv[1])
    # gen_blocks_from_json_gz(sys.argv[1])
    gen_blocks_no_json(sys.argv[1])
