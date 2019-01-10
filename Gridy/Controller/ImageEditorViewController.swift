//
//  ImageEditorViewController.swift
//  Gridy
//
//  Created by Nathaniel on 22.11.18.
//  Copyright © 2018 appostoliq. All rights reserved.
//

import UIKit

class ImageEditorViewController: UIViewController, UIScrollViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        imageEditorVCImage.image = imageEditorVCImagePlaceHolder
        startButton.layer.cornerRadius = 15
    }
    
    
    //MARK: - OUTLETS SECTION
    
    @IBOutlet weak var imageEditorVCImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!

    
    //
    //MARK: - BUTTONS SECTION
    
    @IBAction func cancelButtonPressed() {
        self.dismiss(animated: true)
    }
    
    @IBAction func startButtonPressed() {
        
        
    }
    
    //MARK: - SUPPORTING PROPERTIES SECTION
    
     var imageEditorVCImagePlaceHolder: UIImage?
    
    //MARK: - SUPPORTING METHODS SECTION
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageEditorVCImage
        
    }
    
    
    @IBAction func rotating(_ sender: UIRotationGestureRecognizer) {
        //let rotation = sender.rotation
        
        imageEditorVCImage.transform = imageEditorVCImage.transform.rotated(by: sender.rotation / -2)
        
        
        
        
    }
    
    
    
    
    
    
    
}
