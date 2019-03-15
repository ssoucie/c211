;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname abstraction) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Abstraction

;; As  programmers, we often find ourselves writing functions that are very similar
;; or follow some sort of pattern. We can make our code more concise and adaptable
;; by doing something called abstraction.

;; We have something called The Abstraction Recipe, which is as follows:

;; 1. Design at least 2 similar functions.
;; 2. Identify inessential differences and revise functions to remove them.
;; 3. Identify essential differences and pick input names for each of them.
;; 4. Design the abstraction by replacing differences with input names.
;; 5. Redefine the original functions using the abstraction.

;; Let's consider a simple example. Let's abstract from two functions, one that
;; sums all the numbers in a given list, and one that multiplies all the numbers in
;; a given list.

;; 1. Design at least 2 similar functions.

; sum-list : [ListOf Number] -> Number
; adds up all the numbers in the given list

(check-expect (sum-list empty) 0)
(check-expect (sum-list (list 1 2 3)) 6)
(check-expect (sum-list (list 1 2 3 4 5)) 15)

#;(define (sum-list lst)
  (cond [(empty? lst) 0]
        [else (+ (first lst) (sum-list (rest lst)))]))

; prod-list : [ListOf Number] -> Number
; multiplies all the numbers in the given list

(check-expect (prod-list empty) 1) ; if this were 0, that's all we'd ever get!
(check-expect (prod-list (list 1 2 3)) 6)
(check-expect (prod-list (list 1 2 3 4 5)) 120)

#;(define (prod-list ls)
  (cond [(empty? ls) 1]
        [(cons? ls) (* (first ls) (prod-list (rest ls)))]))

;; See how similar those functions are? Now onto step 2:

;; 2. Identify inessential differences and revise functions to remove them.

;; One inessential difference is that the input is named "lst" in sum-list and
;; "ls" in prod-list, so let's make them both be called "ls."

;; The other inessential difference is that prod-list explicitly asks if the
;; list is cons? while sum-list just uses else. So let's change prod-list to
;; use else.

;; Now, our functions look very similar:

#;(define (sum-list ls)
  (cond [(empty? ls) 0]
        [else (+ (first ls) (sum-list (rest ls)))]))

#;(define (prod-list ls)
  (cond [(empty? ls) 1]
        [else (* (first ls) (prod-list (rest ls)))]))

;; 3. Identify essential differences and pick input names for each of them.

;; What are the essential differences? Well, one is that the base case of sum-list
;; returns 0, while the base case of prod-list returns 1. So, let's call that Number
;; "base."

;; Now, the only other difference is the operation being performed (+ for sum-list
;; and * for prod-list). So, let's call the operation "op."

;; Thus, our abstraction will have two more inputs on top of the list, a Number
;; named "base" and a function with the signature [Number Number -> Number] named
;; "op."

;; Note: We are now passing functions as inputs to other functions, so we need
;; an efficient way to describe the "type" of a function for our abstractions'
;; signatures. We do this by writing the signature of our input function in
;; square brackets, like so: [Number Number -> Number].

;; 4. Design the abstraction by replacing differences with input names.

;; Now, we will actually write the abstraction.
;; Note: you will need to write a new signature and purpose statement
;; for the abstraction, but it's actually okay to write those after the function itself!

;; Let's call the abstraction "reduce-lon" since it reduces a [ListOf Number] to a
;; single Number.

; reduce-lon : [Number Number -> Number] Number [ListOf Number] -> Number
; reduces the given list to a single number using a given base and operation

(define (reduce-lon op base ls)
  (cond [(empty? ls) base]
        [else (op (first ls) (reduce-lon op base (rest ls)))]))

;; Notice that when we recur on the rest of the list, we need to pass the
;; op and base arguments to the function! (Be sure of the order!!)

;; Now that we have our abstraction, time for the last step:

;; 5. Redefine the original functions using the abstraction.

(define (sum-list ls)
  (reduce-lon + 0 ls))

