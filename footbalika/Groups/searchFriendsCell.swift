//
//  searchFriendsCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/2/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

protocol searchFriendsCellDelegate {
    func didEditedSearchTextField(searchText : String)
}

class searchFriendsCell: UITableViewCell , UITextFieldDelegate {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchButtonTitle: UILabel!
    @IBOutlet weak var searchButtonTitleForeGround: UILabel!
    @IBOutlet weak var searchTextField: UITextField!

    @IBOutlet weak var clearTextField: UIButton!
    var delegate : searchFriendsCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.searchTextField.delegate = self
        self.clearTextField.isHidden = true
        self.searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)

        self.clearTextField.addTarget(self, action: #selector(clearTextFieldComplete), for: UIControlEvents.touchUpInside)
        if UIDevice().userInterfaceIdiom == .phone {
        searchButtonTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "جستجو", strokeWidth: -4.0)
          searchButtonTitleForeGround.font = fonts().iPhonefonts
        } else {
        searchButtonTitle.AttributesOutLine(font: fonts().iPadfonts, title: "جستجو", strokeWidth: -4.0)
            searchButtonTitleForeGround.font = fonts().iPadfonts
        }
        searchButtonTitleForeGround.text = "جستجو"
        
        searchButtonTitle.adjustsFontSizeToFitWidth = true
        searchButtonTitle.minimumScaleFactor = 0.5
        searchButtonTitleForeGround.adjustsFontSizeToFitWidth = true
        searchButtonTitleForeGround.minimumScaleFactor = 0.5
        searchTextField.addPadding(.right(5))
        searchTextField.addPadding(.left(30))
    }
    
    @objc func clearTextFieldComplete() {
        self.searchTextField.text = ""
        self.clearTextField.isHidden = true
        delegate?.didEditedSearchTextField(searchText : "")
    }
    
    @objc func textFieldDidChange(textField: UITextField) {

        if self.searchTextField.text! != "" {
            self.clearTextField.isHidden = false
        } else {
            self.clearTextField.isHidden = true
        }
        delegate?.didEditedSearchTextField(searchText : self.searchTextField.text!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
