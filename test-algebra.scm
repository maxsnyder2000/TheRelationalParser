(load "load-parser.scm")

(display
 (run-staged* (q)
	      (fresh (any-store)
		     (evalo-staged
		      (the-relational-parser
		       `(parse
			 (list
			  '(Dig (0) (1) (2) (3) (4) (5) (6) (7) (8) (9))
			  (list 'Num
				(list '0
				      (list '= (lambda (u)
						 '(0))))
				(list '(! 0) '(: x (Dig)) '(: y (* (Dig)))
				      (list '= (lambda (u)
						 (cons (get u 'x)
						       (get u 'y)))))))
			 (cons 'Num '(1 2 3 4))))
		      `(,q () ,any-store)))))

(display "\n")
