public func minimaxMove(board: Board, player: Player, opponent: Player, depth: Int) -> Position {
    var bestVal = GameStateValue.min
    var bestMoves: [Position] = []

    for i in 0 ..< board.size {
        for j in 0 ..< board.size {
            if board.symbol(forPosition: Position(i, j)) == PlayerSymbol.empty {
                var tempBoard = board
                let move = Position(i, j)

                tempBoard.makeMove(player: opponent, position: (i, j))
                let moveVal = minMax(board: tempBoard, player: opponent, opponent: player,
                                     depth: depth,
                                     alpha: GameStateValue.min.rawValue, beta: GameStateValue.max.rawValue,
                                     maximizingPlayer: false)

                if moveVal.rawValue > bestVal.rawValue {
                    bestVal = moveVal
                    bestMoves = []
                    bestMoves.append(move)
                } else if moveVal == bestVal {
                    bestMoves.append(move)
                }
            }
        }
    }

    return bestMoves[Int.random(in: 0 ..< bestMoves.count)]
}

public func minMax(board: Board, player: Player, opponent: Player, depth: Int, alpha: Int, beta: Int, maximizingPlayer: Bool) -> GameStateValue {
    var alpha = alpha
    var beta = beta

    if let gameResult = evaluateGameState(board: board, player: player, opponent: opponent) {
        guard depth != 0 && gameResult != GameStateValue.min && gameResult != GameStateValue.max && gameResult != GameStateValue.null else {
            return gameResult
        }
    }

    if maximizingPlayer {
        var maxEval = GameStateValue.min

        for i in 0 ..< board.size {
            for j in 0 ..< board.size {
                if board.symbol(forPosition: Position(i, j)) == PlayerSymbol.empty {
                    var tempBoard = board
                    tempBoard.makeMove(player: player, position: Position(i, j))

                    let eval = minMax(board: tempBoard, player: player, opponent: opponent, depth: depth - 1,
                                      alpha: alpha, beta: beta,
                                      maximizingPlayer: !maximizingPlayer)

                    maxEval = GameStateValue(rawValue: max(maxEval.rawValue, eval.rawValue))!
                    alpha = max(alpha, eval.rawValue)

                    if beta <= alpha { break }
                }
            }
        }

        return maxEval
    } else {
        var minEval = GameStateValue.max

        for i in 0 ..< board.size {
            for j in 0 ..< board.size {
                if board.symbol(forPosition: Position(i, j)) == PlayerSymbol.empty {
                    var tempBoard = board
                    tempBoard.makeMove(player: opponent, position: (i, j))

                    let eval = minMax(board: tempBoard, player: player, opponent: opponent, depth: depth - 1,
                                      alpha: alpha, beta: beta,
                                      maximizingPlayer: !maximizingPlayer)

                    minEval =  GameStateValue(rawValue: min(minEval.rawValue, eval.rawValue))!
                    beta = min(beta, eval.rawValue)

                    if beta <= alpha { break }
                }
            }
        }

        return minEval
    }
}

public func evaluateGameState(board: Board, player: Player, opponent: Player) -> GameStateValue? {
    if board.check(player: player) == BoardStatus.win {
        return GameStateValue.max
    } else if board.check(player: opponent) == BoardStatus.win {
        return GameStateValue.min
    } else if board.check(player: player) == BoardStatus.draw || board.check(player: opponent) == BoardStatus.draw {
        return GameStateValue.null
    }

    return nil
}
