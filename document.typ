#let title = "Nucleic Acid Nanotube Grapher"
#let author = "Wolf Mermelstein"

#set document(author: author, title: title)
#set cite(form: "author")
#show cite : it => [
  (#emph(it))
]

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

#figure(
  image("./resources/nanotube.png", width: 50%), caption: [Example of a DNA Nanotube @shermanNanotubeDesign],
) <fig:example-nanotube-rendering>

#v(0.05in)

Creating nanoscale structures is a tricky task, as it is hard to achieve
precision and rigidity at such small scale. One unique way is with _Structural DNA Nanotechnology_,
a field of biochemestry that uses DNA as a nanoscale building block. Instead of
using DNA for its biological purpose, one can program base sequences so the DNA "automatically"
combines to form predetermined custom structures.

Here, we focus on tubular nanostructures. A _DNA nanotube_ is made by placing
double helices adjacently, "weaving" them together to create a larger tube (see
@fig:example-nanotube-rendering). They can be used to study cellular membrane
proteins with NMR, for drug delivery, optics, and more.

The theory for the design processes that NATuG (Nucleic Acid Nanotube Grapher)
facilitates are laid out in William Sherman and Nadrian Seeman's paper, _Design of Minimally Strained Nucleic Acid Nanotubes_ @shermanNanotubeDesign.

They introduce an Excel tool to help design DNA nanotubes with specialized plots
(see @fig:natug-1). Eventually, this was reimplemented at Brookhaven National
laboratory as a desktop application (@fig:natug-2). It was better at graphing,
but failed handling "weaving" _multiple_ strands together, and was designed in a
nonmodular way, restrictive to further development.

This briefing introduces _NATuG 3.0_, a significantly more feature-rich
iteration of the program. I, Wolf Mermelstein, was responsible for all software,
and worked closely with Dr. William Sherman to implement his DNA nanotube design
methodologies.

NATuG is a Python application available via `pypi` or `nix`

```bash
pip install natug && natug
nix run "github:natug3/natug"
```

#figure(
  scope: "parent", placement: auto, grid(
    gutter: 0.25in, columns: (1.67fr, 1fr), [
      #figure(
        image("./resources/natug2.png", width: 90%), caption: [NATuG 2.0 Desktop Application],
      ) <fig:natug-2>
    ], [#figure(
        image("./resources/natug1.png", width: 90%), caption: [NATuG 1.0 Excel Spreadsheet],
      ) <fig:natug-1>],
  ),
)

== Designing DNA Nanotubes

Designing DNA nanotubes is a complex process, but it is helpful to have an idea
to understand what NATuG does.

To design a DNA nanotube, first you choose a type of nucleic acid, like "B-Form
DNA", defining parameters like the diameter.

#v(.05in)
#[
  #set figure.caption(position: top)
  #figure(
    [
      #set figure.caption(position: bottom)
      #v(0.025in)
      #grid(
        columns: 2, gutter: .1in, figure(
          image("./resources/top-view-example-2.png", width: 80%), caption: [Domain \#2 has a small angle (see angle between \#1 \#2 and \#3)], numbering: none,
        ), figure(
          image("./resources/top-view-example-1.png", width: 80%), caption: [Domain \#2 has a big angle (see angle between \#1 \#2 and \#3)], numbering: none,
        ),
      )
    ], caption: [Choosing the shape of the nanotube by setting angles between helical domains],
  ) <fig:top-view-example>
]
#v(.05in)

#figure(
  scope: "parent", placement: auto, grid(
    gutter: 0.25in, columns: 2, [#figure(
        image("./resources/cross-strand-exchange.png", height: 1.6in), caption: [Creating a cross-strand exchange],
      ) <fig:cross-strand-exchange>], [#figure(
        image("./resources/holliday.png", height: 1.6in), caption: [A 4 way Holliday junction],
      ) <fig:holliday-junction>],
  ),
)

Then, you find a tube shape by strategically setting angles between _helical domains_ (the
area that the DNA double helices take up) (see @fig:top-view-example).

Now you create cross-strand exchanges to hold the structure together (see
@fig:cross-strand-exchange), redirecting strands, some what like Holliday
junctions (see @fig:holliday-junction).

#figure(
  scope: "parent", placement: auto, image("./resources/staple-strands.png", height: 2in), caption: [DNA staple strands @unsw2017capsid],
) <fig:staple-strands>

Then, you cut strands to create "staple" strands. Usually, one long virus strand
will run through the structure, and be "stitched" together (see
@fig:staple-strands) (synthesizing custom DNA is expensive and restricted to
short lengths).

Finally, you choose base sequences and send for synthesis.

#pagebreak()

= The NATuG Program

