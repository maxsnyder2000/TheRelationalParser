(load "load-parser.scm")

(display
 (run-staged 100 (q)
	     (evalo-staged
	      (the-relational-parser
	       `(letrec
		    ([neg (lambda (x) (if (equal? x 1) 0 1))]
		     [add (lambda (x y) (if (or  (equal? x 1) (equal? y 1)) 1 0))]
		     [mul (lambda (x y) (if (and (equal? x 1) (equal? y 1)) 1 0))])
		  (parse
		   (list
		    (list 'Bit '(0) '(1))
		    (list 'Exp
			  (list '(Bit))
			  (list '- '(: x (Exp))
				(list '= (lambda (u)
					   (neg (get u 'x)))))
			  (list '((: x (Exp)) + (: y (Exp)))
				(list '= (lambda (u)
					   (add (get u 'x)
						(get u 'y)))))
			  (list '((: x (Exp)) x (: y (Exp)))
				(list '= (lambda (u)
					   (mul (get u 'x)
						(get u 'y)))))))
		   ',q 'Exp)))
	      '(1 ()))))

(display "\n")
