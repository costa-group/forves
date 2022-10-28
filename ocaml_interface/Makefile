.PHONY: default
default: all ;

MAIN = main.ml
EXE = checker
STATIC_EXE = static_checker


all: executable static

executable: checker $(MAIN)
	ocamlopt -o $(EXE)  checker.cmx str.cmxa $(MAIN) 
	mv $(EXE) ../bin

checker: checker.ml checker.mli
	ocamlopt -c checker.mli -o checker.cmi
	ocamlopt -c checker.ml -o checker.cmx

static: checker $(MAIN)
	ocamlopt -o $(STATIC_EXE) -ccopt -static str.cmxa checker.cmx $(MAIN)
	mv $(STATIC_EXE) ../bin

static_checker: checker.ml checker.mli
	ocamlopt -c checker.mli -ccopt -static -o checker.cmi
	ocamlopt -c checker.ml -ccopt -static -o checker.cmx

clean:
	rm -f *.cmi
	rm -f *.cmx
	rm -f *.o
	rm -f $(EXE)
	rm -f ../bin/$(EXE)
	rm -f $(STATIC_EXE)
	rm -f ../bin/$(STATIC_EXE)

clean_all: clean
	rm -f checker.ml
	rm -f checker.mli

