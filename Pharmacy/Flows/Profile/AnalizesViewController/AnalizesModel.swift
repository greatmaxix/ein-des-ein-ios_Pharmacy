//
//  AnalizesModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 21.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

protocol AnalizesInput {
    func close()
    func signUpAnalysis()
}

final class AnalizesModel: EventNode {
    
}

extension AnalizesModel: AnalizesInput {
    
    func close() {
        raise(event: ProfileEvent.close)
    }
    
    func signUpAnalysis(){
        let model = InDevelopmentModel(title: R.string.localize.empty_model_title.localized(), subTitle: R.string.localize.empty_subtitle_title.localized(), image: "inDelivary")
        raise(event: AppEvent.presentInDev(model))
    }
}
