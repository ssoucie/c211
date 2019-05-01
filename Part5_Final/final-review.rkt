;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname final-review) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Final Review

; Built-In Abstractions

;; Some abstract functions are so common and useful that they are built into the language.
;; The most used of these built-in abstractions are map and fold.

;; Map

;; The signature for map is:
; map : (X -> Y) [ListOf X] -> [ListOf Y]

;; From the signature, it's pretty clear what map does. It takes each element from the given list,
;; applies the given function to said element, and returns a new list of those new elements.

;; For example,
(map add1 (list 1 2 3))
;; returns (list 2 3 4).

;; Notice that the type variables, X and Y, can be (and often are) the same type. Of course, they
;; can also be different types:
(map (λ (x) (make-posn x x)) (list 1 2 3))
;; returns (list (make-posn 1 1) (make-posn 2 2) (make-posn 3 3)).

;; Fold is a slightly more complicated abstraction. The signature for foldr (the Fold function we
;; use most often) is:
; foldr : (X Y -> Y) Y [ListOf X] -> Y

;; What foldr does is not exactly clear from the signature. Basically, foldr takes a function, which
;; describes how to combine the first element with the recursive call on the rest, a base, which describes
;; what to return in the empty case, and a list to fold over.

;; Fold becomes more clear when we translate a common, structurally recursive definition, into one using
;; a foldr abstraction. Consider the following defintion of sum:

; sum : [ListOf Number] -> Number
; sums all the elements in the given list

(check-expect (sum empty) 0)
(check-expect (sum (list 1 2 3)) 6)

(define (sum ls)
  (cond [(empty? ls) 0]
        [else (+ (first ls) (sum (rest ls)))]))

;; Now check out the same function defined using foldr:

; sum/fold: [ListOf Number] -> Number
; sums all the elements in the given list using foldr

(check-expect (sum/fold empty) 0)
(check-expect (sum/fold (list 1 2 3)) 6)

(define (sum/fold ls)
  (foldr + 0 ls))

;; Look at how much shorter that definition is! Also, look at the similarities. The first argument to foldr
;; is +, which is the function in the third line of sum that combines the first with the sum of the rest.
;; The second argument to foldr is 0, which is exactly what is returned in the base (empty) case. The last
;; argument is just the list, which is passed unchanged.

;; One thing that confuses people about foldr is that the function argument needs to take two arguments.
;; This is because the arguments correspond to the first element and the result of the recursive call,
;; respectively. Consider one more example, a function that draws circles at given positions on an image.

(require 2htdp/image)
(define sprite (circle 5 "solid" "red"))
(define background (empty-scene 200 200))

; draw-circles : [ListOf Posn] -> Image
; draws circles at the given positions onto an image

(check-expect (draw-circles empty) background)
(check-expect (draw-circles (list (make-posn 1 1)
                                  (make-posn 2 2)))
              (place-image sprite 1 1
                           (draw-circles (list (make-posn 2 2)))))

(define (draw-circles ls)
  (cond [(empty? ls) background]
        [else (place-image sprite
                           (posn-x (first ls))
                           (posn-y (first ls))
                           (draw-circles (rest ls)))]))

;; We can redefine this function more concisely using foldr and a lambda!

; draw-circles/fold : [ListOf Posn] -> Image
; draws circles at the given positions onto an image using foldr

(check-expect (draw-circles/fold empty) background)
(check-expect (draw-circles/fold (list (make-posn 1 1)
                                  (make-posn 2 2)))
              (place-image sprite 1 1
                           (draw-circles (list (make-posn 2 2)))))

(define (draw-circles/fold ls)
  (foldr (λ (f r) (place-image sprite
                               (posn-x f)
                               (posn-y f)
                               r)) background ls))

;; I like to name the arguments to my foldr lambda functions "f" and "r", standing for "first"
;; and "recursive result", respectively.

; Mutual Recursion

;; Mutual recursion is when multiple data definitions/functions refer to each other. The clearest
;; and probably most common example is when a data type can be a list of itself.

; A GroupOfNumbers is one of:
; - Number
; - [ListOf GroupOfNumbers]

; A [ListOf GroupOfNumbers] is one of:
; - empty
; - (cons GroupOfNumbers [ListOf GroupOfNumbers])

