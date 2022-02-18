(* open OUnit *)
open Hlist
open OUnit

let sample =
  Hetero.
    [
      (* 0 *)
      123;
      (* 1 *)
      "abc";
      (* 2 *)
      3.14;
      (* 3 *)
      false;
      (* 4 *)
      List.[ 1; -3; 44 ];
      (* 5 *)
      [
        `Foo;
        object
          method bar = "bar"
        end;
        (fun x -> x + 1);
      ];
    ]

let one = Succ Zero
let two = Succ one
let three = Succ two
let four = Succ three
let five = Succ four

let test_get () =
  OUnit.assert_equal (seq_get Zero sample) 123;
  OUnit.assert_equal (seq_get (Succ Zero) sample) "abc";
  OUnit.assert_equal (seq_get (Succ (Succ (Succ Zero))) sample) false

let test_putget () =
  OUnit.assert_equal (seq_get Zero (seq_put Zero sample `Hello)) `Hello;
  OUnit.assert_equal (seq_get Zero (seq_put five sample `Hello)) 123;
  OUnit.assert_equal (seq_get one (seq_put five sample `Hello)) "abc"

let suite =
  "Test Hlist module"
  >::: [ "test_get" >:: test_get; "test_putget" >:: test_putget ]
;;

let _results = run_test_tt_main suite in
()
