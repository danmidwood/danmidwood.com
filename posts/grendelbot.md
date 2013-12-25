---
title: Grendelbot
date: '2013-12-25'
year: 2013
month: 12
month_name: December
day: 25
hour: 15
minute: 33
second: 00
description: John Gardner's Grendel on Twitter
tags: [programming, twitter, clojure, reading]
---

[Grendel][1] is my all time favorite book. Usually I won't read a book more than the once, prefering to pick up something new instead. But Grendel is a book I return to and enjoy often.

As a Christmas gift to the internet I created Grendelbot, a bot tweeting the book line by line.

The bot is built with Clojure and the [twitter-api](https://github.com/adamwynne/twitter-api "Clojure Twitter API on Github") library. While the whole thing is pretty simple there were a couple of complexities:

*    Deciding what to include in a tweet.

     > I split the text by punctuation regex `(?<=[.!?].)`[^1] then combine consecutive short (< 50 characters) sentences up to a limit of 140 characters. After that the sentences are scrubbed of any extranous whitespace before a final process splits any sentences that are too long (> 140 characters).
*    Tweeting in order.

     > I wanted this to be able to survive app restarts, and also to reach the end of the text and start again from the beginning. To find the next tweet from the list of all tweets I drop all until the there is a equality match with the last tweet made. Then that is dropped too and then next one is set to go.
     > The list of possible tweets is wrapped in `cycle` so that after reaching the end of the book the tweets will continue from the beginning.

The bot is hosted on Heroku, using the scheduler to trigger a single worker dyno once an hour. Heroku is fantastic for Clojure hosting, and for this bot the cost is nothing.

The source is available on [GitHub](https://github.com/danmidwood/grendelbot "Grendelbot source code on GitHub")

Grendelbot on twitter is [@worldrimwalker](https://twitter.com/worldrimwalker "Grendel on Twitter"), and here is the beginning,

<blockquote class="twitter-tweet" lang="en"><p>The old ram stands looking down over rockslides, stupidly triumphant.</p>&mdash; Grendel (@worldrimwalker) <a href="https://twitter.com/worldrimwalker/statuses/415740828595023872">December 25, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>


[^1]: The trailing character is required for sentences that end with quotes or parentheses. As a programmer it pains me to see a sentence termination character at not-the-end-of-the-sentence, but ah, so is grammar.

[1]: http://en.wikipedia.org/wiki/Grendel_(novel) "Grendel on wikipedia"
