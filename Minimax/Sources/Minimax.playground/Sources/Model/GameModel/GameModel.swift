import Foundation

public class GameModel {
    // MARK: -- Public variable's
    public var board: Board!

    public var gameStatus: BoardStatus

    // MARK: -- Private variable's
    private var playersList: [Player]!

    private var movementsSequence: [Int]!

    private var actualPlayerIndex: Int!

    private var actualPlayer: Player {
        get {
            return playersList[actualPlayerIndex]
        }
    }

    private var difficultLevel: DifficultLevel = DifficultLevel.hard

    // MARK: -- Public function's
    public init(boardSize: Int, playersList: [Player], difficultLevel: DifficultLevel) {
        self.board = Board.init(size: boardSize)
        self.playersList = playersList
        self.difficultLevel = difficultLevel
        self.gameStatus = BoardStatus.continues

        self.generateMovementsSequence()
        self.changeActualPlayer()
    }

    public func update() {
        self.gameStatus = board.check(player: actualPlayer)

        switch self.gameStatus {
        case BoardStatus.continues:
            changeActualPlayer()
        case BoardStatus.draw:
            changeActualPlayer()
        default: break
        }
    }

    public func playerMakeMove(selectedPosition: (row: Int, column: Int)) {
        guard board.symbol(forPosition: selectedPosition) == PlayerSymbol.empty else { return }
        guard board.hasEmptyField() == true else { return }

        board.makeMove(player: actualPlayer, position: selectedPosition)
        update()
    }

    public func makeMinimaxMove() {
        guard actualPlayer.type == PlayerType.computer else { return }
        guard board.hasEmptyField() == true else { return }

        sleep(1)

        let selectedPosition: Position = minimaxMove(board: board, player: playersList[0], opponent: playersList[1], depth: self.difficultLevel.rawValue)
        board.makeMove(player: actualPlayer, position: selectedPosition)
        update()
    }

    public func newRound() {
        board.clear()
        gameStatus = BoardStatus.continues
        generateMovementsSequence()
        changeActualPlayer()
    }

    // MARK: -- Private function's
    private func generateMovementsSequence() {
        self.movementsSequence = []

        let playersCount = playersList.count
        let movesCount = (board.size * board.size)

        var move = Int.random(in: 0 ..< playersCount)
        movementsSequence.append(move)

        for _ in 0 ..< movesCount - 1 {
            move += 1
            movementsSequence.append(move % playersCount)
        }
    }

    private func changeActualPlayer() {
        if !movementsSequence.isEmpty {
            actualPlayerIndex = movementsSequence.first!
            movementsSequence.removeFirst()
        }
    }
}
