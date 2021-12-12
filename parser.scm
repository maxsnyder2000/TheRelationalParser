(define (the-relational-parser code)
  `(letrec
       ([parse ; PARSER (Core-OMeta)
	 (lambda (grammar in rule-name)
	   (if (get grammar rule-name)
	       (cabr (parse-rule
		      grammar
		      in
		      '()
		      (get grammar rule-name)))
	       (cons #f (list in))))]
	[parse-rule ; ALTERNATION
	 (lambda (grammar in store rule)
	   (if (null? rule)
	       (cons #f (cons in (list store))) ; failure
	       (parse-choice ; next
		grammar
		in
		'NONE ; EMPTY
		in
		store
		rule
		(car rule))))]
	[parse-choice ; SEQUENCING
	 (lambda (grammar in out in-rem store rule choice)
	   (if (null? choice)
	       (cons out (cons in-rem (list store))) ; success
	       (match (car choice)
		      [`(* . ,d)
		       (parse-iteration grammar in '() in-rem store rule choice d)]
		      [`(! . ,d)
		       (parse-negation grammar in in-rem store rule choice
				       (parse-rule
					grammar
					in-rem
					store
					(list d)))]
		      [`(: . ,d)
		       (parse-binding grammar in in-rem store rule choice (car d)
				      (parse-rule
				       grammar
				       in-rem
				       store
				       (list (cdr d))))]
		      [`(= . ,d)
		       (cons (eval d store) (cons in-rem (list store)))]
		      [`(,a . ,d)
		       (if (get grammar a)
			   (parse-nonterminal grammar in in-rem store rule choice
					      (parse-rule
					       grammar
					       in-rem
					       '()
					       (get grammar a)))
			   (if (not (null? in-rem))
			       (parse-list grammar in in-rem store rule choice
					   (parse-rule
					    grammar
					    (car in-rem)
					    store
					    (list (car choice))))
			       (parse-rule
				grammar
				in
				store
				(cdr rule))))]
		      [token
		       (parse-atom grammar in in-rem store rule choice token)])))]
	[parse-atom ; ATOM
	 (lambda (grammar in in-rem store rule choice token)
	   (if (and (not (null? in-rem)) (equal? token (car in-rem)))
	       (parse-choice ; success
		grammar
		in
		token
		(cdr in-rem)
		store
		rule
		(cdr choice))
	       (parse-rule ; failure
		grammar
		in
		store
		(cdr rule))))]
	[parse-nonterminal ; NONTERMINAL
	 (lambda (grammar in in-rem store rule choice rec)
	   (if (car rec)
	       (parse-choice ; success
		grammar
		in
		(car rec)
		(cbr rec)
		store
		rule
		(cdr choice))
	       (parse-rule ; failure
		grammar
		in
		store
		(cdr rule))))]
	[parse-iteration ; ITERATION
	 (lambda (grammar in out in-rem store rule choice iter)
	   (parse-iteration-rec grammar in out in-rem store rule choice iter
				(parse-rule
				 grammar
				 in-rem
				 store
				 (list iter))))]
	[parse-iteration-rec
	 (lambda (grammar in out in-rem store rule choice iter rec)
	   (if (car rec)
	       (parse-iteration ; repetition
		grammar
		in
		(cons (car rec) out)
		(cbr rec)
		(ccr rec)
		rule
		choice
		iter)
	       (parse-choice ; termination
		grammar
		in
		(rev out '())
		in-rem
		(ccr rec)
		rule
		(cdr choice))))]
	[parse-negation ; NEGATION
	 (lambda (grammar in in-rem store rule choice rec)
	   (if (not (car rec))
	       (parse-choice ; success
		grammar
		in
		'NONE
		in-rem
		(ccr rec)
		rule
		(cdr choice))
	       (parse-rule ; failure
		grammar
		in
		(ccr rec)
		(cdr rule))))]
	[parse-binding ; BINDING
	 (lambda (grammar in in-rem store rule choice key rec)
	   (if (car rec)
	       (parse-choice ; success
		grammar
		in
		(car rec)
		(cbr rec)
		(set (ccr rec) key (car rec))
		rule
		(cdr choice))
	       (parse-rule ; failure
		grammar
		in
		(ccr rec)
		(cdr rule))))]
	[eval ; SEMANTIC ACTION
	 (lambda (out store) ((car out) store))]
	[parse-list ; LIST
	 (lambda (grammar in in-rem store rule choice rec)
	   (if (and (car rec) (null? (cbr rec)))
	       (parse-choice ; success
		grammar
		in
		(car in-rem)
		(cdr in-rem)
		(ccr rec)
		rule
		(cdr choice))
	       (parse-rule ; failure
		grammar
		in
		(ccr rec)
		(cdr rule))))]
	[cbr  (lambda (l) (car (cdr l)))]
	[ccr  (lambda (l) (car (cdr (cdr l))))]
	[cabr (lambda (l) (cons (car l) (list (cbr l))))]
	[get ; helper: dictionary get
	 (lambda (dict key)
	   (if (null? dict)
	       #f
	       (if (equal? (car (car dict)) key)
		   (cdr (car dict))
		   (get (cdr dict) key))))]
	[set ; helper: dictionary set
	 (lambda (dict key value)
	   (if (null? dict)
	       (list (cons key value))
	       (if (equal? key (car (car dict)))
		   (cons (cons key value) (cdr dict))
		   (cons (car dict) (set (cdr dict) key value)))))]
	[rev ; helper: list reverse
	 (lambda (list-in list-out)
	   (if (null? list-in)
	       list-out
	       (rev (cdr list-in) (cons (car list-in) list-out))))])
     ,code))
