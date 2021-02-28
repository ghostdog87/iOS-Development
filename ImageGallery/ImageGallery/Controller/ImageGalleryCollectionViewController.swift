//
//  ImageGalleryCollectionViewController.swift
//  ImageGallery
//
//  Created by Petar Stanev on 30.01.21.
//

import UIKit

class ImageGalleryCollectionViewController: UICollectionViewController, UICollectionViewDropDelegate, UICollectionViewDragDelegate,UICollectionViewDelegateFlowLayout {
    
    /// Identifier of collection cell
    private let imageCellIdentifier = "ImageCell"
    /// Identifier of collection cell placeholder used in drag and drop functionality
    private let cellPlaceholderIdentifier = "DropPlaceholderCell"
    /// Identifier of detailed view
    private let detailViewIdentifier = "DetailView"
    /// Number of collection sections in Image gallery
    private let numberOfCollectionViewSections = 1
    /// Scale used to calculate collection cells size
    private var scaleForCollectionViewCell: CGFloat = 1.0
    /// Frame width size with included margin offset
    private var frameWidth: CGFloat {
        return imageGalleryCollectionView.frame.size.width - 20
    }
    /// Frame height size with included margin offset
    private var frameHeight: CGFloat {
        return imageGalleryCollectionView.frame.size.height - 20
    }
    /// Width of the collection cells
    private var cellWidth: CGFloat = 0 {
        didSet {
            if cellWidth > frameWidth {
                cellWidth = frameWidth
            }
        }
    }
    /// Height of the collection cells
    private var cellHeight: CGFloat = 0 {
        didSet {
            if cellHeight > frameHeight {
                cellHeight = frameHeight
            }
        }
    }
    
    /// Currently active gallery
    var imageGallery: ImageGallery? {
        didSet {
            imageGalleryCollectionView.reloadData()
            navigationItem.title = "Image Gallery: " + (imageGallery?.name ?? " undefined")
        }
    }
    
    @IBOutlet private var imageGalleryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onPinch(_ sender: UIPinchGestureRecognizer) {
        scaleForCollectionViewCell *= sender.scale
        sender.scale = 1
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellWidth = (frameWidth * scaleForCollectionViewCell) / 2
        cellHeight = (frameHeight * scaleForCollectionViewCell) / 3
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // MARK: - Navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: detailViewIdentifier, sender: collectionView.cellForItem(at: indexPath))   
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detail = segue.destination.contents as? DetailViewController, let cell = sender as? ImageGalleryCollectionViewCell else { return }
        detail.url = cell.url
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfCollectionViewSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageGallery?.urlList.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as? ImageGalleryCollectionViewCell else { return UICollectionViewCell()}
        cell.url = imageGallery?.urlList[indexPath.item]
        return cell
    }
    
    // MARK: Drag and Drop
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        let isLocalSession = session.localDragSession != nil
        return imageGallery != nil && ((session.canLoadObjects(ofClass: UIImage.self) && session.canLoadObjects(ofClass: NSURL.self)) || isLocalSession)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            // Check if item already exists in gallery
            if let sourceIndexPath = item.sourceIndexPath {
                guard let imageUrl = item.dragItem.localObject as? URL else { continue }
                collectionView.performBatchUpdates({
                    imageGallery?.urlList.remove(at: sourceIndexPath.item)
                    imageGallery?.urlList.insert(imageUrl, at: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            } else {
                // Item does not exist yet in gallery and it will be added
                let placeholderContext = coordinator.drop(
                    item.dragItem,
                    to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: cellPlaceholderIdentifier)
                )
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let imageUrl = provider as? URL {
                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                self.imageGallery?.urlList.insert(imageUrl, at: insertionIndexPath.item)
                            })
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDragDelegate
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageGalleryCollectionViewCell,
              let image = cell.url else { return [] }
        
        let dragItemImage = UIDragItem(itemProvider: NSItemProvider(object: image.imageURL as NSItemProviderWriting))
        dragItemImage.localObject = image
        return [dragItemImage]
    }
}
