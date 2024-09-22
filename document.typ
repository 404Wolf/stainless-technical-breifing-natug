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
  #move(
    dy: -0.50in,
  )[
    #block(
      text(weight: 700, 1.75em, [#title (NATuG)\ Technical Brief]), below: 0.15in,
    )
    #v(.25in)
    #block(text(1.25em, author))
  ]
]

#pagebreak()

#set page(numbering: "1", number-align: center, columns: 2)

= Introduction

== Background

Creating nanoscale structures is a tricky task, as it is very hard to achieve
adequate precision and rigidity at such small scale. _Structural DNA Nanotechnology_ is
a field within biochemistry that uses DNA as a building block for tiny
nanostructures. DNA is a uniquly good candidate because it self assembles, can
be synthesized, and is of the right scale.

#figure(
  image("./resources/nanotube.png", width: 50%), caption: [Example DNA Nanotube @shermanNanotubeDesign],
) <fig:example-nanotube-rendering>

The basis for NATuG is William Sherman and Nadrian Seeman's paper,
_Design of Minimally Strained Nucleic Acid Nanotubes_, which goes into depth
about the process of designing tunular DNA nanostructures
@shermanNanotubeDesign.

A DNA nanotube is a structure made by placing double helices adjacent to each
other and then weaving them together so that you create one larger tube shape
(see @fig:example-nanotube-rendering).

Their initial paper focuses on the theory, providing an example tool that
generates relevant plots within Excel.

#figure(
  image("./resources/natug2.png", width: 90%), caption: [NATuG 2 Desktop Application],
) <fig:natug-2>

Another iteration was produced as a desktop application (@fig:natug-2). It was
better at graphing, but failed to consistently handle "weaving" helical domains
together.

This brief introduces _NATuG 3.0_, a final iteration.

NATuG 3.0 is a Python desktop application available via `pypi`. You can try it
out by running `pip install natug` (ideally in a virtual environment).

== Nanotube Design Process

Designing DNA nanotubes is a complex process; here is a brief overview.

First, you choose the type of DNA you are working with. Then, you find a tube
shape consistent with the geometry of DNA double helices by strategically
setting angles between helical domains, aligning helices next to each other in a
way where you can then place connections between the helices (see
@fig:top-view-example).

#[
  #set figure.caption(position: top)
  #figure(
    [
      #set figure.caption(position: bottom)
      #v(0.025in)
      #grid(
        columns: 2, figure(
          image("./resources/top-view-example-2.png", width: 80%), caption: [Domain \#2 has a small angle (see angle between \#1 \#2 and \#3)], numbering: none,
        ), figure(
          image("./resources/top-view-example-1.png", width: 80%), caption: [Domain \#2 has a big angle (see angle between \#1 \#2 and \#3)], numbering: none,
        ),
      )
    ], caption: [Choosing the shape of the nanotube by setting angles between helical domains],
  ) <fig:top-view-example>
]

#figure(
  image("./resources/cross-strand-exchange.png", height: 1.45in), caption: [Creating a cross-strand exchange],
) <fig:cross-strand-exchange>

You create those cross-strand exchanges to keep the structure held together (see
@fig:cross-strand-exchange). Then, you cut up the strands so as to create "staple"
strands, typically where one long virus strand runs through the entire
structure, and smaller synthetic strands bind it all together. Finally you
choose all the base sequences, and send it to a lab for synthesis.

#figure(
  image("./resources/staple-strands.png", width: 100%), caption: [DNA staple strands @unsw2017capsid],
) <fig:staple-strands>

= Program Overview

#figure(
  image("./resources/program-overview.png", width: 100%), caption: [NATuG Program Layout],
) <fig:progrma-layout>

NATuG is split into a few panes.

The _Side View Plot_ displays an "unrolled" view of the DNA. This view is modal;
it determines what clicks do. Modes include things like like "juncter", which
makes clicking on midpoints between DNA bases create strand-exchanges, or "nicker,"
where you can break apart DNA strands.

The _Top View Plot_ is a bird's eye view of the nanotube. You can click on
helical domains in it and it redirects you to the _Side View Plot_.

On the _Config Panel_ on the right side, there are config tabs, like the _Nucleic Acid Tab_,
for editing DNA parameters; the _Domains Tab_, for placing the double helices;
the _Sequencing Tab_, for choosing the DNA sequences, and more.

#figure(
  image("./resources/creating-cross-strand-exchanges.png", height: 2.25in), caption: [You can create cross-strand exchanges in "juncter" mode with just a click],
) <fig:side-view-plot>

To design a nanotube in NATuG, you follow many of the same steps as if you were
to do it manually.

You choose DNA parameters in the _Nucleic Acid Tab_, and then set angles between
double helices in the _Domains Tab_. The plots of the nanotube update live. You
can also click on double helices in the plot to modify the angles in certain
ways.

