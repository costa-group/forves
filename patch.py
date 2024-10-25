'''
This script is used to patch the OCaml code of the symbolic execution engine 
to include a cache for the memory comparison function.
'''

ORIG = """
  let po_memory_cmp sstack_val_cmp smem1 smem2 maxidx1 sb1 maxidx2 sb2 instk_height ops =
    let n1 = length smem1 in
    let n2 = length smem2 in
    if eqb n1 n2
    then let smem1' = reorder_memory_updates n1 n1 smem1 maxidx1 sb1 in
         let smem2' = reorder_memory_updates n2 n2 smem2 maxidx2 sb2 in
         basic_memory_cmp sstack_val_cmp smem1' smem2' maxidx1 sb1 maxidx2
           sb2 instk_height ops"""

REP = """    let my_hash = Hashtbl.create 123456;;

  let po_memory_cmp sstack_val_cmp smem1 smem2 maxidx1 sb1 maxidx2 sb2 instk_height ops =
    let key = (smem1,smem2,maxidx1,sb1,maxidx2,sb2,instk_height,ops) in
    let n1 = length smem1 in
    let n2 = length smem2 in
    if eqb n1 n2
    then
      
      if (Hashtbl.mem my_hash key) then Hashtbl.find my_hash key
      else 
        let smem1' = reorder_memory_updates n1 n1 smem1 maxidx1 sb1 in
        let smem2' = reorder_memory_updates n2 n2 smem2 maxidx2 sb2 in
        let r = basic_memory_cmp sstack_val_cmp smem1' smem2' maxidx1 sb1 maxidx2 sb2 instk_height ops in
         Hashtbl.add my_hash key r; 
        r;"""

with open("ocaml_interface/checker.ml", "r", encoding="ascii") as f:
    data = f.read()
    data = data.replace(ORIG, REP)

with open("ocaml_interface/checker.ml", "w", encoding="ascii") as f:
    f.write(data)
