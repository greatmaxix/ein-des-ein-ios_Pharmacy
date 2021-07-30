//
//  Moya+Extensions.swift
//  Pharmacy
//
//  Created by Daniiar Erkinov on 26/7/21.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Moya

extension MoyaError {
    static func debugPrintDecodingError(_ error: DecodingError, model: Decodable.Type) {
        switch error {
        case .typeMismatch(let mismatchType, let context):
            debugPrint(model: model, error: error, mismatchType: mismatchType, context: context)
        case .valueNotFound(let mismatchType, let context):
            debugPrint(model: model, error: error, mismatchType: mismatchType, context: context)
        case .keyNotFound(let codingKey, let context):
            debugPrint(model: model, error: error, codingKey: codingKey, context: context)
        case .dataCorrupted(let context):
            debugPrint(model: model, error: error, context: context)
        default:
            debugPrint(model: model, error: error)
        }
    }
    
    static func debugPrint(model: Decodable.Type,
                           error: DecodingError,
                           mismatchType: Any.Type? = nil,
                           codingKey: CodingKey? = nil,
                           context: DecodingError.Context? = nil) {
        print("\n\n\n\n\n❌")
        print("❗️ DecodingError: \(error.localizedDescription)")
        print("❗️ ModelType: \(String(reflecting: type(of: model)))")
        if let mismatchType = mismatchType {
            print("❗️ Mismatch Type: '\(String(reflecting: type(of: mismatchType)))'")
        }
        if let codingKey = codingKey {
            print("❗️ DebugDescription: \(codingKey)")
        }
        if let context = context {
            print("❗️ DebugDescription: \(context.debugDescription)")
            print("❗️ CodingPath: \(context.codingPath as AnyObject)")
        }
        print("❌\n\n\n\n\n")
    }
    
}
