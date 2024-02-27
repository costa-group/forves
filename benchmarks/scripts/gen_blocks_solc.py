import os
import sys
import subprocess
import shutil

from gen_tests_for_ocaml import gen_blocks_from_daniel_format


# solc compiler that generates pre and post optimizations bytecode
# https://github.com/ethereum/solidity/compare/develop...forves
SOLC_PATH = '/tmp/solc'


def gen_evm_json(dir):
    i = 0
    for dirpath,_,filenames in os.walk(dir):
        dirname = os.path.basename(dirpath)
        if dirname.startswith('0x') and f"{dirname}.sol" in filenames:
            i += 1
            print(f"Processing {dirpath}")
            #ret = os.system(f'~/solc {dirname}.sol')
            proc = subprocess.run([SOLC_PATH, '--bin', '--optimize', f'{dirname}.sol'], shell=False, capture_output=True, cwd=dirpath)
            print(proc.returncode)
            if proc.returncode == 0:
                dest = os.path.join(dirpath, 'blockTrace.json')
                dest_check = shutil.copyfile('/tmp/blockTrace.json', dest)
                print(f'Generated  {dest_check}')

            proc = subprocess.run([SOLC_PATH, '--bin', '--via-ir', '--optimize', f'{dirname}.sol'], shell=False, capture_output=True, cwd=dirpath)
            print(proc.returncode)
            if proc.returncode == 0:
                dest = os.path.join(dirpath, 'blockTrace_yul.json')
                dest_check = shutil.copyfile('/tmp/blockTrace.json', dest)
                print(f'Generated  {dest_check}')
            print('\n\n\n')
    print(i)


def gen_blocks(dir):
    for dirpath,_,filenames in os.walk(dir):
        if 'blockTrace.json' in filenames:
            json_path = os.path.join(dirpath, 'blockTrace.json')
            blocks_path = os.path.join(dirpath, 'blocks.txt')
            print(f'Processing {json_path}', flush=True)
            blocks = gen_blocks_from_daniel_format(json_path)
            with open(blocks_path, 'w', encoding='utf8') as f:
                f.write(blocks)
        if 'blockTrace_yul.json' in filenames:
            json_path = os.path.join(dirpath, 'blockTrace_yul.json')
            blocks_path = os.path.join(dirpath, 'blocks_yul.txt')
            print(f'Processing {json_path}', flush=True)
            blocks = gen_blocks_from_daniel_format(json_path)
            with open(blocks_path, 'w', encoding='utf8') as f:
                f.write(blocks)
    

if __name__ == "__main__":
    # gen_evm_json(sys.argv[1])
    gen_blocks(sys.argv[1])
