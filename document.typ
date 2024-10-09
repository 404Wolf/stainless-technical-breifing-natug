#import "./lovelace.typ": pseudocode-list

#let title = "Nucleic Acid Nanotube Grapher"
#let author = "Wolf Mermelstein"
#set document(author: author, title: title)

#set page("us-letter", margin: 1in, header: [
  #set text(12pt)
  #author
  #h(1fr)
  NATuG Technical Brief
], footer: [
  #counter(page).display() #h(1fr)
])

#align(center + horizon)[
  #move(dy: -0.50in)[
    #block(text(weight: 700, 1.75em, [
      #title \ Technical Brief \
      #text(size: 12pt)[for Stainless Interview]
      #v(.5in)
    ]), below: 0.15in)
    #v(.25in)
    #block(text(1.25em, author))
  ]
]

#pagebreak()

#set page(numbering: "1", number-align: center, columns: 2)

= Introduction

== Background

=== Structural DNA Nanotechnology

Creating nanoscale structures is tricky task, as it is hard to achieve adequate
precision and rigidity at such small scale. One unique way to do so is through _Structural DNA Nanotechnology_,
a field that uses DNA as a building block for such structures. Instead of using
DNA to encode information, one can program sequences into where the DNA "automatically"
combines to form predetermined structures.

#figure(
  image("./resources/nanotube.png", width: 50%), caption: [Example DNA Nanotube @shermanNanotubeDesign],
) <fig:example-nanotube-rendering>

Here, focus is given to designing tubular nanostructures -- nanotubes. A _DNA nanotube_ is
a structure made by placing double helices adjacent to each other and then
weaving them together so that you create one larger tube shape (see
@fig:example-nanotube-rendering). One way to think of it is as if each DNA
double helix were a log, and you create a bundle of logs. DNA nanotubes have a
lot of interesting applications, including studying cellular membranes, drug
delivery, and potentially optics.

The theory for the design processes that the NATuG program facilitates are laid
out in William Sherman and Nadrian Seeman's paper, _Design of Minimally Strained Nucleic Acid Nanotubes_ @shermanNanotubeDesign.

#figure(
  image("./resources/natug2.png", width: 90%), caption: [NATuG 2 Desktop Application],
) <fig:natug-2>

They introduce an Excel tool to help design DNA Nanotubes by generating special
projection plots detailed in their paper. Eventually, the spreadsheet was
reimplemented at Brookhaven National laboratory as a desktop application
(@fig:natug-2). It was better at graphing, but failed to consistently handle "weaving"
helical domains together, and was designed in a nonmodular way that was
restrictive to further development.

This technical briefing introduces _NATuG 3.0_, a final iteration of the Nucleic
Acid Nanotube Grapher desktop application (NATuG). I, Wolf Mermelstein, was
responsible for all of the software, and worked closely with Dr. William Sherman
to implement his DNA nanotube design methodologies.

NATuG is a Python application available via `pypi`, and you can try it out by
running `pip install natug` (ideally in a virtual environment), or with nix by
running `nix run github:natug3/natug`.

== Designing DNA Nanotubes

Designing DNA nanotubes is a complex process, but it is helpful to have an idea
of the steps to understand what NATuG does.

To design a DNA nanotube, first you choose a type of DNA. This involves finding
parameters for it, like the diameter.

Then, you find a tube shape consistent with its geometry by strategically
setting angles between helical domains (see @fig:top-view-example).

#figure(
  image("./resources/cross-strand-exchange.png", height: 1.45in), caption: [Creating a cross-strand exchange],
) <fig:cross-strand-exchange>

#figure(
  image("./resources/holliday.png", height: 1.9in), caption: [A 4 way Holliday junction],
) <fig:holliday-junction>

Now you create cross-strand exchanges to hold the structure together (see
@fig:cross-strand-exchange). The key is that we "redirect" the path of DNA, some
what like is the case in Holliday junctions, a naturally occurring phenomena (see
@fig:holliday-junction).

#figure(
  image("./resources/staple-strands.png", width: 100%), caption: [DNA staple strands @unsw2017capsid],
) <fig:staple-strands>

Then, you cut up the strands to create "staple" strands, typically where one
long virus strand runs through the entire structure, and smaller synthetic
strands hold it together (see @fig:staple-strands).

Finally you choose the base sequences, and send to a lab for synthesis.

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

#pagebreak()

= The NATuG Program

#figure(
  image("./resources/program-overview.png", width: 100%), caption: [NATuG Program Layout],
) <fig:progrma-layout>

NATuG is a custom made desktop application designed to streamline this process.
The UX is designed for working on one step of the process at a time, and the
program is broken up into panes.

