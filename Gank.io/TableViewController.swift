//
//  TableViewController.swift
//  Gank.io
//
//  Created by Wu Hengmin on 16/3/31.
//  Copyright © 2016年 Wu Hengmin. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices
import MJRefresh

class TableViewController: UITableViewController {
    
    var data:NSArray = []
    var dataOfiOS:NSMutableArray = []
    var dataOfAndorid:NSMutableArray = []
    var sendStr:String = ""
    var needReload:Bool = true
    var mode:NSInteger = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationController!.navigationBar.barTintColor = UIColor.orange
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController!.navigationBar.barStyle = UIBarStyle.black
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        setupHeader()
    }
    
    func setupHeader() {
//        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction:#selector(refreshData))
        header?.isAutomaticallyChangeAlpha = true;
        // 隐藏时间
        header?.lastUpdatedTimeLabel.isHidden = true;
        self.tableView.mj_header = header;
        
//        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [weakSelf loadData:[weakSelf.data count] end:[weakSelf.data count]+10];
//            }];
        
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
//            self.tableView.mj_footer.endRefreshing()
            self.loadData()
        })
    }
    
    func refreshData() {
        self.tableView.mj_header.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        let ud:UserDefaults = UserDefaults.standard
        
        if let data:NSArray = ud.object(forKey: "datelist") as? NSArray {
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


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if mode == 1 {
            self.sendStr = (self.data[indexPath.row] as? String)!
            performSegue(withIdentifier: "showdetail", sender: nil)
        } else if mode == 2 {
            let dic:NSDictionary = self.dataOfiOS[indexPath.row] as! NSDictionary
            let url:String = dic.value(forKey: "url") as! String
            self.openUrlWithSafariViewContoller(urlStr: url)
        } else if mode == 3 {
            let dic:NSDictionary = self.dataOfAndorid[indexPath.row] as! NSDictionary
            let url:String = dic.value(forKey: "url") as! String
            self.openUrlWithSafariViewContoller(urlStr: url)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier:String = "datecell"
        
        let cell:DateCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? DateCell)!
        if mode == 1 {
            let date:String = (self.data[indexPath.row] as? String)!
            cell.contentLabel.text = "日期: \(date)"
            cell.colorTag.backgroundColor = UIColor.orange
        } else if mode == 2 {
            let dic:NSDictionary = self.dataOfiOS[indexPath.row] as! NSDictionary
            let desc:String = dic.value(forKey: "desc") as! String
            cell.contentLabel.text = "\(desc)"
            cell.colorTag.backgroundColor = UIColor.orange
        } else if mode == 3 {
            let dic:NSDictionary = self.dataOfAndorid[indexPath.row] as! NSDictionary
            let desc:String = dic.value(forKey: "desc") as! String
            cell.contentLabel.text = "\(desc)"
            cell.colorTag.backgroundColor = UIColor.orange
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showdetail" {
            let dc:DetailViewController = segue.destination as! DetailViewController
            dc.data = self.sendStr
        }
        
    }
    
    func loadData() {
        if self.mode == 1 {
            weak var weakSelf = self
            Alamofire.request(baseUrl+url_dayhistory, method: .get).responseJSON { response in
                if let strongSelf = weakSelf {
                    let str = response.result.value as! NSDictionary
                    self.data = str.value(forKey: "results") as! NSArray
                    let ud:UserDefaults = UserDefaults.standard
                    ud.set(strongSelf.data, forKey: "datelist")
                    
                    DispatchQueue.main.async(execute: {
                        strongSelf.tableView.mj_footer.endRefreshing()
                        strongSelf.tableView.reloadData()
                    })
                }
            }
        } else if self.mode == 2 {
            let count:NSInteger = 50
            let page:NSInteger = self.dataOfiOS.count/count+1
            weak var weakSelf = self
            Alamofire.request(baseUrl+url_data+"iOS/\(count)/\(page)", method: .get).responseJSON { response in
                if let strongSelf = weakSelf {
                    let str = response.result.value as! NSDictionary
                    print("\(str)")
                    let tmpdata:NSArray = str.value(forKey: "results") as! NSArray
                    if tmpdata.count > 0 {
                        if page == 1 {
                            strongSelf.dataOfiOS = tmpdata.mutableCopy() as! NSMutableArray
                        } else {
                            for i in 0 ..< tmpdata.count {
                                let dic:NSDictionary = tmpdata.object(at: i) as! NSDictionary
                                strongSelf.dataOfiOS.add(dic)
                            }
                        }
                        DispatchQueue.main.async(execute: {
                            strongSelf.tableView.mj_footer.endRefreshing()
                        })
                    } else {
                        DispatchQueue.main.async(execute: {
                            strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                        })
                    }
                    
                    DispatchQueue.main.async(execute: {
                        strongSelf.tableView.reloadData()
                    })
                }
            }
        } else if self.mode == 3 {
            let count:NSInteger = 50
            let page:NSInteger = self.dataOfAndorid.count/count
            weak var weakSelf = self
            Alamofire.request(baseUrl+url_data+"Android/\(count)/\(page)", method: .get).responseJSON { response in
                if let strongSelf = weakSelf {
                    let str = response.result.value as! NSDictionary
                    let tmpdata:NSArray = str.value(forKey: "results") as! NSArray
                    if tmpdata.count > 0 {
                        if page == 1 {
                            strongSelf.dataOfAndorid = tmpdata.mutableCopy() as! NSMutableArray
                        } else {
                            for i in 0 ..< tmpdata.count {
                                let dic:NSDictionary = tmpdata.object(at: i) as! NSDictionary
                                strongSelf.dataOfAndorid.add(dic)
                            }
                        }
                        DispatchQueue.main.async(execute: {
                            strongSelf.tableView.mj_footer.endRefreshing()
                        })
                    } else {
                        DispatchQueue.main.async(execute: {
                            strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                        })
                    }
                    
                    DispatchQueue.main.async(execute: {
                        strongSelf.tableView.reloadData()
                    })
                }
            }
        }
    }
    
    @IBAction func switchPressed(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "选择分类", message: "", preferredStyle: .actionSheet)
        
        // date
        let dateAction = UIAlertAction(title: "Date", style: .default) { (action:UIAlertAction!) in
            self.title = "干货集中营"
            self.mode = 1
            self.tableView.reloadData()
            self.loadData()
        }
        alertController.addAction(dateAction)
        // iOS
        let iOSAction = UIAlertAction(title: "iOS", style: .default) { (action:UIAlertAction!) in
            self.title = "iOS"
            self.mode = 2
            self.tableView.mj_header.beginRefreshing()
            self.loadData()
        }
        alertController.addAction(iOSAction)
        // Android
        let androidAction = UIAlertAction(title: "Android", style: .default) { (action:UIAlertAction!) in
            self.title = "Android"
            self.mode = 3
            self.tableView.mj_header.beginRefreshing()
            self.loadData()
        }
        alertController.addAction(androidAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("you have pressed the cancel button");
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func openUrlWithSafariViewContoller(urlStr: String) {
        let replaced = (urlStr as NSString).replacingOccurrences(of: " ", with: "")
        let safariVC = SFSafariViewController(url: URL(string:replaced)!, entersReaderIfAvailable: true)
        
        present(safariVC, animated: true, completion: nil)
        
    }
    
}
