//
//  ArrayLimitedQueue.swift
//
//  Created by Sergey Pugach on 15.04.17.
//  Copyright © 2017 Sergey Pugach. All rights reserved.
//

/*
 Array Limited Queue is a collection that has the features
 of a regular array (only get + limited size), queues and sets.
 The way you value and compare items can be user-defined.
 */

import Foundation

public struct ArrayLimitedQueue<T: Comparable> {
    
    //The maximum number of items in the collection. Can be changed after
    public var maxStoredItems: Int = 1 {
        didSet {
            let sizeDiff = list.count - maxStoredItems
            if 0 < sizeDiff && sizeDiff <= list.count {
                for _ in 0 ... sizeDiff {
                    list.remove(atIndex: 0)
                }
            }
        }
    }
    
    //    /*
    //    This property determines which elements can be in the collection.
    //    After the change from true to false. Negative values will be deleted
    //    Note: When using custom types, you need to set the zeroValue.
    //     */
    //    public var zeroValue:T? = 0 as? T
    //    public var positiveValues: Bool = false {
    //        didSet {
    //            if positiveValues {
    //
    //                if let zero = zeroValue {
    //                internalArray = internalArray.filter{$0 > zero}.map{ $0 }
    //
    //                } else {
    //                    fatalError("A zeroValue is not setted")
    //                }
    //            }
    //        }
    //    }
    
    /*
     Specifies whether to remove duplicates from the collection.
     When a copy is found, it leaves the last value.
     */
    public var deleteExisting = true {
        didSet {
            if deleteExisting {
                for i in stride(from: list.count - 1, to: 0, by: -1) {
                    
                    for j in stride(from: i - 1, to: 0, by: -1) {
                        
                        if list[i] == list[j] {
                            list.remove(atIndex: j)
                        }
                    }
                }
            }
        }
    }
    
    public var list = LinkedList<T>()
    
    //    public var array: [T] {
    //        return internalArray
    //    }
    //    private var internalArray = [T]()
    
    public var isEmpty: Bool {
        return list.isEmpty
        //return count == 0
    }
    
    // Returns the number of elements in the collection.
    public var count: Int {
        return list.count
        //return internalArray.count
    }
    
    //    // Returns the 'maximum' or 'largest' value in the collection.
    //    public var maxValue: T? {
    //        return internalArray.max()
    //    }
    //
    //    // Returns the 'minimum' or 'smallest' value in the collection.
    //    public var minValue: T? {
    //        return internalArray.min()
    //    }
    
    public init() {}
    
    // Function adds an element to the end of the array
    public mutating func add(item: T) -> T? {
        
        // If the element exists and the property(deleteExisting) is true,
        // the re-inserted element is removed from the collection
        if let index = indexOf(item: item), deleteExisting {
            return list.remove(atIndex: index)
            //return internalArray.remove(at: index)
        }
        
        //        if positiveValues {
        //
        //            guard let zero = zeroValue, zero < item else {
        //                return nil
        //            }
        //        }
        
        list.append(item)
        //internalArray.append(item)
        
        return self.checkSize()
    }
    
    //The check function in the collection.
    // How many items will be deleted with the new value
    public func removableItems(forMaxSize size: Int) -> [T] {
        
        var deletingArray = [T]()
        
        var removingIndex = 0
        
        //var sizeDiff = internalArray.count - size
        var sizeDiff = list.count - size
        
        while sizeDiff > 0 {
            
            if let value = list.node(atIndex: removingIndex)?.value {
                deletingArray.append(value)
            }
            //deletingArray.append(internalArray[removingIndex])
            removingIndex += 1
            sizeDiff -= 1
        }
        
        return deletingArray
    }
    
    // Checking the size of the array after inserting a new element
    private mutating func checkSize() -> T? {
        
        guard
            0 < maxStoredItems && maxStoredItems < list.count,
            let first = list.first?.value
            else {
                return nil
        }
        
        list.remove(atIndex: 0)
        return first
    }
    
    // Returns true if and only if the item exists somewhere in the collection.
    public func exists(item: T) -> Bool {
        return indexOf(item: item) != nil
    }
    
    //Returns the index of an item if it exists
    public func indexOf(item: T) -> Int? {
        return list.index(of: item)
    }
    
    public mutating func removeAllItems() {
        list.removeAll()
    }
    
    // Returns the item at the given index.
    // Assertion fails if the index is out of the range of [0, count).
    public subscript(index: Int) -> T {
        assert(index >= 0 && index < count)
        return list[index]
    }
}


