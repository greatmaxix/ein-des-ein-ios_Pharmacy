//
//  ChatEvaluationModel.swift
//  Pharmacy
//
//  Created by Egor Bozko on 17.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum ChatEvaluateEvent: Event {
    case send(ChatEvaluation), later
}

protocol ChatEvaluationInput: class {
    func send(_ evaluation: ChatEvaluation)
    func later()
}

protocol ChatEvaluationOutput {}

final class ChatEvaluationModel: EventNode {
    var output: ChatEvaluationOutput!
}

extension ChatEvaluationModel: ChatEvaluationInput {
    func send(_ evaluation: ChatEvaluation) {
        raise(event: ChatEvaluateEvent.send(evaluation))
    }
    
    func later() {
        raise(event: ChatEvaluateEvent.later)
    }
}
