//
//  DetailViewController.swift
//  Gank.io
//
//  Created by Wu Hengmin on 16/4/1.
//  Copyright © 2016年 Wu Hengmin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SafariServices

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate {

    @IBOutlet weak var table: UITableView!
    var data:String = ""
    var dic:NSDictionary?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self;
        self.table.dataSource = self;
        self.title = self.data
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.data = self.data.stringByReplacingOccurrencesOfString("-", withString: "/")
        let str:String = "https://gank.io/api/day/"+self.data
        print("str:\(str)")
        Alamofire.request(.GET, str).responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                self.dic = JSON as? NSDictionary
                print("\(self.dic?.valueForKey("category"))")
            }
            print("数据返回\(response.result.value)");
            self.table.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func load(dic: NSDictionary) {
        
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
        let cell = UITableViewCell()
        
        let category:NSArray     = (self.dic?.valueForKey("category"))! as! NSArray
        let results:NSDictionary = self.dic?.valueForKey("results") as! NSDictionary
        let sectionArr:NSArray = results.valueForKey(category.objectAtIndex(indexPath.section) as! String) as! (NSArray)
        let dic:NSDictionary = sectionArr.objectAtIndex(indexPath.row) as! NSDictionary
        
        
        cell.textLabel?.text = dic.valueForKey("desc") as? String
//        let URL = NSURL(string: "https://moonagic.com/images/avatar.jpg")!
//        let resource = Resource(downloadURL: URL, cacheKey: "your_customized_key")
//        cell.imageView?.kf_setImageWithResource(resource, placeholderImage: UIImage (named: "321"))
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
        let category:NSArray     = (self.dic?.valueForKey("category"))! as! NSArray
        let results:NSDictionary = self.dic?.valueForKey("results") as! NSDictionary
        let sectionArr:NSArray = results.valueForKey(category.objectAtIndex(indexPath.section) as! String) as! (NSArray)
        let dic:NSDictionary = sectionArr.objectAtIndex(indexPath.row) as! NSDictionary
        let str:String = (dic.valueForKey("url") as? String)!
        self.openUrl(str)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("prepareForSegue")
    }
    
    func openUrl(url:String) {
        let safariVC = SFSafariViewController(URL: NSURL(string:url)!, entersReaderIfAvailable: true)
        
        presentViewController(
            safariVC,
            animated: true,
            completion: nil)
        
        safariVC.delegate = self
    }
    
    // =========================================================================
    // MARK: - SFSafariViewControllerDelegate
    
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print(#function)
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        print(#function)
    }

}
