#import "./lovelace.typ": pseudocode-list

#let title = "Nucleic Acid Nanotube Grapher"
#let author = "Wolf Mermelstein"
#set document(author: author, title: title)
#set text(font: "Linux Libertine", lang: "en")

#set page("us-letter", margin: 1in, header: [
  #set text(12pt)
  #author
  #h(1fr)
  NATuG Technical Brief
], footer: [
  #counter(page).display() #h(1fr)
])

#align(
  center + horizon,
)[
  #move(dy: -0.50in)[
    #block(text(weight: 700, 1.75em, [#title:\ NATuG 3.0]), below: 0.15in)
    #v(.25in)
    #block(text(1.25em, author))
  ]
]

#outline(title: [Contents #v(.25in)], depth: 3, indent: .25in)

#pagebreak()

#set page(numbering: "1", number-align: center, columns: 2)

= Introduction

== Program Background

Creating nanoscale structures is an inherently tricky task; it very hard achieve
the precision and rigidity to create useful structures. Structural DNA
Nanotechnology involves the strategic placement of Watson-Crick DNA base
pairings to create extremely precise nanostructures.

#figure(
  image("./resources/nanotube.png", width: 50%), caption: [Example DNA Nanotube @shermanNanotubeDesign],
) <fig:example-nanotube-rendering>

The basis for NATuG is William B. Sherman and Nadrian C. Seeman's paper,
_Design of Minimally Strained Nucleic Acid Nanotubes_, which goes into depth
about the process of designing specifically tubular DNA nanostructures
@shermanNanotubeDesign. Their initial paper was theoretical, but provided an
example spreadsheet tool for the design process.

#figure(
  image("./resources/natug2.png", width: 90%), caption: [NATuG 2 Desktop Application],
)

Eventually, another iteration was produced, as a desktop application. It was
much better at graphing the nanotubes, but the project failed to consistently
handle joining different double heleces together, due to how the program was
designed. Eventually, it became obsolite, as it used python

This paper introduces _NATuG 3.0_, a new, final iteration. _NATuG 3.0_ is a
cross platform desktop application that aims to make the nucleic-acid design
process simpler and easier than ever. NATuG provides an intuitive interface,
allowing one to customize and visualize the nanotube shape, weave together
helices in a matter of clicks, and apply/export sequences, while also being
highly configurable and allowing for convenient exporting/importing of
standardized file formats.

== Nanotube Design Process

NATuG is designed Seeman and Sherman's paper's process of designing nanotubes.
The process, in general, looks like

1) Choosing DNA parameters. Like the number of base pairs per some number of
turns, the diameter of the DNA, etc.

2) Choosing how to place the double helices. This determines the actual shape of
the tube.

#figure(
  image("./resources/top-view-example-2.png", width: 50%), caption: [Domain \#2 has a small angle (see angle between \#1 \#2 and \#3)],
)

#figure(
  image("./resources/top-view-example-1.png", width: 50%), caption: [Domain \#2 has a big angle (see angle between \#1 \#2 and \#3)],
)

There's some geometry at play here to make sure that the tube closes.

#figure(
  image("./resources/staple-strands.png", width: 100%), caption: [DNA staple strands @unsw2017capsid],
)

3) Create cross-strand "linkages".

Often we use "staple strands," where you have one very long virus strand, and
then connect it up at certain points to form a structure.

4) Assign sequences.

Choosing which bases to place for the nucleosides along the strands. One method
is to start with a random sequence, and manually refine it.

It's a long process, and without the right tools it's extremely restrictive and
unfeasible. So let's see how NATuG can help us out.

= Program Overview

#figure(
  image("./resources/program-layout.png", width: 100%), caption: [NATuG Program Layout],
)

The app is broken into two primary regions. First, the _Side View Plot_, a
central component where users can interact directly with DNA strands. You can
think of it sort of like a Mercator projection, where we "unroll" the DNA.
Second, the _Top View Plot_, which displays what the overhead of the nanotube
looks like.

The _Side View Plot_ is modal, the mode determines how you can interact with it.
There are 5 modes: _Informer_, to get information on given points; _Juncter_, to
conjoin strands, "weaving together" the nanotube; _Nicker_, to "cut" up DNA
strands; _Linker_, to connect arbitrary pieces of DNA strands; and _Highlighter_,
to highlight points.

On the _Config Panel_ on the right side of the program, there is a few tabs, the _Nucleic Acid Tab_,
for editing DNA parameters; the _Domains Tab_, for placing the double helices;
the _Sequencing Tab_, for choosing the DNA sequences; and the _Snapshots Tab_,
for setting the bases for the DNA.

To design a nanotube in NATuG, you follow many of the same steps as if you were
to do it manually.

1) You set up DNA parameters in the _Nucleic Acid Tab_.

2) You place the double helices in the _Domains Tab_. You can play with the
angles and watch the _Top View Plot_ update live. Clicking between domains
"dent"s them, automatically adjusts the angles. Datapoints are presented to help
find angles that get the tube to close.

3) You enter "conjunct" mode and "weave" the strands together. NATuG will
automatically figure out where the new strands should go as you "conjunct" at
overlapping NEMids (*N*\ucleoside *E*\nd *Mid*\points). It styles things for
you.

4) You can "nick" ("cut" them up), and then "link" them back together. You can
linkage sequences as you go.

5) You assign sequences in the _Sequencing Tab_, or by clicking on strands and
manually setting sequences. NATuG supports loading in the base pairs of common
viruses. Finally, you can export the sequences to a spreadsheet for synthesis.

= Technical Overview

The program is written in `Python`, with `PyQt6`, and `pyqtplot`. It takes
advantage of a number of different helpful `python` frameworks, like `numpy` and `pandas` for
optimizations and implementing certain features.

