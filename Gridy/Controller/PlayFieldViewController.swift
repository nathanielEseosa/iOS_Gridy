//
//  PlayFieldViewController.swift
//  Gridy
//
//  Created by Nathaniel on 22.11.18.
//  Copyright © 2018 appostoliq. All rights reserved.
//

import UIKit

class PlayFieldViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        newGameButtonOutlet.layer.cornerRadius = 15
        
    }
    
    
    var arrayOfImages: [UIImage] = []
    
    /* Delegate methods of the UICollectionViewDataSource*/
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.slicedImageView.image = arrayOfImages[indexPath.item]
        
        return cell
    }
    


    
    
    //MARK: - IBOUTLETS
  
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newGameButtonOutlet: UIButton!
    //MARK: - IBACTIONS
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //MARK: - SUPPORTING PROPERTIES
    //MARK: - SUPPORTING METHODS
}
