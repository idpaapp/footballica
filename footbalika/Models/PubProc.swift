//
//  PubProc.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation
import UIKit


public class PubProc {
    static var HandleString = THandleString()
    static var HandleDataBase = THandleDataBase()
    static var HandleFirstInfo = THandleFirstInfo()
    static var HandleMassage =  THandleMassage()
    //change post String for send
    public class THandleString{
        public func ReplaceQoutedToDbQouted(str :String) -> String{
            return str.replacingOccurrences(of: "'", with: "\"");
        }
    }
    
    static var isSplash = true
    static var wb = waitingBall()
    static var cV = connectionView()
    static var showWarning = Bool()
    public class THandleDataBase{
//        var cV = connectionView()
        public func readJson(wsName: String, JSONStr: String  , completionHandler: @escaping (Data?, NSError?) -> Void ) -> URLSessionTask{
            var requestNo = URLRequest(url: URL(string: "http://volcan.ir/adelica/api.v2/"+wsName+".php")!)
            
            if !PubProc.isSplash  {
                wb.showWaiting()
            }
            
            requestNo.httpMethod = "POST"
            let postStringNo = PubProc.HandleString.ReplaceQoutedToDbQouted(str: JSONStr)
//            print(postStringNo)
            requestNo.httpBody = postStringNo.data(using: .utf8)
            
            let taskNo = URLSession.shared.dataTask(with: requestNo, completionHandler: { (data, response, error) in
                guard let data = data, error == nil else {
                    completionHandler(nil, (error! as NSError))
                    print("error=\(String(describing: error))")
                    DispatchQueue.main.async {
                       cV.showWarning()
                    }
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response!))")
                    DispatchQueue.main.async {
                    cV.showWarning()
                    }
                }
                
                completionHandler(data, nil)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
//                    wb.hideWaiting()
//                })
            })
            
            taskNo.resume()
            return taskNo;
        }
        
    }
    //    THandleMassage
    public class THandleMassage {
        public func readJson(JSONStr: String, completionHandler: @escaping (Data?, NSError?) -> Void ) -> URLSessionTask{
            var requestNo = URLRequest(url: URL(string: "http://dpa-me.com/WebServices/InsertMessage.php")!)
            
            requestNo.httpMethod = "POST"
            let postStringNo = PubProc.HandleString.ReplaceQoutedToDbQouted(str: JSONStr)
            requestNo.httpBody = postStringNo.data(using: .utf8)
            
            let taskNo = URLSession.shared.dataTask(with: requestNo, completionHandler: { (data, response, error) in
                guard let data = data, error == nil else {
                    completionHandler(nil, (error! as NSError))
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response!))")
                }
                completionHandler(data, nil)
                
                //
            })
            
            taskNo.resume()
            return taskNo;
        }
        
    }
    
    
    public class THandleFirstInfo{
        public func readJson(wsName: String, JSONStr: String, completionHandler: @escaping (Data?, NSError?) -> Void ) -> URLSessionTask{
            var requestNo = URLRequest(url: URL(string: "http://volcan.ir/adelica/api.v2/"+wsName+".php")!)
            
            requestNo.httpMethod = "POST"
            let postStringNo = PubProc.HandleString.ReplaceQoutedToDbQouted(str: JSONStr)
            requestNo.httpBody = postStringNo.data(using: .utf8)
            
            let taskNo = URLSession.shared.dataTask(with: requestNo, completionHandler: { (data, response, error) in
                guard let data = data, error == nil else {
                    completionHandler(nil, (error! as NSError))
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response!))")
                }
                completionHandler(data, nil)
                
                //
            })
            
            taskNo.resume()
            return taskNo;
        }
        
    }
    
}
