import Foundation

class KnapsackItem: NSObject {
    var weight: Int
    var value: Int
    
    init(weight: Int, value: Int) {
        self.weight = weight
        self.value = value
    }
}

var capacityOfBag = Int()
var knapsackItems = [KnapsackItem]()

func knapsack() -> Int {
    
    var tableOfValues = [[Int]]()
    
    tableOfValues = Array(repeating: Array(repeating: 0, count: capacityOfBag+1),
                          count: knapsackItems.count+1)
    
    for itemIndex in 1...knapsackItems.count {
        for totalWeight in 1...capacityOfBag {
            
            if totalWeight < knapsackItems[itemIndex-1].weight {
                tableOfValues[itemIndex][totalWeight] = tableOfValues[itemIndex-1][totalWeight]
            } else {
                let remainingCapacity = totalWeight - knapsackItems[itemIndex-1].weight
                tableOfValues[itemIndex][totalWeight] = max(knapsackItems[itemIndex-1].value + tableOfValues[itemIndex-1][remainingCapacity], tableOfValues[itemIndex-1][totalWeight])
            }
        }
    }
    return tableOfValues[knapsackItems.count][capacityOfBag]
}

func solution() {
    
    capacityOfBag = 7
    
    knapsackItems = [KnapsackItem(weight: 1, value: 1),
                     KnapsackItem(weight: 3, value: 4),
                     KnapsackItem(weight: 4, value: 5),
                     KnapsackItem(weight: 5, value: 7)]
    
    let result = knapsack()
    
    print(result)
}

solution()
