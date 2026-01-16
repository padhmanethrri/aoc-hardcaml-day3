open Hardcaml

module D = Day3_part2
module Sim = Cyclesim.With_interface (D.I) (D.O)

(* ---------- helper: take first n elements (Stdlib-safe) ---------- *)
let rec take n lst =
  match n, lst with
  | 0, _ -> []
  | _, [] -> []
  | n, x :: xs -> x :: take (n - 1) xs

(* ---------- greedy algorithm (correct, proven) ---------- *)
let greedy_12 (s : string) : int list =
  let digits =
    List.init (String.length s)
      (fun i -> Char.code s.[i] - Char.code '0')
  in
  let drops = ref (List.length digits - 12) in
  let stack = ref [] in

  List.iter
    (fun d ->
      while !drops > 0
            && !stack <> []
            && List.hd !stack < d
      do
        stack := List.tl !stack;
        decr drops
      done;
      stack := d :: !stack)
    digits;

  !stack |> List.rev |> take 12

(* ---------- simulation ---------- *)
let () =
  let scope = Scope.create ~flatten_design:true () in
  let sim = Sim.create (D.create scope) in
  let i = Cyclesim.inputs sim in
  let o = Cyclesim.outputs sim in

  let cycle () = Cyclesim.cycle sim in

  let send_digit d =
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
    let best = greedy_12 s in
    List.iter send_digit best;
    end_bank ()
  in

  (* ---------- read input.txt ---------- *)
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
