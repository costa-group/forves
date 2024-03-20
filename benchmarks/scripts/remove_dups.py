# Remove duplicated pairs of blocks in a text file

import sys

def main(txt_file):
    blocks = []
    visited = set()
    with open(txt_file, 'r', encoding='utf8') as f:
        lines = f.readlines()
        nblocks = int(len(lines) / 5)

        for (i,o,s) in [(lines[5*i+1], lines[5*i+2], lines[5*i+3]) for i in range(nblocks)]:
            if (i,o) not in visited:
                visited.add((i,o))
                blocks.append((i,o,s))

        for (i,o,s) in blocks:
            print(f'#\n{i}{o}{s}')


if __name__ == "__main__":
    main(sys.argv[1])
