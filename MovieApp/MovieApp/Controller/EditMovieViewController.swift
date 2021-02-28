//
//  EditMovieViewController.swift
//  MovieApp
//
//  Created by Petar Stanev on 11.02.21.
//

import UIKit

protocol EditMovieViewControllerDelegate {
    func update(_ movie: Movie)
}

class EditMovieViewController: UIViewController {
    
    /// Corner radius of the buttons and text fields
    private let cornerRadius: CGFloat = 15
    /// Long description text placeholder
    private let longDescriptionPlaceholder = "Long description"
    /// List of all predefined genres in movie model
    private let genreList = Genre.all
    /// Text picker for movie genre
    private let pickerView = UIPickerView()
    /// Number of components in picker view
    private let pickerViewNumberOfComponents = 1
    /// Loaded movie
    var movie: Movie?
    
    var delegateEditMovie: EditMovieViewControllerDelegate?
    
    @IBOutlet private weak var backButton: UIButton!
    
    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var releaseDateTextField: UITextField!
    @IBOutlet private weak var shortDescriptionTextField: UITextField!
    @IBOutlet private weak var genreTextField: UITextField!
    @IBOutlet private weak var longDescriptionTextField: UITextView! {
        didSet {
            longDescriptionTextField.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBOutlet weak var editMovieButton: UIButton! {
        didSet {
            editMovieButton.layer.cornerRadius = cornerRadius
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(UIImage(named: "BackButton2.png"), for: .normal)
        createPickerView()
        loadDetails()
    }
    
    @IBAction private func didTapBack() {
        dismiss(animated: true, completion: nil)
    }
    
    /// Load movie details
    private func loadDetails() {
        guard let movieDetails = movie,
              let releaseDate = movieDetails.releaseDate,
              let genre = movieDetails.genre else { return }
        let movieImage = movieDetails.poster
        posterImage.image = movieImage
        titleTextField.text = movieDetails.title
        releaseDateTextField.text = releaseDate.toString()
        genreTextField.text = genre.rawValue
        shortDescriptionTextField.text = movieDetails.shortDescription
        longDescriptionTextField.text = movieDetails.longDescription
    }
    
    // MARK: Edit movie
    
    @IBAction private func didTapEdit(_ sender: UIButton) {
        let (isValidForm, alertMessage) = validator()
        
        if isValidForm {
            guard let movieIdentifier = movie?.identifier else { return }
            
            let poster = posterImage.image
            let title = titleTextField.text
            let releaseDate = releaseDateTextField.text?.toDate(withFormat: "yyyy")
            let genre = Genre(rawValue: genreTextField.text!)
            let shortDescription = shortDescriptionTextField.text
            let longDescription = longDescriptionTextField.text
            
            let movie = Movie(identifier: movieIdentifier, poster: poster, title: title, releaseDate: releaseDate, genre: genre, shortDescription: shortDescription, longDescription: longDescription)
            delegateEditMovie?.update(movie)
            dismiss(animated: true, completion: nil)
        } else {
            showAlert(with: alertMessage.rawValue)
        }
    }
    
    private func showAlert(with message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Text picker for genre
    
    private func createPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        genreTextField.inputView = pickerView
    }
}

// MARK: Extensions

// TODO: In Progress. Refactor and create reusable Form validation class
extension EditMovieViewController {
    /// Validate edit movie form
    /// - Returns: (Bool, ValidationError)
    private func validator() -> (Bool, ValidationError) {
        guard let shortDescriptionText = shortDescriptionTextField.text else { return (false, ValidationError.shortShortDescription)}
        guard let genreText = genreTextField.text else { return (false, ValidationError.emptyGenre)}
        guard Genre(rawValue: genreText) != nil else { return (false, ValidationError.invalidGenre)}
        guard let longDescriptionText = longDescriptionTextField.text else { return (false, ValidationError.emptyLongDescription)}
        
        let isShortDescriptionValid = shortDescriptionText.count >= 3
        let isLongDescriptionValid = longDescriptionText.count >= 10 && longDescriptionText != longDescriptionPlaceholder
        
        var alertMessage: ValidationError = .valid
        alertMessage = !isShortDescriptionValid ? ValidationError.shortShortDescription : alertMessage
        alertMessage = !isLongDescriptionValid ? ValidationError.shortLongDescription : alertMessage
        
        return ((isShortDescriptionValid && isLongDescriptionValid), alertMessage)
    }
}

extension EditMovieViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerViewNumberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genreList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genreList[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genreTextField.text = genreList[row].rawValue
        genreTextField.resignFirstResponder()
    }
}

extension EditMovieViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Long description"
            textView.textColor = .lightGray
        }
    }
}
