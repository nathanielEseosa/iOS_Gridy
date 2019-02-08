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
    
    
    //MARK: - IBOUTLETS
    
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var imageEditorVCImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!


    
    //
    //MARK: - IBACTIONS
    
    @IBAction func cancelButtonPressed() {
        self.dismiss(animated: true)
        
        
    }
    
    @IBAction func startButtonPressed() {
        
        renderedImage = scrollView.asImage()
        
        if let renderedImage = renderedImage {
           arrayOfSlicedImages = slice(image: renderedImage, into: 4)
            performSegue(withIdentifier: "segueToPlayFieldVC", sender: self)
            
           
        } else {
            let alertContainer = UIAlertController(title: "Oh no!", message: "Your image isnt't there!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            alertContainer.addAction(okAction)
            
            present(alertContainer, animated: true, completion: nil)
        }
    
        
        
    }
    
    @IBAction func rotateImage(_ sender: UIRotationGestureRecognizer) {
        //let rotation = sender.rotation
        
        imageEditorVCImage.transform = imageEditorVCImage.transform.rotated(by: sender.rotation / -2)
        
    }
    
    
    //MARK: - SUPPORTING PROPERTIES
    
    var imageEditorVCImagePlaceHolder: UIImage?
    var renderedImage: UIImage?
    
    //MARK: - SUPPORTING METHODS
    
    
    /* Zoom functionality*/
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageEditorVCImage
        
    }
    
    //MARK: - SUPPORTING COLLECTION SECTION
    
    var arrayOfSlicedImages: [UIImage?] = []
    

    
    /// Slice image into array of tiles
    ///
    /// - Parameters:
    ///   - image: The original image.
    ///   - howMany: How many rows/columns to slice the image up into.
    ///
    /// - Returns: An array of images.
    ///
    /// - Note: The order of the images that are returned will correspond
    ///         to the `imageOrientation` of the image. If the image's
    ///         `imageOrientation` is not `.up`, take care interpreting
    ///         the order in which the tiled images are returned.
    
    
    func slice(image: UIImage, into howMany: Int) -> [UIImage] {
        let width: CGFloat
        let height: CGFloat
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            width = image.size.height
            height = image.size.width
        default:
            width = image.size.width
            height = image.size.height
        }
        
        let tileWidth = Int(width / CGFloat(howMany))
        let tileHeight = Int(height / CGFloat(howMany))
        
        let scale = Int(image.scale)
        var images = [UIImage]()
        
        let cgImage = image.cgImage!
        
        var adjustedHeight = tileHeight
        
        var y = 0
        for row in 0 ..< howMany {
            if row == (howMany - 1) {
                adjustedHeight = Int(height) - y
            }
            var adjustedWidth = tileWidth
            var x = 0
            for column in 0 ..< howMany {
                if column == (howMany - 1) {
                    adjustedWidth = Int(width) - x
                }
                let origin = CGPoint(x: x * scale, y: y * scale)
                let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
                let tileCgImage = cgImage.cropping(to: CGRect(origin: origin, size: size))!
                images.append(UIImage(cgImage: tileCgImage, scale: image.scale, orientation: image.imageOrientation))
                x += tileWidth
            }
            y += tileHeight
        }
        return images
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PlayFieldViewController {
            for image in arrayOfSlicedImages {
                vc.unshuffledArray.append(image!)
            }
        }
    }
    
   
    
    

}