(define (prod-list ls)
  (reduce-lon * 1 ls))

;; Note that our tests still pass, because we did not change the signature or
;; purpose of our original functions! This means that we test our abstraction
;; in this redefining step, and we do not actually need to explicitly test the
;; abstraction itself!

;; Abstraction Using Helper Functions

;; Say that we had two functions, one that appended "!" to every String 
;; in a [ListOf String] and made them all uppercase, and one that converted
;; every String in a [ListOf String] to a Number representing its length plus one.

; excitify : [ListOf String] -> [ListOf String]
; appends "!" to every string in a given list and makes them all uppercase

(check-expect (excitify empty) empty)
(check-expect (excitify (list "hi")) (list "HI!"))
(check-expect (excitify (list "hey" "there")) (list "HEY!" "THERE!"))

#;(define (excitify ls)
  (cond [(empty? ls) empty]
        [else (cons (string-upcase (string-append (first ls) "!"))
                    (excitify (rest ls)))]))

; str-lengths : [ListOf String] -> [ListOf Number]
; returns a list of numbers corresponding to each string's length
; plus one in the given list

(check-expect (str-lengths empty) empty)
(check-expect (str-lengths (list "hi")) (list 3))
(check-expect (str-lengths (list "hey" "there")) (list 4 6))

#;(define (str-lengths ls)
  (cond [(empty? ls) empty]
        [else (cons (+ (string-length (first ls)) 1)
                    (str-lengths (rest ls)))]))

;; Now to abstract:

;; 1. Design at least 2 similar functions.

;; Done!

;; 2. Identify inessential differences and revise functions to remove them.

;; There are actually no inessential differences between the functions!

;; Note: You will realize that this will often be the case when doing simple
;; abstractions because you will get into the habit of naming inputs the same
;; (like calling a List input "ls" and a Number input "n") and following the
;; exact same template syntax (like always using else for the last case).

;; 3. Identify essential differences and pick input names for each of them.

;; Well, one essential difference is that excitify calls string-append on the
;; first element, while str-lengths calls string-length on the first element.
;; Another difference is that excitify calls string-upcase on the result of
;; (string-append (first ls) "!"), while str-length calls + onto the
;; result of (string-length (first ls)).

;; Here's my idea: let's have two function inputs, one called "inner" and
;; another called "outer," like so:

;; 4. Design the abstraction by replacing differences with input names.

(define (map-str outer inner ls)
  (cond [(empty? ls) empty]
        [else (cons (outer (inner (first ls)))
                    (map-str outer inner (rest ls)))]))

;; Now an obvious question: what's the signature of map-str? Well, we know
;; that it takes two functions and a [ListOf String] and produces a list of
;; *something*:

; map-str : [?] [?] [ListOf String] -> [ListOf ?]

;; Notice that map-str is abstracting from functions that return different
;; types. This means that we need to variables for the some of the types
;; in where the question marks are.

;; First, let's fill in the return type with the variable "Y", like so:

; map-str : [?] [?] [ListOf String] -> [ListOf Y]

;; Now, let's think about the signatures of the input functions.

;; The inner functions we know needs to take the first element of the list,
;; which is a String. The type that it returns is the type of each element in
;; the returned list, which we named "Y":

; map-str : [?] [String -> Y] [ListOf String] -> [ListOf Y]

;; Lastly, the outer function takes the result of the inner function
;; of type Y and then produces another Y from that:

; map-str : [Y -> Y] [String -> Y] [ListOf String] -> [ListOf Y]

;; 5. Redefine the original functions using the abstraction.

#;(define (excitify ls)
  (map-str string-upcase string-append))

;; Wait a minute...

;; There is no "!" to append within excitify! In other words, our inner function
;; string-append does not match our abstraction's inner function signature
;; ([String -> Y]). We also have a similar problem
;; with the outer function in str-lengths:

#;(define (str-lengths ls)
  (map-str + string-length))

;; Where's the 1 that we need to add to the string-length result?
;; In other words, + does not match our abstraction's outer function signature
;; ([Y -> Y]).

