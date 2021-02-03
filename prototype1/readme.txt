The objective of this prototype was to dip my toes into navigation and mining using turtles.

The code works for the most part, but some parts can be better optimized:
    -The makeHeading makes mulitple turns in a direction where a single turn in the other would 
    do the same thing,
    -The movement algorithm is buggy and sometimes misses the target block and goes back and 
    forth if asked to move to the blobk it is present at.

For future iterations:
    -it makes more sense to split apart files based on use, and use shell.run()
    commands with corresponding arguments.

nice-to-haves:
    -ability to deploy turtles remotely,
    -using mulitple turtles instead of just 1,
    -automatic stripmining