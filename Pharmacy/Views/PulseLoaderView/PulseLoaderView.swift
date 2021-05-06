//
//  PulseLoaderView.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 06.05.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

final class PulseLoaderService {
    
    static func showAdded(to: UIView) {
        guard to.subviews.first(where: { $0 is PulseLoaderContainerView }) == nil else { return }
        let container = PulseLoaderContainerView()
        container.frame = to.bounds
        container.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        to.addSubview(container)
        
        let ind = PulseLoaderView(frame: CGRect(x: to.frame.width / 2, y: to.frame.height / 2, width: 104, height: 104))
        ind.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(ind)
        
        NSLayoutConstraint.activate([
            ind.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            ind.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            ind.heightAnchor.constraint(equalToConstant: 104),
            ind.widthAnchor.constraint(equalToConstant: 104)
        ])
        ind.backgroundColor = .clear
        ind.startAnimating()
    }
    
    static func hide(from: UIView) {
        from.subviews.first(where: { $0 is PulseLoaderContainerView })?.removeFromSuperview()
    }
}

class PulseLoaderContainerView: UIView {
    
}

class PulseLoaderView: UIView {
    
    var freefrom: UIBezierPath!
    
    let shapeLayer = CAShapeLayer()
    
    init(frame: CGRect, image: UIImage? = nil) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.addSublayer(self.shapeLayer)
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        pulse()
    }
    
    func startAnimating() {
        isHidden = false
        pulse()
    }
    
    func stopAnimating() {
        isHidden = true
        removePulse()
    }
    
    func pulse() {
        let freeform = UIBezierPath()
        freeform.move(to: CGPoint(x: 6, y: 52))
        freeform.addLine(to: CGPoint(x: 27, y: 52))
        freeform.addLine(to: CGPoint(x: 32, y: 51))
        freeform.addLine(to: CGPoint(x: 36, y: 55))
        freeform.addLine(to: CGPoint(x: 46, y: 26))
        freeform.addLine(to: CGPoint(x: 56, y: 69))
        freeform.addLine(to: CGPoint(x: 61, y: 50))
        freeform.addLine(to: CGPoint(x: 66, y: 56))
        freeform.addLine(to: CGPoint(x: 70, y: 50))
        freeform.addLine(to: CGPoint(x: 74, y: 52))
        freeform.addLine(to: CGPoint(x: 94, y: 52))

        shapeLayer.strokeColor = R.color.welcomeBlue()?.cgColor ?? UIColor.blue.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.lineWidth = 4
        shapeLayer.path = freeform.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.freefrom = freeform
        animate()
    }
    
    func animate() {
        let trimPathStart = CABasicAnimation(keyPath: "strokeEnd")
        trimPathStart.timingFunction = .init(name: .default)
        trimPathStart.duration = 1
        trimPathStart.repeatCount = .infinity
        trimPathStart.isRemovedOnCompletion = false
        trimPathStart.fromValue = 0
        trimPathStart.timeOffset = 1
        trimPathStart.toValue = 1
        
        self.shapeLayer.add(trimPathStart, forKey: "path")
    }

    private func removePulse() {
        self.layer.removeAnimation(forKey: "path")
    }
}
