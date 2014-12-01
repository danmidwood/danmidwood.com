---
title: The Animated Guide to Paredit
layout: post
description: An animated guide to Paredit, showing the capabilities and the functions in action
tags: [paredit, emacs, gifs]
---

Paredit is great, it brings structural editing to lisps, maintaining the syntactical correctness of your code. I’ve been a fan for a long time, but still was only using a small subset of the functionality available, even afer spending time reading the manual and paper printing out cheat sheets.

Lately I decided to work deliberately with Paredit and really understand it, and now I mostly do. Here is what I learned.

Note: I've included my key-presses in the animations so you can see what I'm doing. However, they are shown as Mac keys, M- is ⌥, C- is ⌃, and shift is ⇧.

## The basics


### Balanced pairs


#### Opening

Paredit has four opening functions, applying to the `()`, `[]`, `{}` and `<>` pairs. Paredit never lets your buffer become unbalanced, so each open function will produce a balanced pair.

* `(` -> `paredit-open-round`
* `[` -> `paredit-open-square`
* `{` -> `paredit-open-curly`


>![Paredit's opening tags](/assets/animated-paredit/paredit-open.gif)
> <br/>
>###### Opening tags

By default, `paredit-open-angle` is not bound to any key.

#### Closing and indenting

Each of these functions has a partner in the `paredit-close-[round|square|curly|angle]` functions. These will move the cursor past the next closing delimiter and also indent.

>![Paredit's closing tags](/assets/animated-paredit/paredit-close.gif)
><br />
>###### Moving past the closing delimiter

<br/>

>![Paredit's closing indent](/assets/animated-paredit/paredit-close-indent.gif)
> <br />
>###### And pulling the closing delimiter onto the current line


A nice feature of these functions is that they are delimiter agnostic, that means that you don't need to match the correct closing character of the pair with the opening character, any will do.

#### Quoting

Paredit treats double quoting similarly to the opening and closing pairs of characters above. However, because the same character is used for opening and closing, there are differences.

`double-quote` is bound to the `"` key and will:

* Insert an open and closing quote `""` when the cursor is not in a quoted space,
* Move past the closing double quote character when the cursor is at the end of a string
* Insert an escaped quote when inside a string,


>![Paredit's double quote](/assets/animated-paredit/paredit-doublequote.gif)
><br />
>###### Double quoting

#### Wrapping an S-expression

Paredit has variants of all of the above that open a pair and automatically wrap the following S-expression into it. These functions are named `paredit-wrap-[round|square|curly|angle]` and `paredit-meta-doublequote`.

* `paredit-wrap-round` is bound to `M-(`
* `paredit-meta-doublequote` is bound to `M-"`
* The other functions are not bound to any keys by default

>![Paredit's wrapping openers](/assets/animated-paredit/paredit-wrap.gif)
><br />
>###### Wrapping an S-expression

#### Deleting

Like the open, close and double quote keys, Paredit also takes over the default key combinations that Emacs uses for deleting:

* `paredit-forward-delete` bound to `C-d`
* `paredit-forward-kill-word` bound to `M-d`
* `paredit-backward-delete` bound to `DEL` (and [probably](http://www.emacswiki.org/emacs/BackspaceKey) backspace too)
* `paredit-backward-kill-word` bound to `M-DEL`
* `paredit-kill` bound to `C-k`

These commands act just the same as the regular Emacs commands that they hijack the keys from, until you try to break the balance of your S-expressions and then they'll refuse to comply. By doing this Paredit can ensure that integrity of your code is maintained.


>![Paredit's forward deleting](/assets/animated-paredit/paredit-delete-forward.gif)
><br />
>###### Deleting forward by character and word

<br />

>![Paredit's backward deleting](/assets/animated-paredit/paredit-delete-backward.gif)
><br />
>###### Deleting backward by character and word

<br />

>![Paredit's backward deleting](/assets/animated-paredit/paredit-kill.gif)
><br />
>###### Killing to the end of the current S-expression

This refusal to unbalance code is also, unfortunately, a great cause of pain to people that are new to Paredit and still transitioning from string based to tree based editing. And is a cause of people quitting Paredit forever. Fortunately, the solution lies below.



## Slurping and Barfing

Say what now?

Slurping is when the current S-expression or string is expanded by pulling in the next outer S-expression. Barfing is the opposite, contracting the S-expression by pushing out it's last-most form.

Slurping is provided by `paredit-forward-slurp-sexp`, bound to `C-)`, and barfing is provided by `paredit-forward-barf-sexp` that is bound to `C-}`.

>![Paredit's slurping and barfing](/assets/animated-paredit/paredit-slurp-barf.gif)
><br />
>###### Slurping and barfing

Notice that these function names contain the word "forward", Paredit also gives us the ability to slurp and barf backwards with `paredit-backward-slurp-sexp`, bound to `C-(`, and `paredit-backward-barf-sexp`, bound to `C-{`.

>![Paredit's slurping and barfing backwards](/assets/animated-paredit/paredit-slurp-barf-backwards.gif)
><br />
>###### Slurping and barfing backwards


## Structural Navigation

Paredit provides functions for graceful S-expression navigation, allowing you to move forward and backward amongst siblings, raise up to the enclosing S-expression and descend back down into the children.

Move forward and backward inside an S-expression using `paredit-forward` and `paredit-backward`, bound to  `C-M-f` and `C-M-b` respectively. Upon reaching a delimiter, a further invocation will move the cursor outside of the current S-expression and into the enclosing S-expression.

>![Paredit's forward and backwards navigation](/assets/animated-paredit/paredit-moving-forward-back.gif)
><br />
>###### Moving forward and backwards

<br />

Paredit offers two methods of descent and ascent, that can be used depending on the direction that you want to move.

To descend forwards use `paredit-forward-down`, bound to `C-M-d`. To reverse that and ascend backwards use `paredit-backward-up`, bound to `C-M-u`.

>![Paredit's forward down navigation](/assets/animated-paredit/paredit-moving-forward-down.gif)
><br />
>###### Descending forwards and ascending backwards

Then, when you want to descend backward you can use `paredit-backward-down`, bound to `C-M-p`. And to reverse that and ascend forwards use `paredit-forward-up`, bound to `C-M-n`.

>![Paredit's backward down navigation](/assets/animated-paredit/paredit-moving-backward-down.gif)
><br />
>###### Descending backwards and ascending forwards

## Splicing

Splicing is the act of removing the current S-expression and joining (some of) the contents with the enclosing S-expression. There are two splices that will kill the content of the current S-expression either to the front of rear of the cursor.

Kill backwards with `paredit-splice-sexp-killing-backward`, bound to `M-<up>`.

>![Paredit's splice killing backward](/assets/animated-paredit/paredit-splice-killing-backward.gif)
><br />
>###### Splice and kill backwards

And kill forwards with `paredit-splice-sexp-killing-forward` that is bound to `M-<down>`.

>![Paredit's splice killing forward](/assets/animated-paredit/paredit-splice-killing-forward.gif)
><br />
>###### Splice and kill forwards

And there is a no kill variant `paredit-splice-sexp` bound to `M-s`, shown here splicing the quotes off a string.

>![Paredit's splice no kill](/assets/animated-paredit/paredit-splice-no-kill.gif)
><br />
>###### Splice a string without killing anything


## Splitting and Joining

An S-expression can be split into two, and two S-expressions can be joining back together into one.

Split is `paredit-split-sexp` and bound to `M-S`, join is `paredit-join-sexps` and bound to `M-J`. Note that the S and J are both uppercase.


>![Paredit's joining and splitting](/assets/animated-paredit/paredit-split-join.gif)
><br />
>###### Joining two printlns into one


## Bonus

A final treat, here is `paredit-convolute-sexp` and it is bound, quite appropriately, to `M-?`.

The description from the function docs is:
> Convolute S-expressions.<br/>
> Save the S-expressions preceding point and delete them.<br/>
> Splice the S-expressions following point.<br/>
> Wrap the enclosing list in a new list prefixed by the saved text.<br/>
> With a prefix argument N, move up N lists before wrapping.

<br/>

>![Paredit's convoluting](/assets/animated-paredit/paredit-convolute.gif)
><br />
>###### Convoluting an expression

I'm still waiting for the day when I recognise a use for this one.

----
Discussion on [Lobsters](https://lobste.rs/s/yjohyw/the_animated_guide_to_paredit), [Hacker News](https://news.ycombinator.com/item?id=8662449) and [Reddit](http://www.reddit.com/r/emacs/comments/2ngqi6/the_animated_guide_to_paredit/)