;; This is where we can use helper functions! Let's just write two helper functions
;; in order to transform string-append and + into specific instances that match
;; our required signature!

; append-! : String -> String
; appends "!" to a given String

(check-expect (append-! "hi") "hi!")
(check-expect (append-! "yo") "yo!")

(define (append-! str)
  (string-append str "!"))

; add-one : Number -> Number
; adds one to a given number

(check-expect (add-one 0) 1)
(check-expect (add-one 119) 120)

(define (add-one n)
  (+ n 1))

;; Now we can redefine our original functions using our abstraction and
;; helper functions!

#;(define (excitify ls)
  (map-str string-upcase append-! ls))

#;(define (str-lengths ls)
  (map-str add-one string-length ls))

;; And our original tests pass!

;; However, all is not (totally) well. While this is a valid abstraction
;; over the two functions, it is kind of silly. Let's see how silly it
;; is by writing the purpose statement:

; map-str : [Y -> Y] [String -> Y] [ListOf String] -> [ListOf Y]
; applies a given function to the result of another given function to
; each element of a list of strings

;; This is quite wordy, and not very useful. In theory, we want our abstractions
;; to be applicable to many different types of problems, but this one really isn't.

;; However, this abstraction map-str would be super useful if it applied a given
;; function to every element of a list of strings, as that's something that we
;; want to do pretty often!

;; So let's define an abstraction better-map-str that does just that!

;; It's signature/PS and definition will be as follows:

; better-map-str : [String -> Y] [ListOf String] -> [ListOf Y]
; applies the given function to every string in a given list
(define (better-map-str f ls)
  (cond [(empty? ls) empty]
        [else (cons (f (first ls))
                    (better-map-str f (rest ls)))]))

;; We can quite easily translate our original functions to
;; this abstraction with more complex helper functions:

; excite : String -> String
; appends "!" to the given string and makes it uppercase

(check-expect (excite "hi") "HI!")
(check-expect (excite "yo") "YO!")

(define (excite str)
  (string-upcase (string-append str "!")))

; add-one-length : String -> Number
; adds one to the length of the given string

(check-expect (add-one-length "hey") 4)
(check-expect (add-one-length "abcde") 6)

(define (add-one-length str)
  (+ 1 (string-length str)))

;; Now just to redefine excitify and str-lengths using our better-map-str
;; abstraction:

#;(define (excitify ls)
  (better-map-str excite ls))

#;(define (str-lengths ls)
  (better-map-str add-one-length ls))

;; Our tests still pass, and now our abstraction is way better.

;; In fact, our abstraction is so much better that it is actually
;; built into the language, it's called map!

;; The signature for map is:

; map : [X -> Y] [ListOf X] -> [ListOf Y]

;; which is just a more generic version of our better-map-str abstraction.
;; Notice, however, that no where in our better-map-str definition do we
;; do anything that requires our list to only contain Strings.

(check-expect (better-map-str add-one (list 1 2 3))
              (map add-one (list 1 2 3)))
(check-expect (better-map-str excite (list "hey" "there"))
              (map excite (list "hey" "there")))

;; These tests passing is my illustration that better-map-str is just map.

;; Abstraction Using Local Helper Functions

;; Let's say that we wanted to abstract from two functions, one that
;; takes a [ListOf Posn] and produces an Image with a blue star at
;; each position, and one that takes a String, a [ListOf String], and
;; another String, and produces one long String with each String in the
;; list in the middle of the first and last given Strings, with spaces in
;; between (this is silly and confusing on purpose, it is clearer with
;; the actual examples).

(require 2htdp/image)
(define background (empty-scene 200 200))
(define sprite (star 12 "solid" "blue"))

; draw-stars : [ListOf Posn] -> Image
; draws stars at every position in the given list

(check-expect (draw-stars empty) background)
(check-expect (draw-stars (list (make-posn 5 5) (make-posn 100 120)))
              (place-image sprite 5 5
                           (place-image sprite 100 120
                                        background)))

