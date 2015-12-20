(* Unification Final Project: 
  Made by Catherine Alvarado, Arjun Shah, Ethan Zornow, Victor Chu
  on December 12th, 2015.
*)

exception UNIMPLEMENTED
exception UNIFICATION_FAILURE  
exception INVALIDSET
exception INVALIDTERM
exception INVALIDSUB
exception NOTERMS
exception BAD_CHAR;;

(* lexing *)
  (* Depending on how you define the lexer you may not need to bother with commas *)
type token_tag = 
  | VAR
  | CONST
  | FUN
  | COMMA
  | LPAREN
  | RPAREN

type term = 
  | Const of string
  | Var of string
  | Fun of string * term list
  | TMError

type substitution = (string * term) list

(* utility functions *)

(* converts a string to a list of chars: stolen from SML because it's so handy *)
let explode s =
    let rec exp i l =
        if i < 0 then l else exp (i - 1) (s.[i] :: l) in
    exp (String.length s - 1) [];;

(* list of chars to string *)
let implode l =
    let res = String.create (List.length l) in
    let rec imp i = function
    | [] -> res
    | c :: l -> res.[i] <- c; imp (i + 1) l in
    imp 0 l;;

(* char x is alphabetical *)
let alph x = 
    let n = Char.code x in
    96< n && n < 123;;

let alph_upper x = 
    let n = Char.code x in
    n > 64 && n < 91;;

(* token boundaries *)
let bdry x = (x='(') || (x = ',') || (x= ')') || (x = '0');;

(* accumulate characters until you reach a blank or a token boundary:
'e' ['l';'s';'e';'(';...] |--> ("else" ['('...])
 *)
let rec grab_chars_until_bdry ch rest =
    match rest with
        |[] -> (String.make 1 ch,rest)
        |(head::tail) ->
             if (head = ' ')
             then (String.make 1 ch,tail)
             else if (bdry head)
             then (String.make 1 ch,rest)
             else let (x,l) = (grab_chars_until_bdry head tail)
             in
     ((String.make 1 ch)^x,l)
;;

(* char list |--> list of token strings *)
let rec aux_lexx chars =
    match chars with
        |[] -> []
        |(ch::rest) ->
             if (ch=' ')
             then aux_lexx rest
             else if (bdry ch)
             then (String.make 1 ch)::(aux_lexx rest)
             else if (alph ch) || (alph_upper ch)
             then
     let (str, remainder) = grab_chars_until_bdry ch rest
     in str::(aux_lexx remainder)
             else raise BAD_CHAR;;

(* helper function: string list |--> string & token_tag pair list *)
let rec aux_lexx_helper(inputLst : string list) : (string * token_tag) list = 
  match inputLst with
    |[] -> []  
    |x::xs -> (match explode x with 
                |[] -> []
                |ch::rem-> (match alph ch with
                            |false -> if (ch = '(')
                                      then [(x, LPAREN)]@(aux_lexx_helper xs)
                                      else if (ch = ')')
                                      then [(x, RPAREN)]@(aux_lexx_helper xs)
                                      else if (ch = ',')
                                      then [(x, COMMA)]@(aux_lexx_helper xs)
                                      else [(x, VAR)]@(aux_lexx_helper xs)
                            |true -> (match xs with
                                      |[] -> []
                                      |y::ys -> (match y with
                                                  |"(" -> [(x ,FUN)]@(aux_lexx_helper xs)
                                                  |_ -> [(x, CONST)]@(aux_lexx_helper xs)
                                                )
                                      )
                            ));;

(* filters out commas and lexxes input string |--> string & token_tag pair list *)
let lex (inp : string) : (string * token_tag) list = 
    List.filter ( fun (tkenName, tkenTag) -> match tkenTag with
                                              |COMMA -> false
                                              |_ -> true) (aux_lexx_helper(aux_lexx(explode(inp))))
;;

(* string & token_tag list |--> (term, (string, token_tag)) list *)
let rec aux_parse (tkns : (string * token_tag) list) : (term * (string * token_tag) list)  = 
  match tkns with
    |[] -> (TMError, [])
    |(x, FUN)::((_,LPAREN)::rest)->
      let (l,r) = aux_parse_list rest
      in (Fun(x,l),r)
    |(y, VAR)::rest -> (Var(y), rest)
    |(z, CONST)::rest -> (Const(z), rest) 
    |_ -> raise INVALIDTERM

  and aux_parse_list (funTermLst : (string * token_tag) list): (term list * (string * token_tag) list) = 
    match funTermLst with
      |[] -> ([],[])
      |(_,RPAREN)::remainder->([], remainder)
      |funTerm1::remainder->
        let (tm, remainder') = aux_parse(funTermLst) in
        let (l', r') = aux_parse_list(remainder') in
        (tm::l', r')
;;

let parse (inp : string) : term = fst(aux_parse (lex inp));;

(* checks if a variable name appears in a term *)
let rec occurrence_free (x : string) (tm : term) : bool = 
  match tm with 
    |Const(y) -> true
    |TMError -> false
    |Var(y) -> if (x=y) then false else true
    |Fun(y,l) -> (match l with
      |[] -> true
      |head::tail -> occurrence_free x head && occurrence_free x (Fun(y,tail))
    )
;;

let rec searchSubLst (x: string) (s: substitution): term =
  (match s with
    |[] -> Var(x)
    |(str,tm)::remainder -> if str = x 
                             then tm
                             else searchSubLst x remainder);;

let rec getNewTmLst (s: substitution) (tml: term list) : term list =
  match tml with  
      |[] -> []
      |[TMError] -> []
      |head::tail -> (match head with 
                      |TMError -> []
                      |Const(x) -> [Const(x)] @ getNewTmLst s tail
                      |Var(x) -> [searchSubLst x s] @ getNewTmLst s tail 
                      |Fun(y,lst) -> [Fun(y, getNewTmLst s lst)] @ getNewTmLst s tail);; 

(* applies a substitution rule to a term list*)
let apply_substitution (s : substitution) (tml : term list) : term list= 
  getNewTmLst s tml;;

let getTmLst (f: substitution): term list  =
  List.map (fun (str, tm) -> tm) (f);;
 
let rec reapplyLst (f:substitution) (tmLst: term list): substitution = 
  match (f, tmLst) with
    |([],[]) -> []
    |([], tm'::remainder) -> raise INVALIDSUB
    |((str,tm)::tail ,[]) -> raise NOTERMS
    |((str,tm)::tail, tm'::remainder) -> [(str, tm')]@reapplyLst tail remainder;;  

let rec exists_in_f (x: string) (f: substitution) : bool = 
  match f with
    |[]-> false
    |(str,tm)::tail -> if (str = x) 
                      then true
                      else exists_in_f x tail;;

let rec getFinalSub (g: substitution) (f: substitution) : substitution = 
  match g with 
    |[] -> []
    |((str_g,tm_g)::tail_g) -> if not (exists_in_f str_g f)
                               then [(str_g, tm_g)] @ (getFinalSub tail_g f)
                              else (getFinalSub tail_g f);;

(* composes two substitutions, apply_substitution whenever necessary *)
let compose_substitution (g : substitution) (f : substitution) : substitution = 
  match (g,f) with
   |([],fSTLst) -> fSTLst
   |(gSTLst, []) -> gSTLst
   |_-> let newSub = reapplyLst f (apply_substitution g (getTmLst f)) in
        let oldComposeSub = getFinalSub g (reapplyLst f (apply_substitution g (getTmLst f))) in
        (newSub @ oldComposeSub);;

(* type (string*term) list*)
let f_sub =
  [("W", Fun("f", [Var("X"); Const("a")])); ("X", Fun("h", [Const("r")]))]

let g_sub =  
  [("X", Fun("f", [Const("a"); Const("b")])); ("Y", Fun("g", [Const("z")])); ("U", Fun("g", [Var("U")]))]

(* compose_substitution test *)
let compose_test () = 
  compose_substitution g_sub f_sub;;

let rec findDisagreeSet (tm0: term) (tm1: term) : term list =
  match (tm0,tm1) with
    |(Fun(x, lst1), Fun(y, lst2)) -> if not(x=y) then [tm0; tm1]
                                   else findDisagreeSetList lst1 lst2
    |(Const(a), Const(b))-> if not (a = b) then [tm0;tm1]
                            else []
    |(Var(x), Var(y)) -> if not (x=y) then [tm0;tm1]
                         else []
    |(t1, t2) -> [t1;t2]

  and findDisagreeSetList (t1: term list) (t2: term list) : term list =
    match (t1,t2) with
      |([],[]) -> []
      |([], t2) -> t2
      |(t1, []) -> t1
      |(head1::tail1, head2::tail2) -> let ls = findDisagreeSet head1 head2 
                                        in (match ls with 
                                              |[] -> findDisagreeSetList tail1 tail2 
                                              |_-> ls)
;;  

let term1 = parse("p(a,X,h(g(Z)))");;

print_string("-------------------------------------------------------------------")

let term2 = parse("p(Z,h(Y),h(Y))");;

print_string("-------------------------------------------------------------------")

let find_disagreeSet_test = findDisagreeSet term1 term2;;  
print_string("-------------------------------------------------------------------")

let rec create_substitution (tmLst: term list) : substitution = 
  match tmLst with
    |[] -> []
    |head::[] -> raise INVALIDSET
    |head1::head2::tail -> match (head1, head2) with  
                            |(TMError, TMError) -> []
                            |(Var(x), t2) when occurrence_free x t2-> [(x,t2)]
                            |(t1, Var(y)) when occurrence_free y t1-> [(y,t1)] 
                            |_ -> raise UNIFICATION_FAILURE 
;;

print_string("-------------------------------------------------------------------")
let create_sub_test = create_substitution (findDisagreeSet term1 term2);;

print_string("-------------------------------------------------------------------")

let apply_sub_test = apply_substitution (create_sub_test) [term1;term2];;

print_string("-------------------------------------------------------------------")

let rec unify_terms (tm0 : term) (tm1 : term) : substitution =  
  match (tm0, tm1) with
    |(TMError,TMError)-> []
    |(t1, t2) when t1 = t2 -> []
    |(Var(x), t2) -> create_substitution(findDisagreeSet (Var(x)) t2)
    |(t1, Var(y)) -> create_substitution(findDisagreeSet (Var(y)) t1)
    |(Fun(x, lst1), Fun(y, lst2)) -> let d1 = findDisagreeSet tm0 tm1 in 
                                     let sub1 = create_substitution(d1) in
                                     let termls = apply_substitution (sub1) [tm0;tm1]
                                      in (match termls with
                                          |tm0'::tm1'::tail -> compose_substitution(unify_terms tm0' tm1') sub1
                                          |_ -> [])
    |_ -> raise UNIFICATION_FAILURE;;

let unify_terms_ex = unify_terms term1 term2;;
 

let rec list_s (t:term list) : string = 
  match t with
   |[Const(x)] -> x
   |[Var(x)] -> x 
   |[Fun(x,l)] -> x ^ "(" ^ list_s l ^ ")"
   |Const(x)::tail -> x ^ "," ^ list_s tail 
   |Var(x)::tail -> x ^ "," ^ list_s tail 
   |Fun(x,l)::tail -> x ^ "(" ^ list_s l ^ ")" ^ "," ^ list_s tail 
   |_ -> ""

 ;;

let rec sub_str_creator (s:substitution) : string = 
  match s with 
  |[] -> ""
  |[(str,Const(a))] -> a ^ "/" ^ str
  |[(str,Var(a))] -> a ^ "/" ^ str 
  |[(str,Fun(a, tlst))] -> a ^ "(" ^ list_s tlst ^ ")" ^ "/" ^ str 
    |((str,tm)::tail) -> 
      match tm with 
      |TMError -> ""
      |Const(a) -> a ^ "/" ^ str ^ "," ^ sub_str_creator tail 
      |Var(x) -> x ^ "/" ^ str ^ "," ^ sub_str_creator tail
      |Fun(x, tlst) -> x ^ "(" ^ list_s tlst ^ ")" ^ "/" ^ str ^ "," ^ sub_str_creator tail
  ;;

(* the final function that takes in terms in string form; returns a most general unifier
that unifies the two strings/makes both strings equivalent or fails and raises an exception *)

let unify (x : string) (y : string) : string = 
 "{"^sub_str_creator (unify_terms (parse x) (parse y))^"}"
;;

(* unify_str_test example #1*)
(* let uStr1 = "p(f(a), g(x))";;

let uStr2 = "p(Y,Y)";;

let unify_str_test = unify uStr1 uStr2;;  *)


(* unify_str_test example #2*)
(* let uStr1 = "p(a,X,h(g(Z)))"

let uStr2 = "p(Z,h(Y),h(Y))";;

let unify_str_test = unify uStr1 uStr2;; *)

(* unify_str_test examples #3*)

(* let uStr1 = "p(X,X)";;

let uStr2 = "p(Y,f(Y))";;

let unify_str_test = unify uStr1 uStr2;; *)
