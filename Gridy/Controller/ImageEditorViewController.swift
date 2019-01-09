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
        imageEditorVCImage.image = imageEditorVCImagePlaceHolder
        startButton.layer.cornerRadius = 15
        
        
    }
    
    
    //MARK: - OUTLETS SECTION
    
    @IBOutlet weak var imageEditorVCImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!

    
    
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
  
    
    
    
    
    
    
}
