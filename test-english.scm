(load "load-parser.scm")

(display
 (run-staged 1 (q)
	     (fresh (d1 d2 n1 n2 v1 v2)
		    (evalo-staged
		     (the-relational-parser
		      `(parse
			(list
			 (list 'D  ; determiner
			       (list ',d1)
			       (list ',d2))
			 (list 'N  ; noun
			       (list ',n1)
			       (list ',n2))
			 (list 'V  ; verb
			       (list ',v1)
			       (list ',v2))
			 (list 'DP ; determiner phrase
			       (list '(: d (D)) '(: np (NP))
				     (list '= (lambda (u) (lambda (p) (list 'EXISTS 'x 'S.T. (list ((get u 'np) 'x) 'AND (p 'x)))))))
			       (list '(: d (D))
				     (list '= (lambda (u) (get u 'd)))))
			 (list 'NP ; noun phrase
			       (list '(: n (N))
				     (list '= (lambda (u) (lambda (x) (list x 'IN (get u 'n)))))))
			 (list 'VP ; verb phrase
			       (list '(: v (V)) '(: dp (DP))
				     (list '= (lambda (u) (lambda (x) (list x (get u 'v) (get u 'dp)))))))
			 (list 'S  ; sentence
			       (list '(: dp (DP)) '(: vp (VP))
				     (list '= (lambda (u) ((get u 'dp) (get u 'vp)))))))
			'(a program learns English) 'S))
		     `(,q ())))))

(display "\n")
