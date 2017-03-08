# Tipspace

A tipspace is a overriding conglomeration of directory trees.

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

Information is inserted at as many places as coherent. For example, Frank Herbert's Dune would be resolvable through (roughly):

* .../book/by/Frank Herbert/Dune/
* .../book/Frank Herbert: Dune/
* .../series/by/Frank Herbert/Dune/Dune/
* .../series/by/Frank Herbert/Dune/1/
* .../award/Hugo/1966/Best Novel/winner/
* .../award/1966/Hugo/Best Novel/winner/
* etc…

I want to go to an overriding compilation for the resolution, so I have a directory:

.../software/Tip/config/base/

With an ordered set of symlinks:

* 1 → ipfs:QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG
* 2 → ipfs:QmP9xigWettR229mBvq2oFbSqhZ3PVijVGAyqPwTRfJ718
* 3 → ipns:dhappy.org/.../
* 4 → ipfs:QmZ8qhLpcZkF3JZ6zmrZCgVn5d54P78fFJ4BTWjR38zZ51
* 5 → ipfs:QmQ3ejGoMG2o2m6HY7c3pHn94oAi3fxXJXXeRNiWSJ2RAN

When someone attempts to resolve .../book/Frank Herbert: Dune/ the systems goes down the list checking each entry for /book/Frank Herbert: Dune/.

This allows curated collections to contain .../award/Hugo/1966/Best Novel/winner/ → .../book/by/Frank Herbert/Dune/ without publishing the actual content.

This message marks the beginning of an implementation which ought to take shape in: https://github.com/dhappy/tip. Are there any reasons this is unreasonable, or ways it could be made more efficient?
