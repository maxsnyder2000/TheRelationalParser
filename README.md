# The Relational Parser

#### A [Core-OMeta](https://web.cs.ucla.edu/~todd/theses/warth_dissertation.pdf#page=47) parser embedded in Racket/[staged-miniKanren](https://github.com/namin/staged-miniKanren).

The Relational Parser (TRP) is an OMeta parser that can be relationally queried. Any of the input or output variables may be partially or completely constrained; these are:

1. Grammar (Core-OMeta)
2. Input / Stream of Tokens
3. Output / Semantic Value

#### How to Use

```scheme
(load "load-parser.scm")

(display
  (run-staged 1 (q)
    (evalo-staged
      (the-relational-parser
        `(letrec
          (...) ; HELPER FUNCTIONS
            (parse
              (list ; GRAMMAR
                (list 'RULE-NAME-1 ; rule 1
                  (list ... ; syntax 1A
                    (list '= (lambda (u) ...))) ; semantics 1A
                  (list ... ; syntax 1B
                    (list '= (lambda (u) ...))) ; semantics 1B
                  ...)
                (list 'RULE-NAME-2 ; rule 2
                  (list ... ; syntax 2A
                    (list '= (lambda (u) ...))) ; semantics 2A
                  (list ... ; syntax 2B
                    (list '= (lambda (u) ...))) ; semantics 2B
                  ...)
                ...)
              '(...) 'RULE-NAME))) ; INPUT
      '(... ())))) ; OUTPUT

(display "\n")
```

#### Grammars and Rules

A grammar is a list of rules, which are each comprised of a name and a list of choices that can instantiate the rule. Each choice has a syntax and a corresponding semantic value.

###### Syntax

The syntax for each choice is represented recursively:

- `'token`: parse one matching atom (symbol, number)
- `'(RULE-NAME)`: parse one instantiation of a non-terminal
- `choice-1 choice-2`: parse one sub-choice followed by another
- `'(* choice)`: parse zero or more sequential instantiations of a sub-choice
- `'(! choice)`: accept inputs that fail to instantiate a sub-choice
- `'(: 'x choice)`: bind the semantic value of a sub-choice to `x` (see Semantics)
- `'(choice)`: parse one list whose contents instantiate a sub-choice

###### Semantics

Semantics are written as lambda expressions in Racket/staged-miniKanren, given a store `u` of bound variables. To compute the value of a bound variable `x`, write `(get u 'x)`.

#### Examples

###### Boolean Algebra

Query for 100 boolean expressions (0, 1, and, or, not) that evaluate to the value 1.

```scheme
(load "test-boolean-algebra.scm")
```

###### Algebra

Query for the value of the input stream "((5 x 4) / (3 + (2 - 1)))".

```scheme
(load "test-algebra-2.scm")
```

###### English

Query for the value of "a program learns English" given a grammar with holes.

```scheme
(load "test-english.scm")
```
