public struct Board {
    // MARK: -- Public variable's
    public var size: Int

    // MARK: -- Private variable's
    private var table: [ [PlayerSymbol?] ]

    // MARK: -- Public function's
    public init(size: Int) {
        self.size = size
        self.table = []
        self.clear()
    }

    public mutating func clear() {
        self.table = Array(repeating: Array(repeating: PlayerSymbol.empty, count: size), count: size)
    }

    public func hasEmptyField() -> Bool {
        for i in 0 ..< self.size {
            for j in 0 ..< self.size {
                if self.table[i][j] == PlayerSymbol.empty {
                    return true
                }
            }
        }
        return false
    }

    public func symbol(forPosition position: Position) -> PlayerSymbol? {
        guard position.row < self.size, position.column < size else { return nil }
        return self.table[position.row][position.column]
    }

    public mutating func makeMove(player: Player, position: Position) {
        guard self.symbol(forPosition: position) == PlayerSymbol.empty else { return }
        guard self.symbol(forPosition: position) != player.symbol else { return }

        self.table[position.row][position.column] = player.symbol
    }

    public func check(player: Player) -> BoardStatus {
        let playerSymbol: PlayerSymbol = player.symbol

        if self.foundWinInRows(playerSymbol) { return BoardStatus.win }
        if self.foundWinInColumns(playerSymbol) { return BoardStatus.win }
        if self.foundWinInSlants(playerSymbol) { return BoardStatus.win }

        if self.hasEmptyField() { return BoardStatus.continues } else { return BoardStatus.draw }
    }

    // MARK: -- Private function's
    private func foundWinInRows(_ playerSymbol: PlayerSymbol) -> Bool {
        for i in 0 ..< self.size {
            var theSameSymbolsInRowCount = 0

            for j in 0 ..< self.size - 1 {
                if self.table[i][j] == self.table[i][j+1] && (self.table[i][j] == playerSymbol) {
                    theSameSymbolsInRowCount += 1
                } else {
                    theSameSymbolsInRowCount = 0
                }
            }

            if theSameSymbolsInRowCount == self.size - 1 {
                return true
            }
        }

        return false
    }

    private func foundWinInColumns(_ playerSymbol: PlayerSymbol) -> Bool {
        for j in 0 ..< self.size {
            var theSameSymbolsInColumnCount = 0

            for i in 0 ..< self.size - 1 {
                if self.table[i][j] == self.table[i+1][j] && (self.table[i][j] == playerSymbol) {
                    theSameSymbolsInColumnCount += 1
                } else {
                    theSameSymbolsInColumnCount = 0
                }
            }

            if theSameSymbolsInColumnCount == self.size - 1 {
                return true
            }
        }

        return false
    }

    private func foundWinInSlants(_ playerSymbol: PlayerSymbol) -> Bool {
        var theSameSymbolsInSlantCount = 0

        for i in 0 ..< self.size {
            for j in -(self.size - 1) ... 0 {
                if(self.table[-j][i] == playerSymbol) {
                    var k: Int = -j
                    var l: Int = i
                    theSameSymbolsInSlantCount = 0

                    while l < self.size && k >= 0 {
                        if self.table[k][l] == playerSymbol {
                            theSameSymbolsInSlantCount += 1
                        } else {
                            theSameSymbolsInSlantCount = 0
                        }
                        k -= 1
                        l += 1

                        if theSameSymbolsInSlantCount == self.size {
                            return true
                        }
                    }
                    theSameSymbolsInSlantCount = 0
                }
                theSameSymbolsInSlantCount = 0
            }
            theSameSymbolsInSlantCount = 0
        }

        theSameSymbolsInSlantCount = 0

        for i in 0 ..< self.size {
            for j in 0 ..< self.size {
                if(self.table[j][i] == playerSymbol) {
                    var k: Int = j
                    var l: Int = i
                    theSameSymbolsInSlantCount = 0

                    while l < self.size && k < self.size {
                        if self.table[k][l] == playerSymbol {
                            theSameSymbolsInSlantCount += 1
                        } else {
                            theSameSymbolsInSlantCount = 0
                        }
                        k += 1
                        l += 1

                        if theSameSymbolsInSlantCount == self.size {
                            return true
                        }
                    }
                    theSameSymbolsInSlantCount = 0
                }
                theSameSymbolsInSlantCount = 0
            }
            theSameSymbolsInSlantCount = 0
        }

        return false
    }
}