#;(define (draw-stars ls)
  (cond [(empty? ls) background]
        [else (place-image sprite
                           (posn-x (first ls))
                           (posn-y (first ls))
                           (draw-stars (rest ls)))]))

; silly-string : String [ListOf String] String -> String
; places each string in the list in the middle of the first and
; last strings, producing one long, silly string

(check-expect (silly-string "yo" empty "bud") "")
(check-expect (silly-string "A " (list "one" "two") " and ")
              "A one and A two and ")

#;(define (silly-string s1 ls s2)
  (cond [(empty? ls) ""]
        [else (string-append s1 (first ls) s2 (silly-string s1 (rest ls) s2))]))

;; There's no way we can abstract from these functions, right? They have
;; a different number of inputs, different types in the input and output,
;; way different base cases, etc...

;; Well what if I told you that we have already written the abstraction for
;; these two functions in this very file?

;; :O

;; Let's take a look at reduce-lon from a few hundred lines ago:

; reduce-lon : [Number Number -> Number] Number [ListOf Number] -> Number
; reduces the given list to a single number using a given base and operation

#;(define (reduce-lon op base ls)
    (cond [(empty? ls) base]
          [else (op (first ls) (reduce-lon op base (rest ls)))]))

;; Notice that reduce-lon does nothing that is specific to Numbers, just
;; as better-map-str did nothing that was specific to Strings. So, let's
;; make its name and signature as generic as possible:

; reduce : [X Y -> Y] Y [ListOf X] -> Y
; reduces the given list to a single thing using a given base and operation

(define (reduce op base ls)
  (cond [(empty? ls) base]
        [else (op (first ls) (reduce op base (rest ls)))]))

;; Let's prove that reduce does the same thing as reduce-lon:

(check-expect (reduce-lon + 0 (list 1 2 3)) (reduce + 0 (list 1 2 3)))
(check-expect (reduce-lon * 1 (list 1 2 3)) (reduce * 1 (list 1 2 3)))

;; And that it can do cool things with other types:

(check-expect (reduce string-append "" (list "hi " "there " "friend!"))
              "hi there friend!")

;; Okay, fine, but how can we use reduce to abstract from draw-stars and
;; silly-string?

;; Remember that most of the work/thought when abstraction should be
;; about the helper functions that we write.

;; Let's focus on draw-stars, which seems to be the less complicated function
;; to abstract from.

;; Let's write the header and reduce first:

#;(define (draw-stars ls)
    (reduce ... ... ...))

;; Now let's think about the signature for reduce:

; reduce : [X Y -> Y] Y [ListOf X] -> Y

;; Knowing this, we can replace all the dots from above with their abstract types:

#;(define (draw-stars ls)
    (reduce [X Y -> Y] Y [ListOf X]))

;; Now, let's think about what X and Y need to be. Take a look at draw-stars's
;; signature:

; draw-stars : [ListOf Posn] -> Image

;; Since the input, ls, has to be a [ListOf Posn], we know that X is Posn!

#;(define (draw-stars ls)
    (reduce [Posn Y -> Y] Y [ListOf Posn]))

;; Since draw-stars returns an image, we know that Y is Image!

#;(define (draw-stars ls)
    (reduce [Posn Image -> Image] Image [ListOf Posn]))

;; Great! Now we can start to replace these types with the correct inputs to
;; reduce for draw-stars!

;; First, we know that the third input, [ListOf Posn], needs to be ls:

#;(define (draw-stars ls)
    (reduce [Posn Image -> Image] Image ls))

;; Next, the base. The base for draw-stars is the constant background, because
;; the base is what we want to return if the list input is empty:

#;(define (draw-stars ls)
    (reduce [Posn Image -> Image] background ls))

;; Now we just need to know what function with the signature [Posn Image -> Image]
;; we need to produce the correct output!

;; We can write this function as a helper!

; place-star : Posn Image -> Image
; places a star at the given position onto the given image

