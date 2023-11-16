//
//  ScannerVC.swift
//  barcodescanner
//
//  Created by Agustin Carbajal on 16/11/2023.
//

import UIKit
import AVFoundation

enum CameraError: String {
    case invalidDeviceInput = "Something wrong with the camera"
    case invalidScannedValue = "Something wrong with the barcode"
}

protocol ScannerVCDeletagate: class {
    func didFind(barcode:String)
    func didSurface(error:CameraError)
}

final class ScannerVC: UIViewController {
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: ScannerVCDeletagate?
    
    init(scannerDelegate: ScannerVCDeletagate) {
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        
        guard let previewLayer = previewLayer else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer.frame = view.layer.bounds
    }
    
    private func setupCaptureSession(){
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let metadataoutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataoutput) {
            captureSession.addOutput(metadataoutput)
            metadataoutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataoutput.metadataObjectTypes = [.ean8,.ean13]
        } else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        captureSession.startRunning()
        
    }
    
}

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate { // el delegado nos sirve para decir que hacemos una vez que escaneamos el codigo
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        guard let machineRedableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        guard let barcode = machineRedableObject.stringValue else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        captureSession.stopRunning()
        scannerDelegate?.didFind(barcode: barcode)
    }
}
