---
title: Announcing MutaCache
layout: post
date: '2014-03-13'
description: A cache for mutable JavaScript data structures
tags: [node.js, javascript]
---

In some recent work I had a piece of node.js code that I wanted to run in the browser. I pulled in my Browserify, fiddled around with a few things, and then I hit a piece of code that:

* Loaded a file from disk (IO)
* Processed it (expensive computation) and built a data structure
* Then returned that data structure

Under Node, everything is fine. But transplanted to the browser, and loading the file over the network, it was considerably slower. Fortunately, the function did fit all of the characteristics of one that could be memoized, so I went ahead and did that.

Unfortunately, JavaScript Memoization didn't work the way I thought it would.

### The problem with JavaScript memoization

Memoization allows us to circumvent expensive computation at the expense of memory. On the first call of a memoized function, the function will calculate the return value and then store it, keyed against the parameters that were passed in. Subsequent invocations with the same parameters will circumvent the computation and simply return the same value as before.

However, JavaScript is not immutable and those stored "values" can be objects, sometimes big sprawling mutable objects. Mine was one of those.

My experience with JavaScript memoization libraries was something like this

```javascript
function noMemo(a, b, c) {
  return { a: a, b: b, c: c };
}

noMemo(1,2,3); // { a: 1, b: 2, c: 3 }

var memoFn = memo(noMemo); // memoized fn

memoFn(1,2,3); // { a: 1, b: 2, c: 3 }

var hash = memoFn(1,2,3); // { a: 1, b: 2, c: 3 }

delete hash.a;
delete hash.b;
delete hash.c;
hash.lol = true;

memoFn(1,2,3); // {lol: true} -- uh oh
```

So, I couldn't any of these and mutate my data. Crap.

I actually tried a few memoization and in-memory cache libraries, and found that they did all behave in the same way. And then I gave up and wrote my own.

### Introducting MutaCache

**MutaCache** is designed to store mutable objects safely, by copying values on insertion and again on retrieval we can allow a client to mutate the value as much as they like without affecting our stored representation.

```javascript
var cache = require('mutacache')();

cache.put('key', {a:'a', b:'b', c:'c'});
if (cache.has('key')) {
  var x = cache.get('key');  // {a:'a', b:'b', c:'c'}
  x.a = 'lol';
  cache.get('key');  // still {a:'a', b:'b', c:'c'}
}
```

As it should be.

#### Tradeoffs

One advantage of caches over compution and IO is their speed, but then if you start copying objects on insertion and retrieval you begin to lose that advantage. Not enough to make it worthless, but enough that MutaCache will never hit the speeds of alternative less safe JS caches. If you're objects are never going to be mutated then you can find something faster.


### Get it

You can find MutaCache on [GitHub](https://github.com/danmidwood/mutacache) and [NPM](https://www.npmjs.org/package/mutacache).
