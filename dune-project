(lang dune 1.12)

(name hlist)

(version 0.0.1)

(allow_approximate_merlin)

(using fmt 1.1)

(authors "Keigo Imai")

(maintainers "keigo.imai@gmail.com")

(source
 (github keigoi/hlist-ocaml))

(documentation "https://github.com/keigoi/hlist-ocaml")

(generate_opam_files true)

(package
 (name hlist)
 (synopsis "Heterogeneously-typed lists for OCaml")
 (description "Heterogeneously-typed lists for OCaml.")
 (depends stdlib-shims))
