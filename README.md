The project I have in mind is a single file structure to contain all the data.

Files are named solely with their content type, for example: [https://github.com/dysbulic/tip/blob/master/department/happiness/svg](http://dhappy.org/.../department/happiness/svg)

This allows linking between directories that doesn't break dependencies: [https://github.com/dysbulic/tip/blob/master/art/by/Will%20Holcomb/The%20DoH](http://dhappy.org/.../art/by/Will%20Holcomb/The%20DoH/)

There is a third special directory defined, ..., that, in the current implementation, is a symlink: ... → ../... in every directory except the root where ... → ..

All links are forward through the tree, either relative to the current directory or through ....

This both allows paths to resolve through symlinks over HTTP and for directories to be relocated without breaking links.

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

When someone attempts to resolve .../book/Frank Herbert: Dune/ the systems goes down the list checking each entry for /book/Frank Herbert: Dune/.

This allows curated collections to contain .../award/Hugo/1966/Best Novel/winner/ → .../book/by/Frank Herbert/Dune/ without publishing the actual content.

This message marks the beginning of an implementation which ought to take shape in: https://github.com/dhappy/tip. Are there any reasons this is unreasonable, or ways it could be made more efficient?
