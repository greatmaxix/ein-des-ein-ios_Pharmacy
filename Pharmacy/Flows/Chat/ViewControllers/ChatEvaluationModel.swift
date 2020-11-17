//
//  ChatEvaluationModel.swift
//  Pharmacy
//
//  Created by Egor Bozko on 17.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

protocol ChatEvaluationInput: class {
    func send(_ eveluation: ChatEvaluation)
    func later()
}

protocol ChatEvaluationOutput {
    
}

final class ChatEvaluationModel: EventNode {
    var output: ChatEvaluationOutput!
}

extension ChatEvaluationModel: ChatEvaluationInput {
    func send(_ eveluation: ChatEvaluation) {
        
    }
    
    func later() {
        raise(event: ChatEvent.later)
    }
}
