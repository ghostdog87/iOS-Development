//
//  Seed.swift
//  MovieApp
//
//  Created by Petar Stanev on 10.02.21.
//

import UIKit

class Seed {
    
    private static var image1 = UIImage(named: "poster1")
    private static var image2 = UIImage(named: "poster2")
    private static var image3 = UIImage(named: "poster3")
    
    private static var movie1 = Movie(poster: image1, title: "Movie1", releaseDate: Date(), genre: .action, shortDescription: "xxxx description", longDescription: "One advanced diverted domestic sex repeated bringing you old. Possible procured her trifling laughter thoughts property she met way. Companions shy had solicitude favourable own. Which could saw guest man now heard but. Lasted my coming uneasy marked so should.")
    private static var movie2 = Movie(poster: image2, title: "Movie2", releaseDate: Date(), genre: .anime, shortDescription: "zzzz description", longDescription: "Gravity letters it amongst herself dearest an windows by. Wooded ladies she basket season age her uneasy saw. Discourse unwilling am no described dejection incommode no listening of. Before nature his parish boy.")
    private static var movie3 = Movie(poster: image3, title: "Movie3", releaseDate: Date(), genre: .scifi, shortDescription: "vvvvv description", longDescription: "Folly words widow one downs few age every seven. If miss part by fact he park just shew. Discovered had get considered projection who favourable. Necessary up knowledge it tolerably.")
    
    static var movies = [movie1, movie2, movie3]
}
