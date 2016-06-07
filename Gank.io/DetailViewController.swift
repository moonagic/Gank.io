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
        
        self.table.tableFooterView = UIView.init(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let data:NSData = ud.objectForKey("detail-\(self.data)") as? NSData {
            self.dic = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSDictionary
            self.table.reloadData()
        }
        
        if self.needReload {
            let params:String = self.data.stringByReplacingOccurrencesOfString("-", withString: "/")
            let str:String = baseUrl+url_day+params
            print(str)
            Alamofire.request(.GET, str).responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    self.dic = JSON as? NSDictionary
                    print(self.dic)
                    
                    let ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    let nsdata:NSData = NSKeyedArchiver.archivedDataWithRootObject(self.dic!)
                    ud.setObject(nsdata, forKey: "detail-\(self.data)")
                }
                self.table.reloadData()
            }
            self.needReload = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (self.dic != nil) {
            let category:NSArray = (self.dic?.valueForKey("category"))! as! NSArray
            return category.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let category:NSArray     = (self.dic?.valueForKey("category"))! as! NSArray
        return category.objectAtIndex(section) as? String
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category:NSArray     = (self.dic?.valueForKey("category"))! as! NSArray
        let results:NSDictionary = self.dic?.valueForKey("results") as! NSDictionary
        let sectionArr:NSArray = results.valueForKey(category.objectAtIndex(section) as! String) as! (NSArray)
        
        
        return sectionArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier:String = "detailcell"
        
        let cell:DetailCell = (tableView.dequeueReusableCellWithIdentifier(identifier) as? DetailCell)!
        
        let category:NSArray     = (self.dic?.valueForKey("category"))! as! NSArray
        let results:NSDictionary = self.dic?.valueForKey("results") as! NSDictionary
        let sectionArr:NSArray = results.valueForKey(category.objectAtIndex(indexPath.section) as! String) as! (NSArray)
        let dic:NSDictionary = sectionArr.objectAtIndex(indexPath.row) as! NSDictionary
        
        let type:String = category.objectAtIndex(indexPath.section) as! String
        
        if type == "休息视频" {
            cell.colorTag.backgroundColor = UIColor.grayColor()
        } else if type == "瞎推荐" {
            cell.colorTag.backgroundColor = UIColor.lightGrayColor()
        } else if type == "前端" {
            cell.colorTag.backgroundColor = UIColor.cyanColor()
        } else if type == "拓展资源" {
            cell.colorTag.backgroundColor = UIColor.blueColor()
        } else if type == "Android" {
            cell.colorTag.backgroundColor = UIColor.greenColor()
        } else if type == "iOS" {
            cell.colorTag.backgroundColor = UIColor.redColor()
        } else if type == "福利" {
            cell.colorTag.backgroundColor = UIColor.brownColor()
        }
        
        cell.titleLabel.text = dic.valueForKey("desc") as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
        let category:NSArray     = (self.dic?.valueForKey("category"))! as! NSArray
        let results:NSDictionary = self.dic?.valueForKey("results") as! NSDictionary
        let sectionArr:NSArray = results.valueForKey(category.objectAtIndex(indexPath.section) as! String) as! (NSArray)
        let dic:NSDictionary = sectionArr.objectAtIndex(indexPath.row) as! NSDictionary
        let str:String = (dic.valueForKey("url") as? String)!
        self.openUrlWithSafariViewContoller(str)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("prepareForSegue")
    }
    
    func openUrlWithSafariViewContoller(urlStr:String) {
        let safariVC = SFSafariViewController(URL: NSURL(string:urlStr)!, entersReaderIfAvailable: true)
        
        presentViewController(safariVC, animated: true, completion: nil)
    }
    
}
