
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
    filter_blocks('blockTraces_dec_1_2022_false_negative.2.txt', 'blockTraces_dec_1_2022_false_negative.3.txt', [0, 2, 3, 5, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29])
    
