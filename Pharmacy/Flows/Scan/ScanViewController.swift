//
//  ScanViewController.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 19.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScanViewControllerInput: ScanModelOutput {}
protocol ScanViewControllerOutput: ScanModelInput {}

final class ScanViewController: UIViewController, NavigationBarStyled {
    var style: NavigationBarStyle { .normalWithoutSearch }
    
    private enum GUI {
        static let animateionDuration: TimeInterval = 0.3
        static let blurIntensity: CGFloat =  0.1
        static let blurViewBackgroundColor = R.color.welcomeBlue()?.withAlphaComponent(0.2)
    }
    
    @IBOutlet private weak var scanImageView: UIImageView!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var preview: UIView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var codeCaptureView: UIView!
    private var captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private var blurView: UIVisualEffectView!
    
    var model: ScanViewControllerOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
        descriptionLabel.alpha = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    // MARK: - Private
    
    private func configUI() {
        blurView = CustomIntensityVisualEffectView(effect: UIBlurEffect(style: .light), intensity: GUI.blurIntensity)
        
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.backgroundColor = GUI.blurViewBackgroundColor
        view.insertSubview(blurView, belowSubview: preview)
        
        title = R.string.localize.scanTitle.localized()
        preview.isHidden = !model.isShouldShowPreview
        doneButton.layer.cornerRadius = doneButton.frame.height / 2
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let scanLayer = CAShapeLayer()
        let outerPath = UIBezierPath(rect: scanImageView.frame)
        let superlayerPath = UIBezierPath(rect: blurView.bounds)
        outerPath.usesEvenOddFillRule = true
        outerPath.append(superlayerPath)
        scanLayer.path = outerPath.cgPath
        scanLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        blurView.layer.mask = scanLayer
    }
    
    private func configCamera() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            failed()
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = codeCaptureView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        codeCaptureView.layer.insertSublayer(previewLayer, at: 0)
        captureSession.commitConfiguration()
        captureSession.startRunning()
        metadataOutput.rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: codeCaptureView.layer.bounds)
    }
    
    private func failed() {
        showError(title: "Scanning not supported",
                  message: "Your device does not support scanning a code from an item. Please use a device with a camera.")
    }
    
    private func found(code: String) {
        print(code)
        model.searchItemBy(code: code)
        showActionSheetView(content: R.nib.medicineCell(owner: self)!)
    }
    
    private func hidePreview() {
        UIView.animate(withDuration: GUI.animateionDuration, animations: { [weak self] in
            self?.preview?.alpha = 0
            self?.descriptionLabel.alpha = 1
        }, completion: { [weak preview] isCompleted in
            preview?.isHidden = isCompleted
        })
    }
    
// MARK: - Actions
    
    @IBAction func doneAction(_ sender: UIButton) {
        hidePreview()
    }
}

// MARK: - ScanViewControllerInput

extension ScanViewController: ScanViewControllerInput {
    func didFoundItem(item: String?) {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
        descriptionLabel.isHidden = item != nil
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
}
