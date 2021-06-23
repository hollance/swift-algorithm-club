import XCTest

class PlayerTests: XCTestCase {

    private var sut: Player!

    private var playerType: PlayerType = .human

    private var playerSymbol: PlayerSymbol = .circle

    override func setUp() {
        super.setUp()
        sut = Player(type: playerType, symbol: playerSymbol)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertEqual(sut.type, playerType)
        XCTAssertEqual(sut.symbol, playerSymbol)
    }
}
