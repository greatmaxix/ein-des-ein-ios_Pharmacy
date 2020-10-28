//
//  ChooseLocationViewModel.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

protocol ChooseLocationViewModelOutput: class {}
protocol ChooseLocationViewModelInput: class {}


class ChooseLocationViewModel: Model {
    weak var output: SearchModelOutput!
}
