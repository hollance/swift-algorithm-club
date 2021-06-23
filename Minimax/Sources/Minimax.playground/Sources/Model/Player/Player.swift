public struct Player {
    // MARK: -- Public variable's
    public var type: PlayerType

    public var symbol: PlayerSymbol

    // MARK: -- Public function's
    public init(type: PlayerType, symbol: PlayerSymbol) {
        self.type = type
        self.symbol = symbol
    }
}
