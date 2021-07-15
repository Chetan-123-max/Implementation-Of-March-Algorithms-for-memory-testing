# Implementation-Of-March-Algorithms-for-memory-testing
Implemented as a part of a mini project for the course Memory design and testing at PES University

MARCH algorithms are a set of deterministic pattern generator algorithms used in
testing of memory cores as they provide a good fault coverage. Some of the common
MARCH algorithms include MARCH C, MARCH C-, Enhanced MARCH C- and MARCH
A. Each of these algorithms come with their own range in terms of the type of faults they
cover.
In this project we will design a small N x N Memory model and design a state machine
which uses these MARCH algorithms to determine the addressing order and the data to
be written into the memory cells.
Faults such as stuck-at, transition, coupling and multiple select address will be injected
into the memory model and detected using the implemented state machine running the
MARCH algorithm.
Finally a comparison between several different MARCH algorithms will be made in
terms of their ability to cover faults by providing the related simulation results.Why MARCH algorithm?
A manufacturing defect is a physical problem that occurs during the manufacturing
process, causing device malfunctions of some kind. The purpose of test generation is to
create a set of test patterns that detect as many manufacturing defects as possible.
The basic types of memory faults include stuck-at, transition, coupling and
neighbourhood pattern-sensitive.
MARCH being a deterministic pattern generator is usually employed in BIST
architectures which in comparison with the pseudo random generators provide a better
fault coverage in testing of the embedded memories.

How to run?
If you have the vivado xilinx tool installed: Just download the repo and run the MDT.xpr file to launch the project in vivado xilinx tool.
Otherwise download the verilog files from the MDT.srcs folder to run on any other platform
