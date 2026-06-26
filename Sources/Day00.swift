import Algorithms

struct Day00: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and converts from string.
  var entities: [[Int]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "\n").compactMap { Int($0) }
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    // Calculate the sum of the first set of input data
    entities.first?.reduce(0, +) ?? 0
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    entities.map { $0.max() ?? 0 }.reduce(0, +)
  }
}
