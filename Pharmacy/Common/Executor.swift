//
//  Executor.swift
//  Pharmacy
//
//  Created by Sapa Denys on 08.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

final class Executor {
    
    // MARK: - Private Properties
    private var cancelsPreviousExecution: Bool
    private let executionBlock: (DispatchWorkItem) -> Void
    
    private var executingItem: DispatchWorkItem!
    
    // MARK: - Init / Deinit Methods
    public required init(cancelsPreviousExecution: Bool = false, executionBlock: @escaping (DispatchWorkItem) -> Void) {
        self.cancelsPreviousExecution = cancelsPreviousExecution
        self.executionBlock = executionBlock
    }
    
    // MARK: - Public Methods
    public func execute(_ work: @escaping () -> Void) {
        if cancelsPreviousExecution {
            executingItem?.cancel()
        }
        
        executingItem = DispatchWorkItem(block: work)
        executionBlock(executingItem)
    }
    
    public func cancelExecution() {
        executingItem?.cancel()
    }
}

// MARK: - External Declarations
extension Executor {
    
    public static func immediate() -> Self {
        return Self { $0.perform() }
    }
    
    public static func main() -> Self {
        return queue(.main)
    }
    
    public static func queue(_ queue: DispatchQueue) -> Self {
        return Self {
            queue.async(execute: $0)
        }
    }
    
    public static func postpone(queue: DispatchQueue = .main, delay: TimeInterval) -> Self {
        return Self {
            queue.asyncAfter(deadline: .now() + delay, execute: $0)
        }
    }
    
    public static func debounce(queue: DispatchQueue = .main, interval: TimeInterval) -> Self {
        return Self(cancelsPreviousExecution: true) {
            queue.asyncAfter(deadline: .now() + interval, execute: $0)
        }
    }
}
