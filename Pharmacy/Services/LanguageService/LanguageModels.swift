//
//  LanguageModel.swift
//  Snail
//
//  Created by Anna Yatsun on 25/12/2019.
//  Copyright © 2019 snailbuzz. All rights reserved.
//

import Foundation

enum LanguageCodes: String, CaseIterable {

    case ukraininan = "uk"
    case russian = "ru"
    case english = "en"
    case uzbekistan = "uz"
    case kazakhstan = "kk"
}

enum LanguageCodesISO: String, CaseIterable {
    
    case kazakhstan = "kk"
    case ukraininan = "ua"
    case russian = "ru"
    case english = "en"
    case uzbekistan = "uz"
}

enum LanguageNames: String, CaseIterable {

    case ukraininan = "Укаїнська"
    case russian = "Русский"
    case english = "English"
    case uzbekistan = "O'zbek"
    case kazakh = "Қазақ"

    func languageCode() -> LanguageCodes {
        let code: LanguageCodes

        switch self {
        case .ukraininan:
            code = .ukraininan
        case .russian:
            code = .russian
        case .english:
            code = .english
        case .uzbekistan:
            code = .uzbekistan
        case .kazakh:
            code = .kazakhstan
        }

        return code
    }
}

struct LanguageModel: Equatable {

    let name: String
    let languageCode: String

    init(name: LanguageNames) {
        self.name = name.rawValue
        self.languageCode = name.languageCode().rawValue
    }
}

struct AppLanguages {

    static let languageModels: [LanguageModel] = {
        return LanguageNames.allCases.map { LanguageModel(name: $0) }
    }()

    private static let defaultLanguageModel = LanguageModel(name: .english)

    static var languageModel: LanguageModel {
        get {
            let languageCode = Locale.current.languageCode
            let model = AppLanguages.languageModels.filter { $0.languageCode == languageCode }.first
                return model ?? AppLanguages.defaultLanguageModel
        }
    }

    static func getLanguageModel(isEqualTo code: String?) -> LanguageModel {
        return AppLanguages.languageModels.filter { $0.languageCode == code }.first ?? AppLanguages.defaultLanguageModel
    }
}
