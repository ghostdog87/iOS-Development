//
//  ImageGalleryCollectionViewCell.swift
//  ImageGallery
//
//  Created by Petar Stanev on 30.01.21.
//

import UIKit

class ImageGalleryCollectionViewCell: UICollectionViewCell {
    
    /// The image url in collection cell
    var url: URL? {
        didSet {
            if url != nil {
                imageView.image = nil
                fetchData(with: url!)
            }
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    /// Fetch the url from google images, get the content and convert it to UIImage
    private func fetchData(with imageUrl: URL) {
        self.spinner.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let urlContents = try? Data(contentsOf: imageUrl.imageURL) {
                DispatchQueue.main.async {
                    if let image = UIImage(data: urlContents) {
                        self?.imageView?.image = image
                        self?.spinner.stopAnimating()
                        //print("got the image")
                    } else {
                        //print("lost the image 1")
                    }
                }
            } else  if self != nil {
                DispatchQueue.main.async {
                    //print("lost the image 2")
                }
            }
        }
    }
}
