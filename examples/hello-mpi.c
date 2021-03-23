#include <mpi.h>
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

  // Output a message
  printf("Hello, World! rank=%d size=%d\n", rank, size);

  // If this is not the last process, then send a message to the next
  // process
  if (rank < size - 1)
    MPI_Send(NULL, 0, MPI_INT, rank + 1, 0, MPI_COMM_WORLD);

  // Shut down MPi
  MPI_Finalize();
  return 0;
}
