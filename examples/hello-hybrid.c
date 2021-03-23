#include <mpi.h>
#include <omp.h>
#include <stdio.h>

int main(int argc, char **argv) {
  // Initialize MPI
  MPI_Init(&argc, &argv);

  // Determine number of processes
  int rank, size;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  // This example program implements a token-passing algorithm where
  // each process outputs a message in turn. The first process begins
  // the token-passing, the last process finishes it. The token is a
  // zero-length message.

  // If this is not the first process, then wait for a message from
  // the previous process
  if (rank > 0)
    MPI_Recv(NULL, 0, MPI_INT, rank - 1, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

// Begin a parallel region
#pragma omp parallel
  {
    // Determine number of threads
    int thread_num = omp_get_thread_num();
    int num_threads = omp_get_num_threads();

    // Loop as many times as there are threads, and let a different
    // thread output a message each time. Use a barrier for
    // synchronization.
    for (int i = 0; i < num_threads; ++i) {

      if (thread_num == i)
        // Output a message
        printf("Hello, World! rank=%d size=%d thread_num=%d num_threads=%d\n",
               rank, size, thread_num, num_threads);

// Synchronize all threads
#pragma omp barrier
    }
  }

  // If this is not the last process, then send a message to the next
  // process
  if (rank < size - 1)
    MPI_Send(NULL, 0, MPI_INT, rank + 1, 0, MPI_COMM_WORLD);

  // Shut down MPi
  MPI_Finalize();
  return 0;
}
