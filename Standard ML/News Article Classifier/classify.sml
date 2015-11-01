
functor NaiveBayes (ClassSpec : sig
                                  structure Category : ORDERED
                                  val default_category : Category.t
                                      
                                  structure Dataset : MAP_REDUCE
                                end) : NAIVE_BAYES_CLASSIFIER =
struct

    type category = ClassSpec.Category.t

    type labeled_document = category Seq.seq * string Seq.seq
    type document = string Seq.seq

    structure Dataset = ClassSpec.Dataset
        
    (* TASK 2.1: Defines a dictionary structure WordDict whose keys are strings.*)

    structure WordDict = Dict(StringLt)

    (* Task 2.2: Uses the functor ExtractCombine to make an extract-combine instance 
      whose keys are categories and whose mapreducable type is Dataset. 
      CatDict is a dictionary from this extract-combine instance.*)

    structure CatEC = ExtractCombine(struct
                                        structure Key = ClassSpec.Category
                                        structure MR = ClassSpec.Dataset
                                    end)
    structure CatDict = CatEC.D
    
    type counts = 
        int (* number of labeled_documents with that category *)
      * int WordDict.dict (* frequencies of words in labeled_documents with that category *)

    fun counts_documents ((n,_) : counts) : int = n
    fun counts_words     ((_,w) : counts) : int WordDict.dict = w


    (* TASK 2.3: *)

    (* helper function that takes the document and returns a single dict with 
      the word counts as values *)
    fun countHelp (doc: string Seq.seq) : int WordDict.dict = 
      let val extract = fn s => WordDict.insert WordDict.empty (s,1)
          val combine = WordDict.merge Int.+
        in (Seq.mapreduce extract WordDict.empty combine doc)
        end

    (* takes a mapreducable doocument and returns a single dict with category counts as a values *)
    fun count_by_category (docs : labeled_document Dataset.mapreducable) : counts CatDict.dict =
        let val extract = fn (catSeq, doc) => Seq.map (fn x => (x ,(1,countHelp doc))) catSeq
            val combine = fn ((c1, wDict1), (c2, wDict2)) => (c1+c2, WordDict.merge (Int.+) (wDict1,wDict2))
        in (CatEC.extractcombine extract combine docs)
        end

    type postprocess_data =
          category Seq.seq (* list of categories (no duplicates) *)
        * int              (* total number of categorized training labeled_documents (count doc once for each label) *)
        * int              (* total number of words *)
        * int CatDict.dict (* how many words in each category? *) 

    (* TASK 2.4: takes a CatDict and returns postprocess_data based on the type defined above *)
    fun postprocess (counts_by_category : counts CatDict.dict) : postprocess_data = 
        let 
            val counts_seq = CatDict.toSeq counts_by_category
            val all_categories = Seq.map (fn (c,_) => c) counts_seq

            val total_num_docs = Seq.mapreduce (fn (_,(ccount,_)) => ccount) 0 Int.+ counts_seq

            val num_words_by_cat = 
                CatDict.map (fn (_,wordfreqs) => Seq.reduce Int.+ 0 (WordDict.valueSeq wordfreqs)) counts_by_category

            val total_num_words = 
                (Seq.length (WordDict.toSeq (Seq.mapreduce (fn (_,(_,wd)) => wd)
                                              WordDict.empty
                                              (WordDict.merge (fn (_,_) => 0)) (* don't care about counts *) 
                                              counts_seq)))
        in 
            (all_categories, 
             total_num_docs,
             total_num_words,  
             num_words_by_cat)
        end
        
    (* returns count of category c in the CatDict *)

    fun dLookupHelp (c: category) (counts_by_category: counts CatDict.dict) : int = 
      case (CatDict.lookup counts_by_category c) of
          NONE => 0
          |SOME v => let val (docf, wDict) = v
                      in (docf)
                      end
    (* returns count of word w in the CatDict *)

    fun iwrdLookupHelp (w: string) (c: category) (counts_by_category : counts CatDict.dict): int =

        case (CatDict.lookup counts_by_category c) of
            NONE => 0
            |SOME v => (let val (docf, wDict) = v
                      in case (WordDict.lookup wDict w) of
                            NONE => 0
                            |SOME v => v 
                      end)

    (* returns count of total words in a category *)

    fun ctotWordHelp (ctg : category) (num_words_by_cat: int CatEC.D.dict) : int = 
      case (CatDict.lookup num_words_by_cat ctg) of
                              NONE => 0
                              |SOME v => v

    (* calculuates the Naive Bayesian probability *)

    fun probability 
        (ctg : category) (counts_by_category: counts CatDict.dict) 
        (num_words_by_cat: int CatEC.D.dict) (test_doc: document) (total_num_docs : int) 
        (total_num_words: int): real = 
      let val cdocCount = dLookupHelp ctg counts_by_category
            val ctotWord = ctotWordHelp ctg num_words_by_cat
            val testrhs = Real./ (1.0, Real.fromInt(total_num_words))
            val sigmaRhs= Seq.mapreduce 
            (fn wi => (case (iwrdLookupHelp wi ctg counts_by_category) of
                        0 => Math.ln(testrhs)
                      |_ => Math.ln (Real./ (Real.fromInt(iwrdLookupHelp wi ctg counts_by_category),Real.fromInt(ctotWord))))) 
            0.0 (fn (x,y) => Real.+(x,y)) test_doc
            
            val lhsprob = Math.ln(Real.fromInt(cdocCount)/Real.fromInt(total_num_docs))
        
      
      in  (Real.+(lhsprob,sigmaRhs))
      end

    (* Task 2.5: that maps a document w1, . . . , wn to the sequence of all pairs (C,lnP(C | w1,...,wn))
    for every category C. *)

    fun possible_classifications 
        (counts_by_category : counts CatDict.dict)
        ((all_categories, total_num_docs, total_num_words, num_words_by_cat) : postprocess_data)
        (test_doc : document) : (category * real) Seq.seq =

        Seq.map (fn ctg => (ctg,probability ctg counts_by_category num_words_by_cat test_doc total_num_docs total_num_words)) 
        (all_categories)
        

    (* TASK 2.6 : returns the default category and Real.negInf (negative infinity) if there are no possible classifications. *)
    fun classify (counts_by_category : counts CatDict.dict)
                 (pp : postprocess_data)
                 (test_doc : document) : (category * real) =
                 
        Seq.reduce(fn ((cat1, prob1), (cat2, prob2)) => case (Real.compare(prob1,prob2)) of 
                                                         LESS=> (cat2,prob2)
                                                        |EQUAL => (cat1,prob1)
                                                        |GREATER => (cat1,prob1)) 
        (ClassSpec.default_category, Real.negInf) 
        (possible_classifications counts_by_category pp test_doc)


    (* TASK 2.7 : classifier main function *)

    fun train_classifier (train : labeled_document Dataset.mapreducable) : document -> (category * real) =  
        let val catDict = count_by_category(train)
            val postprocessD = postprocess(catDict)
            val result = classify catDict postprocessD
        in result
        end
      
    (* TASK 2.9:
        
        small train with small test: (6,8) ~= 75.00%
        medium train with medium test: (735,818) ~= 89.85%
        big train with big test: (74131, 80435) ~= 92.16%

        medium train with small test: (8,8) ~= 100.0%
        small train with medium test: (487,818) ~= 59.54%
        big train with small test: (8,8) ~= 100.0%

        Yes, the medium training data did improve on the results of the small test.
        Generally, using a smaller test on a larger or same size train would improve 
        the accuracy. Using a larger test with a smaller or same size train would 
        drastically lower the accuracy. 
      

      *)
end
