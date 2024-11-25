import Testing

@testable import AdventOfCode

// One off test to validate that basic data load testing works
struct AdventDayTests {

  @Test func testInitData() async throws {
    let challenge = Day00()
    #expect(challenge.data.starts(with: "4514"))
  }
}
