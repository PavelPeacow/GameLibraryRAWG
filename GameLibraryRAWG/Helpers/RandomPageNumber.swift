//
//  RandomPageNumber.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 19.09.2022.
//

import Foundation

fileprivate var usedValues = [Int]()

func randomPageNumber(with range: ClosedRange<Int>) -> Int? {
    guard usedValues.count != range.upperBound - 1 else { return nil }
    
    var randomValue = Int.random(in: range)
    
    if !usedValues.contains(randomValue) {
        usedValues.append(randomValue)
        return randomValue
    } else {
        while usedValues.contains(randomValue) {
            randomValue = Int.random(in: range)
            
            if !usedValues.contains(randomValue) {
                usedValues.append(randomValue)
                break
            }
            
        }
        return randomValue
    }
}
