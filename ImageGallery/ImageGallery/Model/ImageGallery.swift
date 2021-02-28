//
//  ImageGallery.swift
//  ImageGallery
//
//  Created by Petar Stanev on 30.01.21.
//

import Foundation

class ImageGallery {
    
    /// The name of image gallery
    var name: String
    /// A list with the urls of all images in image gallery
    var urlList: [URL]
    
    init(_ name: String,_ urlList: [URL]) {
        self.name = name
        self.urlList = urlList
    }
}
