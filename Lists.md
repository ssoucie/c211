# Lists

Let's say that we want to have a data structure containing a lot
of Numbers. Before we knew about lists we would do this with the
following recursive union data/structure definition.

```racket
; A BunchOfNumbers is one of:
; - (make-no-numbers)
; - (make-bunch Number BunchOfNumbers)

(define-struct no-numbers [])
(define-struct bunch [first rest])

(define b1 (make-no-numbers))
(define b2 (make-bunch 5 b1))
(define b3 (make-bunch 19 b2))
```

Now let's look at how we would accomplish this using a list.

```racket
; A ListOfNumbers is one of:
; - empty
; - (cons Number ListOfNumbers)

(define l1 empty)
(define l2 (cons 5 l1))
(define l3 (cons 19 l2))
```

Now l1, l2, and l3 represent the same things as b1, b2, and b3, respectively.
See how much more convenient it was to use a list? We did not need to define
any structures.

Now let's design functions that will compute the sum of a bunch and a list.

```racket
; sum-bunch : BunchOfNumbers -> Number
; sums all the numbers in the given bunch

(check-expect (sum-bunch b1) 0)
(check-expect (sum-bunch b2) 5)
(check-expect (sum-bunch b3) 24)

; template for processing a BunchOfNumbers
(define (process-bunch b)
  (cond [(no-numbers? b) ...]
        [(bunch? b) (... (bunch-first b)
                         (process-bunch (bunch-rest b)))]))

(define (sum-bunch b)
  (cond [(no-numbers? b) 0]
        [(bunch? b) (+ (bunch-first b)
                       (sum-bunch (bunch-rest b)))]))

; sum-list : ListOfNumbers -> Number
; sums all the numbers in the given list

(check-expect (sum-list l1) 0)
(check-expect (sum-list l2) 5)
(check-expect (sum-list l3) 24)

; template for processing a ListOfNumbers
(define (process-list l)
  (cond [(empty? l) ...]
        [(cons? l) (... (first l)
                        (process-list (rest l)))]))

(define (sum-list l)
  (cond [(empty? l) 0]
        [(cons? l) (+ (first l)
                      (sum-list (rest l)))]))
```

See how similar the two functions are? That's good,
they do they exact same thing, just with different data
representations!

```racket
(define (sum-bunch b)
  (cond [(no-numbers? b) 0]
        [(bunch? b) (+ (bunch-first b)
                       (sum-bunch (bunch-rest b)))]))

(define (sum-list l)
  (cond [(empty? l) 0]
        [(cons? l) (+ (first l)
                      (sum-list (rest l)))]))
```

The only differences are the questions in each clause of the cond
and the accessing of the data within the representation.
no-numbers? is replaced by empty?, a built in function.
bunch? is replaced by cons?, another built in function.
bunch-first is replaced by first and bunch-rest is replaced by
rest, as both are built in functions that access the data in lists.

In sum, here's the rundown on lists:
* empty is a constant referring to the empty list ['()]
* All lists follow this data definition:
```racket
; A ListOfX is one of:
; - empty
; - (cons X ListOfX)
```
where X is an already-defined data type.
* The built in functions MOST IMPORTANT for using lists are:
  * empty? : Anything -> Boolean
    returns true if the input is the empty list
  * cons? : Anything -> Boolean
    returns true if the input is a non-empty list
  * cons : X ListOfX -> ListOfX
    creates a list with X becoming the first and ListOfX becoming the rest
    ex: (cons 1 empty) -> (list 1), (cons 1 (cons 2 empty)) -> (list 1 2)
  * first : ListOfX -> X
    returns the first element of the given list
  * rest : ListOfX -> ListOfX
    returns the list of everything BUT the first element

## IMPORTANT NOTE:
The list function creates a list of the inputs given to it.
This is useful for testing, but you should almost NEVER use it
in a function definition. This is because it does not work like
cons. For example: (list 1 (list 2 empty)) does not create the list
containing 1 and 2, it creates a list containing 1 and the list containing
2 and the empty list!! If that is confusing, that's fine, just use cons!!
