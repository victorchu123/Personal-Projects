use "lib.sml";

(* ---------------------------------------------------------------------- *)
(* map *)


(* Purpose: evaluates to a tree t’, where
  t’ has the same structure as t, and the string at each leaf of t’
  is the string at the corresponding position in t, with an ’s’
  affixed to the end. *)

fun pluralize_rec (t : string tree) : string tree =
    case t of
        Empty => Empty
      | Leaf x => Leaf (x ^ "s")
      | Node(l,r) => Node(pluralize_rec l , pluralize_rec r)

(* Purpose: evaluates to a tree t’, where
   t’ has the same structure as t, and the int at each leaf of t’
   is the int at the corresponding position in t, multiplied by c
*)

fun mult_rec (c : int, t : int tree) : int tree =
    case t of
        Empty => Empty
      | Leaf x => Leaf (c * x)
      | Node(l,r) => Node(mult_rec (c,l) , mult_rec (c,r))

(* Purpose: this map function abstracts the pattern of pluralize_rec
and mult_rec so we won't have to write the same pattern multiple times
 *)

fun map (f : 'a -> 'b, t : 'a tree) : 'b tree = 
  case t of 
    Empty => Empty
    |Leaf x => Leaf (f(x))
    | Node(l,r) => Node(map(f,l), map(f, r))


(* Purpose: takes the tree t and computes a tree t' where the string
at each leaf of t' is the string at the corresponding position in t and 
's' attached at the end. 
  
  ex. 

  pluralize(fromlist["x", "a"]) = fromlist(["xs", "as"])
  pluralize(fromlist["a", "s"]) = fromlist(["as", "ss"])
*)
fun pluralize (t : string tree) : string tree = 
  map(fn y => y ^ "s", t)

(*tests for pluralize*)

val Node(Leaf "xs", Leaf "as") =pluralize(Node(Leaf "x", Leaf "a"))
val Node(Leaf "as", Leaf "ss") = pluralize(Node(Leaf "a", Leaf "s"))

(* Purpose: takes the tree t and computes a new tree t' where
  the int in each leaf of t' becomes the int from the same positon 
  in t times c. 
    
    ex. 

    mult(2, fromlist[3,4]) = fromlist([ 6,8])
    mult(4, fromlist[1,2]) = fromlist([4,8])

    *)
fun mult (c : int, t : int tree) : int tree = 
  map(fn y=> y * c, t)

(*tests for mult*)
val Node(Leaf 6, Leaf 8) = mult(2 ,Node(Leaf 3, Leaf 4))
val Node(Leaf 4, Leaf 8) = mult(4, Node(Leaf 1, Leaf 2))

(* ---------------------------------------------------------------------- *)
(* reduce *)


(* Purpose: evaluates to a number n, where n is
   the sum of all of the numbers at the leaves of t *)

fun sum_rec (t : int tree) : int =
    case t of
        Empty => 0
      | Leaf x => x
      | Node(t1,t2) => (sum_rec t1) + (sum_rec t2)


(* Purpose: evaluates to a string s, where s is
   the concatenation of all of the strings at the leaves of t,
   in order from left to right *)
fun join_rec (t : string tree) : string =
    case t of
        Empty => ""
      | Leaf x => x
      | Node(t1,t2) => (join_rec t1) ^ (join_rec t2)

(* Purpose: abstracts the pattern in sum+rec and join_rec *)
fun reduce (n : 'a * 'a -> 'a, b : 'a, t : 'a tree) : 'a = 
  case t of
    Empty => b
    | Leaf x => x
    | Node(t1,t2) => n(reduce(n, b, t1), reduce(n, b, t2))

(* Purpose: computes the sum of all numbers at the leaves of t
    
    ex. 

    sum(Node(Leaf 5, Leaf 6)) = 11
    sum(Node(Leaf 5)) = 5
  

  *)        
fun sum (t : int tree) : int = 
  reduce(fn (x,y) => x+y,0,t)

(*tests for sum*)
val 11 = sum(Node(Leaf 5, Leaf 6))
val 5 = sum(Node(Leaf 5, Empty))

(* Purpose: computes the concatenation of all string at the leaves
of t in order from left to right 
  
    ex. 
    
    join(Node(Leaf "h", Leaf "i")) = "hi"
    join(Node(Leaf "t", Leaf "r")) = "tr"

  *)
fun join (t : string tree) : string =
  reduce(fn (x,y) => x ^ y, "", t)

(*tests for join*)

val "hi" = join(Node(Leaf "h", Leaf "i"))
val "tr" = join(Node(Leaf "t", Leaf "r"))

(* ---------------------------------------------------------------------- *)
(* programming with map and reduce *)

(* Purpose: computes a tree t' with all the original elements of all trees
in t. The elements of each tree t1 in t should be in t' with the same order
as in t1. The order of the trees and the elements in the tree should be preserved.

  
    ex: 

      flatten (Node (Leaf (Node (Leaf 1, Leaf 2)),Node (Leaf (Leaf 3),Empty)))
        => Node (Node (Leaf 1,Leaf 2),Node (Leaf 3,Empty))



 *)
fun flatten (t : ('a tree) tree) : 'a tree = 
  reduce(fn (a,b)=> Node(a,b), Empty, t)

(*tests for flatten*)

val Node (Node (Leaf 1,Leaf 2),Node (Leaf 3,Empty)) = 
        flatten (Node (Leaf (Node (Leaf 1, Leaf 2)),
                       Node (Leaf (Leaf 3),
                             Empty)))


(* Purpose: takes in the function p and the tree t and returns a tree
t' where all the elements x in t' must return true for p(x). Also, the 
elements should stay in the same order as the original tree t.

ex. 
  
    filter (fn x => x > 2, Node (Node (Leaf 1,Leaf 2),Node (Leaf 3,Empty))) 
    =>  Node (Node (Empty,Empty),Node (Leaf 3,Empty))



 *)
fun filter (p : 'a -> bool, t : 'a tree) : 'a tree = 
  flatten(map((fn x => case p(x) of
                      true => Leaf x
                      |false => Empty),t))


(*tests for filter*)
val Node (Node (Empty,Empty),Node (Leaf 3,Empty)) = filter (fn x => x > 2, Node (Node (Leaf 1,Leaf 2),Node (Leaf 3,Empty)))



(* Purpose: takes all the elements x from tree1 and all the elements y from tree2 and combines them into pairs (x,y)
  , which is stored into the result tree. The order of the pairs is unspecified. 

    ex. 

    allpairs (Node(Leaf 1, Leaf 2), Node(Leaf "a", Leaf "b"))
    =>  Node (Node (Leaf (1,"a"),Leaf (1,"b")),Node (Leaf (2,"a"),Leaf (2,"b")))
    

   *)
fun allpairs (tree1 : 'a tree, tree2 : 'b tree) : ('a * 'b) tree = 

  flatten( map(fn a=> map (fn b=> (a,b),tree2) , tree1))

 

 (*tests for allpairs*)

val Node (Node (Leaf (1,"a"),Leaf (1,"b")),Node (Leaf (2,"a"),Leaf (2,"b"))) = allpairs (Node(Leaf 1, Leaf 2), Node(Leaf "a", Leaf "b"))


type answers = int * int * int * int

fun same(x : int, y : int) : real = 
    case x = y of
        true => 1.0
      | false => 0.0

fun count_same ((a1,a2,a3,a4) : answers , (a1',a2',a3',a4') : answers) : real = 
    same (a1,a1') + same (a2,a2') + same (a3,a3') + same (a4,a4')

(* Purpose: implements my own scoring for compatible study buddies by
using case analysis to prioritize the fourth answer over every other answer. 
I did this because I feel that the pace at which you do your work is the most
important in determining a study buddy match. If these two answers do not match,
then there is no point in giving them a score at all. It counts as a habit that
is not easily change and that it rank my other cases. ex. if one person doesn't
like to study in the same background noise or at the same time as another person, then
there is no point in checking the other answers, as habits rarely change. I believe
2nd answer is more of a preference since study buddies are more likely to adapt
to the study place, rather than the other answers.

ex.

  my_scoring((1,3,2,1), (2,3,2,1)) => 2.0
  my_scoring((1,3,3,2), (2,2,2,1)) => 0.0
  my_scoring((5,2,3,1), (5,3,3,1)) => 3.0
  my_scoring((5,3,3,1), (5,3,3,1)) => 4.0

 *)
fun my_scoring ((a1,a2,a3,a4) : answers , (a1',a2',a3',a4') : answers) : real =
    case (a4 = a4') of
        true => (case(a3 = a3') of
                  true => (case ((a1 = a1') orelse (a1 = 5) orelse (a1'=5)) of
                            true=> (case (a2 = a2') of
                                    true => 4.0
                                    |false => 3.0)

                            |false=> 2.0)
                  |false => 1.0)
        |false => 0.0

(*tests for my_scoring*)
val result = real(2)
val result = my_scoring((1,3,2,1), (2,3,2,1))
val result = real (0)
val result = my_scoring((1,3,3,2), (2,2,2,1))
val result = real(3)
val result = my_scoring((5,2,3,1), (5,3,3,1))
val result = real(4)
val result = my_scoring((5,3,3,1), (5,3,3,1))

(* Purpose: given a similarity comparison function, a cutoff point, and 
a tree with the form (string, answers), matches computes a tree with the form
(string,string,real) where the strings are the people's names and the real number is 
the score that two people are given based on how compatible their answers are.

The tree is also sorted from highest scores to lowest scores. Only pairs of people
whose score is larger than cutoff are included. Also, the tree never contains a pair of the 
form (person1, person1)-- duplicate pairs-- or both the pair (person2,person1) and 
(person1,person2)-- reverse pairs.
    

    ex. 
    
    tolist (matches (similarity, cutoff, people))
    => fromlist [ ("A",(1,1,1,1)), ("B",(2,2,2,2)), ("C",(1,2,2,2)) ]

    *)
fun matches (similarity : answers * answers -> real,
             cutoff : real,
             people : (string * answers) tree) : (string * string * real) tree = 

  sort(fn ((str1,str2, realNum1), (str3, str4,realNum2)) => Real.compare(realNum2, realNum1), map (fn ((a,b),(x,y)) => (a,x,similarity(b,y))  ,(filter(fn((a,b),(x,y)) => similarity(b,y) > cutoff
    ,filter (fn ((a,b),(x,y)) => a < x ,(filter(fn ((a,b),(x,y)) => case (a = x) of
                                                          true => false 
                                                        |false => true ,allpairs(people, people))))))))


    
(* code for testing matches *)

val test_data : (string * answers) tree = fromlist [ ("A",(1,1,1,1)), ("B",(2,2,2,2)), ("C",(1,2,2,2)) ]

fun show_matches (similarity : answers * answers -> real, cutoff : real, people : (string * answers) tree) : unit =
    List.app (fn (n1,n2,score) => print (n1 ^ " and " ^ n2 
                                         ^ " have compatibility " ^ (Real.toString score ^ "\n"))) 
             (tolist (matches (similarity, cutoff, people)))


(* for class compatibility ranking: 
  show_matches(count_same, 0.0, survey_data_class) 
*)

val survey_data_class = 
fromlist 
[("acdc", (5, 1, 3, 2)),
("awg",(2,1,3,1)),
("unik",(4, 3, 3,1) ),
(("abm"),(3,3,1,1)),
("pop",(1,1,3,2)),
("jeanralphio",(3,3,1,1)),
("cql", (5, 1, 2, 2)),
("ericartman",(4,3,3,2)),
("xug", (2, 1, 3, 4)),
("FoxShine",(4,1,1,2)),
("elz",( 2, 1, 1, 1)),
("kurt",(5,3,1,1)),
("tree", (3,1,2,2)),
("jdl", (5, 1, 3, 1)),
("JAF",(2,1,3,1)),
("whosthatpokemon", (5, 3, 3, 2)),
("Kehan",(5,3,1,2)),
("LeeChen",(3,3,3,1)),
("kots", (2, 3, 3, 2)),
("mplaud",(3, 1, 2, 2)) ,
("rthornley",(3,3,3,2)),
("nkykia",(6,4,8,9)),
("poh", (5, 3, 3, 2)),
("keyboardcat", (5, 3, 3, 2)),
("rshteyn", (1, 3, 3, 2)),
("littlekidlover", (5, 3, 1, 1)),
("timmay",(4,3,1,2)),
("dt", (1, 3, 3, 1)),
("chrisnolan78", (4, 3, 3, 1)),
("huh",(2,3,3,1)),
("Xiping", (5, 3, 3, 2)),
("abc", (5, 3, 3, 2)),
("bloop",(5,1,1,2))]



