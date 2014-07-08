Packaging Status
================

2014-07-08 21:06 UTC
--------------------

Additional packages added.  All currrently work with octave* and fink-octave-packages from this repository,
apart from fem-fenics, which has been stashed in the `libs/octmods-work-in-progress` directory.

2014-07-06 19:51 UTC
--------------------

Additional packages added.  All currrently work with octave* and fink-octave-packages from this repository.

2014-07-05 18:53 UTC
--------------------

Existing fpl (1.3.4) and new upstream msh (1.0.10) and splines (1.2.7) work.
These and their older colleagues have been converted to use fink-octave-scripts.

2014-07-05 13:47 UTC
--------------------

New upstream bim (1.1.4) works with octave-3.8.1 and octave-3.6.0.  It's supposed to be
for Octave 3.6.0 and later, so we can call that done.
Older bim packages have been converted to use fink-octave-scripts.

2014-07-24 23:35 UTC
--------------------

octave305 also works.

2014-07-24 21:53 UTC
--------------------

octave324, 343, 360-364, and 381 appear to be doing the right thing.
octave305 is currently in testing.

I'll start with Octave-forge packages afterwards.

fink-octave-scripts replaces older octave3*-dev so that it can take charge of oct-cc and oct-cxx.
Current octave3*-dev have Depends: fink-octave-scripts (>=0.3.0-1).
