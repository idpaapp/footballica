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
    
    public var giftsImages = [String]()
    public var giftsTitles = [String]()
    public var giftsNumbers = [String]()
    public var giftHeight : CGFloat = 525
    public var giftWidth : CGFloat = 310
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        giftsImages.append("ic_gift")
        giftsTitles.append("وارد کردن کد هدیه")
        giftsNumbers.append("")
        
        giftsImages.append("like")
        giftsTitles.append("حمایت از ما")
        giftsNumbers.append("\((loadingViewController.loadGameData?.response?.giftRewards?.invited_user!)!)")
        
        giftsImages.append("invite_friend")
        giftsTitles.append("دعوت دوستان")
        giftsNumbers.append("\((loadingViewController.loadGameData?.response?.giftRewards?.invite_friend!)!)")
        
        if (login.res?.response?.mainInfo?.status!)! != "2" {
        giftsImages.append("ic_avatar_large")
        giftsTitles.append("تکمیل ثبت نام")
        giftsNumbers.append("\((loadingViewController.loadGameData?.response?.giftRewards?.sign_up!)!)")
        }

        if (login.res?.response?.mainInfo?.email_connected!)! != "1" {
        giftsImages.append("google_plus")
        giftsTitles.append("اتصال به حساب گوگل")
        giftsNumbers.append("\((loadingViewController.loadGameData?.response?.giftRewards?.google_sign_in!)!)")
        }

        giftsImages.append("ic_bug")
        giftsTitles.append("گزارش مشکل")
        giftsNumbers.append("\((loadingViewController.loadGameData?.response?.giftRewards?.report_bug!)!)")

        giftsImages.append("ic_comment")
        giftsTitles.append("انتقاد و پیشنهاد")
        giftsNumbers.append("\((loadingViewController.loadGameData?.response?.giftRewards?.comment!)!)")
        
        self.isOpaque = false
        if UIDevice().userInterfaceIdiom == .phone {
            self.topTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "جوایز", strokeWidth: 8.0)
             self.topTitleForeGround.font = fonts().iPhonefonts
        } else {
            self.topTitle.AttributesOutLine(font: fonts().iPadfonts, title: "جوایز", strokeWidth: 8.0)
            self.topTitleForeGround.font = fonts().iPadfonts
        }
        self.topTitleForeGround.text = "جوایز"
        
    }
    
}
