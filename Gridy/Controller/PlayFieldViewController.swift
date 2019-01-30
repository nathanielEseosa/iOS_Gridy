//
//  PlayFieldViewController.swift
//  Gridy
//
//  Created by Nathaniel on 22.11.18.
//  Copyright © 2018 appostoliq. All rights reserved.
//

import UIKit


class PlayFieldViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    //MARK: - PROPERTIES
    
    
    //Data Source for CollectionView-1
    /// This array contains the sliced images from the ImageEditorViewController
    var imagesInCollectionView1: [UIImage] = []
    
    //Data Source for CollectionView-2
    /// This array will contain the sliced images draged from the CollectionView-1
    var imagesInCollectionView2: [UIImage] = []
    
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    
    @IBOutlet weak var newGameButtonOutlet: UIButton!
    
    //MARK: - VIEW LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CollectionView-1 drag and drop configuration
        collectionView1.dragInteractionEnabled = true //default value on iPhone is false
        collectionView1.dataSource = self
        //collectionView1.delegate = self // ?
        collectionView1.dragDelegate = self
        collectionView1.dropDelegate = self
        
        //CollectionView-2 drag and drop configuration
        self.collectionView2.dragInteractionEnabled = true
        self.collectionView2.dropDelegate = self
        self.collectionView2.dragDelegate = self
        self.collectionView2.reorderingCadence = .fast //default value - .immediate
        
        newGameButtonOutlet.layer.cornerRadius = 15
        
    }
    
    
    /* Enabling drags with the delegate method of the UICollectionViewDragDelegate*/
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let item = self.imagesInCollectionView1[indexPath.row]
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
            //Code to reorder items
            
            let items = coordinator.items
            if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
            {
                var dIndexPath = destinationIndexPath
                if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
                {
                    dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
                }
                collectionView.performBatchUpdates({
                    self.imagesInCollectionView1.remove(at: sourceIndexPath.row)
                    self.imagesInCollectionView1.insert(item.dragItem.localObject as! UIImage, at: dIndexPath.row)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [dIndexPath])
                })
                coordinator.drop(item.dragItem, toItemAt: dIndexPath)
            }
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

    
    
    /* Delegate methods of the UICollectionViewDataSource*/
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesInCollectionView1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionView1Cell", for: indexPath) as! CollectionViewCell1
        
        cell.imageView.image = imagesInCollectionView1[indexPath.item]
        
        return cell
    }
    
    
    
  
    
    //MARK: - IBACTIONS
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //MARK: - SUPPORTING PROPERTIES
    //MARK: - SUPPORTING METHODS
    
    
    /* Drag and Drop */
   

 
    
    
}
