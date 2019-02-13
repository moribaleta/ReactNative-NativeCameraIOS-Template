//
//  CameraModule.swift
//  SampleProjectCamera
//
//  Created by Gabriel on 11/02/2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import AVFoundation

@available(iOS 10.0, *)
@objc(CameraModuleManager)
public class CameraModuleManager: RCTViewManager {
  
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  var captureSession: AVCaptureSession!
  var stillImageOutput: AVCapturePhotoOutput!
  var videoPreviewLayer: AVCaptureVideoPreviewLayer!
  var camerapreview: CameraPreview!
  
  var delegate : CameraAction?
  
  
  override init() {
    super.init()
    self.delegate = self
    camerapreview = CameraPreview(frame: CGRect(x: 0, y: 0, width: 400, height: 400), delegate: delegate!)
    captureSession = AVCaptureSession()
    captureSession.sessionPreset = .photo
    guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
      else {
        print("Unable to access back camera!")
        return
    }
    
    do {
      let input = try AVCaptureDeviceInput(device: backCamera)
      stillImageOutput = AVCapturePhotoOutput()
      
      if captureSession.canAddInput(input) && self.captureSession.canAddOutput(stillImageOutput) {
        captureSession.addInput(input)
        captureSession.addOutput(stillImageOutput)
        self.setupLivePreview()
      }
    }
    catch let error  {
      print("Error Unable to initialize back camera:  \(error.localizedDescription)")
    }
  }
  
  func setupLivePreview() {
    
    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    videoPreviewLayer.videoGravity = .resizeAspectFill
    videoPreviewLayer.connection?.videoOrientation = .portrait
    camerapreview.layer.addSublayer(videoPreviewLayer)
    
    DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
      self.captureSession.startRunning()
      //Step 13
    }
    
    DispatchQueue.main.async {
      self.videoPreviewLayer.frame = self.camerapreview.bounds
    }
    //Step12
  }
  
  override public func view() -> UIView! {
      return camerapreview
    }
  
  @objc func onCameraTakePhoto(_ node: NSNumber) {
    print("take photo")
    self.onTakePhoto()
  }

}

/*

*/
@available(iOS 10.0, *)
extension CameraModuleManager: CameraAction {
  public func onTakePhoto() {
    if #available(iOS 11.0, *) {
      print("on take photo")
      let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
      stillImageOutput.capturePhoto(with: settings, delegate: self)
    } else {
      // Fallback on earlier versions
    }
    
  }
  
  public func onChangeSize(_ frame: CGRect) {
    //self.camerapreview.subviews[0].frame = frame
    DispatchQueue.main.async {
      self.videoPreviewLayer.frame = self.camerapreview.bounds
    }
    self.videoPreviewLayer.setNeedsLayout()
  }
  
}

@available(iOS 10.0, *)
extension CameraModuleManager: AVCapturePhotoCaptureDelegate{
  
  
  
  @available(iOS 11.0, *)
  public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    guard let imageData = photo.fileDataRepresentation() else {
      return
    }
    if let image = UIImage(data: imageData) {
      let success = saveImage(image: image)
      if(success) {
        print("saved")
      }else{
        print("damnit")
      }
    }else {
      // Fallback on earlier versions
    }
  }
  
  
  func saveImage(image: UIImage) -> Bool {
    guard (image.jpegData(compressionQuality: 1) ?? image.pngData()) != nil else {
      return false
    }
    guard (try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL) != nil else {
      return false
    }
    
    
    if let pathToSavedImage = saveImageToDocumentsDirectory(image: image, withName: "\(randomString(length: 8)).jpeg") {
      self.camerapreview.setImageUpdate(imagePath: pathToSavedImage)
    }
    /*
    if (pathToSavedImage == nil) {
        print("Failed to save image")
    }
    */
  
    /*
    if let strBase64 = image.jpegData(compressionQuality: 1)?.base64EncodedString() {
        print(pathToSavedImage)
        self.camerapreview.setImageUpdate(imagePath: pathToSavedImage)
        //self.camerapreview.setImageUpdate(base64: strBase64)
    }
    */
    
    return true
  }
  
  func getDocumentDirectoryPath() -> NSString {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory as NSString
  }
  
  func saveImageToDocumentsDirectory(image: UIImage, withName: String) -> String? {
    if let data = image.jpegData(compressionQuality: 1) {
      let dirPath = getDocumentDirectoryPath()
      let imageFileUrl = URL(fileURLWithPath: dirPath.appendingPathComponent(withName) as String)
      do {
        try data.write(to: imageFileUrl)
        print("Successfully saved image at path: \(imageFileUrl)")
        return imageFileUrl.absoluteString
      } catch {
        print("Error saving image: \(error)")
      }
    }
    return nil
  }
  
  func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0...length-1).map{ _ in letters.randomElement()! })
  }

  
}


/*
-----
*/
public protocol CameraAction{
  func onTakePhoto()
  func onChangeSize(_ frame: CGRect )
}

/*
-------
*/
public class CameraPreview: UIView {
  
  
  var height: NSNumber = 400
  var width : NSNumber = 400
  var delegate : CameraAction?
  

  @objc var onImageReturn: RCTDirectEventBlock?
  
  public func setImageUpdate(imagePath: String){
      onImageReturn!(["image":imagePath])
  }
  
  public override func reactSetFrame(_ frame: CGRect) {
    super.reactSetFrame(frame)
    delegate?.onChangeSize(frame)
  }
  
  
  @objc(setHeight:) func setHeight( _ val: NSNumber){
    self.height = val
  
    print("set height \(self.height)")
    self.frame = CGRect(x: 0, y: 0, width: Double(self.width), height:Double(self.height))
    self.setNeedsLayout()
    self.reactSetFrame(self.frame)
  }
  
  @objc(setWidth:) func setWidth(_ val: NSNumber){
    self.width = val
    
    print("set width \(self.width)")
    
    self.frame = CGRect(x: 0, y: 0, width: Double(self.width), height:Double(self.height))
    self.setNeedsLayout()
    self.reactSetFrame(self.frame)
  }
  
  
  /*
  @objc(onClick:) func onClick(_ val: NSNumber) {
      self.delegate?.onTakePhoto()
  }
  */
  
  
  init(frame: CGRect, delegate: CameraAction) {
    super.init(frame: frame)
    self.delegate = delegate
    
    self.backgroundColor = UIColor.blue
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
