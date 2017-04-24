# Tipspace

A tipspace is an exploration in potentials for extension to the traditional unix filesystem.

There are two primary differences:

* Additive Mounts: Multiple filesystems may be mounted at the same location and their contents are conglomerated. This opens the doors to collisions. Currently, those are handled by always taking the first instance encountered.
* Relative Root: The special directory `...` recurses up the directory tree checking at each level for the presence of the requested file.

For example, Bob might publish a tree of symlinks of the format:

.../award/Hugo/Best Novel/#{year}/ → .../book/by/#{author}/#{title}/
.../award/Hugo/#{year}/Best Novel/ → .../book/by/#{author}/#{title}/

While Alice publishes:

* .../book/by/Frank Herbert/Dune/xhtml
* .../book/by/Frank Herbert/Dune/css
* .../book/by/Frank Herbert/Dune/cover/jpg

Files are named solely with their content type. This allows more flexible linking between semantic locations with dependencies.

Roger then creates a space in which paths are searched for in Bob's and Alice's trees sequentially.

All of Bob's links will be broken except:

* .../award/Hugo/Best Novel/1966/ → .../book/by/Frank Herbert/Dune/
* .../award/Hugo/1966/Best Novel/ → .../book/by/Frank Herbert/Dune/

All links are forward either relative to the current location, or through the "relative root": `...`.

Information is ideally inserted at as many places as unambiguous and comprehensible. For example, Frank Herbert's Dune would be resolvable through (roughly):

* .../book/by/Frank Herbert/Dune/
* .../book/Frank Herbert: Dune/
* .../series/by/Frank Herbert/Dune/Dune/
* .../series/by/Frank Herbert/Dune/1/
* .../award/Hugo/1966/Best Novel/winner/
* .../award/1966/Hugo/Best Novel/winner/
* etc…

In the browser, when an location is viewed, it can either be a file or directory.