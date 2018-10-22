//
//  currentUserCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 7/28/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class currentUserCell: UITableViewCell {

    @IBOutlet weak var senderChatImage: UIImageView!
    
    @IBOutlet weak var senderTexts: UILabel!
    
    @IBOutlet weak var chatDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        changeImage(name: "senderChat")
        senderChatImage.tintColor = UIColor.init(red: 225/255, green: 255/255, blue: 199/255, alpha: 1.0)
        self.senderChatImage.addUIImageShadow(color: UIColor.black, offset: CGSize(width: 0, height: 0), opacity: 0.5, Radius: 1)
    }
    
    func changeImage(name: String) {
        guard let image = UIImage(named: name) else { return }
        senderChatImage.image = image
            .resizableImage(withCapInsets: UIEdgeInsetsMake(17, 21, 17, 21), resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
    }

    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
