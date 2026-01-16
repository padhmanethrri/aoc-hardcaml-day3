open Hardcaml

module D = Day3_part1
module Sim = Cyclesim.With_interface (D.I) (D.O)

let () =
  let scope = Scope.create ~flatten_design:true () in
  let sim = Sim.create (D.create scope) in
  let i = Cyclesim.inputs sim in
  let o = Cyclesim.outputs sim in

  let cycle () = Cyclesim.cycle sim in

  let send d =
    i.digit := Bits.of_int ~width:4 d;
    i.bank_end := Bits.gnd;
    cycle ()
  in

  let end_bank () =
    i.bank_end := Bits.vdd;
    cycle ();
    i.bank_end := Bits.gnd
  in

  let send_line s =
    String.iter
      (fun ch ->
        let d = Char.code ch - Char.code '0' in
        send d)
      s;
    end_bank ()
  in

  let ic = open_in "input.txt" in
  (try
     while true do
       let line = input_line ic in
       if String.length line > 0 then
         send_line line
     done
   with End_of_file ->
     close_in ic);

  cycle ();

  Printf.printf "FINAL RESULT = %d\n"
    (Bits.to_int !(o.result))
