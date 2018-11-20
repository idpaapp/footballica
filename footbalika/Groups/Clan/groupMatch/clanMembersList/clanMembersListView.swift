//
//  clanMembersListView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/19/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class clanMembersListView: UIView  {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var warningTitle: UILabel!
    
    @IBOutlet weak var topTitle: UILabel!
    
    @IBOutlet weak var topTitleForeGround: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var useButton: RoundButton!
    
    @IBOutlet weak var useButtonPrice: UILabel!
    
    @IBOutlet weak var useButtonPriceTitle: UILabel!
    
    @IBOutlet weak var useButtonPriceIcon: UIImageView!
    
    @IBOutlet weak var membersTV: UITableView!
    
    @IBOutlet weak var useButtonPriceForeGround: UILabel!
    
    @IBOutlet weak var noPriceTitle: UILabel!
    
    @IBOutlet weak var noPriceTitleForeGround: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("clanMembersListView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }

}