;; Notice that each data definition refers to the other, this is mutual recursion.

;; Let's write some examples for GroupOfNumbers.

(define gon1 4)
(define gon2 (list gon1 gon1))
(define gon3 (list gon1 gon2))

;; Check out the templates for GroupOfNumbers and [ListOf GroupOfNumbers].

(define (process-gon gon)
  (cond [(number? gon) ...]
        [else (... (process-lgon gon))]))

(define (process-lgon lgon)
  (cond [(empty? lgon) ...]
        [else (... (process-gon (first gon))
                   (process-lgon (rest lgon)))]))

;; Notice that each template refers to the other in the same place the data definitions do.

;; Let's write a function that produces the sum of a GroupOfNumbers.

; sum-gon : GroupOfNumbers -> Number
; sums a group of numbers

(check-expect (sum-gon gon1) 4)
(check-expect (sum-gon gon2) 8)
(check-expect (sum-gon gon3) 12)

(define (sum-gon gon)
  (cond [(number? gon) gon]
        [else (sum-lgon gon)])) ; I haven't written this function, but I know I need it from the template!

; sum-lgon : [ListOf GroupOfNumbers] -> Number
; produces the sum of a list of group of numbers

(check-expect (sum-lgon empty) 0)
(check-expect (sum-lgon (list gon1 gon1)) 8)

(define (sum-lgon lgon)
  (cond [(empty? lgon) 0]
        [else (+ (sum-gon (first lgon))
                 (sum-lgon (rest lgon)))]))

; Accumulators

;; Accumulators are extra inputs to functions that "remember" things about the current computation.
;; This can be used to build the output of the function in a more efficient manner, or to recognize
;; when certain things need to happen.

;; The most common use of accumulators is to build the output. For example, say we wanted a function
;; that sums a list of numbers. Recall that we've already written this above, reprinted below:

; sum : [ListOf Number] -> Number
; sums all the elements in the given list

#;(check-expect (sum empty) 0)
#;(check-expect (sum (list 1 2 3)) 6)

#;(define (sum ls)
  (cond [(empty? ls) 0]
        [else (+ (first ls) (sum (rest ls)))]))

;; If we wanted to rewrite this function using an accumulator, we need to do a few things. First, we need
;; to add an input, the accumulator, and then specify what that input exactly is under the purpose statement
;; (we call this the accumulator statement).

; sum/acc : [ListOf Number] Number -> Number
; sums all the elements in the given list
; *Accumulator* : total is the current total of the sum

#;(define (sum/acc ls total)
  ...)

;; Now we need to rewrite the function using the total input.

(define (sum/acc ls total)
  (cond [(empty? ls) total] ; if there's nothing else to sum, return the total so far
        [else (sum/acc (rest ls) (+ (first ls) total))])) ; if there is more, add the first to the total
                                                          ; and continue the computation

;; Now, we just need to write the overall function to match the signature of sum, [ListOf Number] -> Number

; sum/a : [ListOf Number] -> Number
; sums all the numbers in a given list

(check-expect (sum/a empty) 0)
(check-expect (sum/a (list 1 2 3)) 6)

(define (sum/a ls)
  (sum/acc ls 0))

;; We can also use accumulators to help the function recognize when it needs to do something.
;; Consider the alternating-sum function from lab, which takes a list of numbers and produces
;; their alternating sum (add the first, subtract the second, ...)

; alternating-sum : [ListOf Numbers] -> Number
; produces the alternating-sum of the list

(check-expect (alternating-sum empty) 0)
(check-expect (alternating-sum (list 1 4 9 16 9 7 4 9 11))
              (+ 1 -4 9 -16 9 -7 4 -9 11))

;; The lab tells us to use the following accumulators, copied under the purpose statement:

; alt-sum/acc : [ListOf Number] Boolean Number -> Number
; returns the alternating sum using the following accumulators
; *Accumulator*: subtract is whether to subtract rather than add the next number
; *Accumulator*: sum-so-far is the sum of numbers seen so far

;; Here, the Boolean accumulator is the example of an accumulator helping the function make decisions.

