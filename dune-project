(lang dune 3.1)

(name hlist)

(version 0.0.1)

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
 (depends
  stdlib-shims
  (ounit :with-test)))
