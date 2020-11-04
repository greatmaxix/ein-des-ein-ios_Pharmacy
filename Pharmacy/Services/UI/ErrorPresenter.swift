//
//  ErrorPresenter.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 04.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import UIKit

protocol ErrorPresenter {
    func showError(text: String)
}

extension UIViewController: ErrorPresenter {

    func showError(text: String) {
        let alert = UIAlertController(title: "Ошибка!", message: text, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }

}
