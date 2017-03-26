//
//  ShellSortExample.swift
//  
//
//  Created by Cheer on 2017/2/26.
//
//

import Foundation

public func shellSort(_ list : inout [Int])
{
    var sublistCount = list.count / 2
    
    while sublistCount > 0
    {
        for var index in 0..<arr.count{
            
            guard index + sublistCount < arr.count else { break }
            
            if arr[index] > arr[index + sublistCount]{
                swap(&arr[index], &arr[index + sublistCount])
            }
            
            guard sublistCount == 1 && index > 0 else { continue }

            while arr[index - 1] > arr[index] && index - 1 > 0  {
                swap(&arr[index - 1], &arr[index])
                index -= 1
            }
        }
        sublistCount = sublistCount / 2
    }
}
