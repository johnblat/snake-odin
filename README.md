Hey all,

This is an example of creating a native cross-platform repository using the platform-independent core module approach that was described in [Day 11 of Handmade Hero](https://yakvi.github.io/handmade-hero-notes/html/day11.html) - or at least how I understood it.

I've implemented a basic snake game as a module that contains a few API functions:
- intialize
- set_view_size
- set_inputs
- update

The idea is that this can serve as an example and exercise for learning basics of a particular platform (or library that acts as a platform) - Windows, Linux, Mac, SDL, Sokol, raylib, etc.

Feel free to submit PR for a platform that you want to implement.
