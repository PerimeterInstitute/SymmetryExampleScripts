#include <omp.h>
#include <stdio.h>

int main(int argc, char **argv) {
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
        printf("Hello, World! thread_num=%d num_threads=%d\n", thread_num,
               num_threads);

// Synchronize all threads
#pragma omp barrier
    }
  }
  return 0;
}
