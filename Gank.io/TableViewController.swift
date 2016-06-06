//
//  TableViewController.swift
//  Gank.io
//
//  Created by Wu Hengmin on 16/3/31.
//  Copyright © 2016年 Wu Hengmin. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SafariServices

class TableViewController: UITableViewController {
    
    var data:NSArray = []
    var dataOfiOS:NSArray = []
    var dataOfAndorid:NSArray = []
    var sendStr:String = ""
    var needReload:Bool = true
    var mode:NSInteger = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        self.tableView.tableFooterView = UIView.init(frame: CGRectZero)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        let ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let data:NSArray = ud.objectForKey("datelist") as? NSArray {
            self.data = data
            self.tableView.reloadData()
        }
        
        if self.needReload {
            self.loadData()
            self.needReload = false
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if mode == 1 {
            return self.data.count
        } else if mode == 2 {
            return self.dataOfiOS.count
        } else if mode == 3 {
            return self.dataOfAndorid.count
        }
        return 0;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if mode == 1 {
            self.sendStr = (self.data[indexPath.row] as? String)!
            performSegueWithIdentifier("showdetail", sender: nil)
        } else if mode == 2 {
            let dic:NSDictionary = self.dataOfiOS[indexPath.row] as! NSDictionary
            let url:String = dic.valueForKey("url") as! String
            self.openUrlWithSafariViewContoller(url)
        } else if mode == 3 {
            let dic:NSDictionary = self.dataOfAndorid[indexPath.row] as! NSDictionary
            let url:String = dic.valueForKey("url") as! String
            self.openUrlWithSafariViewContoller(url)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier:String = "datecell"
        
        let cell:DateCell = (tableView.dequeueReusableCellWithIdentifier(identifier) as? DateCell)!
        if mode == 1 {
            let date:String = (self.data[indexPath.row] as? String)!
            cell.contentLabel.text = "日期: \(date)"
            cell.colorTag.backgroundColor = UIColor.orangeColor()
        } else if mode == 2 {
            let dic:NSDictionary = self.dataOfiOS[indexPath.row] as! NSDictionary
            let desc:String = dic.valueForKey("desc") as! String
            cell.contentLabel.text = "\(desc)"
            cell.colorTag.backgroundColor = UIColor.orangeColor()
        } else if mode == 3 {
            let dic:NSDictionary = self.dataOfAndorid[indexPath.row] as! NSDictionary
            let desc:String = dic.valueForKey("desc") as! String
            cell.contentLabel.text = "\(desc)"
            cell.colorTag.backgroundColor = UIColor.orangeColor()
        }
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showdetail" {
            let dc:DetailViewController = segue.destinationViewController as! DetailViewController
            dc.data = self.sendStr
        }
        
    }
    
    func loadData() {
        if self.mode == 1 {
            Alamofire.request(.GET, baseUrl+url_dayhistory).responseJSON { response in
                let str = response.result.value as! NSDictionary
                self.data = str.valueForKey("results") as! NSArray
                let ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                ud.setObject(self.data, forKey: "datelist")
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                
            }
        } else if self.mode == 2 {
            let count:NSInteger = 50
            let page:NSInteger = self.dataOfiOS.count/50
            
            Alamofire.request(.GET, baseUrl+url_data+"iOS/\(count)/\(page)").responseJSON { response in
                let str = response.result.value as! NSDictionary
                self.dataOfiOS = str.valueForKey("results") as! NSArray
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                
            }
        } else if self.mode == 3 {
            let count:NSInteger = 50
            let page:NSInteger = self.dataOfAndorid.count/50
            
            Alamofire.request(.GET, baseUrl+url_data+"Android/\(count)/\(page)").responseJSON { response in
                let str = response.result.value as! NSDictionary
                self.dataOfAndorid = str.valueForKey("results") as! NSArray
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                
            }
        }
    }
    
    @IBAction func switchPressed(sender: AnyObject) {
        let alertController = UIAlertController(title: "选择分类", message: "", preferredStyle: .ActionSheet)
        
        // date
        let dateAction = UIAlertAction(title: "Date", style: .Default) { (action:UIAlertAction!) in
            print("you have pressed the iOS button");
            self.title = "干货集中营"
            self.mode = 1
            self.loadData()
        }
        alertController.addAction(dateAction)
        // iOS
        let iOSAction = UIAlertAction(title: "iOS", style: .Default) { (action:UIAlertAction!) in
            print("you have pressed the iOS button");
            self.title = "iOS"
            self.mode = 2
            self.loadData()
        }
        alertController.addAction(iOSAction)
        // Android
        let androidAction = UIAlertAction(title: "Android", style: .Default) { (action:UIAlertAction!) in
            print("you have pressed the Android button");
            self.title = "Android"
            self.mode = 3
            self.loadData()
        }
        alertController.addAction(androidAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in
            print("you have pressed the cancel button");
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
    }
    
    func openUrlWithSafariViewContoller(urlStr:String) {
        let safariVC = SFSafariViewController(URL: NSURL(string:urlStr)!, entersReaderIfAvailable: true)
        
        presentViewController(safariVC, animated: true, completion: nil)
        
    }
    
}
