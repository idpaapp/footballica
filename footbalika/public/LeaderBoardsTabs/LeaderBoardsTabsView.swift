//
//  LeaderBoardsTabsView.swift
//  footbalika
//
//  Created by M.Bakhtiari on 1/29/19.
//  Copyright © 2019 Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class LeaderBoardsTabsView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var leftButton: RoundButton!
    
    @IBOutlet weak var rightButton: RoundButton!
    
    @IBOutlet weak var leftButtonTitle: UILabel!
    
    @IBOutlet weak var leftButtonTitleForeGround: UILabel!
    
    @IBOutlet weak var rightButtonTitle: UILabel!
    
    @IBOutlet weak var rightButtonTitleForeGround: UILabel!
        
    func setOutlets(leftTitle : String , rightTitle : String , font : UIFont , stroke : Double) {
        leftButtonTitle.AttributesOutLine(font: font, title: leftTitle, strokeWidth: stroke)
        leftButtonTitleForeGround.font = font
        leftButtonTitleForeGround.text = leftTitle
        
       rightButtonTitle.AttributesOutLine(font: font, title: rightTitle, strokeWidth: stroke)
       rightButtonTitleForeGround.font = font
       rightButtonTitleForeGround.text = leftTitle
    }
    
    
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
        Bundle.main.loadNibNamed("LeaderBoardsTabsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }
}
