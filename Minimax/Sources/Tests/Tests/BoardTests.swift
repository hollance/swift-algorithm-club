import XCTest

class BoardTests: XCTestCase {

    private var sut: Board!

    private var boardSize = 3

    override func setUp() {
        super.setUp()
        sut = Board(size: boardSize)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertEqual(sut.size, boardSize)
        XCTAssertEqual(allFieldsAreEmpty(), true)
    }

    func testSymbolForPosition() {
        let player = Player(type: .human, symbol: .circle)
        let position = Position(0, 0)

        sut.clear()
        XCTAssertEqual(sut.symbol(forPosition: position), PlayerSymbol.empty)

        sut.makeMove(player: player, position: position)
        XCTAssertEqual(sut.symbol(forPosition: position), player.symbol)
    }

    func testClear() {
        let player = Player(type: .computer, symbol: .circle)
        let position = Position(0, 0)

        sut.makeMove(player: player, position: position)

        XCTAssertEqual(allFieldsAreEmpty(), false)

        sut.clear()

        XCTAssertEqual(allFieldsAreEmpty(), true)
    }

    func testHasEmptyField() {
        let player = Player(type: .computer, symbol: .circle)

        sut.clear()

        XCTAssertEqual(sut.hasEmptyField(), true)

        sut.makeMove(player: player, position: Position(0, 0))
        sut.makeMove(player: player, position: Position(0, 1))
        sut.makeMove(player: player, position: Position(0, 2))

        sut.makeMove(player: player, position: Position(1, 0))
        sut.makeMove(player: player, position: Position(1, 1))
        sut.makeMove(player: player, position: Position(1, 2))

        sut.makeMove(player: player, position: Position(2, 0))
        sut.makeMove(player: player, position: Position(2, 1))
        sut.makeMove(player: player, position: Position(2, 2))

        XCTAssertEqual(sut.hasEmptyField(), false)
    }

    func testMakeMove() {
        let firstPlayer = Player(type: .human, symbol: .circle)
        let secondPlayer = Player(type: .human, symbol: .cross)
        let position = Position(0, 0)

        sut.clear()
        sut.makeMove(player: firstPlayer, position: position)
        sut.makeMove(player: secondPlayer, position: position)

        XCTAssertEqual(sut.symbol(forPosition: position), firstPlayer.symbol)
    }

    func testCheck() {
        let firstPlayer = Player(type: .computer, symbol: .circle)
        let secondPlayer = Player(type: .computer, symbol: .cross)

        sut.clear()

        XCTAssertEqual(sut.check(player: firstPlayer), BoardStatus.continues)
        XCTAssertEqual(sut.check(player: secondPlayer), BoardStatus.continues)

        sut.clear()
        sut.makeMove(player: firstPlayer, position: Position(0, 0))
        sut.makeMove(player: firstPlayer, position: Position(0, 1))
        sut.makeMove(player: firstPlayer, position: Position(0, 2))

        XCTAssertEqual(sut.check(player: firstPlayer), BoardStatus.win)
        XCTAssertEqual(sut.check(player: secondPlayer), BoardStatus.continues)

        sut.clear()
        sut.makeMove(player: firstPlayer, position: Position(0, 0))
        sut.makeMove(player: firstPlayer, position: Position(1, 0))
        sut.makeMove(player: firstPlayer, position: Position(2, 0))

        XCTAssertEqual(sut.check(player: firstPlayer), BoardStatus.win)
        XCTAssertEqual(sut.check(player: secondPlayer), BoardStatus.continues)

        sut.clear()
        sut.makeMove(player: firstPlayer, position: Position(0, 0))
        sut.makeMove(player: firstPlayer, position: Position(1, 1))
        sut.makeMove(player: firstPlayer, position: Position(2, 2))

        XCTAssertEqual(sut.check(player: firstPlayer), BoardStatus.win)
        XCTAssertEqual(sut.check(player: secondPlayer), BoardStatus.continues)

        sut.clear()
        sut.makeMove(player: firstPlayer, position: Position(0, 0))
        sut.makeMove(player: secondPlayer, position: Position(0, 1))
        sut.makeMove(player: secondPlayer, position: Position(0, 2))

        sut.makeMove(player: secondPlayer, position: Position(1, 0))
        sut.makeMove(player: firstPlayer, position: Position(1, 1))
        sut.makeMove(player: firstPlayer, position: Position(1, 2))

        sut.makeMove(player: secondPlayer, position: Position(2, 0))
        sut.makeMove(player: firstPlayer, position: Position(2, 1))
        sut.makeMove(player: secondPlayer, position: Position(2, 2))

        XCTAssertEqual(sut.check(player: firstPlayer), BoardStatus.draw)
        XCTAssertEqual(sut.check(player: secondPlayer), BoardStatus.draw)
    }

    private func allFieldsAreEmpty() -> Bool {
        var allFieldAreEmpty = true

        for row in 0 ..< sut.size {
            for column in 0 ..< sut.size {
                if sut.symbol(forPosition: Position(row, column)) != PlayerSymbol.empty {
                    allFieldAreEmpty = false
                }
            }
        }

        return allFieldAreEmpty
    }
}
