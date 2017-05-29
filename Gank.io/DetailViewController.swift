//
//  DetailViewController.swift
//  Gank.io
//
//  Created by Wu Hengmin on 16/4/1.
//  Copyright © 2016年 Wu Hengmin. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    var data:String = ""
    var dic:NSDictionary?
    var needReload:Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self;
        self.table.dataSource = self;
        self.title = "详情"
        
        self.table.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let ud:UserDefaults = UserDefaults.standard
        
        if let data:Data = ud.object(forKey: "detail-\(self.data)") as? Data {
            self.dic = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSDictionary
            self.table.reloadData()
        }
        
        if self.needReload {
            let params:String = self.data.replacingOccurrences(of: "-", with: "/")
            let str:String = baseUrl+url_day+params
            print(str)
            weak var weakSelf = self
            Alamofire.request(str, method: .get).responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
                
                if let strongSelf = weakSelf {
                    if let JSON = response.result.value {
                        strongSelf.dic = JSON as? NSDictionary
                        
                        let ud:UserDefaults = UserDefaults.standard
                        let nsdata:NSData = NSKeyedArchiver.archivedData(withRootObject: self.dic!) as NSData
                        ud.set(nsdata, forKey: "detail-\(strongSelf.data)")
                    }
                    DispatchQueue.main.async() {
                        strongSelf.table.reloadData()
                    }
                }
                
                
                
            }
            self.needReload = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (self.dic != nil) {
            let category:NSArray = (self.dic?.value(forKey: "category"))! as! NSArray
            return category.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let category:NSArray     = (self.dic?.value(forKey: "category"))! as! NSArray
        var title:String! = category.object(at: section) as! String
        if title == "Android" {
            title = "Other"
        }
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category:NSArray     = (self.dic?.value(forKey: "category"))! as! NSArray
        let results:NSDictionary = self.dic?.value(forKey: "results") as! NSDictionary
        let sectionArr:NSArray = results.value(forKey: category.object(at: section) as! String) as! (NSArray)
        
        
        return sectionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier:String = "detailcell"
        
        let cell:DetailCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? DetailCell)!
        
        let category:NSArray     = (self.dic?.value(forKey: "category"))! as! NSArray
        let results:NSDictionary = self.dic?.value(forKey: "results") as! NSDictionary
        let sectionArr:NSArray = results.value(forKey: category.object(at: indexPath.section) as! String) as! (NSArray)
        let dic:NSDictionary = sectionArr.object(at: indexPath.row) as! NSDictionary
        
        let type:String = category.object(at: indexPath.section) as! String
        
        if type == "休息视频" {
            cell.colorTag.backgroundColor = UIColor.gray
        } else if type == "瞎推荐" {
            cell.colorTag.backgroundColor = UIColor.lightGray
        } else if type == "前端" {
            cell.colorTag.backgroundColor = UIColor.cyan
        } else if type == "拓展资源" {
            cell.colorTag.backgroundColor = UIColor.blue
        } else if type == "Android" {
            cell.colorTag.backgroundColor = UIColor.green
        } else if type == "iOS" {
            cell.colorTag.backgroundColor = UIColor.red
        } else if type == "福利" {
            cell.colorTag.backgroundColor = UIColor.brown
        }
        
        cell.titleLabel.text = dic.value(forKey: "desc") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let category:NSArray     = (self.dic?.value(forKey: "category"))! as! NSArray
        let results:NSDictionary = self.dic?.value(forKey: "results") as! NSDictionary
        let sectionArr:NSArray = results.value(forKey: category.object(at: indexPath.section) as! String) as! (NSArray)
        let dic:NSDictionary = sectionArr.object(at: indexPath.row) as! NSDictionary
        let str:String = (dic.value(forKey: "url") as? String)!
        self.openUrlWithSafariViewContoller(str)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("prepareForSegue")
    }
    
    func openUrlWithSafariViewContoller(_ urlStr:String) {
        let safariVC = SFSafariViewController(url: URL(string:urlStr)!, entersReaderIfAvailable: true)
        
        present(safariVC, animated: true, completion: nil)
    }
    
}
