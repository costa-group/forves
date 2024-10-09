
def filter_blocks(blocks_filename, filter_filename, positions):
    """ Filter blocks from a file that are in the position included in "positions" 
        and write them to another file."""
    with open(blocks_filename, "r", encoding='utf8') as f_in:
        blocks = f_in.read().split('\n\n')
        with open(filter_filename, "w", encoding='utf8') as f_out:
            for i in positions:
                f_out.write(blocks[i])
                f_out.write('\n\n')

if __name__ == "__main__":
    pos = [0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 16, 17, 20, 31, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 52, 56, 57, 58, 59, 60, 61, 62, 63, 64, 66, 69]
    filter_blocks("blocks.txt", "filtered_blocks.txt", pos)
