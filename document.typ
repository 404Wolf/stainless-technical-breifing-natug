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

#outline(title: [Contents #v(.25in)], depth: 5, indent: .25in)

#pagebreak()

#set page(numbering: "1", number-align: center, columns: 2)

= Introduction

== Program Background

Creating nanoscale structures is an inherently tricky task; it very hard achieve
the precision and rigidity to create useful structures.

In the 1980s Nadrian Seeman first realized that DNA possessed various unique
properties that made it an ideal candidate for synthesizing nanoscale structures
@originalSeeman. The strategic placement of Watson-Crick DNA base pairings allow
for the creation of extremely precise nanotubes since the base pairings could
hold created shapes together. The design process is quite tricky. What Seeman
created has come to be known as the field of _Structural DNA Nanotechnology_,
the study of using DNA in general to create nanoscale structures, for various
purposes, including non-biological applications.

#figure(
  image("./resources/nanotube.png", width: 50%), caption: [Example DNA Nanotube @shermanNanotubeDesign],
) <fig:example-nanotube-rendering>

The basis for this work is William B. Sherman and Nadrian C. Seeman's paper,
_Design of Minimally Strained Nucleic Acid Nanotubes_, which goes into depth
about the process of designing specifically tubular DNA nanostructures. Their
initial paper was mostly theoretical, but provided an example spreadsheet based
for the design process.

#figure(
  image("./resources/natug2.png", width: 90%), caption: [NATuG 2 Desktop Application],
)

Eventually, a second iteration of the _Nucleic Acid Nanotube Grapher_ program
(NATuG) was produced, as a desktop application. It was much better at graphing
the nanotubes, but the project failed to consistently handle joining different
double heleces together, due to how the program was designed.

This paper introduces _NATuG 3.0_, a new, final iteration. _NATuG 3.0_ is a
cross platform desktop application that aims to make the nucleic-acid design
process simpler and easier than any other program or iteration of NATuG. NATuG
provides an intuitive interface, allowing one to customize and visualize the
nanotube shape, weave together helices in a matter of clicks, and apply/export
sequences, while also being highly configurable and allowing for convenient
exporting and importing of standardized file formats.

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

= User Flow

== Program Overview

There are two primary regions of the app, the _Side View Plot_ -- a central
component where users can interact directly with the strands of the DNA
nanotube. You can think of it sort of like a Mercator projection, where we "unroll"
the DNA. To the left is the _Top View Plot_, which displays what the overhead of
the nanotube looks like.

The _Side View Plot_ is modal. There are current 5 modes: _Informer_, to get
information on given points; _Juncter_, to conjoin strands, "weaving together"
the nanotube; _Nicker_, to "cut" up DNA strands; _Linker_, to connect arbitrary
pieces of DNA strands; and _Highlighter_, to highlight points.

On the _Config Panel_ on the right side of the program, there is a few tabs, the _Nucleic Acid Tab_,
for editing DNA parameters; the _Domains Tab_, for placing the double helices;
the _Sequencing Tab_, for choosing the DNA sequences; and the _Snapshots Tab_,
for setting the bases for the DNA.

== Typical Usage

To design a nanotube in NATuG, you follow many of the same steps as if you were
to do it manually.

1) You set up DNA parameters in the _Nucleic Acid Tab_.

2) You place the double helices in the _Domains Tab_. You can play around with
the angles and watch the _Top View Plot_ automatically update. You can click
between domains to "dent" them inwards or outwards and automatically adjust the
angles. Various datapoints are presented to help you ensure that the shape you
design closes.

3) You enter "conjunct" mode and connect the strands together. NATuG is smart
and will automatically figure out where the new strands end up leading from and
going to. It colors everything automatically, and you can configure the style of
most things by clicking on them to get a style dialog.

4) You can "nick" strands to cut them up, and then "link" them back together.
You can set the sequences of the linkages as you go.

5) You assign sequences in the _Sequencing Tab_, or by clicking on strands and
manually setting sequences. NATuG supports loading in the base pairs of common
viruses. Finally, you can export the sequences to a spreadsheet for synthesis.

= Technical Overview

The program is written in `Python`, with `PyQt6`, and `pyqtplot`. It takes
advantage of a number of different helpful `python` frameworks, like `numpy` and `pandas` for
optimizations and implementing certain features.

=== Program Design

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
the sequence editor that autofills the corresponding bases to prevent mistakes,
or the domain angle chooser.

===== Conjuncting Strands

One of the most important features of NATuG is being able to "conjoin" strands.
Given two arbitrary NEMids, we want to be able to cut and then reroute the
strands. Sometimes this will result in loops, which we need to deal with.

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
same strand or two different strands. Then, we check to see if the strands that they lie within are closed or open. 

If the overlapping NEMids are in the same strand, and the strand that they are
in is an open strand, then one of the new strands will be an open strand, and
the other strand will become a closed loop strand. If the NEMids are in the same
strand, and the strand that they are in is an closed-loop strand, which will be
split into two smaller closed-loop strands.

On the other hand, if the NEMids are in two different strands, things are more
complicated.

If the NEMids are in different strands, and one of the NEMids is in a closed
strand, and the other NEMid is in an open strand, then a closed loop is being
opened back up.

If the NEMids are in different strands, but both strands are open strands, the
result will be two open strands that traverse multiple domains.

2B is most common when creating a cross-strand exchange between two vertical
helices in two different domains (pictured), but can occur with two adjacent
inter-domain strands that are both open as well.

And, lastly, if the NEMids are in different strands, but both strands are
closed, then two closed-loop strands are being connected to form one larger
closed-loop strand.

=== Data Exchange

NATuG supports exporting and importing of program states to various degrees of
granularity.

You can export and import the entire program program state as a `.natug` file,
which is a `zip` archive containing metadata about every unique artifact
currently specified in the system. It is sometimes redundant, since we could
recompute the artifacts given the configuration, but allows for very quickly
loading back in the data.

You can also export and import certain parts of the program state by themselves,
to use as templates for various different types of nanotubes. For example, DNA
parameters in the _Nucleic Acid Tab_ are stored in simple `json` files and
profiles automatically get loaded in/can be exported. Likewise, the arrangement
of domains can be imported/exported to `csv`s.

Finally, it is still a significant work in progress, but there are plans to
support exporting the entire program state to a spreadsheet for portability
outside of the program. Spreadsheets are popular among professionals in the
field, and are relatively easy to analyze.

== Next Steps

As this iteration of NATuG is completed, a paper is in the process of being
drafted on various algorithms and functionalities of the program. In the
process, we have been increasingly considering our end users: NATuG is very good
at designing tubular structures, but since it is relatively intuitive and simple
to use compared to alternatives, and given how configurable it is, it also is
suitable for non-tubular structures as well.

#bibliography("works.bib")

