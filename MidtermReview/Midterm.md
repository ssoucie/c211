# Midterm Review

This addition to HILTSWALTDR is meant to give a rundown of what you need to know
for the upcoming midterm exam. It was my goal to write it so that it assumes no
programming experience. I would suggest also trying to make a review session and
especially the mock midterm, as practice is the best way to study for CS exams.

## Syntax 

One of the biggest hills that people learning the Beginning Student Language have to get over
is its syntax (the order and choice of symbols that are typed in to create programs). The main
villain in BSL's syntax is prefix notation. In most other languages (including the most popular
ones) arithmetic and logical functions are expressed with infix notation, which is how they are
expressed in standard English writing.

Examples of infix notation: 3 + 3, true or false, (3 * 2) - 1
Above examples translated to prefix notation: (+ 3 3), (or true false), (- (* 3 2) 1)

The reason for this is that all functions use the same syntax, namely:

```racket
;(function-name argument1 argument2 ... argumentn)
```

This is very close to how we write functions in mathematics:

function-name(argument1, argument2, ..., argumentn)

We just take the name of the function, drop it in between the open paren and the first argument,
and remove all the commas between the arguments.

## Data Types 


> A "data type" is a name for a collection of data (read, stuff)
> that share certain characteristics.                       

It's actually sort of hard to give "data type" a good definition, but giving examples is easy.

Examples of data types:
* Strings
* Numbers
* Booleans (true or false)

Types like the ones listed above are called "primitive" data types. A primitive is so fundamental
to programming in general that it is defined by the people that wrote the programming language.

However, programming becomes truly interesting when we define our own types of data. We can
represent anything with our own defined types, the only limit is our imagination (or knowledge).

Examples of our own data types (called "data definitions"):

```racket
; A Color is one of:
; - "black"
; - "brown"

; A Size is one of:
; - "large"
; - "medium"
; - "small"
```

We can reference previously defined types inside of others:

```racket
; A Dog is a (make-dog Color Size)
```

Types can get pretty complicated:

```racket
; A BinaryTree is one of:
; - (make-none)
; - (make-bt BinaryTree Number BinaryTree)
```

If these look confusing, don't worry, we'll get to the ins and outs of these definitions later.

## Functions (at a high level)

Functions are the bread and butter of the Beginning Student Language, as BSL is a functional programming
language. The programs that you write in this class are going to be collections of functions that work
together to accomplish some task. But what are functions, anyway?

A function is a box that takes in a specified number/type of arguments and returns exactly one output.
Functions can be combined (also known as composed) with others to produce different outputs.

We have to be careful, though. As mentioned above, a function takes in a specified number and type of
arguments. If we do not give a function the correct number of arguments, or we give it the wrong type,
the function (and code) will break.

> We call the specification of a function's number, order, and         
> type of arguments, along with the type of the output its "signature".


## Defining Stuff 

There are two kinds of things that we use the define keyword to name for future use:
constants and functions.

> A "constant" is an instance of a data type that we give a name.

We cannot change a constant once it has been named, that's why we call it a constant!

The syntax for defining a constant is simple: (define constant-name value)

Here are some examples of constants:

Primitive constants:
```racket
(define x 10)
(define my-fave-string "Hello world!")
(define bool true)
```
Non-primitive constants:
```racket
(define my-dogs-size "small") ; instance of the Size type
(define my-dogs-color "black") ; instance of the Color type
```

You can name any instance of any data type in this way.

Functions are defined using this syntax: (define (function-name arg1 arg2 ... arg-n) body)

Here are some example function definitions:

```racket
(define (sum-add3 x y)
  (+ 3 x y))

(define (small? s)
  (cond [(string=? s "small") true]
        [else false]))

(define (say-what-up str)
  (string-append "What up, " str))
```

Calling a function is done in this way: (function-name input1 input2 ... input-n), where the
inputs are instances of the argument data types.

Examples of calling functions:

```racket
(sum-add3 1 2) ; returns 6
(small? my-dogs-size) ; returns true
(say-what-up "John") ; returns "What up, John"
```

You may be wondering where this "signature" stuff comes in. In this language, we are not
required to define a function's signature. That means we must specify the signature in a comment
like so:

