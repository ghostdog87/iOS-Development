//
//  AddMovieViewController.swift
//  MovieApp
//
//  Created by Petar Stanev on 11.02.21.
//

import UIKit

protocol AddMovieViewControllerDelegate {
    func add(_ movie: Movie)
}

class AddMovieViewController: UIViewController {
    
    /// Corner radius of the buttons and text fields
    private let cornerRadius: CGFloat = 15
    /// Number of components in picker view
    private let pickerViewNumberOfComponents = 1
    /// Long description text placeholder
    private let longDescriptionPlaceholder = "Long description"
    /// List of predefined posters
    private let posterList = [#imageLiteral(resourceName: "poster2"), #imageLiteral(resourceName: "poster4"), #imageLiteral(resourceName: "poster7"), #imageLiteral(resourceName: "poster1"), #imageLiteral(resourceName: "poster5"), #imageLiteral(resourceName: "poster6"), #imageLiteral(resourceName: "poster3")]
    /// List of all predefined genres in movie model
    private let genreList = Genre.all
    /// Date picker for movie release date
    private let datePicker = UIDatePicker()
    /// Text picker for movie genre
    private let pickerView = UIPickerView()
    
    var delegateCollectionViewAddMovie: AddMovieViewControllerDelegate?
    var delegateMainMenuAddMovie: AddMovieViewControllerDelegate?
    
    @IBOutlet private weak var posterButton: UIButton!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var releaseDateTextField: UITextField!
    @IBOutlet private weak var shortDescriptionTextField: UITextField!
    @IBOutlet private weak var genreTextField: UITextField!
    @IBOutlet private weak var longDescriptionTextField: UITextView! {
        didSet {
            longDescriptionTextField.layer.cornerRadius = cornerRadius
        }
    }
    @IBOutlet private weak var addMovieButton: UIButton! {
        didSet {
            addMovieButton.layer.cornerRadius = cornerRadius
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        createPickerView()
        longDescriptionTextField.text = longDescriptionPlaceholder
        longDescriptionTextField.textColor = .lightGray
    }
    
    // MARK: Adding movie
    
    @IBAction private func didTapAdd(_ sender: UIButton) {
        let (isValidForm, alertMessage) = validator()
        
        if isValidForm {
            let poster = posterButton.image(for: .normal)
            let title = titleTextField.text
            let releaseDate = releaseDateTextField.text?.toDate(withFormat: "yyyy")
            let genre = Genre(rawValue: genreTextField.text! )
            let shortDescription = shortDescriptionTextField.text
            let longDescription = longDescriptionTextField.text
            
            let movie = Movie(poster: poster, title: title, releaseDate: releaseDate, genre: genre, shortDescription: shortDescription, longDescription: longDescription)
            
            // Check if previous controller is collection view or main menu
            if delegateCollectionViewAddMovie != nil {
                delegateCollectionViewAddMovie?.add(movie)
            } else {
                delegateMainMenuAddMovie?.add(movie)
            }
            
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
    
    @IBAction private func didTapPoster(_ sender: UIButton) {
        posterButton.setTitle(nil, for: .normal)
        let randomImage = posterList.randomItem();
        posterButton.setImage(randomImage, for: .normal)
        posterButton.imageView?.contentMode = .scaleAspectFit
    }
    
    @IBAction private func didTapClose(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Date picker for release date
    
    private func createDatePicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(didTapDone))
        toolBar.setItems([doneButton], animated: true)
        toolBar.updateConstraintsIfNeeded()
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        releaseDateTextField.inputAccessoryView = toolBar
        releaseDateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc private func didTapDone() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        releaseDateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    // MARK: Text picker for genre
    
    private func createPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        genreTextField.inputView = pickerView
    }
}

// MARK: Extensions and Delegates

extension String {
    /// Converts String to Date with given format
    /// - Parameter format: Date format
    /// - Returns: Date
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
}

extension AddMovieViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

// TODO: In Progress. Refactor and create reusable form validation class
extension AddMovieViewController {
    /// Validate add movie form
    /// - Returns: (Bool, ValidationError)
    private func validator() -> (Bool, ValidationError) {
        
        guard let titleText = titleTextField.text else { return (false, ValidationError.emptyTitle)}
        guard let releaseDateText = releaseDateTextField.text else { return (false, ValidationError.emptyReleaseDate)}
        guard let releaseDate = Int(releaseDateText) else { return (false, ValidationError.invalidReleaseDate)}
        guard let shortDescriptionText = shortDescriptionTextField.text else { return (false, ValidationError.shortShortDescription)}
        guard let genreText = genreTextField.text else { return (false, ValidationError.emptyGenre)}
        guard Genre(rawValue: genreText) != nil else { return (false, ValidationError.invalidGenre)}
        guard let longDescriptionText = longDescriptionTextField.text else { return (false, ValidationError.emptyLongDescription)}
        
        let isPosterEmpty = posterButton.image(for: .normal) != nil
        let isTitleValid = titleText.count >= 3
        let isReleaseDateValid = releaseDate >= 1900 && releaseDate <= 2021
        let isShortDescriptionValid = shortDescriptionText.count >= 3
        let isLongDescriptionValid = longDescriptionText.count >= 10 && longDescriptionText != longDescriptionPlaceholder
        
        var alertMessage: ValidationError = .valid
        alertMessage = !isPosterEmpty ? ValidationError.emptyPoster : alertMessage
        alertMessage = !isTitleValid ? ValidationError.shortTitle : alertMessage
        alertMessage = !isReleaseDateValid ? ValidationError.outOfRangeReleaseDate : alertMessage
        alertMessage = !isShortDescriptionValid ? ValidationError.shortShortDescription : alertMessage
        alertMessage = !isLongDescriptionValid ? ValidationError.shortLongDescription : alertMessage
        
        return ((isPosterEmpty && isTitleValid && isReleaseDateValid && isShortDescriptionValid && isLongDescriptionValid), alertMessage)
    }
}

extension AddMovieViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = longDescriptionPlaceholder
            textView.textColor = .lightGray
        }
    }
}

extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
