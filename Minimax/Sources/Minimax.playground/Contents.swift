import UIKit
import PlaygroundSupport

let boardSize = CGSize(width: 500, height: 550)
let boardView = BoardView(frame: CGRect(origin: .zero, size: boardSize))

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = boardView
