# SymmetryExampleScripts
Example scripts for submitting compute jobs to Perimeter's Symmetry high-performance computing cluster.

*Symmetry* is Perimeter Institute's in-house computing cluster or
 "high-performance computer" (HPC).

We use the *Slurm* system to process *batch jobs*.  This is the main
way users run large (multi-node) compute jobs on Symmetry.

Symmetry currently (as of March 2021) has 76 regular compute nodes and
2 GPU nodes.

To use Slurm, you write a "batch script" that describes how many nodes
you want, for how long, which queue it should wait in, and a script of
what you want to run.  You submit this script to the batch system
using the `sbatch` command, and your job gets assigned a job ID and
then goes into a queue.  We have a few different queues to support
different kinds of computer use.  Once your job gets to the front of
the queue, it will get sent to one or more of the compute nodes and
run there.  Any output your job prints will get written to a file
named (by default) `slurm-<JOBID>.out` in the directory you were in
when you submitted the job.

## Parallel computing

There are three main ways that people do parallel computing to make
good use of the powerful nodes that Symmetry offers.  Programs such as
Mathematica, and libraries such as Python's NumPy, may use some of
these approaches, so that as a user you don't need to do anything
special to get a speed-up from using a Symmetry compute node.  These
methods are:

* multi-processing.  The program starts up multiple copies of itself,
 and splits the work among the copies.  This only works within a node.

* OpenMP.  This is an extension to programming languages such as C++
  that allow programmers to tell the compiler about available
  parallelism in the program.  This only works within a node.

* MPI.  This is the main way that multi-node parallel computing is
  achieved.  MPI provides a message-passing library that allows
  different copies of the program (running within or across nodes) to
  talk to each other.

## Queue details

The main queues you will want to use are the `debugq` and `defq`.
`debugq` has a 1-hour time limit, and is meant for quick turn-around
jobs.  A total of 8 compute nodes are dedicated to running `debugq`
jobs; the goal is for it to be very quick for people to get a node to
test out some code.  Please don't submit tons of jobs here; if you're
ready to run a big batch of jobs, please use the `defq`.  `defq` is
the "default queue", and is the main workhorse of Symmetry.  You can
use up to 32 nodes per job, and the time limit is 1 day.

Similarly, there is a `gpudebugq` and `gpuq` for the GPU nodes.

For long-running jobs (up to one week), we have the `longq`.

We also have a queue for people who want to scavenge all the compute
time they can get.  This `preq` (pre-emptible) will run jobs on any
spare computers, but jobs can get killed if any other job wants to
run.

Finally, when researchers need to do some computing that doesn't work
with our regular offerings, we can create a "reservation", setting
aside one or more nodes for their exclusive use.  The `reservedq`
allows access to those reservations.

## Computer node details

The way we have set up Slurm, most of the time we allocate full
compute nodes to a job (users do not share nodes).

The regular compute nodes have 2 CPUs, each with 20 cores, and
supporting 2 "hyper-threads".  Slurm counts hyper-threads as "cpus",
so as far as it is concerned, the compute nodes have 80 "cpus".  The
regular compute nodes have 192 GB of memory.

The GPU nodes have one CPU with 8 cores and 2 hyper-threads, so 16
"cpus" according to Slurm.  They also have 4 NVIDIA GeForce RTX 2080
GPUs.  Unlike the regular compute nodes, we *do* allow users to
request 1 to 4 GPUs; jobs may share these nodes.

## Example scripts.

### Mathematica -- on one node

This example uses Mathematica's built-in ability to use all the
available cores in the node when performing certain kinds of
computations.  Linear algebra usually does the best here, just because
many people have put in the effort to write code that can split work
among cores, and the computations are structured enough that this
works well.

* [mathematica-manythreads.sbatch -- Slurm batch script](examples/mathematica-manythreads.sbatch)
* [mathematica-manythreads.m -- C source code](examples/mathematica-manythreads.m)
* [mathematica-manythreads.out -- example output](examples/mathematica-manythreads.out)

To run the example:

```
sbatch mathematica-manythreads.sbatch
```

### Mathematica -- one node, many small tasks

This example is for when you have a number of small tasks to perform
-- for example, you have 100 data files and you need to run a
mathematica script on each one.

* [mathematica-manytasks.sbatch -- Slurm batch script](examples/mathematica-manytasks.sbatch)
* [mathematica-onetask.m -- Mathematica script run on each data item](examples/mathematica-onetask.m)
* [mathematica-manytasks.out -- example output](examples/mathematica-manytasks.out)

### Julia -- on one node

Like the Mathematica example, this uses built-in parallelism in the
linear algebra libraries that Julia uses.

* [julia-manythreads.sbatch -- Slurm batch script](examples/julia-manythreads.sbatch)
* [julia-manythreads.jl -- Julia source code](examples/julia-manythreads.jl)
* [julia-manythreads.out -- example output](examples/julia-manythreads.out)

To run the example:

```
sbatch julia-manythreads.sbatch
```

### Julia -- on many nodes

This runs 40 copies of a Julia program on each of the 4 nodes
requested.  In a real program, they would need some way of splitting
up a large task.

* [julia-manytasks.sbatch -- Slurm batch script](examples/julia-manytasks.sbatch)
* [julia-manytasks.m -- Julia source code](examples/julia-manytasks.jl)
* [julia-manytasks.out -- example output](examples/julia-manytasks.out)

To run the example:

```
sbatch julia-manytasks.sbatch
```

### C: single-node OpenMP

* [hello-openmp.build -- build script](examples/hello-openmp.build)
* [hello-openmp.c -- C source code](examples/hello-openmp.c)
* [hello-openmp.sbatch -- Slurm batch script](examples/hello-openmp.sbatch)
* [hello-openmp.out -- example output](examples/hello-openmp.out)

This example is written in C and uses OpenMP to parallelize within a
compute node.

To run the example:

```
. hello-openmp.build
```

This will compile the program and submit it to the batch system.  The output will appear in the file `hello-openmp.out`.


### C: multi-node MPI

* [hello-mpi.build -- build script](examples/hello-mpi.build)
* [hello-mpi.c -- C source code](examples/hello-mpi.c)
* [hello-mpi.sbatch -- Slurm batch script](examples/hello-mpi.sbatch)
* [hello-mpi.out -- example output](examples/hello-mpi.out)

This example is written in C and uses MPI to parallelize across 4 nodes.

To run the example:

```
. hello-mpi.build
```

This will compile the program and submit it to the batch system.  The output will appear in the file `hello-mpi.out`.


### C: Hybrid OpenMP + MPI

* [hello-hybrid.build -- build script](examples/hello-hybrid.build)
* [hello-hybrid.c -- C source code](examples/hello-hybrid.c)
* [hello-hybrid.sbatch -- Slurm batch script](examples/hello-hybrid.sbatch)
* [hello-hybrid.out -- example output](examples/hello-hybrid.out)

This example is written in C and uses OpenMP within a compute node,
and MPI to coordinate between multiple compute nodes.

To run the example:

```
. hello-hybrid.build
```

This will compile the program and submit it to the batch system.  The output will appear in the file `hello-hybrid.out`.