You can then enter "conjunct" mode to "weave" strands together. You can chop-up
strands, and create linkages. You assign sequences in the _Sequencing Tab_, or
by clicking on strands and manually setting sequences.

Finally, you can export the program state, and the sequences that you need to
synthesis.

= Technical Overview

The program is written in `Python`, with `PyQt6`, and `pyqtplot`. It takes
advantage of a `numpy` and `pandas` for vectorizing optimizations and features
like file exports.

=== General Design

NATuG is a `python` package that heavily follows `oop` principals for managing
program state and exposing functionality.

The hardest part of the design of the program has been state management. When
you launch the program, `natug` creates a `natug.Runner`, which keeps track of
many `natug.Manager`s. Each `Manager` has a `.current` state, and there are `Manager`s
for most parts of the program: the `Domain`s, `Helices`, etc. .

The various biological structures are represented with special data structures.
Significant effort has gone into making these as simple/modularized as possible.

For example, `Domain`s are stored in groups called `Subunit`s, which all go into
one big `Subunits`, which is a property of `Domains`. This lets us do nice
things like modifying angles of all symmetrical subunits at once.

#figure(
  image("./resources/sequence-editor-manual-input.png", height: 2in), caption: [Custom base pair sequence editor],
)

#figure(
  image("./resources/domain-config-table-counts.png", height: 2in), caption: [Domain triple spinbox container],
)

`PyQt` is somewhat restrictive; it ships with predefined widgets and it is
annoying to compose complex new ones. However, some components are so important
that it was worth the effort, like the sequence editor that autofills the
corresponding bases to prevent mistakes. Designing custom UI components like
this is tricky, both technically, and because there are usage implications to
consider.

=== Plotting

All the plotting is handled by `pyqtplot`, with lots of customization to make
plots highly interactive.

NATuG is able to compute the positions of all of the `Point`s (e.g. DNA
nucleosides) by first computing their angles as they spin about their respective
helices, and then converting those angles to corresponding $x$ coordinates,
while the $z$ coordinates just increase at a steady pace. This algorithm is
roughly defined in Sherman and Seeman's paper, but has been improved on and
optimized for performance.

Computing the _Top View Plot_ is more straight forward, where we begin at the
first domain, and then draw by placing each domain relative to the first at some
angle displacement off from the previous one.

=== Conjuncting

The most interesting algorithm within NATuG is the strand "conjoining" feature.

Given two arbitrary midpoints between nucleosides, we want to be able to cut and
then reroute the strands. Sometimes this will result in loops, which we need to
deal with.

In developing NATuG, an algorithm has been contrived and implemented for this
process.

#figure(
  image("./mermaid/out/conjoin-graph.png", width: 100%), caption: [Case 1A],
) <fig:junction-conjoin-tree>

#v(0.15in)

#block[
  #let height = 1.4in
  #grid(
    columns: 5, gutter: 15pt, [
      #figure(
        image("./resources/junction-case-1A.png", height: height), caption: [Case 1A],
      ) <fig:junction-case-1a>
    ], [
      #figure(
        image("./resources/junction-case-1B.png", height: height), caption: [Case 1B],
      ) <fig:junction-case-1b>
    ], [
      #figure(
        image("./resources/junction-case-2A.png", height: height), caption: [Case 2A],
      ) <fig:junction-case-2a>
    ], [
      #figure(
        image("./resources/junction-case-2B.png", height: height), caption: [Case 2B],
      ) <fig:junction-case-2b>
    ], [#figure(
        image("./resources/junction-case-2C.png", height: height), caption: [Case 2C],
      )<fig:junction-case-2c> ],
  )
]

Generally, how to create a junction is intuitive, and NATuG handles breaking
down the cases based on whether the two points are along the same strand, and
whether the strand(s) are open; for all the cases, see
@fig:junction-conjoin-tree.

=== Data Exchange

You can export/import state to `.natug` files, which are `zip` archives
containing metadata about every all artifacts, linking objects together with `uuid`s.
We trade redundancy for fast reloads and data accessibility. It also lets us
implement undo/redo with frequent `.natug` saves.

Pickling for state saving was considered, but `python` pickles ended up being
too inaccessible and fragile.

Work is in progress to support exporting to spreadsheets using `openpyxl`.
Spreadsheets are popular among professionals in the field, are easy to analyze,
and are highly portable.

For the `.natug` save, we give artifacts unique identifiers to link them
together with. For a spreadsheet, it would be ideal to reference by spreadsheet
cell instead.

You can also export/import certain parts of the program alone. For example, DNA
parameters in the _Nucleic Acid Tab_ are stored in `json` files and profiles
automatically get loaded in/exported.

== Next Steps

As this iteration is completed, a paper is being drafted on algorithms and
functionalities of the program. We have been increasingly considering our end
users: NATuG is very good at designing tubular structures, but since it is
relatively intuitive and simple to use, it also is suitable for non-tubular
structures as well.

#bibliography("works.bib")

