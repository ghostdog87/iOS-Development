//
//  Movie.swift
//  MovieApp
//
//  Created by Petar Stanev on 9.02.21.
//

import UIKit

struct Movie {
    /// Movie identifier
    private(set) var identifier = UUID()
    /// Poster image
    var poster: UIImage?
    /// Movie title
    var title: String?
    /// Movie release date
    var releaseDate: Date?
    /// Movie genre
    var genre: Genre?
    /// Short movie description
    var shortDescription: String?
    /// Long movie description
    var longDescription: String?
}

enum Genre: String, CaseIterable {
    case action = "Action"
    case drama = "Drama"
    case scifi = "Sci-Fi"
    case anime = "Anime"
    case comedy = "Comedy"
    
    static var all: [Genre] {
        return Genre.allCases
    }
}
