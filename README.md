# hlist: Heterogeneously-typed lists for OCaml

An implementation of [heterogeneously-typed lists](https://wiki.haskell.org/Heterogenous_collections) in (pure) OCaml.

## Usage

```ocaml
open Hlist

(* A heterogeneously-typed list *)
let x = Hetero.[123; "abc"; true]
(*
val x :
  [ `cons of
      int *
      [ `cons of string * [ `cons of bool * ([ `cons of unit * 'a ] as 'a) ] ]
  ] seq
*)

let a = seq_head x
(* 123 *)

let b = seq_head x
(* ["abc"; true] *)

(** Getting elements by index *)

let x0 = seq_get Zero x 
(* 123 *)

let x1 = seq_get (Succ Zero) x
(* "abc" *)

let x2 = seq_get (Succ (Succ Zero)) x
(* true *)

(* Returns the unit value for the index beyond the end *)
let x3 = seq_get (Succ (Succ (Succ Zero))) x
(* () *)

(** Updating an element by index, polymorphically *)

let y0 = seq_put Zero x `Hello_world
(*
val y0 :
  [ `cons of
      _[> `Hello_world ] *
      [ `cons of string * [ `cons of bool * ([ `cons of unit * 'a ] as 'a) ] ]
  ] seq
*)

let y1 = seq_put (Succ (Succ Zero)) y0 ["this"; "is"; "a"; "homogeneous"; "list"]
(*
val y1 :
  [ `cons of
      _[> `Hello_world ] *
      [ `cons of string * [ `cons of string list * ([ `cons of unit * 'a ] as 'a) ] ]
  ] seq
*)
```

## Installation and development

Trying with utop:

```sh
git clone http://github.com/keigoi/hlist-ocaml.git
cd hlist-ocaml
dune utop
```

Installation:

```sh
opam install http://github.com/keigoi/hlist-ocaml.git
```

Uninstall:

```sh
opam remove hlist
```

## Contact

- Issues: <https://github.com/keigoi/hlist-ocaml/issues>

## References

The Peano-number based index is introduced in Fig. 6 in the following paper:

* Keigo Imai and Jacques Garrigue: Lightweight Linearly-typed Programming with Lenses and Monads, Journal of Information Processing,  vol. 27, pp. 431-444, 2019.
  * Online PDF (open access): https://www.jstage.jst.go.jp/article/ipsjjip/27/0/27_431/_article
  * Draft PDF in Japanese: https://keigoimai.info/linocaml-paper/jpn-draft.pdf
  * LinOCaml reference implementation [on GitHub](https://github.com/keigoi/linocaml)

And heterogeneously-typed lists are originally introduced in:

* Oleg Kiselyov, Ralf Lämmel and Keean Schupke: Strongly typed heterogeneous collections. Haskell 2004, pp. 96-107, 2004.

