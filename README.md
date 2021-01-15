# Defect-Detection Experiment

This repository has the materials required for replicating a defect-detection
experiment that was developed by Basili/Selby in 1985 and extended by Kamsties/Lott
in 1994. Both English- and German-language versions are included here.  These
materials were used to replicate the experiment at the University of Kaiserslautern,
Germany and at the University of Strathclyde, Scotland.  Before using this kit,
you should get a copy of the Uni-KL technical report and read about the procedures
used to run the experiment.

## Update 2021

I don't think many computer science departments are teaching the C language anymore.
And the code usage messages are all in German, so that might further limit the use!
But in the hope that someone might still find value here, I updated these materials
lightly as part of a move to Github.  This included adding some include directives
to source code, switching to pdflatex, dropping use of tgrind, etc. The code compiles
and runs! But the structural-test technique is still written to require on Brian Marick's
generic coverage tool (gct) which is obsolete.

## Manifest

These materials include six C-language programs: three for training participants on
the reading and testing techniques, and three more for running an experiment.

- BasiliSelby/    FORTRAN programs and specs from the 1985 experiment
- Makefile        Makefile used to start recursive make in all directories
- Makefile.latex  Makefile used to generate and print LaTeX documents
- common/         Driver sources shared among the programs
- lecture/        Slides that can be used to lecture subjects on techniques
- e-cmdline/      Materials for experiment program "cmdline"
- e-nametbl/      Materials for experiment program "nametbl"
- e-ntree/        Materials for experiment program "ntree"
- e0-overview/    Overview of the experiment for participants
- e1-doc-cr/      Instructions for code reading
- e2-doc-ft/      Instructions for functional testing
- e3-doc-st/      Instructions for structural testing
- t-count/        Materials to train participants on program "count"
- t-series/       Materials to train participants on program "series"
- t-tokens/       Materials to train participants on program "tokens"
- texinputs/      Support files for LaTeX


## Documents 

The documents in the directories named `e?-doc-??` are not specific to
any particular objects.  They are suitable for use during the training
phase and the live experiment.  The documents in the directories `t-*`
and `e-*` are the code objects and accompanying materials for the
(t)raining phase and live (e)xperiment.  Some of the documents include
Unix path names that particpants should use to fetch the necessary
files.  This path names are marked with the LaTeX environment "path"
so that they show clearly in the output; they should be simple to find.
If you're a perfectionist, you may want to fuss with the pagination to
avoid documents with one line on the last page; there are a few.

## LaTeX

You will need the LaTeX document formatting system to format and print
the various files.  You can use LaTeX2.09 (the old version as of this
writing) or LaTeX2e (the new version).  You must install the `listings`
package so source code can be included in LaTeX documents.
To get started:

   0. Download and install listings:<br>
      https://ctan.org/tex-archive/macros/latex/contrib/listings/
   1. Edit "texinputs/language.sty" to specify either English or German.
   2. Edit "texinputs/paper.sty" to specify either USLetter or A4.
   3. Edit "texinputs/expconfig.sty" to add other fixups as needed.
   4. Make the files available to LaTeX.  You can do this either by
      setting the TEXINPUTS variable to include the texinputs/ dir
      or by copying them to a directory already on your TEXINPUTS path;
      for example: <br>
      `export TEXINPUTS=/path/to/defect-detect-expt/texinputs:`
   5. See the notes about the Makefiles below.
   6. Once everything is configured, the command "make" can be
      issued in this directory to format all the documents. 

## Makefiles

A central Makefile.latex (in this directory) specifies all details on
how the LaTeX formatter is invoked and how documents are spooled to
the printer.  All directories with LaTeX documents have a tiny stub
Makefile that includes the master Makefile.latex.  You will certainly
want to change the PRINTER variable in the master Makefile.latex.  You
may also need to edit the LATEX variable (what the LaTeX formatter is
called at your site), the way that dvi files are printed, etc.

## Source code

You will need a C compiler such as the GNU C compiler (gcc) to build
the objects.  You will also need a structural testing tool such as
GCT, the Generic Coverage Tool by Brian Marick, to build the objects
for structural (coverage) testing.  The objects are built using a
driver + body.  Participants see the source code to body but are
unaware of the existence of the driver.  The build process that is
defined in the Makefiles renames the main() function of the body
to mymain() and uses the main() from the driver.  The driver sends
mail upon each invocation of the program to a known address with the
command line and the contents of any supplied data files, then invokes
the main program of the body.  This allows the experimenter to collect
data unbeknownst to the participant.  The known email address is
encoded in an include file.  (See the source and notes in directory
common/.)

## Files for the participants.

The object directories e-* and t-* include subdirectories dir-*-test
that hold all the files needed by a participant in the experiment. 
The Makefiles copy the necessary executable into these directories
automatically.  The target "make tar" will create tar files under
/tmp that subjects should unpack in their own directories as one of
the first steps.  

## Final words

I have tried to avoid redundancy and make this kit of materials as
portable, flexible, and easy to use as possible.  Doing so entailed
providing the necessary LaTeX style files, dealing with documents in
two languages, building a system of Makefiles to format the documents
and compile the code objects, etc etc.  Each LaTeX document lives in
its own directory, a decision which was perhaps not the best choice.
This was surprisingly complex and various problems are certainly lurking
in the materials.  I would very much appreciate hearing about problems
and your solutions.  Although I cannot dedicate a large amount of time to
supporting this kit, I will definitely answer questions.  Thank you
for your interest.  I wish you the best of luck in using this kit.
I've enjoyed working with this experiment very much and learned a
tremendous amount, I hope that your efforts will meet with success.
