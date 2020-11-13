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
        var d: [String: Any] = ["evaluatingRating" : "\(evaluatingRating)"]
        if let c = evaluatingComment {
            d["evaluatingComment"] = c
        }
        if let t = evaluatingTags {
            d["evaluatingTags"] = t
        }
        
        return d
    }
}