(define (alt-sum/acc ls subtract sum-so-far)
  (cond [(empty? ls) sum-so-far]
        [subtract (alt-sum/acc (rest ls) (not subtract) (- sum-so-far (first ls)))] 
        [else (alt-sum/acc (rest ls) (not subtract) (+ (first ls) sum-so-far))]))

;; The idea for how this function using the subtract input is that it asks "Is subtract true?" If so,
;; the first element is subtracted from sum-so-far, and the function recurs, flipping subtract to false.
;; Otherwise, it adds the first element and the function recurs in the same way.

;; Now, we can define the overall function.

(define (alternating-sum ls)
  (alt-sum/acc ls false 0))

; Generative Recursion

;; Generative recursion refers to recursive functions that decompose in a way fundamentally different
;; than what their data definition specifies. For example, if you write a function that takes a list
;; and does something with a middle element and then recurs on that list with the element removed, then
;; you have written a generative recursive function, since you didn't do the standard first/rest decomposition
;; for lists. Generative recursive functions require termination statements, which are placed under the purpose
;; statement and describe why the function will always eventually terminate, since it may not be obvious.

;; For this part, I will be working through Lab 13's Generative Recursion for power section, but only
;; the generative recursion parts (exercises 7-9).

; A PowerTree is one of:
; - (make-zeroth)
; - (make-oddth  PowerTree)
; - (make-eventh PowerTree)
(define-struct zeroth [])
(define-struct oddth  [sub1])
(define-struct eventh [half])

; power-tree-exponent : PowerTree -> NaturalNumber
; returns the meaning of the given PowerTree
(define (power-tree-exponent pt)
  (cond [(zeroth? pt) 0]
        [(oddth?  pt) (+ 1 (power-tree-exponent (oddth-sub1  pt)))]
        [(eventh? pt) (* 2 (power-tree-exponent (eventh-half pt)))]))

; generate-power-tree : NaturalNumber -> PowerTree
; creates a power tree representing the input natural number
; *Termination* : the function always terminates because the recursive calls
; are called on either n-1 for odd numbers, or n/2 for even numbers, which
; will eventually get the number down to 0, which is the base case

(check-expect (generate-power-tree 0)
              (make-zeroth))
(check-expect (generate-power-tree 1)
              (make-oddth (make-zeroth)))
(check-expect (generate-power-tree 2)
              (make-eventh (make-oddth (make-zeroth))))
(check-expect (generate-power-tree 4)
              (make-eventh (make-eventh (make-oddth (make-zeroth)))))
(check-expect (generate-power-tree 9)
              (make-oddth (make-eventh (make-eventh
               (make-eventh (make-oddth (make-zeroth)))))))
(check-expect (power-tree-exponent (generate-power-tree 10000)) 10000)

; given function in lab
(define (generate-power-tree n)
  (cond [(= 0 n) (make-zeroth)]
        [(odd? n) (make-oddth (generate-power-tree (sub1 n)))]
        [(even? n) (make-eventh (generate-power-tree (/ n 2)))]))

; power-tree-result : Number PowerTree -> Number
; returns the number raised to the given power tree's power

(check-expect (power-tree-result 2 (make-zeroth)) 1) ; 2^0 = 1
(check-expect (power-tree-result 2 (make-oddth (make-zeroth))) 2) ; 2^1 = 2
(check-expect (power-tree-result 2 (make-eventh (make-oddth (make-zeroth)))) 4) ; 2^2 = 4

(define (power-tree-result x pt)
  (cond [(zeroth? pt) 1]
        [(oddth? pt) (* x (power-tree-result x (oddth-sub1 pt)))]
        [(eventh? pt) (sqr (power-tree-result x (eventh-half pt)))]))

;; This function does not need a termination statement since it just follows the template
;; for processing a PowerTree. I understood what needed to happen in the oddth/eventh cases
;; by thinking about inputs and outputs (the table method). For example, 2^5 = 2 * 2^4, and
;; 2^4 = (2^2)^2.

; fast-power : Number NaturalNumber -> Number
; raises the first number to the power of the natural number

(check-expect (fast-power 2 4) 16)
(check-expect (fast-power 5 2) 25)
(check-expect (fast-power 10 6) 1000000)

(define (fast-power x n)
  (power-tree-result x (generate-power-tree n)))

;; This was just combining the two functions by looking at the signatures.