```racket
; sum-add3 : Number Number -> Number
; small? : Size -> Boolean
; say-what-up : String -> String
```

In general, we give signatures like so:
```racket
; function-name : ArgumentOneType ArgumentTwoType ... ArgumentNType -> ReturnType
```

Without specifying this signature, we are almost certainly causing trouble for ourselves later on.
As functions get more complex with composition and the number of arguments, it is really easy to
forget the order/number/type of the arguments, and any of those mistakes will break your code.

## The Design Recipe

At this point we are ready to formally define The Design Recipe, which is the most important
subject we will learn in this class. TDR will be used any time that you design a function.

The steps of The Design Recipe are:
1. Define your data.
2. Write the signature, purpose statement, and header.
3. Write examples.
4. Write a template based on the data definiton.
5. Write the function definition.
6. Test your function.

We have already seen step one and part of step two (signatures).

The best way to fully understand the steps and use of TDR is through an example.

Let's say that we want to design a function that takes a day of the week and returns
the next day of the week.

1. Define your data.

```racket
; A DayOfWeek is one of:
; - "Sunday"
; - "Monday"
; - "Tuesday"
; - "Wednesday"
; - "Thursday"
; - "Friday"
; - "Saturday"
```

2. Write the signature, purpose statement, and header.

```racket
; next-day : DayOfWeek -> DayOfWeek
; Returns the day that comes after the given one.
; (define (next-day d) ...)
```

3. Write examples.

```racket
; Given: (next-day "Sunday")   Expect: "Monday"
; Given: (next-day "Thursday") Expect: "Friday"
; Given: (next-day "Saturday") Expect: "Sunday"
```

4. Write a template based on the data definition.

This is the most important step for getting the correct solution. If you do not follow
the correct template, you almost certainly will NOT get the right answer!

Since we know that a DayOfWeek can be one of seven Strings (from the data definition),
we know that we need to check which DayOfWeek is passed as the argument to the function.
We do this using the function cond, which works like this:

(cond [<question1> <answer1>]  
      [<question2> <answer2>]  
      [<question3> <answer3>]  
               ...  
      [<question-n> <answer-n>]  
      [else <alternative>]) *note*: this line is optional

Each expression wrapped in square brackets is evaluated from top to bottom until one of
the <question>s is true, in which case the <answer> within that expression is returned.
So, each <question> needs to be something that returns a boolean.

If each <question> is false, two things could happen. The first is that your code just
breaks. If all <question>s are false, nothing can be returned, but something has to be
returned, so an error is thrown. The second thing that could happen only happens if you
have the optional else expression, which is evauluated only if each prior <question> 
was false.

For the template that processes a DayOfWeek, we need to check which String the DayOfWeek
is, and for that we will use string=?:

```racket
(define (process-dow d)
  (cond [(string=? d "Sunday") ...]
        [(string=? d "Monday") ...]
        [(string=? d "Tuesday") ...]
        [(string=? d "Wednesday") ...]
        [(string=? d "Thursday") ...]
        [(string=? d "Friday") ...]
        [(string=? d "Saturday") ...]))
 ```

We put ... in the <answer> expressions because this is just a template. Templates should be
so general that we can use them for any function that takes a DayOfWeek as an input.

5. Write the function definition.

Now that we have the template, we can write our function definition. We do this by
copying the template, changing the name, and filling in the dots!

```racket
(define (next-day d)
  (cond [(string=? d "Sunday") "Monday"]
        [(string=? d "Monday") "Tuesday"]
        [(string=? d "Tuesday") "Wednesday"]
        [(string=? d "Wednesday") "Thursday"]
        [(string=? d "Thursday") "Friday"]
        [(string=? d "Friday") "Saturday"]
        [(string=? d "Saturday") "Sunday"]))
```

6. Test your function.

We test our functions using check-expect, a built in testing function in BSL.

The syntax of check-expect is as follows:
(check-expect (function-we-are-testing <inputs>) <expected output>)

```racket
(check-expect (next-day "Sunday") "Monday")
(check-expect (next-day "Thursday") "Friday")
(check-expect (next-day "Saturday") "Sunday")
```

Notice that our tests were obtained by basically just translating examples (step 3)
into code. This is why it is okay to just write check-expects before writing the template
or definition, and not explicitly write out examples.

