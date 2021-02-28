//
//  MovieListCollectionViewCell.swift
//  MovieApp
//
//  Created by Petar Stanev on 10.02.21.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    /// The image in collection cell
    var image: UIImage? {
        didSet {
            guard image != nil else { return }
            imageView.image = image
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
}
