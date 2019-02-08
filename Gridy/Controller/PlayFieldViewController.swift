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
    
    
    //Data Source for unshuffled array
    /// This array contains the sliced images from the ImageEditorViewController
    var unshuffledArray: [UIImage] = []
    
    //Data Source for CollectionView-1
    /// This shuffled array contains the sliced images from the unshuffledArray
    var imagesInCollectionView1: [UIImage] = []
    
    //Data Source for CollectionView-2
    /// This array will contains the sliced images draged from the CollectionView-1 which originated from the imagesInCollectionView1
    var imagesInCollectionView2: [UIImage] = []
    
    
//MARK: - IBOUTLETS
    
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    
    @IBOutlet weak var newGameButtonOutlet: UIButton!
    
//MARK: - VIEW LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesInCollectionView1 = unshuffledArray
        imagesInCollectionView1.shuffle()
        
        //CollectionView-1 drag and drop configuration
        collectionView1.dragInteractionEnabled = true //default value on iPhone is false
        collectionView1.dataSource = self
        collectionView1.dragDelegate = self
        collectionView1.dropDelegate = self
        
        //CollectionView-2 drag and drop configuration
        collectionView2.dragInteractionEnabled = true
        collectionView2.dropDelegate = self
        collectionView2.dataSource = self
        collectionView2.dragDelegate = self
        collectionView2.reorderingCadence = .fast //default value - .immediate
        
        newGameButtonOutlet.layer.cornerRadius = 15
        
    }
    
    
// MARK: - UICollectionViewDragDelegate METHODS
    
    // Provides the initial set of items (if any) to drag.
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let item = self.imagesInCollectionView1[indexPath.row]
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    

// MARK: - UICollectionViewDropDelegate METHODS
    
    // Asking the delegate whether the collection view can accept a drop with the specified type of data.
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    
    // Tells the delegate that the position of the dragged data over the collection view changed.
    private func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {
        if collectionView === self.collectionView1
        {
            if collectionView.hasActiveDrag
            {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
            else
            {
                return UICollectionViewDropProposal(operation: .forbidden)
            }
        }
        else
        {
            if collectionView.hasActiveDrag
            {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
            else
            {
                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            }
        }
    }
    
    // Tells the delegate to incorporate the drop data into the collection view.
    
  
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destinationIndexPath: IndexPath

        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of collection view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }

        switch coordinator.proposal.operation {

        case .move:
            
            // A drop operation type specifying that the data represented by the drag items should be moved, not copied.

            let items = coordinator.items
            if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath {
                var dIndexPath = destinationIndexPath
                if dIndexPath.row >= collectionView.numberOfItems(inSection: 0) {
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
            
            // A drop operation type specifying that the data represented by the drag items should be copied to the destination view.

            collectionView.performBatchUpdates({
                var indexPaths = [IndexPath]()
                for (index, item) in coordinator.items.enumerated()
                {
                    //Destination index path for each item is calculated separately using the destinationIndexPath fetched from the coordinator
                    let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                    self.imagesInCollectionView2.insert(item.dragItem.localObject as! UIImage, at: indexPath.row)
                    indexPaths.append(indexPath)
                }
                collectionView.insertItems(at: indexPaths)
            })


            break

        default:
            return
        }
    }
    

 
    
//    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
//
//        if session.localDragSession != nil {
//
//            if collectionView.hasActiveDrag {
//                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
//            } else {
//                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
//            }
//
//        } else {
//            return UICollectionViewDropProposal(operation: .forbidden)
//        }
//    }

    
    
    
// MARK: - UICollectionViewDataSource METHODS
    
    // Asks the data source object for the number of items in the specified section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionView == self.collectionView1 ? self.imagesInCollectionView1.count : self.imagesInCollectionView2.count
        
    }
    
    //Asks the data source object for the cell that corresponds to the specified item in the collection view.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionView1Cell", for: indexPath) as! CollectionViewCell1
            cell.imageView.image = imagesInCollectionView1[indexPath.item]
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionView2Cell", for: indexPath) as! CollectionViewCell2
            cell.imageView.image = imagesInCollectionView2[indexPath.item]
            return cell
        }
    }
    
    
    
  
    
//MARK: - IBACTIONS
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
  
   

 
    
    
}
