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

// Methods to create Executor instance
// MARK: - External Declarations
extension Executor {
    
    /// Work item will be execute immediately
    public static func immediate() -> Self {
        return Self { $0.perform() }
    }
    
    /// Work item will be execute on main queue
    public static func main() -> Self {
        return queue(.main)
    }
    
    /// Static method to create Executor and pass concrette queue
    /// - Parameter queue: pass DispatchQueue to execute work item on it
    public static func queue(_ queue: DispatchQueue) -> Self {
        return Self {
            queue.async(execute: $0)
        }
    }
    
    /// Static method to create Executor
    /// - Parameter queue: pass DispatchQueue to execute work item on it
    /// - Parameter delay: Time interval between calling `execute()` method and execution work item
    public static func postpone(queue: DispatchQueue = .main, delay: TimeInterval) -> Self {
        return Self {
            queue.asyncAfter(deadline: .now() + delay, execute: $0)
        }
    }
    
    /// Static method to create Executor with option to cancel previous work item execution
    /// - Parameter queue: pass DispatchQueue to execute work item on it
    /// - Parameter delay: Time interval between calling `execute()` method and execution work item
    public static func debounce(queue: DispatchQueue = .main, interval: TimeInterval) -> Self {
        return Self(cancelsPreviousExecution: true) {
            queue.asyncAfter(deadline: .now() + interval, execute: $0)
        }
    }
}