## Structures

A structure is a way for us to combine multiple pieces of data into one bigger piece of data.
Creating a structure also creates functions automatically that we need to work with the structure,
called courtesy functions.

The syntax for creating a structure is as follows:
(define-struct struct-name [<field-name1> <field-name2> ... <field-name-n>])

The number of courtesy functions defined by this structure is n+2, where n is the number of fields
defined in the structure. This is because each field needs to be able to be accessed (using a function),
which creates n functions, and the two extra couresy functions are the constructor (how we create an
instance) and the predicate (how we check if something is that structure).

Let's take a look at a data definition that was written previously:
```racket
; A Dog is a (make-dog Color Size)
```

Clearly, we need to use define-struct to make this data definition BSL code:

```racket
(define-struct dog [col siz])
```

Note: I named the fields "col" and "siz" in order to show that field names can be (and often are)
different from their types, which is what "Color" and "Size" are in the data definition.

This dog structure created 4 courtesy functions, since there are two fields within it.

```racket
; make-dog : Color Size -> Dog (constructor)
; dog-col : Dog -> Color (accessor/selector)
; dog-siz : Dog -> Size (accessor/selector)
; dog? : Anything -> Boolean (predicate)
```

In order to make our example more interesting, allow me to create the following data definitions:

```racket
; A Cat is a (make-cat Color String)

(define-struct cat [color name])

; A Pet is one of:
; - Cat
; - Dog
```

Now let's create a function that takes a Pet and outputs "My <Size> dog is <Color>." if the given
Pet is a Dog, and "My <Color> cat is named <String>." if the given Pet is a Cat.

The data is already defined, so let's write a signature, purpose statement, and header.

```racket
; pet-to-string : Pet -> String
; Returns a string representing the given Pet.
; (define (pet-to-string p) ...)
```

Now, let's write some examples/tests.

```racket
(check-expect (pet-to-string (make-dog "black" "small")) "My small dog is black.")
(check-expect (pet-to-string (make-cat "brown" "Tabby")) "My brown cat is named Tabby.")
```

Now for the template.

Clearly we need a cond since the data definition for Pet says it can be "one of" two things:

```racket
(define (process-pet p)
    (cond []
          []))
```

But how do we check if the given pet is a Cat or a Dog? We use the predicate courtesy function!

```racket
(define (process-pet p)
    (cond [(cat? p) ...]
          [(dog? p) ...]))
```

We're almost there, but not quite. The overall goal of a template is to take out all pieces of
data within the input and process each one of those!

So, we need to access each field within the Pet, using the courtesy functions for Dogs and Cats:

```racket
(define (process-pet p)
    (cond [(cat? p) (... (cat-color p)
                         (cat-name p))]
          [(dog? p) (... (dog-col p)
                         (dog-siz p))]))
```

Note: we wrap the accessed fields with (...) to achieve the same goal as the ... in the template
for processing a DayOfWeek. We don't know what we are going to do with these data, so we wrap them
with the ... placeholder.

Now we are almost there. The problem is that (cat-color p), (dog-col p), and (dog-siz p) are
all return non-primitive data types, which means we must process them!

```racket
(define (process-pet p)
    (cond [(cat? p) (... (process-color (cat-color p))
                         (cat-name p))] ; (cat-name p) does not need to be processed,
                                        ; since it returns a primitive String
          [(dog? p) (... (process-color (dog-col p))
                         (process-size (dog-siz p)))]))
```

Since we used two functions that we have not yet defined (process-color and process-size),
we better define them (using their data definitions above).

```racket
(define (process-color c)
  (cond [(string=? c "brown") ...]
        [(string=? c "black") ...]))

(define (process-size s)
  (cond [(string=? s "small") ...]
        [(string=? s "medium") ...]
        [(string=? s "large") ...]))
```

Now for the function definition.

```racket
(define (pet-to-string p)
    (cond [(cat? p) (string-append "My " (cat-color p)
                                   " cat is named "
                                   (cat-name p) ".")]
          [(dog? p) (string-append "My " (dog-siz p)
                                   " dog is " (dog-col p) ".")]))
```

