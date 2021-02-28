//
//  DetailViewController.swift
//  ImageGallery
//
//  Created by Petar Stanev on 31.01.21.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    /// The image url in collection cell
    var url: URL?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 2.0
            scrollView.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard imageView.image == nil else { return }
        fetchImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    /// Fetch the url from google images, get the content and convert it to UIImage
    private func fetchImage() {
        guard let currentUrl = url else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let urlContents = try? Data(contentsOf: currentUrl.imageURL)
            DispatchQueue.main.async {
                guard let imageData = urlContents, currentUrl == self?.url else { return }
                self?.spinner?.stopAnimating()
                self?.imageView.image = UIImage(data: imageData)
            }
        }
    }
}
