//
//  TakePicture.swift
//  GroceryHandler
//
//  Created by Victor Micha on 6/16/22.
//

import Foundation
import AVFoundation

func takePicture(){
    //could maybe return an image which could be passed into other method which would
    //give it to vision api
    
    /*
     code for this function is taken/copied from here:
     https://developer.apple.com/documentation/avfoundation/capture_setup/requesting_authorization_for_media_capture_on_ios
   
     */
    print("in the take picture method")
    
    switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera. was "self.setupCaptureSession()"
          captureSession()
        
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                   print("can now take pics")
                    // self.setupCaptureSession()
                   captureSession()
                }
            }
        
        case .denied: // The user has previously denied access.
            print("denied")//return

        case .restricted: // The user can't grant access due to restrictions.
            print("restricted")//return
        default:
            print("default")//return
    }

}
class PhotoCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    func photoOutput(didFinishProcessingPhoto photo: AVCapturePhoto,
                error: Error?){
        print("GOT TO HEERE")
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?){
        print("Got tO HERE 2")
    }
}

func captureSession(){
    /*
     code for this function is taken/copied from:
     https://developer.apple.com/documentation/avfoundation/capture_setup/setting_up_a_capture_session
     */
    print("beginning of capture session function")
    let captureSession = AVCaptureSession()
    captureSession.beginConfiguration()
    let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                              for: .video, position: .unspecified)
    if (videoDevice==nil){
        print("havent found videoDevice")
        return
    }
    guard
        let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
        captureSession.canAddInput(videoDeviceInput)
        else { return }
    captureSession.addInput(videoDeviceInput)
    
    print("heeeeere")
    
    
    let photoOutput = AVCapturePhotoOutput()
    guard captureSession.canAddOutput(photoOutput) else { return }
    captureSession.sessionPreset = .photo
    captureSession.addOutput(photoOutput)
    captureSession.commitConfiguration()
 
    
    //to setup live preview
    let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    //https://guides.codepath.com/ios/Creating-a-Custom-Camera-View
    previewLayer.videoGravity = .resizeAspect
    previewLayer.connection?.videoOrientation = .portrait
    //myView.layer.addSublayer(previewLayer)
    
  
    
    let capturePhotoSetting = AVCapturePhotoSettings()
    let del = PhotoCaptureProcessor()
    photoOutput.capturePhoto(with: capturePhotoSetting, delegate: del)
    captureSession.startRunning()

  //  let captureResolvePhotoSettings = AVCaptureResolvedPhotoSettings()
//    del.photoOutput?(output:photoOutput, didCapturePhotoFor: <#T##AVCaptureResolvedPhotoSettings#>)
   
    print("end of capture session function")
   
    
}
func photoOutput(didFinishProcessingPhoto photo: AVCapturePhoto,
                 error: Error?){
    print("IN THIS METHOD NOT THE OTHER ONE")
}

func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto,
    error: Error?){
    print("IN PHOTO OUTPUT FUNCTION")
    /*
     code for this function is taken/copied from https://nitinagam17.medium.com/capture-photo-using-avcapturesession-in-swift-842bb95751f0
     */
  //  guard let imageData = photo.fileDataRepresentation() else { return}
   // let previewImage = UIImage(data: imageData)
    print("END OF PHOTO OUTPUT FUNCTION")
   //we now have the image we can work with
    //there is more code on website described above
}
