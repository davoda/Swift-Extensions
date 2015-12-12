//
//  SequenceHelpers.swift
//  InstagramSpike
//
//  Created by David Elsonbaty on 12/12/15.
//  Copyright © 2015 David Elsonbaty. All rights reserved.
//

import Foundation

extension SequenceType {
    
    @warn_unused_result
    func allMatch(match: Generator.Element -> Bool) -> Bool {
        return !contains({ !match($0) })
    }
    @warn_unused_result
    func noneMatch(match: Generator.Element -> Bool) -> Bool {
        return !contains({ match($0) })
    }
    
    @warn_unused_result
    func count(match: Generator.Element -> Bool) -> Int {
        
        return reduce(0) { count, elem in
            count + Int(match(elem))
        }
    }
    @warn_unused_result
    func indicesOf(match: Generator.Element -> Bool) -> [Int] {
        
        var indices: [Int] = []
        for (idx, elem) in self.enumerate() {
            if match(elem) { indices.append(idx) }
        }
        
        return indices
    }
    
    func enumerateUntil(match: Generator.Element -> Bool, body: Generator.Element -> ()) {
        forEach { if match($0) { return }; body($0) }
    }
    func enumerateWhile(match: Generator.Element -> Bool, body: Generator.Element -> ()) {
        forEach { if !match($0) { return }; body($0) }
    }
    
    @warn_unused_result
    func takeWhile(match: Generator.Element -> Bool) -> [Generator.Element] {
        
        var elements: [Generator.Element] = []
        enumerateWhile(match) { elem in
            elements.append(elem)
        }
        
        return elements
    }
    @warn_unused_result
    func takeUntil(match: Generator.Element -> Bool) -> [Generator.Element] {
        
        var elements: [Generator.Element] = []
        enumerateUntil(match) { elem in
            elements.append(elem)
        }
        
        return elements
    }
    
    @warn_unused_result
    func findElement(match: Generator.Element -> Bool) -> Generator.Element? {
        
        for element in self where match(element) {
            return element
        }
        
        return nil
    }
    
    /// - Note: When the condition is met, execution stops
    /// - Note: You cannot use the `break` or `continue` statement to exit the
    ///   current call of the `body` closure or skip subsequent calls.
    /// - Note: Using the `return` statement in the `body` closure will only
    ///   exit from the current call to `body`, not any outer scope, and won't
    ///   skip subsequent calls.
    ///
    /// - Complexity: O(`self.count`)
    func forEachUntil(condition: Void -> Bool, body: Self.Generator.Element -> Void) {
        
        for element in self {
            
            if condition() { break }
            body(element)
        }
    }
    
    /// - Note: When condition is met, `body` is called with element.
    /// - Note: You cannot use the `break` or `continue` statement to exit the
    ///   current call of the `body` closure or skip subsequent calls.
    /// - Note: Using the `return` statement in the `body` closure will only
    ///   exit from the current call to `body`, not any outer scope, and won't
    ///   skip subsequent calls.
    ///
    /// - Complexity: O(`self.count`)
    func forEachWhere(condition: Generator.Element -> Bool, body: Self.Generator.Element -> Void) {
        
        for element in self where condition(element) {
            body(element)
        }
    }
}
