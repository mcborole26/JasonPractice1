//
//  ViewController.swift
//  JasonPractice1
//
//  Created by minal borole on 20/10/18.
//  Copyright © 2018 minal borole. All rights reserved.
//

import UIKit
//https://api.whitehouse.gov/v1/petitions.json?limit=100
class ViewController: UIViewController {
    var titleArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        jasonParse()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet weak var myTableView: UITableView!
    func jasonParse(){
        let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        let url = NSURL(string: urlString)! as URL
        let sessionConf = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConf)
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            let r=response
            if(r != nil){
                let d = data
                if(d != nil){
                    do{
                        let firstDic:[String:Any] = try
                            JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                        print(firstDic)
                        
                        // url
                        let metadic:[String:Any] = firstDic["metadata"] as! [String:Any]
                        print(metadic)
                        let requestDic:[String:Any] = metadic["requestInfo"] as! [String:Any]
                        let queryDic:[String:Any] = requestDic["query"] as! [String:Any]
                        let webUrl:String = queryDic["websiteUrl"] as! String
                        print("url=\(webUrl)")
                        
                        let resultArray:[[String:Any]] = firstDic["results"] as! [[String:Any]]
                        for dicItem in resultArray{
                            let titleStr = dicItem["title"] as! String
                            self.titleArray.append(titleStr)
                            print(self.titleArray)
                            DispatchQueue.main.async {
                                self.myTableView.reloadData()
                            }
                            
                        }
                        
                        
                    }
                    catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
        dataTask.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

