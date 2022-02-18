(** The {b type-level indices} of a type-level [cons]-list, i.e., it is just a
    type of (Peano) {i natural numbers} represented as [Zero], [(Succ Zero)],
    [(Succ (Succ Zero))] ... and so on. The type denotes a {b polymorphic lens}
    defined using GADTs. A lens is a functional reference to a portion in a data
    structure. A polymorphic lens is capable of replacing a portion with a value
    of {i different type}. *)
type ('a, 'b, 'xs, 'ys) idx =
  | Zero : ('a, 'b, [ `cons of 'a * 'tl ], [ `cons of 'b * 'tl ]) idx
      (** Type-level zero. *)
  | Succ :
      ('a, 'b, 'aa, 'bb) idx
      -> ('a, 'b, [ `cons of 'hd * 'aa ], [ `cons of 'hd * 'bb ]) idx
      (** Type-level succ. *)

module type S = sig
  type 'a elem

  type _ seq =
    | ( :: ) : 'hd elem * 'tl seq -> [ `cons of 'hd * 'tl ] seq
    | [] : ([ `cons of unit * 'a ] as 'a) seq

  val seq_head : [ `cons of 'hd * 'tl ] seq -> 'hd elem
  val seq_tail : [ `cons of 'hd * 'tl ] seq -> 'tl seq
  val seq_get : ('a, 'b, 'xs, 'ys) idx -> 'xs seq -> 'a elem
  val seq_put : ('a, 'b, 'xs, 'ys) idx -> 'xs seq -> 'b elem -> 'ys seq
  val seq_get2 : ('a, 'b, 'xs, 'ys) idx -> 'ys seq -> 'b elem
  val seq_put2 : ('a, 'b, 'xs, 'ys) idx -> 'ys seq -> 'a elem -> 'xs seq
end

include S with type 'a elem := 'a

module Hetero : sig
  type 'a t = 'a seq =
    | ( :: ) : 'hd * 'tl t -> [ `cons of 'hd * 'tl ] t
    | [] : ([ `cons of unit * 'a ] as 'a) t
end

(** Shadows the hetero list above, re-introducing the standard list constructors
    (::) and [] in scope. The original hetero list could be written as
    Hetero.[1; "abc"; true], for example. *)
type 'a list = 'a List.t = [] | ( :: ) of 'a * 'a list

module Make : functor
  (E : sig
     type 'a t

     val unit : unit t
   end)
  -> sig
  include S with type 'a elem := 'a E.t
end

(** The index type [('a,'b,'xs,'ys) idx] says that:

    - It refers to the portion ['a] in ['xs], and
    - If ['a] in ['xs] is replaced with ['b], ['ys] is obtained.

    The [Zero] constructor refers to the first element of a (type-level)
    cons-list. The list is expressed by a polymorphic variant
    [\[`cons of 'hd * 'tl\]], and [Zero] refers to the ['hd] part of a list. The
    type [Zero : ('a, 'b, \[`cons of 'a * 'tl\], \[`cons of 'b * 'tl\]) idx]
    says that the type of the head of list is ['a], and it could be replaced by
    ['b], obtaining the whole list type [\[`cons of 'b * 'tl\]].

    [Succ] is more complex. It takes a lens referring to some portion ['a] in
    ['aa], and makes another lens larger by one value, by nesting it inside
    [\[`cons of 'hd * 'aa\]].

    This type is originally inspired by Garrigue's
    {{:https://github.com/garrigue/safeio} Safeio} and
    {{:https://www.math.nagoya-u.ac.jp/~garrigue/papers/linocaml-201902.pdf}
    Linocaml (Fig. 6)}. *)
