import ArgumentParser
import Foundation

// Add each new day implementation to this array:
let allChallenges: [any AdventDay] = [
  Day00(),
//  Day01(),
//  Day02(),
//  Day03(),
//  Day04(),
//  Day05(),
//  Day06(),
//  Day07(),
//  Day08(),
//  Day09(),
//  Day10(),
//  Day11(),
//  Day12(),
//  Day13(),
//  Day14(),
//  Day15(),
//  Day16(),
//  Day17(),
//  Day18(),
//  Day19(),
//  Day20(),
//  Day21(),
//  Day22(),
//  Day23(),
//  Day24(),
//  Day25(),
]

@main
struct AdventOfCode: AsyncParsableCommand {
  @Argument(help: "The day of the challenge. For December 1st, use '1'.")
  var day: Int?

  @Flag(help: "Create new code, data, and test files for the next day.")
  var new: Bool = false

  @Flag(help: "Benchmark the time taken by the solution")
  var benchmark: Bool = false

  @Flag(help: "Run all the days available")
  var all: Bool = false

  /// The selected day, or the latest day if no selection is provided.
  var selectedChallenge: any AdventDay {
    get throws {
      if let day {
        if let challenge = allChallenges.first(where: { $0.day == day }) {
          return challenge
        } else {
          throw ValidationError("No solution found for day \(day)")
        }
      } else {
        return latestChallenge
      }
    }
  }

  /// The latest challenge in `allChallenges`.
  var latestChallenge: any AdventDay {
    allChallenges.max(by: { $0.day < $1.day })!
  }

  func run<T>(part: () async throws -> T, named: String) async -> Duration {
    var result: Result<T, Error>?
    let timing = await ContinuousClock().measure {
      do {
        result = .success(try await part())
      } catch {
        result = .failure(error)
      }
    }
    switch result! {
    case .success(let success):
      print("\(named): \(success)")
    case .failure(let failure as PartUnimplemented):
      print("Day \(failure.day) part \(failure.part) unimplemented")
    case .failure(let failure):
      print("\(named): Failed with error: \(failure)")
    }
    return timing
  }

  func run() async throws {
    if self.new {
      let day = (allChallenges.last?.day ?? 0) + 1
      try createFiles(for: day)
      let year = Calendar(identifier: .gregorian).component(.year, from: Date())
      try uncommentAllChallenges(for: day)
      print("See your question at https://adventofcode.com/\(year)/day/\(day)")
      print("Good luck!")
      return
    }

    let challenges =
      if all {
        allChallenges
      } else {
        try [selectedChallenge]
      }

    for challenge in challenges {
      print("Executing Advent of Code challenge \(challenge.day)...")

      let timing1 = await run(part: challenge.part1, named: "Part 1")
      let timing2 = await run(part: challenge.part2, named: "Part 2")

      if benchmark {
        print("Part 1 took \(timing1), part 2 took \(timing2).")
        #if DEBUG
          print("Looks like you're benchmarking debug code. Try swift run -c release")
        #endif
      }
    }
  }

  private func createFiles(for day: Int) throws {
    let fileManager = FileManager.default
    let currentPath = fileManager.currentDirectoryPath
    let className = String(format: "Day%02d", Int(day))

    // Data file
    let newDataFilePath = "\(currentPath)/Sources/Data/\(className).txt"
    try createFile(atPath: newDataFilePath, content: "")

    // Code file
    let templateFilePath = "\(currentPath)/Sources/DayTemplate.swift"
    let newCodeFilePath = "\(currentPath)/Sources/\(className).swift"
    let newCodeFileContent = try String(contentsOfFile: templateFilePath, encoding: .utf8)
      .replacingOccurrences(of: "DayTemplate", with: className)
    try createFile(atPath: newCodeFilePath, content: newCodeFileContent)

    // Test file
    let templateTestFilePath = "\(currentPath)/Tests/DayTemplate.swift"
    let newTestFilePath = "\(currentPath)/Tests/\(className).swift"
    let newTestFileContent = try String(contentsOfFile: templateTestFilePath, encoding: .utf8)
      .replacingOccurrences(of: "DayTemplate", with: className)
    try createFile(atPath: newTestFilePath, content: newTestFileContent)
  }

  private func createFile(atPath path: String, content: String) throws {
    let fileManager = FileManager.default
    guard !fileManager.fileExists(atPath: path) else {
      fatalError("File already exists at \(path).")
    }
    try content.write(toFile: path, atomically: true, encoding: .utf8)
    print("Created \(path)")
  }

  private func uncommentAllChallenges(for day: Int) throws {
    let fileManager = FileManager.default
    let currentPath = fileManager.currentDirectoryPath
    let filePath = "\(currentPath)/Sources/AdventOfCode.swift"
    let className = String(format: "Day%02d", Int(day))

    let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
    let newFileContent = fileContent.replacingOccurrences(of: "//  \(className)()", with: "  \(className)()")
    try newFileContent.write(toFile: filePath, atomically: true, encoding: .utf8)
  }

}
