//
//  LanguageService.swift
//  Snail
//
//  Created by Anna Yatsun on 25/12/2019.
//  Copyright © 2019 snailbuzz. All rights reserved.
//

import Foundation
import Rswift

private let appleLanguages = "AppleLanguages"
private let appLanguage = "Pharamcy_AppLanguage"

class LanguageService: Observable {

    static var current: LanguageService =  {
        return LanguageService()
    }()
    
    private override init() {
        
    }

    // MARK: - Public methods

    public func setLanguageIfNeed() {
        if !self.isContainsLanguage(forKey: appLanguage) {
            self.setLanguage(AppLanguages.languageModel)
        }
    }

    public func saveLanguageModel(_ languageModel: LanguageModel) {
        UserDefaults.standard.set([languageModel.languageCode], forKey: appleLanguages)
        UserDefaults.standard.set(languageModel.languageCode, forKey: appLanguage)
        didChange()
    }

    public func getCurrentLanguageModel() -> LanguageModel {
        return self.savedLanguageModel() ?? AppLanguages.languageModel
    }

    public func resetLanguage() {
        UserDefaults.standard.removeObject(forKey: appLanguage)
    }

    // MARK: - Private methods

    private func savedLanguageModel() -> LanguageModel? {
        var languageModel: LanguageModel?
        if let languageCode = UserDefaults.standard.object(forKey: appLanguage) as? String {
            languageModel = AppLanguages.getLanguageModel(isEqualTo: languageCode)
        }
        return languageModel
    }

    private func setLanguage(_ languageModel: LanguageModel) {
        UserDefaults.standard.set([languageModel.languageCode], forKey: appleLanguages)
        UserDefaults.standard.synchronize()
    }

    private func isContainsLanguage(forKey: String) -> Bool {
        return UserDefaults.standard.object(forKey: forKey) != nil
    }

}

class Observable {

    private var observers = [Observer]()

    func attach(_ observer: Observer) {
        observers.append(observer)
    }

    func detach(_ observer: Observer) {
        if let idx = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: idx)
        }
    }

    private func notify() {
        observers.forEach({ $0.update(subject: self)})
    }

    func didChange() {
        notify()
    }
}

protocol Observer: class {
    func update(subject: Observable)
}
