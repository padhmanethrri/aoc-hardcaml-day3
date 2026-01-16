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
    { result : 'a [@bits 64] }
  [@@deriving hardcaml]
end

let create (_ : Scope.t) (i : _ I.t) =
  let spec = Reg_spec.create ~clock:i.clk () in

  let acc_w = wire 64 in
  let sum_w = wire 64 in

  let acc_q = reg spec acc_w in
  let sum_q = reg spec sum_w in

  let acc_times_10 = (sll acc_q 3) +: (sll acc_q 1) in
  assign acc_w
    (mux2 i.bank_end
       (zero 64)
       (acc_times_10 +: uresize i.digit 64));

  assign sum_w
    (mux2 i.bank_end
       (sum_q +: acc_q)
       sum_q);

  { O.result = sum_q }