Note: I did not use any functions that correspond to the process-color and process-size functions
within the template. This is because Colors and Sizes are just enumerations of Strings, and
the pet-to-string functions just wants the Strings within the structures, so helper functions
corresponding to process-size and process-color would be quite arbitrary for this function.
However, you still need process-color and process-size within the template, because you may
want to write a function that does something more complicated based on the size/color of your Pet!

## Recursion

Let's take a look at a data type that was mentioned previously that seemed pretty complicated:

```racket
; A BinaryTree is one of:
; - (make-none)
; - (make-bt BinaryTree Number BinaryTree)
```

This seems rather circular. A BinaryTree is defined in terms of the data type BinaryTree, which
is what we're defining. However, it is not circular, it is a perfectly acceptable recursive data
type.


> A "recursive data type" is a data type that refers to itself in its definition.

Because we have that (make-none) in the definition, the definition is not circular.
Let's see this by defining some constants.

First we need to define the none and bt structures:

```racket
(define-struct none []) ; since the constructor make-none takes no arguments, we know that the
                        ; none structure has no fields
(define-struct bt [left data right])

(define empty-bt (make-none))
(define bt1 (make-bt empty-bt 5 empty-bt))
(define bt2 (make-bt bt1 6 empty-bt))
(define bt3 (make-bt bt2 9 bt1))
```

We can keep defining instances of BinaryTrees to make them as large as we want.

Let's design a function that sums all the numbers in a given BinaryTree.

Our data is already defined, so let's write a signature, purpose statement, and header.

```racket
; sum-bt : BinaryTree -> Number
; sums all the numbers in a given BinaryTree.
;(define (sum-bt bt) ...)
```

Now for tests:
```racket
(check-expect (sum-bt empty-bt) 0) ; if there's no numbers, the sum is 0
(check-expect (sum-bt bt1) 5) ; 0 + 5 + 0 = 5
(check-expect (sum-bt bt2) 11) ; 5 + 6 + 0 = 11
(check-expect (sum-bt bt3) 25) ; 11 + 9 + 5 = 25
```

Template time:
```racket
(define (process-bt bt)
  (cond [(none? bt) ...]
        [(bt? bt) (... (bt-left bt)
                       (bt-data bt)
                       (bt-right bt))]))
```

Almost there. Remember that we need to process all non-primitive data. (bt-left bt) and
(bt-right bt) are not primitive, namely they are BinaryTrees. Thus, we need to process
those parts, using process-bt.

```racket
(define (process-bt bt)
  (cond [(none? bt) ...]
        [(bt? bt) (... (process-bt (bt-left bt))
                       (bt-data bt)
                       (process-bt (bt-right bt)))]))
```

Realize that we are calling process-bt within the definition of process-bt. This is recursion,
and we have to do it because BinaryTree is a recursive data type.

Our recursive calls to process-bt happen on bt-left and bt-right, which makes sense if we look
at the data definition for BinaryTree.

IMPORTANT NOTE: whenever we call a function recursively, it must be on a smaller piece of data
than the input. Thus, if we had (process-bt bt) within the process-bt function, the template
would be (extremely) wrong!!

Now that we have the template, we can copy it and write our definition based on our tests.

Note: when you change the name of the template to the name of the function you are
defining, make sure to change all recursive calls to the function name as well.

```racket
(define (sum-bt bt)
  (cond [(none? bt) 0]
        [(bt? bt) (+ (sum-bt (bt-left bt))
                     (bt-data bt)
                     (sum-bt (bt-right bt)))]))
```

## Lists

A list is a simple way for us to hold an arbitrarily large amount of data in order to process
it in a simple, consistent way. Lists are defined recursively, like so:

```racket
; A [ListOf X] is one of:
; - empty
; - (cons X [ListOf X])
```
where X is any data type.

empty is a built in constant that refers to the empty list, sometimes represented as '().
cons is a built in function that takes an X and a [ListOf X] and produces a new [ListOf X].

We can access the first element in a list by using the first function, and access the list
minus the first element by using the rest function.

The template for processing a [ListOf X] is as follows:

```racket
(define (process-list l)
  (cond [(empty? l) ...]
        [(cons? l) (... (process-x (first l)) ; we need the process-x because the list can be made of non-primitives
                        (process-list (rest l)))])) ; because a list is a recursive data type, we must recur on the rest
```