(check-expect (place-star (make-posn 2 1) background)
              (place-image sprite 2 1 background))
(check-expect (place-star (make-posn 2 1) (circle 12 "solid" "red"))
              (place-image sprite 2 1 (circle 12 "solid" "red")))

;; Notice in the second example that the second argument to place-star can
;; be any Image, not just background. This can be confusing to some people,
;; but just trust the signature of reduce and realize that we have already
;; handled the base case by having background be the second argument!

(define (place-star p i)
  (place-image sprite
               (posn-x p)
               (posn-y p)
               i))

;; Now, let's redefine draw-stars in terms of reduce:

#;(define (draw-stars ls)
    (reduce place-star background ls))

;; That wasn't too hard! But now let's do silly-string...

;; We can see quite clearly that "" is our base:

#;(define (silly-string s1 ls s2)
    (reduce ... "" ls))

;; But what [X Y -> Y] function goes in those dots?

;; Let's figure out what X and Y are first. Y needs to be a String,
;; since that is what silly-string returns. X also needs to be a String,
;; since that is what we have a list of!

;; Note: X and Y can totally be the same type. That is just a special case
;; when writing functions with abstractions.

;; So we need a function that takes two Strings and returns a String.

;; For this harder example, we actually need to understand what reduce's
;; first argument actually refers to.

#;(define (reduce op base ls)
    (cond [(empty? ls) base]
        [else (op (first ls) (reduce op base (rest ls)))]))

;; Look at what op takes as its arguments: (first ls) and the recursive call.
;; This is what we're looking for: the first argument to reduce is a function
;; that is meant to return the final result we want by combining the first
;; element with the recursive call on the rest!

;; Cool, so our String String -> String function will be taking in the first
;; element of the list as its first argument and the result of recurring on
;; the rest as its second argument!

; sillyify : String String -> String
; combines the first and recursive call together for silly-string

; these tests assume s1 = "A " and s2 = " and "
#;(check-expect (sillyify "one" "") "A one and ")
#;(check-expect (sillyify "one" " A two and ") "A one and A two and ")

#;(define (sillyify f r) ; f = first, r = recursive call
    (string-append s1 f s2 r))

;; Wait, that produces an error! s1 and s2 are out of scope, as they are inputs
;; to the silly-string function. We can't reference them in our globally defined
;; sillyify function. How can I access the s1 and s2 within my helper function
;; without adding them as inputs?

;; This is a great question that actually has to be solved using a completely
;; new idea: local definitions.

;; When we write (define x 10), we are *globally* defining x to have the value
;; 10. Thus, if we write any function and write x inside of it somewhere,
;; the function will treat that as if we just wrote 10 at that exact place.

;; Similarly, when we write (define (f x) x), we are *globally* defining the
;; function f and can use it anywhere else in our file.

;; However, we can also *locally* define constants and functions using this
;; syntax:

#;(define (global-function x)
    (local [(define const value)
            (define (f x) ...)
            ...]
      ...))

;; where we just write (local [] ...) right after the header and place our
;; local definitions inside the square brackets and the body of our global
;; function in the place of the dots.

;; The power of this is that we can reference any globally defined constants
;; and functions within our local definitions, *including* the arguments
;; to the global function that we are within!

;; So, we just need to write our sillyify function within a local so that we
;; can refer to the s1 and s2 inputs within silly-string.

#;(define (silly-string s1 ls s2)
    (local [; sillyify : String String -> String
            ; combines the first and recursive call together for silly-string
            ; if s1 = "A " and s2 = " and ":
            ; given : "one" ""
            ; expect : "A one and "
            ; given : "one" "A two and "
            ; expect : "A one and A two and "
            (define (sillyify f r) ; f : first, r : recursive call
              (string-append s1 f s2 r))]
      (reduce sillyify "" ls)))

;; Note: we cannot write check-expects within a local, but we still need to
;; follow the design recipe, so we revert to the old school given : X
;; expect : Y way of writing examples from the beginning of the semester.

