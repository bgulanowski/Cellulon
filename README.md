# Cellulon

A simple demonstration of cellular automata on iOS.

There are three working view controllers. (TODO: hide the Metal tab and/or implement 2D CA in Metal.) The first shows a collection of 1D automata visualized in 2D (so I call it "1.5D"). You can view a higher detail version, and tweak some options.

The second shows Conway's Game of Life implemented on the CPU and rendered with a bitmap. Both the 1.5 and CPU 2D versions use a custom data storage model called a "Grid". Shows off combining a genericized class and a protocol.

The third is empty, a Metal implementation, not done.

The fourth is Game of Life in an OpenGL ES 3.0 shader. Requires a sufficiently modern iOS device and iOS 9.0+, or runs fine in simulator. The OpenGL ES framework is accessed through a light wrapper, with a few nice features thanks to Swift generics.

Relies on https://github.com/bgulanowski/Grift, a Swift wrapper for OpenGL.
