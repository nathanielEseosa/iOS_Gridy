 //
//  IntroView.swift
//  Gridy
//
//  Created by Nathaniel on 22.11.18.
//  Copyright © 2018 appostoliq. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class IntroViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeIntroViewVCButtonRadius() //Supporting method
    }
    
    //MARK: - OUTLETS SECTION
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var labelButton: UIButton!
    @IBOutlet weak var gridyButton: UIButton!
    

  
    //MARK: - BUTTONS SECTION
    
    @IBAction func randomButtonPressed(_ sender: UIButton) {
        displayRandomImage()
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        openDeviceCamera()
    }
    
    @IBAction func libraryButtonPressed(_ sender: UIButton) {
        openPhotoLibrary()
    }
    

    
    //MARK: - SUPPORTING PROPERTIES SECTION
    
    /**/
    var introVCImagePlaceholder: UIImage?
    
    /**/
    let gridyRandomImageArray: [String?] = ["globe", "hamburger", "nature", "squirrel", "toyCar"]

    //MARK: - SUPPORTING METHODS SECTION
  
    /* Makes the buttons have rounded corners. Called after view loaded */
    func changeIntroViewVCButtonRadius() {
        cameraButton.layer.cornerRadius = 15
        labelButton.layer.cornerRadius = 15
        gridyButton.layer.cornerRadius = 15
    }
    
    /**/
    func displayRandomImage() {
        
        /* Check if the array is empty and if the name is valid */
        if !gridyRandomImageArray.isEmpty {
            let randomImageIndex = Int.random(in: 0...gridyRandomImageArray.count - 1)
            if let randomImageName = gridyRandomImageArray[randomImageIndex] {
                introVCImagePlaceholder = UIImage(named: randomImageName)
                performSegue(withIdentifier: "segueToImageEditorVC", sender: nil)
            }
        }
    }
    
                        //MARK: ACCESS PHOTO LIBRARY SECTION
    
    //MARK: - Helper Methods
    
    /* A helper method that will run the photo library app*/
    func presentImagePicker(sourceType: UIImagePickerController.SourceType){
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    /* A helper method that run an alert if the photo library is not reachable (has no photos). */
    func troubleAlert(message: String?) {
        let alertController = UIAlertController(title: "Oops...", message: message , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Got it", style: .cancel)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    //MARK: - Main Method
    
    /* The main method that uses the “presentImagePicker” and “troubleAlert” methods to display the library and if necessary run the alert. */
    func openPhotoLibrary() {
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        
        // Asking the user for authorization is redundant because the app does not have access to the images in the photo library. It is only asking the user to pick an image. After the user picks an image, the image will be handed over (using the delegate) to the app's associated view. In this case the user always have full control.
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let status = PHPhotoLibrary.authorizationStatus()
            let noPermissionMessage = "Looks like Gridy doesn't have access to your photos. Please go to Settings on your device to permit Gridy accessing your library"
            
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus == .authorized {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            }
        }
        else {
            troubleAlert(message: "Sincere apologies, it looks like we can't access your photo library at this time")
        }
    }
    

                        //MARK: ACCESS DEVICE CAMERA SECTION

    //MARK: - Helper Methods
    
    /* A helper method that will run the device camera app */
    func presentCamera(sourceType: UIImagePickerController.SourceType){
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    /* A helper method that display an alert if the device camera is not accessable */
    func troubleAlertForOpenCamera(message: String?) {
        let alertController = UIAlertController(title: "Oops...", message: message , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Got it", style: .cancel)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    //MARK: - Main Method
    
    /**/
    func openDeviceCamera() {
        let sourceType = UIImagePickerController.SourceType.camera
        
        // Check if device camera is available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {

            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            let noPermissionMessage = "Looks like Gridy doesn't have access to your camera. Please go to Settings on your device to permit Gridy accessing your camera"

            // Check if access to the device camera is authorized
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                    if granted {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            }
        }
        else {
            troubleAlert(message: "Sincere apologies, it looks like we can't access your camera at this time")
        }
    }
    
    /* Tells the delegate (IntroViewController) that the user picked an image. It is called as soon as the user picks an image */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let unwrappedImagePickedByUser = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            introVCImagePlaceholder = unwrappedImagePickedByUser
            picker.dismiss(animated: true) {
                self.performSegue(withIdentifier: "segueToImageEditorVC", sender: nil)
            }
        }
    }
    
    
    
    /* Using the prepare for segue method to assign the user's picked image to a variable in targeted view controller */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ImageEditorViewController {
        vc.imageEditorVCImagePlaceHolder = introVCImagePlaceholder
        }
    }
    
    
}

