//
//  UIViewRenderExtention.swift
//  Gridy
//
//  Created by Nathaniel Idahosa on 15.01.19.
//  Copyright © 2019 appostoliq. All rights reserved.
//


import UIKit


extension UIView {
  
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
