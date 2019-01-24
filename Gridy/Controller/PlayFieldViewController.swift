//
//  PlayFieldViewController.swift
//  Gridy
//
//  Created by Nathaniel on 22.11.18.
//  Copyright © 2018 appostoliq. All rights reserved.
//

import UIKit


class PlayFieldViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    
    
    
    /* Enabling drags with the delegate method of the UICollectionViewDragDelegate*/
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let item = self.arrayOfImages[indexPath.row]
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    
    /* Enabling drops with the delegate method of the UICollectionViewDropDelegate*/
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath
        {
            destinationIndexPath = indexPath
        }
        else
        {
            // Get last index path of collection view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation
        {
        case .move:
            //Add the code to reorder items
            break
            
        case .copy:
            //Add the code to copy items
            break
            
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if session.localDragSession != nil {
            if collectionView.hasActiveDrag {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
            else {
                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            }
        }
        else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }

  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        

        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        // The default value of this property is true on iPad and false on iPhone
        collectionView.dragInteractionEnabled = true
    
        
        
        newGameButtonOutlet.layer.cornerRadius = 15
        
    }
    

    
    
    var arrayOfImages: [UIImage] = []
    
    /* Delegate methods of the UICollectionViewDataSource*/
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.image = arrayOfImages[indexPath.item]
        
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
    
    
    /* Drag and Drop */
   

 
    
    
}
