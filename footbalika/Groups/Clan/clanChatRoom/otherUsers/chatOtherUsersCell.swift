//
//  chatOtherUsersCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 7/28/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class chatOtherUsersCell: UITableViewCell {

    @IBOutlet weak var otherChatsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeImage(name: "recieverChat")
        otherChatsImage.tintColor = .white
    }
    
    func changeImage(name: String) {
            guard let image = UIImage(named: name) else { return }
            otherChatsImage.image = image
               .resizableImage(withCapInsets: UIEdgeInsetsMake(17, 21, 17, 21), resizingMode: .stretch)
               .withRenderingMode(.alwaysTemplate)
                self.otherChatsImage.addUIImageShadow(color: UIColor.black, offset: CGSize(width: 0, height: 0), opacity: 0.5, Radius: 1)
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
