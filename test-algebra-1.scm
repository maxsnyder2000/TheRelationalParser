(load "load-parser.scm")

(display
 (run-staged 100 (q)
	     (fresh (any-out)
		    (evalo-staged
		     (the-relational-parser
		      `(parse
			'((Dig (0) (1) (2) (3) (4) (5) (6) (7) (8) (9))
			  (Num (0) ((! 0) (Dig) (* (Dig))))
			  (Exp
			   ((Num))
			   (((: x (Exp)) + (: y (Exp))))
			   (((: x (Exp)) - (: y (Exp))))
			   (((: x (Exp)) x (: y (Exp))))
			   (((: x (Exp)) / (: y (Exp))))))
			',q 'Exp))
		     `(,any-out ())))))

(display "\n")
