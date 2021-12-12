(load "load-parser.scm")

(display
 (run-staged* (q)
	      (evalo-staged
	       (the-relational-parser
		`(letrec
		     ([add (lambda (x y) (if (or (not x) (not y)) #f
					     (if (null? y) x
						 (add (cons 1 x) (cdr y)))))]
		      [sub (lambda (x y) (if (or (not x) (not y)) #f
					     (if (null? y) x
						 (if (null? x) #f
						     (sub (cdr x) (cdr y))))))]
		      [mul (lambda (x y) (if (or (not x) (not y)) #f
					     (if (null? y) '()
						 (add (mul x (cdr y)) x))))]
		      [div (lambda (x y) (if (or (not x) (not y)) #f
					     (if (null? y) #f
						 (if (null? x) '()
						     (inc (div (sub x y) y))))))]
		      [inc (lambda (x) (if (not x) #f (cons 1 x)))])
		   (parse
		    (list
		     (list 'Dig
			   (list '0 (list '= (lambda (u) '())))
			   (list '1 (list '= (lambda (u) '(1))))
			   (list '2 (list '= (lambda (u) '(1 1))))
			   (list '3 (list '= (lambda (u) '(1 1 1))))
			   (list '4 (list '= (lambda (u) '(1 1 1 1))))
			   (list '5 (list '= (lambda (u) '(1 1 1 1 1))))
			   (list '6 (list '= (lambda (u) '(1 1 1 1 1 1))))
			   (list '7 (list '= (lambda (u) '(1 1 1 1 1 1 1))))
			   (list '8 (list '= (lambda (u) '(1 1 1 1 1 1 1 1))))
			   (list '9 (list '= (lambda (u) '(1 1 1 1 1 1 1 1 1)))))
		     (list 'Exp
			   (list '(Dig))
			   (list '((: x (Exp)) + (: y (Exp)))
				 (list '= (lambda (u)
					    (add (get u 'x)
						 (get u 'y)))))
			   (list '((: x (Exp)) - (: y (Exp)))
				 (list '= (lambda (u)
					    (sub (get u 'x)
						 (get u 'y)))))
			   (list '((: x (Exp)) x (: y (Exp)))
				 (list '= (lambda (u)
					    (mul (get u 'x)
						 (get u 'y)))))
			   (list '((: x (Exp)) / (: y (Exp)))
				 (list '= (lambda (u)
					    (div (get u 'x)
						 (get u 'y)))))))
		    '(((5 x 4) / (3 + (2 - 1)))) 'Exp)))
	       `(,q ()))))

(display "\n")
