//
//  PDFViewController.swift
//  Pharmacy
//
//  Created by Egor Bozko on 19.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController, NavigationBarStyled {
    var style: NavigationBarStyle {
        return .normalWithoutSearch
    }
    let pdfView = PDFView()
    let pdfURL: URL
    
    init(url: URL) {
        pdfURL = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.addSubview(pdfView)
        pdfView.constraintsToSuperView()
        open(pdf: pdfURL)
    }
    
    func open(pdf url: URL) {
        if let pdfDocument = PDFDocument(url: url) {
            pdfView.displayMode = .singlePageContinuous
            pdfView.autoScales = true
            pdfView.displayDirection = .vertical
            pdfView.document = pdfDocument
        }
    }
}