Let's say that we wanted to design a function that takes a ListOfNumbers and returns the result of
multiplying each number in the list.

We need to define the data since we only have the definition for a [ListOf X].

```racket
; A ListOfNumbers is one of:
; - empty
; - (cons Number ListOfNumbers)
```

Here are some examples:
```racket
(define ls1 (cons 1 empty))
(define ls2 (cons 2 ls1))
(define ls3 (cons 3 ls2))
```

Signature, purpose statement, header

```racket
; prod-list : ListOfNumbers -> Number
; returns the product of all the numbers in the given list
; (define (prod-list l) ...)
```

Examples/Tests

```racket
(check-expect (prod-list empty) 1) ; this has to be 1, if it were 0 the function would always produce 0!
(check-expect (prod-list ls1) 1)
(check-expect (prod-list ls2) 2)
(check-expect (prod-list ls3) 6)
```

Template

```racket
(define (process-lon l)
  (cond [(empty? l) ...]
        [(cons? l) (... (first l) ; we do not need to process the first element because it is just a Number
                        (process-lon (rest l)))]))
```

Definition

```racket
(define (prod-list l)
  (cond [(empty? l) 1]
        [(cons? l) (* (first l)
                      (prod-list (rest l)))]))
```

## big-bang
We will need these two libraries for this section:
```racket
(require 2htdp/image)
(require 2htdp/universe)
```

big-bang is a function that allows us to create animations and games quite easily in BSL. The
syntax is as follows:

(big-bang initial-world  
  [to-draw draw-function]  
  [on-tick tick-function]  
  [on-mouse mouse-handler]  
  [on-key key-handler]  
  ...)

The signatures of the four functions in the angle braces are:
* draw-function : World -> Image  
* tick-function : World -> World  
* mouse-handler : World Number Number MouseEvent -> World  
  (the two numbers represent the x and y coordinates of the cursor)
* key-handler : World KeyEvent -> World  
no matter what animation/game/application you are writing!

Note that the only function that deals with Images is the draw-function!!!

Note: big-bang can take a lot of different handlers (functions), but to-draw, on-tick, on-mouse,
and on-key are the most used in this class. Also note that the only function required is a to-draw.

What's this world stuff? Well, a World is a data type that we define that represents what we are trying
to animate and/or make changeable by the user.

Let's say that we were going to make a little game that has a circle in the middle of a screen,
and pressing the "g" key makes the circle grow, pressing the "s" key makes the circle shrink,
and clicking on the circle changes its color.

What would the world be in this case? Well, what changes? The size of the circle, and the color of the circle!

So, the world in this case would be a structure containing a Number and a Color.
Note that we will use the following definition of Color (instead of the old one):
```racket
; A Color is one of:
; - "red"
; - "blue"
; - "yellow"

; A World is a (make-world Number Color)
(define-struct world [size color])
```

Let's define some constants for testing:
```racket
(define w1 (make-world 10 "blue"))
(define w2 (make-world 100 "red"))
(define w3 (make-world 200 "yellow"))
```

What functions do we need to define? We automatically need a to-draw, because that is always require.
Also, we know that pressing keys does something, so we need an on-key function. Clicking does something
as well, so we need an on-mouse. Nothing else is needed for this one!

First, let's design the draw function.

```racket
; draw : World -> Image
; draws a given world
```
It's useful to have a constant for the background:
```racket
(define background (empty-scene 500 500))

(check-expect (draw w1) (overlay (circle 10 "solid" "blue") background))
(check-expect (draw w2) (overlay (circle 100 "solid" "red") background))
(check-expect (draw w3) (overlay (circle 200 "solid" "yellow") background))
```

Template for processing a World:
```racket
(define (process-world w)
  (... (world-size w) (process-color (world-color w))))

(define (draw w)
  (overlay (circle (world-size w) "solid" (world-color w)) background))
```

;; Now, the on-key.

```racket
; key : World KeyEvent -> World
; makes the circle grow or shrink based on a given key event

(check-expect (key w1 "g") (make-world 12 "blue")) ; pressing "g" makes the circle grow by 2 units.
(check-expect (key w2 "s") (make-world 98 "red")) ; pressing "s" make the cirlce shrink by 2 units.
(check-expect (key w3 "f") w3) ; pressing another key does nothing.
```

