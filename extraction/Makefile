.PHONY: default
default: all ;

TEST = test_examples.ml
EXE = test_examples

step1: examples.ml examples.mli
	ocamlopt -c examples.mli -o examples.cmi
	ocamlopt -c examples.ml -o examples.cmx

step2: step1
	ocamlopt examples.cmx -open Examples $(TEST) -o $(EXE)
	
all: step2
	@echo "Compilation Finished"

run: all
	./$(EXE)

clean:
	rm -f *.cmi
	rm -f *.cmx
	rm -f *.o
	rm -f $(EXE)
	
clean_all: clean
	rm -f examples.ml
	rm -f examples.mli

