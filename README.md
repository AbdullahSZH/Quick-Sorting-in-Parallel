# CUDA Parallel Quicksort

This project implements a parallel quicksort algorithm using CUDA for sorting an array. It displays the original array, the sorted array, and the execution time.

## Description

The CUDA parallel quicksort algorithm utilizes parallelism to sort the array efficiently. It partitions the array into smaller segments using the quicksort partition function. Each segment is then recursively sorted in parallel. The sorting is performed using shared memory for improved performance.

## Features

- Efficient parallel sorting using CUDA threads
- Utilization of shared memory for improved performance
- Display of the original array, sorted array, and execution time

## Requirements

To run the CUDA parallel quicksort program, you need:

- NVIDIA GPU with CUDA support
- CUDA Toolkit 
- Visual Studio IDE 

## Installation

Follow these steps to set up the project and compile the CUDA program:

1. Clone the repository or download the source code files.
2. Open the project in Visual Studio.
3. Make sure you have the CUDA Toolkit installed and configured in Visual Studio.
4. Build the project to compile the CUDA program.

## Usage

To use the CUDA parallel quicksort program, follow these steps:

1. Open the command prompt or terminal.
2. Navigate to the directory where the compiled program is located.
3. Run the executable file.
4. The program will display the original array, sorted array, and execution time.

## Examples

Here are some examples of input arrays and their corresponding sorted arrays:

### Example 1:

Original array: 7 2 1 6 8 5 3 4

Sorted array: 1 2 3 4 5 6 7 8

Execution time: 0.7234 ms

### Example 2:

Original array: 3 9 2 5 1 8 4 7 6

Sorted array: 1 2 3 4 5 6 7 8 9

Execution time: 0.5678 ms

## Troubleshooting

If you encounter any issues while running the program, consider the following:

- Ensure that you have a compatible NVIDIA GPU with CUDA support.
- Make sure the CUDA Toolkit is installed correctly and configured in Visual Studio.
- Check for any error messages or warnings during the compilation process.

If you're experiencing specific problems, please refer to the troubleshooting section in the documentation or seek help from the project's support channels.

## Limitations

- The current implementation may have limitations related to the input array size, GPU memory constraints, or specific edge cases. Please refer to the project documentation for more details.

## Contributing

Contributions to the project are welcome! If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request.

## Credits

This project is created and maintained by [AbdullahSZH]. It is based on the CUDA parallel quicksort algorithm and utilizes the CUDA Toolkit provided by NVIDIA.

## License

This project is licensed under the [MIT License](LICENSE). Please see the LICENSE file for more details.
