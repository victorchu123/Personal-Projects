use "lib.sml";

(* ---------------------------------------------------------------------- *)
(* quicksort on lists *)

(* Purpose: computes a list with only elements of l that are in appropriate 
 relation to the pivot p, which is represented by r (all elements can either
  be less than the pivot or all of them can be greater/equal compared to the 
  pivot 

  examples:
  
  filter_l([1,2,3], 4, LT) => [1,2,3]
  filter_l([3,4,5,6], 2, GEQ) => [3,4,5,6]

  *)
fun filter_l (l : int list,p:int,r:rel) : int list = 
  
  case l of
    [] => []
    |x::xs => case r of
              LT => (case (x<p) of
                      true => x :: filter_l(xs,p,r)
                      |false => filter_l(xs,p,r))
              |GEQ => (case (x>= p) of
                      true => x :: filter_l(xs,p,r)
                      |false => filter_l(xs,p,r))
              
(*tests for filter_l*)

val [] = filter_l([1],1,LT)
val [] = filter_l([1], 0, LT)
val [2] = filter_l([2],1, GEQ)
val [1,2,3] = filter_l([1,2,3], 4, LT)
val [3,4,5,6] = filter_l([3,4,5,6], 2, GEQ)


(* Purpose: computes a sorted list from list l that has only elements of l
that are in increasing order


    examples:

    quicksort_l([5,4,2,8]) => [2,4,5,8]
    quicksort_l([1,2,3]) => [1,2,3]
    quciksort_l([8,7,6]) => [6,7,8]

 *)
fun quicksort_l (l : int list) : int list = 

  case l of
    [] => []
    |x::xs => filter_l(quicksort_l(xs),x, LT) @ [x] @ filter_l(quicksort_l(xs), x, GEQ)
      
(*tests for quicksort_l*)    

val [3] = quicksort_l([3])
val [2,4,5,8] = quicksort_l([5,4,2,8])
val [6,7,8] = quicksort_l([8,7,6])
val [1,2,3] = quicksort_l ([1,2,3])


(* ---------------------------------------------------------------------- *)
(* quicksort on trees *)

(* Purpose: combines two trees into one tree; ensures all and only elements of t1
 and t2 are in the result tree; order doesn't matter. Also ensures that the depth
  of the result tree is less than or equal to 1 + max(depth t1, depth t2). 

    Running time: Work and span of combine(t1, t2) = O(depth of t1)

  examples: 

  combine(Node(Empty,4,Empty), Node(Empty,3,Empty)) => Node(Empty,4,Node(Empty,3,Empty))
  combine(Node(Empty,1,Empty), Node(Empty,5, Empty)) => Node(Empty,1,Node(Empty,5,Empty))
  

  *)
fun combine (t1 : tree, t2 : tree) : tree = 
  case t1 of
    Empty => t2
    |Node(l1,x1,r1) => Node(combine(l1,r1), x1, t2)

(*test for combine*)

val Node(Empty,4,Node(Empty,3,Empty)) = combine(Node(Empty,4,Empty), Node(Empty,3,Empty))
val Node(Empty ,1,Node(Empty,5,Empty)) = combine(Node(Empty,1,Empty), Node(Empty,5, Empty))
val [1,5] = quicksort_l(tolist(fromlist([5,1])))
val 2 = depth(combine(Node(Empty,1,Empty),Node(Empty,5,Empty)))

 (* Purpose: takes the argument tree t and returns a tree containing all and only elements in
 relation with r, either (less than) or (greater than/equal)s to i. Also ensures depth of the 
  original tree is greater than or equal to the depth of the result tree.

  Running time: work = filter(t, i, r) = O((depth of tree t) ^ 2)
                On a balanced tree, span = O(size of tree t)

  examples: 

  filter(Node(Node(Empty,4,Empty), 6, Node(Empty, 1, Empty)), 2, LT) => Node(Empty,1,Empty)
  filter(Node(Node(Empty,4,Empty), 6, Node(Empty, 1, Empty)), 4, GEQ) => Node(Node(Empty,4,Empty),6,Empty)

  *)
fun filter (t : tree, i : int, r : rel) : tree = 
  case t of
    Empty => Empty
    | Node(l1,x1,r1) => case (r) of
                      LT => (case (x1<i) of
                              true => Node(filter(l1,i,r), x1, filter(r1,i,r))
                              |false => filter(combine(l1,r1), i, r)
                              )
                      |GEQ => (case (x1>= i) of
                                true => Node(filter(l1,i,r), x1, filter(r1,i,r))
                                |false=> filter(combine(l1,r1), i, r)
                                )
(*test for filter*)

val Node(Empty,1,Empty) =filter(Node(Node(Empty,4,Empty), 6, Node(Empty, 1, Empty)), 2, LT) 
val Node(Node(Empty,4,Empty),6,Empty) =filter(Node(Node(Empty,4,Empty), 6, Node(Empty, 1, Empty)), 4, GEQ)
val Empty = filter(Node(Node(Empty,6,Empty), 1, Node(Empty,10,Empty)),0, LT)
val 2 = depth(filter(Node(Node(Empty,4,Empty), 6, Node(Empty, 1, Empty)), 4, GEQ))


(* Purpose: computes a sorted tree from the tree t which contains all and only
the elements of t. Running time: with a balanced tree, work = O(nlogn) and
  span = O((logn)^3), where n is the size of the tree t. 
  
  examples: 

  quicksort_t(Node(Node(Empty,4,Empty), 5, Node(Empty,1,Empty))) = Node(Node(Node(Empty,1,Empty),4,Empty), 5, Empty) 
  quicksort_t(Node(Node(Empty,1,Empty), 3, Empty )) = Node(Node(Empty,1,Empty), 3, Empty)


 *)
fun quicksort_t (t : tree) : tree = 
  case t of
      Empty => Empty
      | Node(l1,x1,r1) => Node(quicksort_t(filter(combine(l1,r1), x1, LT)), 
        x1, quicksort_t(filter(combine(l1,r1), x1, GEQ)))

(*tests for quicksort_t*)

val Node(Node(Node(Empty,1,Empty),4,Empty), 5, Empty) = quicksort_t(Node(Node(Empty,4,Empty), 5, Node(Empty,1,Empty)))
val Node(Node(Empty,1,Empty), 3, Empty) = quicksort_t(Node(Node(Empty,1,Empty), 3, Empty )) 
val [1,2,3,4,5,6,7] = tolist(quicksort_t(fromlist([7,3,2,4,5,6,1])))
val true = issorted(quicksort_t(fromlist([7,3,2,4,5,6,1])))


(* ---------------------------------------------------------------------- *)
(* rebalance *)

(* Purpose: separates the tree t into a 'left' and 'right' subtree, T1 and T2 respectively.
T1 contains the leftmost i elements of T in the original order and T2 contains the remaining elements
of T in the original order. 
  These conditions should also be met: max(depth T1, depth T2) ≤ depth T,
                                        size T1 ∼= i, 
                                    (tolist T1) @ (tolist T2) ∼= (tolist T).
  
  Running time: Work and span = O(d), where d is the depth of the tree T.
  
  examples: 
    
    takeanddrop (Node(Node (Node (Empty,1,Empty),2, Node (Empty,3,Empty)),4,Node (Node (Empty,5,Empty),
    6, Empty)),3) =>  (Node (Node (Empty,1,Empty),2,Node (Empty,3,Empty)),
    Node (Empty,4,Node (Node (Empty,5,Empty),6,Empty)))

    takeanddrop(Empty,3) => (Empty,Empty)


  
   *)
fun takeanddrop (t : tree, i : int) : tree * tree = 

  case t of 
    Empty => (Empty, Empty)
    | Node(l1,x1,r1) => 
    (case (i <= size(l1)) of
        true => let val (ll, lr) = takeanddrop(l1, i)
                in (ll,Node(lr,x1,r1))
                end

        |false => let val (rl, rr) = takeanddrop(r1,i-size(l1)-1)
                in ( Node(l1,x1,rl), rr)
                end
                )

(*tests for takeanddrop*)

val (Empty,Empty) = takeanddrop(Empty,3)
  val (Node (Node (Empty,1,Empty),2,Node (Empty,3,Empty)),Node (Empty,4,Node (Node (Empty,5,Empty),6,Empty))) = 
  takeanddrop (Node(Node (Node (Empty,1,Empty),2,Node (Empty,3,Empty)),4,Node (Node (Empty,5,Empty),6, Empty)),3) 

(* the rest of rebalance interms of your takeanddrop *)

    

fun halves (t : tree) : tree * int * tree =
    let
      val (l , vr) = takeanddrop (t , (size t) div 2)
      val (Node (Empty, v , Empty) , r) = takeanddrop (vr , 1)
    in
      (l , v , r)
    end

fun rebalance (t : tree) : tree =
    case t
     of Empty => Empty
      | _ =>
        let
          val (l , x , r) = halves t
        in
          Node (rebalance l , x , rebalance r)
        end
