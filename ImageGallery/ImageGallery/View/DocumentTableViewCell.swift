//
//  DocumentTableViewCell.swift
//  ImageGallery
//
//  Created by Petar Stanev on 2.02.21.
//

import UIKit

protocol ImageGalleryTableViewCellDelegate {
    func nameDidChange(_ name: String?, in cell: UITableViewCell)
}

class DocumentTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate: ImageGalleryTableViewCellDelegate?
    
    @IBOutlet weak var textField: UITextField!  {
        didSet {
            textField.isUserInteractionEnabled = false
            let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(_:)))
            doubleTapGestureRecognizer.numberOfTapsRequired = 2
            self.addGestureRecognizer(doubleTapGestureRecognizer)
        }
    }
    
    @objc func onDoubleTap(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        textField.isUserInteractionEnabled = true
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ sender: UITextField) {
        sender.isUserInteractionEnabled = false
        delegate?.nameDidChange(sender.text, in: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
