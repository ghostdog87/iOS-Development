//
//  MovieListCollectionViewController.swift
//  MovieApp
//
//  Created by Petar Stanev on 10.02.21.
//

import UIKit

protocol MovieListCollectionViewControllerDelegate {
    func synchronize(_ movies: [Movie])
    func add(_ newMovie: Movie)
}

class MovieListCollectionViewController: UICollectionViewController {
    
    /// Reusable identifier for movie cell
    private let reuseMovieIdentifier = "MovieCell"
    /// Reusable identifier for add more movies cell
    private let reuseAddMovieIdentifier = "AddMovieCell"
    /// Segue identifier for movie details
    private let movieDetailsViewIdentifier = "movieDetails"
    /// Segue identifier for add movie scene
    private let addMovieViewIdentifier = "addMovie"
    /// Number of collection sections in Image gallery
    private let numberOfCollectionViewSections = 1
    /// Frame width size with included margin offset
    private var frameWidth: CGFloat {
        return movieListCollectionView.frame.size.width
    }
    /// Frame height size with included margin offset
    private var frameHeight: CGFloat {
        return movieListCollectionView.frame.size.height
    }
    /// Width of the collection cells
    private var cellWidth: CGFloat = 0
    /// Height of the collection cells
    private var cellHeight: CGFloat = 0
    /// Background color of movies cells
    private var movieCellBackgroundColor = #colorLiteral(red: 0.1634692848, green: 0.1491840482, blue: 0.2255987227, alpha: 1)
    /// Corner radius of add more movies cell
    private var addMovieCellCornerRadius: CGFloat = 15
    /// Movie list
    var movieList: [Movie]?
    
    var addMovieController: AddMovieViewController?
    var delegateMainMenuSynchronizeMovies: MovieListCollectionViewControllerDelegate?
    
    @IBOutlet private var movieListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: UICollectionView Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellWidth = frameWidth / 2
        cellHeight = frameHeight / 3
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfCollectionViewSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movies = movieList else { return 0 }
        return movies.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movies = movieList else { return UICollectionViewCell() }
        let cellIdentifier = indexPath.row < movies.count ? reuseMovieIdentifier : reuseAddMovieIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        customCell(cell: cell, indexPath: indexPath, type: cellIdentifier)
        return cell
    }
    
    private func customCell(cell: UICollectionViewCell, indexPath: IndexPath, type: String) {
        guard let movies = movieList else { return }
        switch type {
        case reuseMovieIdentifier:
            guard let movieCell = cell as? MovieListCollectionViewCell else { return }
            movieCell.image = movies[indexPath.row].poster
            movieCell.contentView.backgroundColor = movieCellBackgroundColor
        case reuseAddMovieIdentifier:
            guard let addMovieCell = cell as? AddMovieCollectionViewCell else { return }
            addMovieCell.contentView.layer.cornerRadius = addMovieCellCornerRadius
        default:
            break
        }
    }
    
    // MARK: Navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movies = movieList, indexPath.row < movies.count else { return }
        let movie = movies[indexPath.row]
        performSegue(withIdentifier: movieDetailsViewIdentifier, sender: movie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case movieDetailsViewIdentifier:
            guard let movieDetailScene = segue.destination as? MovieDetailViewController,
                  let selectedMovie = sender as? Movie else { return }
            movieDetailScene.movie = selectedMovie
            movieDetailScene.delegateMovieDetailEditMovie = self
            movieDetailScene.delegateMovieDetailRemoveMovie = self
        case addMovieViewIdentifier:
            guard let addMovieScene = segue.destination as? AddMovieViewController else { return }
            addMovieScene.delegateCollectionViewAddMovie = self
        default:
            return
        }
    }
}

extension MovieListCollectionViewController: AddMovieViewControllerDelegate, MovieDetailViewControllerDelegate {
    func add(_ movie: Movie) {
        guard var movies = movieList else { return }
        movies.append(movie)
        self.movieList = movies
        delegateMainMenuSynchronizeMovies?.add(movie)
        collectionView.reloadData()
    }
    
    func update(_ movie: Movie) {
        guard var movies = movieList, let movieIndex = movies.firstIndex(where: {$0.identifier == movie.identifier}) else { return }
        movies[movieIndex] = movie
        self.movieList = movies
        delegateMainMenuSynchronizeMovies?.synchronize(movies)
        collectionView.reloadData()
    }
    
    func remove(_ movie: Movie) {
        guard var movies = movieList, let movieIndex = movies.firstIndex(where: {$0.identifier == movie.identifier}) else { return }
        movies.remove(at: movieIndex)
        self.movieList = movies
        delegateMainMenuSynchronizeMovies?.synchronize(movies)
        collectionView.reloadData()
    }
}

