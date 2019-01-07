//
//  videoAdsView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 10/17/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class videoAdsView: UIView {


    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var shineImg: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    var shineTimer: Timer!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shineTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(rotating), userInfo: nil, repeats: true)

    }
    
    
    @objc func rotating() {
        shineImg.rotate()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("videoAdsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
    }

}
