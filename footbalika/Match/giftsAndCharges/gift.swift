//
//  gift.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/4/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation
import UIKit

public class gift : menuView {
    
    public var giftsImages = ["ic_gift",
                              "like",
                       "invite_friend",
                       "ic_avatar_large",
                       "google_plus",
                       "ic_bug",
                       "ic_comment"]
    
    public var giftsTitles = ["وارد کردن کد هدیه",
                              "حمایت از ما",
                       "دعوت دوستان",
                       "تکمیل ثبت نام",
                       "اتصال به حساب گوگل",
                       "گزارش مشکل",
                       "انتقاد و پیشنهاد"]
    
    public var giftsNumbers = ["",
                               "\((loadingViewController.loadGameData?.response?.giftRewards?.invited_user!)!)",
                        "\((loadingViewController.loadGameData?.response?.giftRewards?.invite_friend!)!)",
        "\((loadingViewController.loadGameData?.response?.giftRewards?.sign_up!)!)",
        "\((loadingViewController.loadGameData?.response?.giftRewards?.google_sign_in!)!)",
        "\((loadingViewController.loadGameData?.response?.giftRewards?.report_bug!)!)",
        "\((loadingViewController.loadGameData?.response?.giftRewards?.comment!)!)"]
    
    public var giftHeight : CGFloat = 525
    public var giftWidth : CGFloat = 310
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        if (login.res?.response?.mainInfo?.status!)! == "2" {
         giftsNumbers.remove(at: 3)
        giftsTitles.remove(at: 3)
        giftsImages.remove(at: 3)
        }
        
        self.isOpaque = false
        if UIDevice().userInterfaceIdiom == .phone {
            self.topTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "جوایز", strokeWidth: -4.0)
             self.topTitleForeGround.font = fonts().iPhonefonts
        } else {
            self.topTitle.AttributesOutLine(font: fonts().iPadfonts, title: "جوایز", strokeWidth: -4.0)
            self.topTitleForeGround.font = fonts().iPadfonts
        }
        self.topTitleForeGround.text = "جوایز"
        
    }
    
}
