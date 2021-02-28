//
//  MainMenuViewController.swift
//  MovieApp
//
//  Created by Petar Stanev on 9.02.21.
//

import UIKit
import CoreData

class MainMenuViewController: UIViewController {
    /// Segue identifier for movie list scene
    private let movieListViewIdentifier = "movieList"
    /// Segue identifier for add movie scene
    private let addMovieViewIdentifier = "addMovie"
    /// Movies seeded from data repository
    //var movieList = Seed.movies
    var movieList: [Movie] = []
    
    var addMovieController: AddMovieViewController?
    
    @IBOutlet private weak var showMoviesButton: UIButton!
    @IBOutlet private weak var addMoviesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovies()
        showMoviesButton.layer.cornerRadius = 15
        addMoviesButton.layer.cornerRadius = 15
        navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationItem.backBarButtonItem?.title = "Back"
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case movieListViewIdentifier:
            guard let movieCollectionView = segue.destination as? MovieListCollectionViewController else { return }
            movieCollectionView.delegateMainMenuSynchronizeMovies = self
            movieCollectionView.movieList = movieList
        case addMovieViewIdentifier:
            guard let addMovieView = segue.destination as? AddMovieViewController else { return }
            addMovieView.delegateCollectionViewAddMovie = self
        default:
            return
        }
    }
    
    // MARK: Persistence Data
    
    func saveMovie(_ movie: Movie) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Movies", in: context)
        let newMovie = NSManagedObject(entity: entity!, insertInto: context)
        
        newMovie.setValue(movie.identifier, forKey: "identifier")
        newMovie.setValue(movie.poster?.jpegData(compressionQuality: 1), forKey: "poster")
        newMovie.setValue(movie.title, forKey: "title")
        newMovie.setValue(movie.releaseDate, forKey: "release_date")
        newMovie.setValue(movie.genre?.rawValue, forKey: "genre")
        newMovie.setValue(movie.shortDescription, forKey: "short_description")
        newMovie.setValue(movie.longDescription, forKey: "long_description")
        
        do {
            try context.save()
            print("saved the movie")
        } catch {
            print("failed saving")
        }
    }
    
    func updateMovie(_ movie: Movie) {
        // TODO: Update movie
    }
    
    func deleteMovie(_ movie: Movie) {
        // TODO: Delete movie
    }
    
    func getMovies() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let movieIdentifier = data.value(forKey: "identifier") as! UUID
                let moviePoster = UIImage(data: data.value(forKey: "poster") as! Data, scale: 1.0)
                let movieTitle = data.value(forKey: "title") as! String
                let movieReleaseDate = data.value(forKey: "release_date") as! Date
                let movieGenre = Genre(rawValue: data.value(forKey: "genre") as! String)
                let movieShortDescription = data.value(forKey: "short_description") as! String
                let movieLongDescription = data.value(forKey: "long_description") as! String
                let movie = Movie(identifier: movieIdentifier, poster: moviePoster, title: movieTitle, releaseDate: movieReleaseDate, genre: movieGenre, shortDescription: movieShortDescription, longDescription: movieLongDescription)
                
                movieList.append(movie)
            }
        } catch {
            print("failed loading movie")
        }
    }
}

extension MainMenuViewController: AddMovieViewControllerDelegate, MovieListCollectionViewControllerDelegate {
    func synchronize(_ movies: [Movie]) {
        self.movieList = movies
    }
    
    func add(_ movie: Movie) {
        var movies = movieList
        movies.append(movie)
        self.movieList = movies
        saveMovie(movie)
    }
}

extension UIImage {
    func jpegData(withCompressionQuality quality: CGFloat) -> Data? {
        return autoreleasepool(invoking: {() -> Data? in
            return self.jpegData(compressionQuality: quality)
        })
    }
}
