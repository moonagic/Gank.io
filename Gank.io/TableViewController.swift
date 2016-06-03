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

class TableViewController: UITableViewController {
    
    var data:NSArray = []
    var sendStr:String = ""
    var needReload:Bool = true
    
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
        
        if ud.objectForKey("datelist") != nil {
            self.data = ud.objectForKey("datelist") as! NSArray
            self.tableView.reloadData()
        }
        
        if self.needReload {
            Alamofire.request(.GET, "https://gank.io/api/day/history").responseJSON { response in
                
                print("数据返回");
                let str = response.result.value as! NSDictionary
                self.data = str.valueForKey("results") as! NSArray
                let ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                ud.setObject(self.data, forKey: "datelist")
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                
            }
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
        return self.data.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.sendStr = (self.data[indexPath.row] as? String)!
        performSegueWithIdentifier("showdetail", sender: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier:String = "datecell"
        
        let cell:DateCell = (tableView.dequeueReusableCellWithIdentifier(identifier) as? DateCell)!
        let date:String = (self.data[indexPath.row] as? String)!
        cell.contentLabel.text = "日期: \(date)"
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
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
    
    
}
