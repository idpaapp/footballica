//
//  groupLogoView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/6/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher

class groupLogoView: UIView , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    
    var delegate : groupLogoViewDelegate!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "logoCell", for: indexPath) as! logoCell
        let url = "\(urlClass.clan)\((self.logoRes?.response?[indexPath.item].img_group!)!)"
        let urls = URL(string : url)
        let resource = ImageResource(downloadURL: urls!, cacheKey: url)
        cell.logoImage.kf.setImage(with: resource ,options:[.transition(ImageTransition.fade(0.5))])
        cell.selectLogo.tag = indexPath.item
        cell.selectLogo.addTarget(self, action: #selector(selectingLogo), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    @objc func selectingLogo(_ sender : UIButton) {
        self.delegate?.selectedLogo(url : "\(urlClass.clan)\((self.logoRes?.response?[sender.tag].img_group!)!)")
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.contentView.frame.width / 3 - 20, height: self.contentView.frame.width / 3 - 20)
        return size
    }
    

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var closeButton: RoundButton!
    
    @IBOutlet weak var logoCV: UICollectionView!
    
    var cellCount = Int()
    var urlClass = urls()
    var logoRes : createGroupLogo.Response? = nil
    @objc func getLogos() {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'GET_CLAN_LOGO'}") { data, error in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                }
                
                //                print(data ?? "")
                
                do {
                    
                    self.logoRes = try JSONDecoder().decode(createGroupLogo.Response.self , from : data!)
                    
                    self.cellCount = (self.logoRes?.response?.count)!
                    DispatchQueue.main.async {
                        self.logoCV.reloadData()
                        
                        PubProc.wb.hideWaiting()
                    }
                    
                } catch {
                    self.getLogos()
                    print(error)
                }
            } else {
                self.getLogos()
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        getLogos()
        self.logoCV.delegate = self
        self.logoCV.dataSource = self
        self.logoCV.register(UINib(nibName: "logoCell", bundle: nil), forCellWithReuseIdentifier: "logoCell")
        self.logoCV.layer.backgroundColor = UIColor.clear.cgColor
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
        Bundle.main.loadNibNamed("groupLogoView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }

}
