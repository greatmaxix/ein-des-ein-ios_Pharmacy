//
//  ChatEvaluatingModel.swift
//  Pharmacy
//
//  Created by Egor Bozko on 13.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct ChatEvaluation {
    let evaluatingRating: Int
    let evaluatingComment: String?
    let evaluatingTags: [String]?
    
    var asDictionary: [String: Any] {
        var d: [String: Any] = [:]
        d["evaluatingRating"] = evaluatingRating
        d["evaluatingComment"] = evaluatingComment ?? ""
        d["evaluatingTags"] = evaluatingTags ?? [""]
        
        return d
    }
}
