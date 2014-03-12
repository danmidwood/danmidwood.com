---
title: Exploring Clojure Memoization
date: '2013-02-24'
year: 2013
layout: post
month: 02
month_name: February
day: 24
hour: 16
minute: 00
second: 00
description: In which Clojure's memoize function is put through its paces
categories: Clojure
---

Memoization is an optimization technique used to "remember" the result of function evaluation for a set of parameters, and then on future function execution with the same arguments the result can be looked up instead of recalculated. This offers great speed increases on computationally expensive function calls, but at the expense of increased memory usage required to record arguments and results.

Clojure has memoization built in with the `memoize` function. And now we'll see some examples of how this can be used.

```clojure
clojure.core/memoize
([f])
  Returns a memoized version of a referentially transparent function. The
  memoized version of the function keeps a cache of the mapping from arguments
  to results and, when calls with the same arguments are repeated often, has
  higher performance at the expense of higher memory use.
```


Here is a simple addition function named `add` that accepts many arguments and adds them together. We include a `print` statement to indicate when the function body is being executed. Passing our add function into memoize returns a memoized version of our addition function, and here we named that `add-memoized`.

```clojure
(defn add [& args]
  (print ".")
  (apply + args))
 
(def add-memoized
  (memoize add))
```

It's worth pointing out now that side effects (such as printing) should be avoided in memoized functions because they will be not be evaluated on subsequent calls, but here we will be taking advantage of that particular behaviour to indicate when we are calculating values and when we are looking up already-calculated values.

Now let us add the numbers 1, 2 and 3 together using the memoized addition, and then do it again with the same arguments.

```clojure
example.memo> (add-memoized 1 2 3)
.
6
example.memo> (add-memoized 1 2 3)
6
```

The first function call calculates the result to be 6. In the second function call the function body is circumvented and the result retrieved from the memoization, as we can see through the absence of a printed dot.

That was easy. Let's try something a bit more challenging, something like memoization of recursive functions.

Here's a standard recursive implementation of a Fibonacci number calculator. 

```clojure
(defn fib [n]
  (print ".")
  (if (>= 1 n)
    n
    (+ (fib (- n 1)) (fib (- n 2)))))
```

Other (better) algorithms are available for calculating Fibonacci numbers. This one is inefficient and will branch on each recursion, running the same calculations multiple times, but these characteristics make it ideal for our demonstration. 
Again, our print dot is included to highlight how many times the function body is entered.

```clojure
example.memo> (fib 1)
.
1
example.memo> (fib 2)
...
1
example.memo> (fib 3)
.....
2
example.memo> (fib 10)
.................................................................................................................................................................................
55
```

We can see that calculating the first number enters the function once only, the second number three times, the third number five times, and for the tenth number, well, a lot of times.

Now let us create a memoized version name `fib-memoized` and run it again.

```clojure
(def fib-memoized
  (memoize fib))
```

```clojure
example.memo> (fib-memoized 10)
.................................................................................................................................................................................
55
example.memo> (fib-memoized 10)
55
example.memo> (fib-memoized 9)
.............................................................................................................
34
```

That didn't work quite right. Our `fib-memoized` top level call _is_ memoized, and we can see that by the second `(fib-memoized 10)` circumventing the function body to immediately return the result. But our intermediate function calls are not memoized.

To discover why, let's see what we have so far. There is a non memoized function `fib` that recursively calls itself, and our memoized function `fib-memoized` that is recursively calling, not itself, but the non-memoized `fib`. 

We want out memoized function to call itself, one option is to retain the fib symbol for our memoized function.

```clojure
(defn fib [n]
  (print ".")
  (if (>= 1 n)
    n
    (+ (fib (- n 1)) (fib (- n 2)))))

(def fib
  (memoize fib))
```

But binding to the same symbol twice is not very pleasant and can be difficult to read later. A better option is to create the function and memoize it before binding it to `fib`.

```clojure
(def fib
  (memoize
   (fn [n]
     (print ".")
     (if (>= 1 n)
       n
       (+ (fib (- n 1)) (fib (- n 2)))))))
```

Running our tests now shows the intended behaviour.

```clojure
example.memo> (fib 10)
...........
55
example.memo> (fib 10)
55
example.memo> (fib 9)
34
```

Here we can see that the call to find the tenth Fibonacci number entered the fib body only eleven times, once each for numbers zero to ten, with no superflous calculations made. The subsequent call to find the tenth number in the sequence doesn't enter the function body at all. And this time the intermediate results have been memoized and can be reused to calculate other numbers in the series, as shown by the calculation of the 9th number in the sequence also not entering the function body.

While this is now achieving everything we hoped for, it isn't as clear as we might like, with the extra verbosity introduced by the explicit `fn` and `memoize` contributing to this. It would be nice if there was somthing as simple and intuitive as the standard `defn` that we could use. 

There isn't, but Clojure is a Lisp, and with Lisps we can just create it. So, let's do that.

Here is a macro named `defn-memo` that accepts a symbol for the name as well as an argument list and function body and then creates a memoized function.

```clojure
(defmacro defn-memo [name & body]
  `(def ~name (memoize (fn ~body))))
```

This matches standard function definition that is available with `defn` but evaluates straight to a memoized function that can also handle recursion. 
Here is our `fib` function as implemented using the macro.

```clojure
(defn-memo fib [n]
  (if (>= 1 n)
    n
    (+ (fib (- n 1)) (fib (- n 2)))))
```


There are limitations in what we've covered above, this macro would require extra work in order to be able to handle `recur`. But that's a problem for another day.

Final thought. Remember that memoization is cool but it isn't free. Use it wisely.

