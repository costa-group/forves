import sys
from collections import defaultdict
from pprint import pprint

supported_rules = ['ADD(X,0)',
                   'SUB(X,X)',
                   'MUL(X,0)',
                   'MUL(X,1)',
                   'DIV(X,1)',
                   'GT(1,X)',
                   'LT(X,1)',
                   'EQ(0,X)',
                   'ISZERO(ISZERO(ISZERO(X)))', # no se usa
                   'NOT(X)',  # no se si es NOT(NOT(X)) porque se aplica en ejemplos en los que solo aparece un NOT
                   'OR(X,0)', # no se usa
                   'AND(AND(X,Y),Y)', # no se usa
                   'AND(X,AND(X,Y))',
                   'AND(AND(Y,X),Y)', # no se usa
                  ]
                  
def extract_rules(line):
  rules = eval(line.strip()[17:])
  return [ner for ner in rules if len(ner) > 0]

""" Returns the rules in case not supported """
def unsupported_rules(case):
  rest_rules = []
  for r in extract_rules(case[3]):
  	if r not in supported_rules and not r.startswith('EVAL ('):
  	  rest_rules.append(r)
  return rest_rules
  
""" Returns all rules in case, removing EVAL """
def all_rules(case):
  return [r for r in extract_rules(case[3]) if not r.startswith('EVAL (')]
  

def main(filename):
  all_urules = defaultdict(int)
  nblocks_rules = 0
  with open(filename, mode='r', encoding='utf8') as fich:
    lines = fich.readlines()
    nlines = len(lines)
    for i in range(int(nlines/8)):
    	case = lines[8*i: 8*(i+1)]
    	rules = extract_rules(case[3])
    	if len(rules) > 0:
          nblocks_rules += 1

    	# urules = unsupported_rules(case)
    	urules = all_rules(case)
    	for r in urules:
    	    print(r)
    	#for r in urules:
    	#  all_urules[r] += 1
    	
    	#if urules == []:
    	#  for l in case:
    	#    print(l.strip())
    	  
  # pprint(urules)
  # print(f'blocks with optimization rules: {nblocks_rules}')
    	  


if __name__ == '__main__':
  main(sys.argv[1])
