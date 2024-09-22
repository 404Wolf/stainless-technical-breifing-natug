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

= Using The Program

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

In the _Nucleic Acid Tab_, users can adjust geometrical nucleic-acid settings ,
such as diameter, helical turns, and angles. Th.e tab includes a Profile
Manager, allowing users to save and load different nucleic acid profiles for
quick adjustments. This feature is particularly useful for experimenting with
different DNA configurations and observing how changes affect the overall
structure.

Moving to the _Domains Tab_, users can define the shape of the nanotube by
setting the interior angles between domains. The tab provides comprehensive
controls for managing symmetry with subgroups. It also lets you choose the
number of nucleosides per strand.

The _Sequencing Tab_ is dedicated to nucleotide sequence assignment. Here, users
can perform bulk operations to randomize or clear sequences across all strands
or only those without assigned bases. This feature streamlines the process of
assigning sequences, ensuring that the designed nanotube meets specific
experimental requirements. There is also support for exporting the sequences of
all the strands, so that you can send them to a company for synthesis.

== Modal Side View Interaction
The _Side View Plot_ is an interactive visualization tool that represents the
nanotube's double helices in a two-dimensional "unrolled" view.

For complex designs involving long strands or multiple repetitive actions, there
is an _Action Repeater_ feature, where all clicks get repeated in some direction
some number of times.

This is a "modal" editor view because clicking on artifacts within this view do
different things based on your "mode."

=== Informer Mode

Clicking on any point provides detailed information about that specific
nucleoside or NEMid, like coordinates, angle, strand index, and base.

=== Juncter Mode

Allows users to create cross-strand junctions by clicking on overlapping NEMids,
enabling strands to weave across multiple domains and forming a cohesive
nanotube structure.

=== Nicker Mode

Clicking on NEMids introduce nicks in the strands, effectively splitting a
strand into two separate strands at the selected point.

=== Linker Mode

Enables the connection of the ends of two strands to form longer strands or
loops. Users can customize the linkage, including adding nucleosides and setting
sequences for these regions.

=== Highlighter Mode

Provides the ability to highlight specific nucleosides or NEMids for emphasis,
useful for presenting.

== Uses

== Features

== Technical Overview

=== Program Design

==== Frameworks

==== Layout

==== Data Structures

=== Notable Algorithms

=== Top View Computation

=== Side View Computation

=== Conjuncting strands

=== Data Exchange

== Current State

=== Packaging

=== Paper

#bibliography("works.bib")

