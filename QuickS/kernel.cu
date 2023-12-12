#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <stdio.h>
#include <stdlib.h>

#define STACK_SIZE 32
#define SHARED_SIZE 256

// Swap function to swap two elements
__device__ void swap(int* arr, int i, int j) {
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
}

// Partition function (moved outside of the kernel)
__device__ int partition(int* arr, int low, int high) {
    int pivot = arr[high];
    int i = low - 1;
    for (int j = low; j <= high - 1; j++) {
        if (arr[j] <= pivot) {
            i++;
            swap(arr, i, j);
        }
    }
    swap(arr, i + 1, high);
    return (i + 1);
}

// Parallel quicksort kernel function
__global__ void parallelQuicksort(int* arr, int size) {
    __shared__ int sharedArr[SHARED_SIZE];

    int tid = blockIdx.x * blockDim.x + threadIdx.x;

    if (tid < size) {
        int low = 0;
        int high = size - 1;
        int stack[STACK_SIZE * 2];
        int top = -1;

        stack[++top] = low;
        stack[++top] = high;

        while (top >= 0) {
            high = stack[top--];
            low = stack[top--];

            int pivot = partition(arr, low, high);

            if (pivot - 1 > low && pivot - 1 <= high) {
                stack[++top] = low;
                stack[++top] = pivot - 1;
            }

            if (pivot + 1 >= low && pivot + 1 < high) {
                stack[++top] = pivot + 1;
                stack[++top] = high;
            }
        }
    }

    // Ensure all threads have finished sorting
    __syncthreads();

    // Each thread loads a block of elements into shared memory
    int sharedIndex = threadIdx.x;
    while (sharedIndex < size) {
        sharedArr[sharedIndex] = arr[sharedIndex];
        sharedIndex += blockDim.x;
    }

    // Ensure all shared memory is loaded
    __syncthreads();

    // Sort the block of elements in shared memory
    for (int i = 0; i < size - 1; i++) {
        for (int j = i + 1; j < size; j++) {
            if (sharedArr[i] > sharedArr[j]) {
                swap(sharedArr, i, j);
            }
        }
    }

    // Ensure all threads have finished sorting
    __syncthreads();

    // Each thread writes back the sorted elements from shared memory to global memory
    sharedIndex = threadIdx.x;
    while (sharedIndex < size) {
        arr[sharedIndex] = sharedArr[sharedIndex];
        sharedIndex += blockDim.x;
    }
}

// Host function to invoke the parallel quicksort kernel
void sortArray(int* arr, int size) {
    int* d_arr;

    cudaMalloc((void**)&d_arr, size * sizeof(int));
    cudaMemcpy(d_arr, arr, size * sizeof(int), cudaMemcpyHostToDevice);

    int numThreadsPerBlock = SHARED_SIZE;
    int numBlocks = (size + numThreadsPerBlock - 1) / numThreadsPerBlock;

    printf("The number of blocks is %d\n", numBlocks);

    parallelQuicksort << <numBlocks, numThreadsPerBlock >> > (d_arr, size);

    cudaMemcpy(arr, d_arr, size * sizeof(int), cudaMemcpyDeviceToHost);

    cudaFree(d_arr);
}

// Helper function to print the array
void printArray(int* arr, int size) {
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main() {
    int arr[] = { 7, 2, 1, 6, 8, 5, 3, 4 };
    int size = sizeof(arr) / sizeof(arr[0]);

    printf("Original array: ");
    printArray(arr, size);

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);

    
    sortArray(arr, size);

    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float elapsedTime;
    cudaEventElapsedTime(&elapsedTime, start, stop);

    printf("Execution time: %.4f ms\n", elapsedTime);

    cudaEventDestroy(start);
    cudaEventDestroy(stop);

    printf("Sorted array: ");
    printArray(arr, size);

    return 0;
}