;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname StructuresUnionsRecursion) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; More on Unions and Recursion (and Structures, too)
;; by Sam Soucie
;----------------------------------------------------------------------------

;; Let's consider a data definition Location, which is one of three Strings

; A Location is one of:
; - "Bloomington"
; - "Chicago"
; - "New York City"

;; The template for processing a Location is a simple conditional
;; since it is an enumeration of primitive types

(define (process-location l)
  (cond [(string=? l "Bloomington") ...]
        [(string=? l "Chicago") ...]
        [(string=? l "New York City") ...]))

;; Now let's make a new data definition for a House
;; which has a Location and a Number (representing price)

; A House is (make-house Location Number)
(define-struct house [place price])

;; Recall the courtesy functions associated with the house structure:
;; - make-house : Location Number -> House (constructor)
;; - house-place : House -> Location (accessor)
;; - house-price : House -> Number (accessor)
;; - house? : Anything -> Boolean (predicate)

;; The template for processing a House is not a conditional, since
;; a House is not an enumeration. Remember that templates that process
;; structures should pull out all data within the structure and process
;; those that are non-primitive.

;; So, by calling house-place, we get the Location stored within the
;; given House, but Location is a data type we defined (non-primitive).
;; Thus, we need to process said Location. Notice that we have already
;; defined the template that processes a location above. So, we
;; call process-location with (house-place h) as the argument.
;; This is what we mean when we refer to "Unions," non-primitive data types
;; that reference other non-primitive data types.

(define (process-house h)
  (... (process-location (house-place h))
       (house-price h)))

;; Now let's define another data type, Neighborhood. A Neighborhood
;; can either be a House, or it can be a new structure that contains
;; a House and a Neighborhood. This is a recursive data type since
;; it references itself within its definition.

; A Neighborhood is one of:
; - House
; - (make-neighborhood House Neighborhood)
(define-struct neighborhood [house others])

;; Let's look at the courtesy functions for the neighborhood structure:
;; - make-neighborhood : House Neighborhood -> Neighborhood (constructor)
;; - neighborhood-house : Neighborhood -> House (accessor)
;; - neighborhood-others : Neighborhood -> Neighborhood (accessor)
;; - neighborhood? : Anything -> Boolean (predicate)

;; It may seem like this definition is circular, but it is not.
;; It isn't because there is a base case for a Neighborhood, namely
;; that it can just be a House. The fact that this works (and makes
;; sense) is clear when we define some examples.

(define n1 (make-house "Bloomington" 100000))
(define n2 (make-neighborhood (make-house "Chicago" 200000) n1))
(define n3 (make-neighborhood (make-house "New York City" 150000) n2))

;; n1 represents just one house in Bloomington that costs $100,000.
;; n1 is clearly an example of a House (we used make-house in it after all!)
;; but it is also an example of a Neighborhood, since Neighborhoods can
;; be just a House.

;; n2 represents a neighborhood of two houses, a $200,000 house in Chicago
;; and n1, which we know is just a $100,000 house in Bloomington.

;; Similarly, n3 represents a neighborhood of three houses, a new one that
;; costs $150,000 in New York City, and the two that are represented by n2.

;; Don't let the name "neighborhood" confuse you, by the data definition
;; it can be any collection of Houses, they do not need to be in the same
;; Location. 

;; It should be clear that we can keep this up to make a Neighborhood
;; of any arbitrarily large size. We just need to keep adding Houses
;; onto the previously defined Neighborhood.

;; Now let's make a template to process a Neighborhood. It is actually
;; no more complicated than making a template for a non-recursive union!

;; Since a Neighborhood can be either a House or a neighborhood structure,
;; we need to check if it is a House first (using house?). If we know it is a
;; house, then we need to process said house (using process-house).

;; Now, for the second cond case where we know it is a neighborhood structure,
;; we need to pull out the data within the structure and process it.
;; Pulling out the two pieces of data, we get a House (using neighborhood-house)
;; and a Neighborhood (using neighborhood-others). Again, we need to process both
;; of these, so we need to call process-house on the House and some function that
;; processes a neighborhood for the Neighborhood. Well, we are literally writing
;; the function that processes a neighborhood right now (namely, process-neighborhood)!
;; Let's do the same thing we've been doing with unions and call said function.
;; So, process-neighborhood calls itself within its definition, just as the data definition
;; for Neighborhood refers to itself!

(define (process-neighborhood n)
  (cond [(house? n) (... (process-house n))]
        [else (... (process-house (neighborhood-house n))
                   (process-neighborhood (neighborhood-others n)))]))

;; Now let's make this concrete. Let's define a function avg-square-footage-total that takes
;; a Neighborhood and returns a Number representing the total average square footage for
;; said Neighborhood. Let's assume that houses in Bloomington have an average square
;; footage of 2,000, Chicago 1,500, and New York City 1,000.

;; First, let's design a function that takes a Location and returns the average square footage
;; for said Location.

; location-avg : Location -> Number
; returns the average square footage for a given Location

(check-expect (location-avg "Bloomington") 2000)
(check-expect (location-avg "Chicago") 1500)
(check-expect (location-avg "New York City") 1000)

;; We can just copy and paste the template and change the name and fill in the dots!

(define (location-avg l)
  (cond [(string=? l "Bloomington") 2000]
        [(string=? l "Chicago") 1500]
        [(string=? l "New York City") 1000]))

;; Easy enough, right? Now we can define a function that takes in a House and
;; returns the average square footage for said House.

; house-avg : House -> Number
; returns the average square footage of the city the House is located in

(check-expect (house-avg (make-house "Chicago" 100000)) 1500)
(check-expect (house-avg (make-house "Bloomington" 300000)) 2000)
(check-expect (house-avg (make-house "New York City" 1000000)) 1000)

;; Once again, let's copy and paste the template, change the names, and fill in the dots!
;; However, this time we have extraneous data (we don't care about the House's price for this
;; problem), so we will remove it.

(define (house-avg h)
  (location-avg (house-place h)))

;; Finally, let's write our complete avg-square-footage-total.

; avg-square-footage-total : Neighborhood -> Number
; computes the total square footage of the Neighborhood based on the averages

;; Let me remind you of n1, n2, and n3, which are previously defined:
#;(define n1 (make-house "Bloomington" 100000))
#;(define n2 (make-neighborhood (make-house "Chicago" 200000) n1))
#;(define n3 (make-neighborhood (make-house "New York City" 150000) n2))

(check-expect (avg-square-footage-total n1) 2000)
; just one House in Bloomington (2000)
(check-expect (avg-square-footage-total n2) 3500)
; a House in Chicago (1500) + the total from n1 (2000)
(check-expect (avg-square-footage-total n3) 4500)
; a House in New York City (1000) + the total from n2 (3500)

;; Copy and paste template, change the names, fill in dots, remove extraneous data

(define (avg-square-footage-total n)
  (cond [(house? n) (house-avg n)]
        [else (+ (house-avg (neighborhood-house n))
                 (avg-square-footage-total (neighborhood-others n)))]))

;; I was able to realize the dots in the else case should be replaced by +
;; because of my tests!

;----------------------------------------------------------------------------

;; I hope that this helps! Feel free to email me at ssoucie@iu.edu if you
;; have any questions about this document (or in general).

