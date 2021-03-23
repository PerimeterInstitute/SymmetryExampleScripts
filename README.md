# SymmetryExampleScripts
Example scripts for submitting compute jobs to Perimeter's Symmetry high-performance computing cluster.

*Symmetry* is Perimeter Institute's in-house computing cluster or
 "high-performance computer" (HPC).

Symmetries are important in physics. [Noether's
theorem](https://en.wikipedia.org/wiki/Noether%27s_theorem) states
that every local symmetry of a physical system generates a
conservation law.  Our cluster is named in honour of this principle.

Symmetry is intended to serve the needs of Perimeter researchers,
filling a gap between personal devices such as laptops and desktops,
and large national sytems offered e.g. by [Compute
Canada](https://www.computecanada.ca). As such, each node of Symmetry
is significantly more powerful than a laptop, but cannot compete with
a national system such as
[Graham](https://docs.computecanada.ca/wiki/Graham) or
[Niagara](https://docs.computecanada.ca/wiki/Niagara).

## Contact and help

As usual for all technical systems at Perimeter, the main channel to
report issues and ask for assistance is our [help
desk](mailto:help@perimeterinstitute.ca).


## Running jobs

While you can run jobs interactively on the head nodes, you need to be
careful when doing so: Head nodes are shared between all users on
Symmetry. **Do this only for tasks that do not need many resources.**
For example, compiling code, or brief tests of a Julia or Mathematica
notebook are probably fine. If in doubt, use a compute node instead.

We use the [Slurm](https://slurm.schedmd.com) resource manager (aka
"scheduler" or "queueing system") to run *batch jobs*. Slurm keeps
track of which compute nodes are currently used by who. If you want to
use a certain number of compute nodes, you have to ask Slurm, and you
might have to wait until the nodes are available before you can run
your job.

The basic work flow is thus as follows:

1. You write a *batch script* (shell script) for your job. (Below are
   some examples.) This script defines which resources you want (e.g.
   "4 nodes for 7 days"), and also how to run your job.

1. You submit this script to Slurm via `sbatch` (see below for
   examples).  We have a few different queues to support
   different kinds of computer use.

1. If the system is busy, your job might have to wait in the queue for
   some time. Slurm will try to be "fair" to all users (whatever that
   means). Your job's priority is determined by several factors,
   including how much you have used Symmetry recently, and how many
   resources your job requests.

1. Slurm will run your job automatically (that's what *batch* means).
   This does generally not work with notebooks (e.g. Mathematica,
   Jupyter). Instead, you need to write a script with a text editor
   (see below for examples).

1. After the job has finished, you examine its output that was
   presumably written to a file.


## Parallel computing

When running a job on Symmetry, you need to describe how many *nodes*
and *cores* your job is requesting. Determining this correctly is not
always straightforward:

- First, you need to know whether your application can run across
  multiple nodes. Many applications cannot, because it is difficult to
  implement this. Usually you will know whether your application
  supports this. For exampe, in Mathematica you need to use *remote
  kernels* to enable this. In Fortran, C, or C++, you need to use
  `MPI` or a similar mechanism. In Julia or Python programs, you also
  need to explicitly support using multiple processes.

- You also need to know whether your application uses multiple
  threads. Even if your application does not support this explicitly,
  it might use a library that uses multi-threading. For example,
  Mathematica, Julia, or Python are not multi-threaded by default, but
  if you use linear algebra (e.g. systems with large matrices for
  floating-point numbers), then they might use multiple threads. In
  Fortran, C, or C++, you can use OpenMP for multi-threading. (Note
  that `OpenMP` and `MPI`/`OpenMPI` are very different, despite the
  very similar names.)

- If your application uses multiple nodes, then it most likely will
  use all the cores on each node efficiently. This gives the highest
  performance, but is the most difficult to implement.

- If your application use a single node but is multi-threaded, then
  you should probably run only a single program on each compute node.
  This is the easiest case.

- If your application is not multi-threaded, then it iuses only a
  single core. Each node of Symmetry has many cores (up to 40). It
  thus makes sense to run multiple copies of your application at the
  same time on the same node, if there is enough memory available.


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

Symmetry currently (as of March 2021) has 76 regular compute nodes and
2 GPU nodes.

The regular compute nodes have 2 Intel Xeon Gold CPUs, each with 20
cores, and supporting 2 "hyper-threads".  Slurm counts hyper-threads
as "cpus", so as far as it is concerned, the compute nodes have 80
"cpus".  The regular compute nodes have 192 GB of memory.

The GPU nodes have one CPU with 8 cores and 2 hyper-threads, so 16
"cpus" according to Slurm.  They also have 4 NVIDIA GeForce RTX 2080
GPUs.  Unlike the regular compute nodes, we *do* allow users to
request 1 to 4 GPUs; jobs may share these nodes.

We have a local file server hosting a GPFS file system offering 233
  TeraBytes of space, and a high-performance InfiniBand network
  connects the nodes and the file server.


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

