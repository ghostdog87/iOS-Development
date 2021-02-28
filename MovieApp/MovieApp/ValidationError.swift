//
//  ValidationError.swift
//  MovieApp
//
//  Created by Petar Stanev on 13.02.21.
//

import Foundation

enum ValidationError: String {
    case emptyTitle = "Title cannot be empty."
    case emptyReleaseDate = "Release date must not be empty."
    case invalidReleaseDate = "Release date must be a correct year (fe. 2000)."
    case emptyShortDescription = "Short description must not be empty."
    case emptyGenre = "Genre must not be empty."
    case invalidGenre = "Please select an existing genre from downdown menu."
    case emptyLongDescription = "Long description must not be empty."
    case emptyPoster = "Please select a poster."
    case shortTitle = "Title must be at least 3 characters long."
    case outOfRangeReleaseDate = "Release date must be in the range between 1900 and 2021."
    case shortShortDescription = "Short description must be at least 3 characters long."
    case shortLongDescription = "Long description must be at least 10 characters long."
    case valid = ""
}