We need to use the template for processing a KeyEvent, except we only care about the KeyEvents
"g" and "s", everything else does nothing:

```racket
(define (process-ke ke)
  (cond [(string=? ke "g") ...]
        [(string=? ke "s") ...]
        [else ...])) ; make sure you have this else, or your code will break if someone hits a different key!

(define (key w ke)
    (cond [(string=? ke "g") (make-world (+ (world-size w) 2) (world-color w))]
          [(string=? ke "s") (make-world (- (world-size w) 2) (world-color w))]
          [else w]))
```

This function now works, but there's one more bug we should squash before it can happen.
What if the user tries to shrink the circle when it's size is already 0? The code will break.
So, let's add a new clause in the cond to check if the user pressed "s" and the circle large
enough to shrink!

```racket
(define (key w ke)
  (cond [(string=? ke "g") (make-world (+ (world-size w) 2) (world-color w))]
        [(and (string=? ke "s") (> (world-size w) 2))
         (make-world (- (world-size w) 2) (world-color w))]
        [else w]))
```

Now for the on-mouse.

```racket
; mouse : World Number Number MouseEvent -> World
; changes the color of the circle when the mouse is clicked.
```

Note: the MouseEvent corresponding to clicking the mouse is "button-down"

```racket
(check-expect (mouse w1 3 3 "button-down") (make-world 10 "yellow")) ; blue circle becomes yellow
(check-expect (mouse w2 3 3 "button-down") (make-world 100 "blue")) ; red circle becomes blue
(check-expect (mouse w3 3 3 "button-down") (make-world 200 "red")) ; yellow circle becomes red
(check-expect (mouse w1 3 3 "enter") w1) ; any other mouse event does nothing
```

Template for processing the MouseEvent we care about:
```racket
(define (process-me me)
  (cond [(string=? me "button-down") ...]
        [else ...]))

(define (mouse w x y me) ; even though we don't care about the x and y coords, we still need them in the header!
    (cond [(string=? me "button-down") (make-world (world-size w) ???)]
          [else w]))
```

How do we know what Color to make the circle? Well, we know from the template for processing a World that
we need to process the Color within the World, and we know from our tests which color comes after which.
So, let's write a helper function called next-color:

```racket
; next-color : Color -> Color
; returns the color that comes after the given one

(check-expect (next-color "red") "blue")
(check-expect (next-color "blue") "yellow")
(check-expect (next-color "yellow") "red")
```

Template for processing a color:
```racket
(define (process-color* c)
  (cond [(string=? c "red") ...]
        [(string=? c "blue") ...]
        [(string=? c "yellow") ...]))

(define (next-color c)
  (cond [(string=? c "red") "blue"]
        [(string=? c "blue") "yellow"]
        [(string=? c "yellow") "red"]))
```

Now we can finish our mouse function:

```racket
(define (mouse w x y me)
    (cond [(string=? me "button-down") (make-world (world-size w) (next-color (world-color w)))]
          [else w]))
```

Now we have everything we need to run our animation/game. Just plug the function names we wrote
into the syntax template listed above:

```racket
(big-bang w1
  [to-draw draw]
  [on-key key]
  [on-mouse mouse])
```

## Style Guide

We need to make sure that when we write code we follow specific style requirements. This makes it
much easier to read, debug, and grade!

Whenever we write type names, we use upper camel case. This means that the first letter of a type is
capitalized, and each word within the type is also capitalized.
Examples: UpperCamelCase, String, ReallyLongTypeName.

Whenever we write function names, we use kabob case. This means that every letter is lowercase and
words are separated with hypens.
Examples: sum, kabob-case, my-function, really-long-function-name.

BSL ignores line breaks and whitespace, so it's generally recommended to break lines that are too long
and indent lines in a nice way.
For example,
```racket
(define (sum-bt bt)
    (cond [(none? bt) 0]
          [(bt? bt) (+ (sum-bt (bt-left bt))
                       (bt-data bt)
                       (sum-bt (bt-right bt)))]))
```
looks and reads a lot better than
```racket
(define (sum-bt bt)
  (cond[(none? bt) 0]
  [(bt? bt) (+ (sum-bt (bt-left bt)) (bt-data bt) (sum-bt (bt-right bt)))]))
```