=== General Design

The hardest part of the design of the program has been state management. The
program is packaged as a `python` package, with a `launch()` function exported
from a top level `natug/launcher.py` file. The program follows `oop` principals
for managing program state and exposing functionality.

When you launch the program, `natug` creates a `natug.Runner`, which is an
object that keeps track of many `natug.Manager`s. Each `Manager` has a `.current` state,
and there are `Manager`s for most parts of the program: the `Domain`s, `Helices`, `NucleicAcidProfile`,
etc. .

The various biological and theoretical structures are all represented with their
own data structures. Significant effort has gone into making these as simple and
modularized as possible. For example, `Domain`s are stored in groups called `Subunit`s,
which all go into one big `Subunits`, which is a property of `Domains`. This
lets us do really nice things, like modifying the angles of all subunits at
once.

All the plotting is handled by `pyqtplot`, which is a very powerful plotting
framework for `PyQt`. We define our own plotter class inherited from theirs, and
do a lot of custom plotting functionality, like mapping plotted points to actual
data structures for what the given points are, which have pointers to things
like the `Strand` they are in.

#figure(
  image("./resources/sequence-editor-manual-input.png", height: 2in), caption: [Custom base pair sequence editor],
)

#figure(
  image("./resources/domain-config-table-counts.png", height: 2in), caption: [Domain triple spinbox container],
)

`PyQt` is somewhat restrictive in that it ships with a predefined subset of
widgets, and most of the interface was layed out with `QtDesigner`. However,
some components are so important that custom Widgets have been designed, like
the sequence editor that autofills the corresponding bases to prevent mistakes.
Designing custom UI components like this is quite tricky, both technically, and
because there are implications we need to consider, like since some strands are
longer than others not all have complements.

===== Computing Plots

NATuG is able to compute the positions of all of the `NEMids` and `Nucleosides` by
first computing their angles as they spin about their respective helices, and
then converting those angles to corresponding $x$ coordinates. This is a
relatively complicated algorithm that has been heavily iterated on through `numpy` vectorize
optimizations and debugging to fix various indexing errors.

Computing the _Top View Plot_ is more straight forward. We begin at the first
domain, and then draw by placing each domain relative to the first at some angle
displacement off from the previous one.

===== Conjuncting Strands

The most interesting algorithm within NATuG is the strand "conjoining" feature.

Given two arbitrary NEMids, we want to be able to cut and then reroute the
strands. Sometimes this will result in loops, which we need to deal with.

In developing NATuG, an algorithm has been contrived and implemented for this
process.

#figure(
  image("./mermaid/out/conjoin-graph.png", width: 100%), caption: [Case 1A],
)

#v(0.15in)

#block[
  #let height = 1.4in
  #grid(
    columns: 5, gutter: 15pt, figure(
      image("./resources/junction-case-1A.png", height: height), caption: [<fig:junction-case-1a> Case 1A],
    ), figure(
      image("./resources/junction-case-1B.png", height: height), caption: [<fig:junction-case-1b> Case 1B],
    ), figure(
      image("./resources/junction-case-2A.png", height: height), caption: [<fig:junction-case-2a> Case 2A],
    ), figure(
      image("./resources/junction-case-2B.png", height: height), caption: [<fig:junction-case-2b> Case 2B],
    ), figure(
      image("./resources/junction-case-2C.png", height: height), caption: [<fig:junction-case-2c> Case 2C],
    ),
  )
]

Generally, how to create a junction is intuitive, and NATuG handles breaking
down the cases as shown in the tree.

To conjoin strands, either one or two new strands get created, and the old
strands get removed; no NEMids are destroyed.

The first step in the processes is checking whether the NEMids are within the
same strand or two different strands. Then, we check to see if the strands that
they lie within are closed or open.

Based on a variety of cases, we create new strands, move around points to
different strands, and do re-painting.

=== Data Exchange

NATuG supports exporting and importing of program states to various degrees of
granularity.

Originally, it was planned to simply pickle the program state (dump the raw
binary), but that turned out to cause a lot of redundancy and also be extremely
inaccessible to the end user.

Now, you can export and import the entire program program state as a `.natug` file,
which is a `zip` archive containing metadata about every unique artifact
currently specified in the system. It is sometimes redundant, since we could
recompute the artifacts given the configuration, but allows for very quickly
loading back in the data.

To add undo/redo functionality, "snapshot"s are taken at every click/change, and
these "snapshot"s are just `.natug` program saves because of how relatively
quick they are to create.

You can also export and import certain parts of the program state by themselves,
to use as templates for various different types of nanotubes. For example, DNA
parameters in the _Nucleic Acid Tab_ are stored in simple `json` files and
profiles automatically get loaded in/can be exported. Likewise, the arrangement
of domains can be imported/exported to `csv`s.

Finally, it is still a significant work in progress, but there are plans to
support exporting the entire program state to a spreadsheet for portability
outside of the program using `openpyxl`. Spreadsheets are popular among
professionals in the field, and are relatively easy to analyze.

For the `.natug` save, we give every artifact a unique identifier, and then can
link them together in the save file. This means that when we load things back
in, we can quickly reassemble the program state by putting all artifacts in a
hash map first and then referencing things from that. For a spreadsheet, we
could do `uuid` lookups, but it would be much more ideal to reference properly
by cell.

== Next Steps

As this iteration is completed, a paper is being drafted on algorithms and
functionalities of the program. We have been increasingly considering our end
users: NATuG is very good at designing tubular structures, but since it is
relatively intuitive and simple to use, it also is suitable for non-tubular
structures as well.

#bibliography("works.bib")

