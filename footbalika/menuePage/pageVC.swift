//
//  pageVC.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class pageVC: UIPageViewController, UIPageViewControllerDataSource , UIPageViewControllerDelegate  {
    
    
    let pageVC3 = UIPageControl()
    lazy var VCArr : [UIViewController] = {
        
        return [self.VCInstance(name :"p1"),
                self.VCInstance(name :"p2"),
                self.VCInstance(name :"p3"),
                self.VCInstance(name :"p4"),
                self.VCInstance(name :"p5")]
        
    }()
    
    private func VCInstance(name : String) -> UIViewController {
        
        if UIDevice().userInterfaceIdiom == .phone {
         if UIScreen.main.nativeBounds.height == 2436 {
            //iPhone X
        return UIStoryboard(name : "iPhoneX" , bundle : nil).instantiateViewController(withIdentifier: name)
        } else {
        return UIStoryboard(name : "Main" , bundle : nil).instantiateViewController(withIdentifier: name)
        }
        } else {
           return UIStoryboard(name : "iPad" , bundle : nil).instantiateViewController(withIdentifier: name)
        }
    }
    
    @objc func scrollFunction(notification: Notification){
        if let index = notification.userInfo?["pageIndex"] as? Int {
            setViewControllers([VCArr[index]], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollFunction(notification:)), name: Notification.Name("scrollToPage"), object: nil)
        
        self.pageVC3.backgroundColor = UIColor.init(red: 243/255, green: 243/255, blue: 244/255, alpha: 1.0)
        
        self.pageVC3.pageIndicatorTintColor = UIColor.clear
        self.pageVC3.currentPageIndicatorTintColor = UIColor.clear
        
        let pageControl = UIPageControl.appearance()
        
        pageControl.layer.position.y = self.view.frame.height - 20
        
        pageControl.pageIndicatorTintColor = UIColor.clear
        
        pageControl.currentPageIndicatorTintColor = UIColor.clear
        
        self.view.backgroundColor = UIColor.black
        self.delegate = self
        self.dataSource = self
        if let firstVC = VCArr.last {
            setViewControllers([firstVC] , direction: .forward , animated: true, completion: nil)
            setViewControllers([firstVC] , direction: .reverse , animated: true, completion: nil)
            
        }
        setViewControllers([VCArr[2]], direction: .forward, animated: true, completion: nil)
//        let pageIndexDict:[String: Int] = ["pageIndex": 2]
//        NotificationCenter.default.post(name: Notification.Name("scrollToPage"), object: nil, userInfo: pageIndexDict)
//        NotificationCenter.default.post(name: Notification.Name("selectButtonPage"), object: nil, userInfo: pageIndexDict)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for subV in self.view.subviews {
            if type(of: subV).description() == "UIPageControl" {
                
                let pos = CGPoint(x: 0, y: 600)
                subV.frame = CGRect(origin: pos, size: subV.frame.size)
            }
        }
        
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
                
            }
        }
    }
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex-1
        guard previousIndex >= 0  else {
            return nil
            
        }
        
        guard VCArr.count > previousIndex else {
            return nil
        }

        let pageIndexDict:[String: Int] = ["button": viewControllerIndex]
        NotificationCenter.default.post(name: Notification.Name("selectButtonPage"), object: nil, userInfo: pageIndexDict)
        
        return VCArr[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex+1
        guard nextIndex < VCArr.count
            else {
                return nil
        }
        
        guard VCArr.count > nextIndex else {
            return nil
        }
        let pageIndexDict:[String: Int] = ["button": viewControllerIndex]
        NotificationCenter.default.post(name: Notification.Name("selectButtonPage"), object: nil, userInfo: pageIndexDict)
        
        return VCArr[nextIndex]
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int{
        return VCArr.count
    }
    
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int{
        guard let firstViewController = viewControllers?.first , let firstViewControllerIndex = VCArr.index(of: firstViewController) else {
            return 0
        }
        
        return firstViewControllerIndex
    }
}