The _Side View Plot_ displays an "unrolled" view of the DNA. This view is modal;
modes determines what clicks do, like "juncter" mode, where clicking on
midpoints between DNA bases creates strand-exchanges, or "nicker," where clicks
break apart DNA strands. The _Top View Plot_ is a bird's eye view. You can click
on a helical domain and it redirects you to it in the _Side View Plot_.

On the _Config Panel_ on the right side, there are config tabs, like the _Nucleic Acid Tab_,
for editing DNA parameters; the _Domains Tab_, for placing double helices; the _Sequencing Tab_,
for setting DNA sequences.

#figure(
  image("./resources/creating-cross-strand-exchanges.png", height: 2.25in), caption: [You can create cross-strand exchanges in "juncter" mode with just a click],
) <fig:creating-cross-strand-exchanges>

To design a nanotube in NATuG, you follow many of the same steps as if you were
to do it manually.

First, you choose DNA parameters in the _Nucleic Acid Tab_. Then, you set angles
between double helices in the _Domains Tab_, which provides you with various
tools to help the tube stay closed.

The plots of the nanotube update live, and are interactive. You can click in the _Top View Plot_ to
modify angles in certain ways.

You can then click on nucleoside midpoints to create cross-strand exchanges (see
@fig:creating-cross-strand-exchanges). You can chop-up strands, and create
linkages. You assign sequences in the _Sequencing Tab_, or by clicking on
strands.

Finally, you can export the sequences you need to synthesis.

= Technical Overview

NATuG is a `Python` application that uses `PyQt6`, and `pyqtplot` for graphics.
It takes advantage of a `numpy` and `pandas` for vectorizing optimizations and
for implementing features like file exports.

=== General Design

The program design heavily follows `oop` principals for managing program state
and exposing functionality. References off a global "runner" object provide a
source of truth for state, and "manager" objects that are passed along to UI
elements can access and update parts of it. In the future, this means it will be
possible to have multiple `Runners` to edit multiple nanotubes simultaneously.

The various biological structures are represented using special data structures,
and significant effort has gone into making these as simple/modularized as
possible. For example, it is common in nanotube design to take advantage of
symmetries for choosing angles between helical domains. NATuG stores `Domain`s
in groups called `Subunit`s, which go into one big `Subunits` collection, which
is a property of `Domains`. This lets us do nice things like modifying or
intellegently exporting angles of all symmetrical groups of `Domains` at once.

#figure(
  image("./resources/sequence-editor-manual-input.png", height: 2in), caption: [Custom base pair sequence editor],
)

#figure(
  image("./resources/domain-config-table-counts.png", height: 2in), caption: [Domain triple spinbox container],
)

`PyQt` is somewhat restrictive; it ships with predefined widgets and it is
annoying to compose complex new ones, but some custom ones needed to be made,
like the sequence editor that auto-fills the corresponding bases to prevent
mistakes. Designing custom widgets like this is tricky, technically, and because
there are usage implications to consider.

=== Plotting

The first iteration of NATuG was a spreadsheet, and used non-interactive
spreadsheet plots. NATuG 2.0 used `Matplotlib`, which was considered for NATuG
3.0. Ultimately, we chose `pyqtgraph`, a very powerful plotting library designed
for great support with PyQt, because of its real time capabilities and deep
interactivity.

NATuG is able to compute the positions of all of the `Point`s (e.g. DNA
nucleosides) by first computing their angles as they spin about their helices,
and then converting those angles to $x$ coordinates, while the $z$ coordinates
just increase at a steady pace. This algorithm is roughly defined in Sherman and
Seeman's paper. NATuG implements it with numpy.

Computing the _Top View Plot_ is more straight forward. We begin at the first
domain, and then draw by placing each domain relative to the first at some angle
displacement off from the previous one. It is useful to be able to determine
which top view domain in the plot corresponds to the domains in the side view
plot; for now, you can click on a domain to visit it, but in the future we may
add color coding.

=== Conjuncting

The most interesting algorithm within NATuG is the strand "conjoining" feature.

Given two arbitrary midpoints between nucleosides, we want to be able to cut and
then reroute the strands. Sometimes this will result in loops, which we need to
deal with.

#figure(
  image("./mermaid/out/conjoin-graph.png", width: 100%), caption: [All possible cases], scope: "parent", placement: auto,
) <fig:junction-conjoin-tree>

#v(0.15in)

#figure(
  scope: "parent", placement: auto, [
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
  ], caption: [All case figures],
)

Generally, how to create a junction is intuitive. NATuG handles breaking down
the cases based on whether the two points are along the same strand, and whether
the strand(s) are open; for all the cases, see @fig:junction-conjoin-tree.

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

As this iteration is completed, a paper is being drafted on program
algorithms/functionalities. We have been increasingly considering end users:
NATuG is very good at designing tubular structures, but since it is relatively
intuitive and straight forward, it also is suitable for non-tubular structures
as well, and potentially educational purposes.

#bibliography("works.bib")

