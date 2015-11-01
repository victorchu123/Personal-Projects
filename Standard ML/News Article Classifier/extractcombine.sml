(*Task 1.1: *)
functor ExtractCombine (A : sig 
                                structure Key : ORDERED
                                structure MR : MAP_REDUCE
                            end) : EXTRACT_COMBINE =
struct
	 structure MR = A.MR
	 structure D = Dict(A.Key)

	 fun extractHelper (s: (D.Key.t * 'v) Seq.seq) (combine : 'v * 'v -> 'v) : 'v D.dict=  
	 	let val extractHelp = fn (k,v) => D.insert D.empty (k,v)
	 		val combineHelp = fn(v1,v2) => D.merge combine (v1,v2)
	 	in (Seq.mapreduce extractHelp D.empty combineHelp s)
	 	end

	 fun extractcombine
	 	(extract: 'a -> (D.Key.t * 'v) Seq.seq )(combine: 'v * 'v -> 'v)
	 	(data: 'a MR.mapreducable) : 'v D.dict =

	 	let val newExtract = fn a => extractHelper (extract a) combine
	 		val newCombine = fn (d1,d2) => D.merge combine (d1,d2)
	 	in (MR.mapreduce newExtract D.empty newCombine data)
	 	end
end


