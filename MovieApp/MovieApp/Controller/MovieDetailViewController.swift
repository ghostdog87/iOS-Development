//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Petar Stanev on 10.02.21.
//

import UIKit

protocol MovieDetailViewControllerDelegate {
    func remove(_ movie: Movie)
    func update(_ movie: Movie)
}

class MovieDetailViewController: UIViewController {
    
    /// Segue identifier for movie details
    private let editMovieViewIdentifier = "editMovie"
    /// Loaded movie
    var movie: Movie?
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var longDescriptionLabel: UILabel!
    
    var delegateMovieDetailRemoveMovie: MovieDetailViewControllerDelegate?
    var delegateMovieDetailEditMovie: MovieDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetails()
    }
    
    /// Load movie details
    private func loadDetails() {
        guard let movieDetails = movie,
              let releaseDate = movieDetails.releaseDate,
              let genre = movieDetails.genre else { return }
        let movieImage = movieDetails.poster
        imageView.image = movieImage
        titleLabel.text = movieDetails.title
        releaseDateLabel.text = releaseDate.toString()
        genreLabel.text = genre.rawValue
        shortDescriptionLabel.text = movieDetails.shortDescription
        longDescriptionLabel.text = movieDetails.longDescription
        longDescriptionLabel.layer.borderColor = UIColor.lightGray.cgColor
        longDescriptionLabel.layer.borderWidth = 3.0
    }
    
    @IBAction func didTapClose(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapDelete() {
        guard let currentMovie = movie else { return }
        confirmDelete(currentMovie)
    }
    
    /// Opens confirmation window before deletion of the movie
    /// - Parameter movie: Movie
    private func confirmDelete(_ movie: Movie) {
        let alert = UIAlertController(title: "Delete Movie", message: "Are you sure you want to delete this movie?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.delegateMovieDetailRemoveMovie?.remove(movie)
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Navigation
    
    @IBAction func didTapEdit() {
        performSegue(withIdentifier: editMovieViewIdentifier, sender: movie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let editMovieScene = segue.destination as? EditMovieViewController else { return }
        editMovieScene.movie = movie
        editMovieScene.delegateEditMovie = self
    }
}

// MARK: Extensions

extension MovieDetailViewController: EditMovieViewControllerDelegate {
    func update(_ movie: Movie) {
        self.movie = movie
        loadDetails()
        delegateMovieDetailEditMovie?.update(movie)
    }
}

extension Date {
    /// Converts Date to String
    /// - Parameter format: Format of represented date
    /// - Returns: String
    func toString(format: String = "yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
