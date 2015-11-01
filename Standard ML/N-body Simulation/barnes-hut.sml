structure BarnesHut =
struct

  open Mechanics
  structure BB = BoundingBox
  open Plane
  open TestData

  infixr 3 ++
  infixr 4 **
  infixr 3 -->
  infixr 4 //

  datatype bhtree =
      Empty
    | Single of body
    | Cell of (Scalar.scalar * Plane.point) * BB.bbox * bhtree * bhtree * bhtree * bhtree
      (* ((mass, center), box, top-left, top-right, bottom-left, bottom-right) *)

  (* Projects the mass and center from the root node of a bhtree *)
  fun center_of_mass (T : bhtree) : Scalar.scalar * Plane.point =
      case T of
          Empty => (Scalar.zero, Plane.origin)
        | Single (m, p, _) => (m, p)
        | Cell (com, _, _,_,_,_) => com

  (* Note: Doesn't compare velocities as these are unaffected by compute_tree *)
  fun bodyEq ((m1, p1, _) : body, (m2, p2, _) : body) : bool =
      (Scalar.eq (m1, m2)) andalso Plane.pointEqual (p1, p2)

  fun bhtreeEq (t1 : bhtree, t2 : bhtree) : bool =
      case (t1, t2) of
          (Empty, Empty) => true
        | (Single b1, Single b2) => bodyEq (b1, b2)
        | (Cell ((cm1, cp1), bb1, tl1,tr1,bl1,br1), Cell ((cm2, cp2), bb2, tl2,tr2,bl2,br2)) =>
              Scalar.eq (cm1, cm2) andalso
              Plane.pointEqual (cp1, cp2) andalso
              BB.equal (bb1, bb2) andalso 
              bhtreeEq (tl1,tl2) andalso bhtreeEq (tr1,tr2) andalso 
              bhtreeEq (bl1,bl2) andalso bhtreeEq (br1,br2)
        | (_, _) => false

  (* ---------------------------------------------------------------------- *)
  (* TASKS *)

  (* TASK *)
  (* Compute the barycenter of four points *)
  (* Assumes the total mass of the points is positive *)
  fun barycenter ((m1,p1) : (Scalar.scalar * Plane.point),
                  (m2,p2) : (Scalar.scalar * Plane.point),
                  (m3,p3) : (Scalar.scalar * Plane.point),
                  (m4,p4) : (Scalar.scalar * Plane.point)) : Scalar.scalar * Plane.point =
      let val totMass = Scalar.plus(Scalar.plus(Scalar.plus(m1,m2),m3),m4)
          val barcenter = head((((origin --> p1) ** m1) ++
          ((origin --> p2) ** m2) ++ ((origin --> p3) ** m3) ++ ((origin --> p4) ** m4)) // totMass)
        in 
          (totMass,barcenter)
        end


  (* TASK *)
  (* Compute the four quadrants of the bounding box *)
  fun quarters (bb : BB.bbox) : BB.bbox * BB.bbox * BB.bbox * BB.bbox =
      let val (tl,tr,bl,br) = BB.corners bb
          val bbtl = BB.from2Points(tl, BB.center(bb))
          val bbtr = BB.from2Points(tr,BB.center(bb))
          val bbbl = BB.from2Points(bl,BB.center(bb))
          val bbbr = BB.from2Points(br,BB.center(bb))
      in
        (bbtl, bbtr, bbbl,bbbr)
      end

  (* Test for quarters:*)
  val true = let val (tl,tr,bl,br) = quarters(bb4) 
             in BB.equal(tl,bb0) andalso BB.equal(tr,bb1) andalso
                BB.equal(bl, bb2) andalso BB.equal(br,bb3)
             end
  

  (* TASK *)
  (* Computes the Barnes-Hut tree for the bodies in the given sequence.
   * Assumes all the bodies are contained in the given bounding box,
     and that no two bodies have collided (or are so close that dividing the 
     bounding box will not eventually separate them).
     *)
  fun compute_tree (s : body Seq.seq) (bb : BB.bbox) : bhtree = 
      case (Seq.length(s)) of
      0 => Empty
      |1 => Single(Seq.nth 0 s)
      |_ => let val (tl,tr,bl,br) = quarters(bb)
                val tlseq = Seq.filter (fn (m,p,v)=> BB.contained (false, false, false, false) (p,tl)) s
                val trseq = Seq.filter (fn (m,p,v)=> BB.contained (true, false, false, false) (p,tr)) s
                val blseq = Seq.filter (fn (m,p,v)=> BB.contained (false, false, true, false) (p,bl)) s
                val brseq = Seq.filter (fn (m,p,v)=> BB.contained (true, false, true, false) (p,br)) s
                val (tlBh, trBh, blBh, brBh) = (compute_tree tlseq tl, compute_tree trseq tr, compute_tree blseq bl, compute_tree brseq br)
                val baryctr = barycenter(center_of_mass(tlBh), center_of_mass(trBh), center_of_mass(blBh), center_of_mass (brBh))
              in Cell(baryctr, bb, tlBh, trBh, blBh, brBh)
              end
  (* Test for compute_tree:*)
  val three_bodies = Seq.cons body1 (Seq.cons body2 (Seq.cons body3 (Seq.empty())))
  val three_bodies_tree = Cell ((Scalar.fromInt 3, p22), bb4,
                                Cell ((Scalar.fromInt 2, p13), bb0,
                                      Single body3, Empty, Empty, Single body2), 
                                Empty, 
                                Empty, 
                                Single body1)
  val true = bhtreeEq (compute_tree three_bodies bb4, three_bodies_tree)
  

  (* TASK *)
  (* too_far p1 p2 bb t determines if point p1 is "too far" from 
   * a region bb with barycenter p2, given a threshold parameter t,
   * for it to be worth recuring into the region
   *)
  fun too_far (p1 : Plane.point) (p2 : Plane.point) (bb : BB.bbox) (t : Scalar.scalar) : bool =
      Scalar.lte(Scalar.divide(BB.diameter(bb), distance p1 p2),t) 

  (* TASK *)
  (* Computes the acceleration on b from the tree T using the Barnes-Hut
   * algorithm with threshold t
   *)
  fun bh_acceleration (T : bhtree) (t : Scalar.scalar) (b : body) : Plane.vec =
      case T of
        Empty=> zero
        |Single(body1)=> Mechanics.accOn(b,body1)
        |Cell((m,c),bb,tl,tr,bl,br)=> let val (m1,p1,v1) = b
                                      in
                                        (case too_far p1 c bb t of
                                          true => accOn(b,(m,c,zero))
                                          |false => (bh_acceleration tl t b) ++ (bh_acceleration tr t b) ++ (bh_acceleration bl t b)
                                              ++ (bh_acceleration br t b))
                                      end

  (* TASK
     Given a threshold and a sequence of bodies, compute the acceleration
     on each body using the Barnes-Hut algorithm.
   *)
  fun barnes_hut (threshold : Scalar.scalar) (s : body Seq.seq) : Plane.vec Seq.seq = 
      let val map1 = Seq.map (fn (m,p,v) => p) s 
          val boundbox = BB.fromPoints(map1)
          val newbhT = compute_tree s boundbox
        in
          Seq.map (fn b1 => bh_acceleration newbhT threshold b1) s
        end
      

  (* Default value of the threshold, theta = 0.5 *)
  val threshold = (Scalar.fromRatio (1,2))

  val accelerations : body Seq.seq -> Plane.vec Seq.seq = barnes_hut threshold

end
