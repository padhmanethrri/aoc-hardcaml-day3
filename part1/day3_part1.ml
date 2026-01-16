open Hardcaml
open Signal

module I = struct
  type 'a t =
    { clk      : 'a
    ; digit    : 'a [@bits 4]
    ; bank_end : 'a
    }
  [@@deriving hardcaml]
end

module O = struct
  type 'a t =
    { result : 'a [@bits 16] }
  [@@deriving hardcaml]
end

let create (_scope : Scope.t) (i : _ I.t) =
  let spec = Reg_spec.create ~clock:i.clk () in

  let best_pair_w = wire 8 in
  let best_tens_w = wire 4 in
  let sum_w       = wire 16 in

  let best_pair_q = reg spec best_pair_w in
  let best_tens_q = reg spec best_tens_w in
  let sum_q       = reg spec sum_w in

  let ten_tens =
    (sll (uresize best_tens_q 8) 3) +:
    (sll (uresize best_tens_q 8) 1)
  in
  let candidate = ten_tens +: uresize i.digit 8 in

  assign best_pair_w
    (mux2 i.bank_end
       (zero 8)
       (mux2 (candidate >: best_pair_q) candidate best_pair_q));

  assign best_tens_w
    (mux2 i.bank_end
       (zero 4)
       (mux2 (i.digit >: best_tens_q) i.digit best_tens_q));

  assign sum_w
    (mux2 i.bank_end
       (sum_q +: uresize best_pair_q 16)
       sum_q);

  { O.result = sum_q }