#figure(
  scope: "parent", placement: bottom, block[#grid(
      columns: (1.5fr, 1fr), gutter: 0.6in, [#figure(
          image("./resources/program-overview.png", height: 2.625in), caption: [NATuG Program Layout],
        ) <fig:program-layout>], [#figure(
          image("./resources/creating-cross-strand-exchanges.png", height: 2in), caption: [You can create cross-strand exchanges in "juncter" mode with just a click, "weaving"
            together helical domains],
        ) <fig:creating-cross-strand-exchanges>],
    )
    #v(0.15in)],
)

NATuG is a custom-made desktop application to streamline this process. The UI is
broken up into panes for focus on one step at a time (see @fig:program-layout);
a flow similar to doing it "manually."

The _Side View Plot_ (center region) displays an "unrolled" view. It is modal;
modes determines what clicks do, like having clicking between DNA bases create
strand-exchanges, or break apart DNA strands. The _Top View Plot_ (left side) is
a "bird's eye" view of the tube.

The plots update live and are interactive. For example, you can click in the _Top View Plot_ to
modify angles in certain ways.

The _Config Panel_ (right side) has tabs for configuring parameters. For
example, entering DNA parameters, placing the double helices, or setting base
sequences.

You can then click on nucleoside midpoints to create cross-strand exchanges (see
@fig:creating-cross-strand-exchanges). You can chop-up strands and create
linkages. You assign sequences in the _Sequencing Tab_, or by clicking on
strands.

Finally, you can export the sequences to a spreadsheet for synthesis.

= Technical Overview

NATuG is a `Python` application that uses `PyQt6`, and `pyqtplot` for graphics.
It takes advantage of a `numpy` and `pandas` for vectorizing optimizations and
for features like file exports.

=== General Design

NATuG follows `oop` principals for managing state and exposing functionality.
References off a "runner" object provide a source of truth for state, and "manager"
instances are passed along to UI elements to access and update parts of it. In
the future, it will be possible to have multiple `Runners`, to edit multiple
nanotubes simultaneously.

Biological structures are represented using special data structures designed to
be as simple/modularized as possible. For instance, it is common in nanotube
design to take advantage of symmetries for choosing angles between helical
domains. NATuG stores `Domain`s in groups called `Subunit`s, which go into `Subunits` collection.
This lets us do nice things like modifying or intelligently exporting angles of
all symmetrical groups at once.

#figure(
  scope: "parent", placement: bottom, block[
    #grid(
      columns: (1fr, 1fr), [#figure(
          image("./resources/sequence-editor-manual-input.png", height: 2in), caption: [Custom base pair sequence editor/entry modal],
        ) <fig:bp-editor>], [#figure(
          image("./resources/domain-config-table-counts.png", height: 2in), caption: [Domain triple spinbox container for choosing the number of nucleosides per
            strand],
        )],
    )
  ],
)

`PyQt` is somewhat restrictive; it ships with predefined widgets and it is
annoying, but sometimes necessary, to compose complex new ones, like the
sequence editor that auto-fills the corresponding bases to prevent mistakes (see
@fig:bp-editor). Designing custom widgets like this is tricky, both technically,
and because there are usage implications to consider.

=== Plotting

The first iteration of NATuG was a spreadsheet, and used non-interactive
spreadsheet plots. NATuG 2.0 used `Matplotlib`, which was considered for NATuG
3.0. Ultimately, we chose `pyqtgraph`, a very powerful plotting library designed
for great support with PyQt, because of its real time capabilities and deep
interactivity.

NATuG is able to compute the positions of all of the `Point`s (e.g. DNA
nucleosides) by first computing their angles as they spin about their helices,
and then converting those angles to $x$ coordinates, while the $z$ coordinates
grow steadily.

Computing the _Top View Plot_ is more straight forward. Starting at the first
domain, we place each domain relative to the previous at some angle
displacement. It is useful to be able to determine which domain in this plot
corresponds to which in the _Side View Plot_; clicking domains navigates to
them, but in the future we may add color coding.

=== Conjuncting

The most interesting algorithm within NATuG is the strand "conjoining" feature.

Given two arbitrary midpoints between nucleosides, we want to be able to cut and
then reroute the strands. Sometimes this will result in loops, which we need to
deal with.

#figure(
  scope: "parent", placement: top, block[
    #figure(
      image("./mermaid/out/conjoin-graph.png", width: 100%), caption: [All the unique ways NATuG has to handle resolving clicks on junctions #v(0.07in)],
    ) <fig:junction-conjoin-tree>

    #figure(
      [
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
      ], caption: [Examples for all the possible junction cases],
    )
  ],
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

#bibliography("works.bib", full: true)

