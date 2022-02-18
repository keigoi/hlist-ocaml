type ('a, 'b, 'xs, 'ys) idx =
  | Zero : ('a, 'b, [ `cons of 'a * 'tl ], [ `cons of 'b * 'tl ]) idx
  | Succ :
      ('a, 'b, 'aa, 'bb) idx
      -> ('a, 'b, [ `cons of 'hd * 'aa ], [ `cons of 'hd * 'bb ]) idx

module type ElemType = sig
  type 'a t

  val unit : unit t
end

module type S = sig
  type 'a elem

  type 'a seq =
    | ( :: ) : 'hd elem * 'tl seq -> [ `cons of 'hd * 'tl ] seq
    | [] : ([ `cons of unit * 'a ] as 'a) seq

  val seq_head : [ `cons of 'hd * 'tl ] seq -> 'hd elem
  val seq_tail : [ `cons of 'hd * 'tl ] seq -> 'tl seq
  val seq_get : ('a, 'b, 'xs, 'ys) idx -> 'xs seq -> 'a elem
  val seq_put : ('a, 'b, 'xs, 'ys) idx -> 'xs seq -> 'b elem -> 'ys seq
  val seq_get2 : ('a, 'b, 'xs, 'ys) idx -> 'ys seq -> 'b elem
  val seq_put2 : ('a, 'b, 'xs, 'ys) idx -> 'ys seq -> 'a elem -> 'xs seq
end

module Make (E : ElemType) = struct
  module Hetero = struct
    type _ seq =
      | ( :: ) : 'hd E.t * 'tl seq -> [ `cons of 'hd * 'tl ] seq
      | [] : ([ `cons of unit * 'a ] as 'a) seq
  end

  type 'a seq = 'a Hetero.seq =
    | ( :: ) : 'hd E.t * 'tl seq -> [ `cons of 'hd * 'tl ] seq
    | [] : ([ `cons of unit * 'a ] as 'a) seq

  let seq_head : type hd tl. [ `cons of hd * tl ] seq -> hd E.t = function
    | hd :: _ -> hd
    | [] -> E.unit

  let seq_tail : type hd tl. [ `cons of hd * tl ] seq -> tl seq = function
    | _ :: tl -> tl
    | [] -> []

  let rec seq_get : type a b xs ys. (a, b, xs, ys) idx -> xs seq -> a E.t =
   fun ln xs ->
    match ln with Zero -> seq_head xs | Succ ln' -> seq_get ln' (seq_tail xs)

  let rec seq_get2 : type a b xs ys. (a, b, xs, ys) idx -> ys seq -> b E.t =
   fun ln xs ->
    match ln with Zero -> seq_head xs | Succ ln' -> seq_get2 ln' (seq_tail xs)

  let rec seq_put :
      type a b xs ys. (a, b, xs, ys) idx -> xs seq -> b E.t -> ys seq =
   fun ln xs b ->
    match ln with
    | Zero -> b :: seq_tail xs
    | Succ ln' -> seq_head xs :: seq_put ln' (seq_tail xs) b

  let rec seq_put2 :
      type a b xs ys. (a, b, xs, ys) idx -> ys seq -> a E.t -> xs seq =
   fun ln xs b ->
    match ln with
    | Zero -> b :: seq_tail xs
    | Succ ln' -> seq_head xs :: seq_put2 ln' (seq_tail xs) b

  type 'a list = 'a List.t = [] | ( :: ) of 'a * 'a list
end

include Make (struct
  type 'a t = 'a

  let unit = ()
end)

module Hetero = struct
  type 'a t = 'a seq =
    | ( :: ) : 'hd * 'tl t -> [ `cons of 'hd * 'tl ] t
    | [] : ([ `cons of unit * 'a ] as 'a) t
end