;; Now we have successfully abstracted from draw-stars and silly-string
;; using reduce! Just like better-map-str is so useful it is built in
;; (as map), reduce is so useful it is also built in (with the less expressive
;; name foldr).

(check-expect (reduce place-star background (list (make-posn 10 10) (make-posn 20 20)))
              (foldr place-star background (list (make-posn 10 10) (make-posn 20 20))))
(check-expect (reduce + 0 (list 1 2 3))
              (foldr + 0 (list 1 2 3)))

;; Let's look at how reduce/foldr follow the template for processing a list.

#;(define (process-list ls)
    (cond [(empty? ls) ...]
          [else (... (first ls) (process-list (rest ls)))]))

#;(define (reduce op base ls)
    (cond [(empty? ls) base]
        [else (op (first ls) (reduce op base (rest ls)))]))

;; See how closely reduce/foldr follows the template? It literally just replaces the
;; first set of dots with base (what to return in the empty case) and the second set
;; of dots with op (how to combine the first and recursive call).

;; Abstraction Using Lambdas

;; We could redefine our old abstractions that used global helper functions
;; to use local ones, which is a great idea since it's not particularly helpful
;; to have functions like add-one-length and excite laying around.

#;(define (excitify ls)
    (local [; excite : String -> String
            ; appends "!" to the given string and makes it uppercase
            ; given : "hi", expect : "HI!"
            ; given : "yo", expect : "YO!"
            (define (excite str)
              (string-upcase (string-append str "!")))]
      (better-map-str excite ls)))

#;(define (str-lengths ls)
    (local [; add-one-length : String -> Number
            ; adds one to the length of the given string
            ; given : "hey", expect : 4
            ; given : "abcde", expect : 6
            (define (add-one-length str)
              (+ 1 (string-length str)))]
      (better-map-str add-one-length ls)))

;; This is much cleaner code than our original global helper method. It
;; keeps all of the helpers contained within the function that actually uses
;; them.

;; However, note how silly and simple these functions are. excite just
;; appends two Strings and makes the result uppercase, while add-one-length
;; just adds one to the length of a String. Their definitions fit on one
;; line. Why even give them a name? We actually don't have to...

;; We can write functions without giving them a name using the following syntax:

#;(lambda (arg1 ... arg-n) body)

;; Note: if you are using DrRacket (you should be!), you can type Command+\ on Mac
;; or CTRL+\ on Windows/Linux to insert a Greek lambda(λ) which works the same as
;; the lambda keyword, but is shorter and cooler.

;; So, excite would translate to
#; (λ (str) (string-upcase (string-append str "!")))

;; and add-one-length would translate to
#; (λ (str) (+ 1 (string-length str)))

;; Then, we could avoid the local definitions (and the requirement for following
;; the Design Recipe for such a simple function) by defining excitify and str-lengths
;; as follows (I'm also replacing better-map-str with map since we've seen that they're
;; the same function):

(define (excitify ls)
  (map (λ (str) (string-upcase (string-append str "!"))) ls))

(define (str-lengths ls)
  (map (λ (str) (+ 1 (string-length str))) ls))

;; Now the code is cleaner and much more concise (and you avoided explicitly designing
;; boring functions)!

;; We can define draw-stars and silly-string using lambdas, too (I'm also replacing
;; reduce with foldr since we've seen that they're the same functions):

(define (draw-stars ls)
  (foldr (λ (f r) (place-image sprite
                               (posn-x f)
                               (posn-y f)
                               r))
         background ls))

(define (silly-string s1 ls s2)
  (foldr (λ (f r) (string-append s1 f s2 r)) "" ls))

;; However, you should be careful. It's a rule of thumb to only use lambda if the
;; function is quite simple. Starting out, using lambda for draw-stars or even
;; silly-string may be confusing, in which case local (with the Design Recipe)
;; is your best bet!

;; Extra Fun

;; map can actually be written using foldr and lambda. Can you write it this way?
;; If so, email ssoucie@iu.edu with your solution and win a virtual high five from me!