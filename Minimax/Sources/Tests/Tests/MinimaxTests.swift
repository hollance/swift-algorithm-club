import XCTest

class MinimaxTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testEvaluateGameState() {
        var board = Board(size: 3)
        let firstPlayer = Player(type: .human, symbol: .cross)
        let secondPlayer = Player(type: .human, symbol: .circle)

        board.clear()

        XCTAssertEqual(evaluateGameState(board: board, player: firstPlayer, opponent: secondPlayer), nil)

        board.makeMove(player: firstPlayer, position: Position(0, 0))

        XCTAssertEqual(evaluateGameState(board: board, player: firstPlayer, opponent: secondPlayer), nil)

        board.makeMove(player: firstPlayer, position: Position(0, 1))
        board.makeMove(player: firstPlayer, position: Position(0, 2))

        XCTAssertEqual(evaluateGameState(board: board, player: firstPlayer, opponent: secondPlayer), .max)
        XCTAssertEqual(evaluateGameState(board: board, player: secondPlayer, opponent: firstPlayer), .min)

        board.clear()
        board.makeMove(player: secondPlayer, position: Position(0, 0))
        board.makeMove(player: secondPlayer, position: Position(0, 1))
        board.makeMove(player: secondPlayer, position: Position(0, 2))
        board.makeMove(player: firstPlayer, position: Position(1, 0))

        XCTAssertEqual(evaluateGameState(board: board, player: firstPlayer, opponent: secondPlayer), .min)
        XCTAssertEqual(evaluateGameState(board: board, player: secondPlayer, opponent: firstPlayer), .max)

        board.clear()
        board.makeMove(player: firstPlayer, position: Position(0, 0))
        board.makeMove(player: secondPlayer, position: Position(0, 1))
        board.makeMove(player: secondPlayer, position: Position(0, 2))

        board.makeMove(player: secondPlayer, position: Position(1, 0))
        board.makeMove(player: firstPlayer, position: Position(1, 1))
        board.makeMove(player: firstPlayer, position: Position(1, 2))

        board.makeMove(player: secondPlayer, position: Position(2, 0))
        board.makeMove(player: firstPlayer, position: Position(2, 1))
        board.makeMove(player: secondPlayer, position: Position(2, 2))

        XCTAssertEqual(evaluateGameState(board: board, player: firstPlayer, opponent: secondPlayer), .null)
        XCTAssertEqual(evaluateGameState(board: board, player: secondPlayer, opponent: firstPlayer), .null)
    }
}
