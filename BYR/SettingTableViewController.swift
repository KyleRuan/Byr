//
//  SettingTableViewController.swift
//  BYR
//
//  Created by Jason on 15/11/2.
//  Copyright © 2015年 KYLERUAN. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

enum UserType {
    case me
    case Others
}

class SettingTableViewController: UITableViewController {
    var headerView:userAvatarView!
    var headHeight:CGFloat! = 160
    var keys = Array<String>()
    var values = Array<String>()
    var user:User!
    var type:UserType = .me
    
    
    override init(style: UITableViewStyle) {
        super.init(style: .Plain)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(userType:UserType,user:User) {
        self.init(style: UITableViewStyle.Plain)
        type = userType
        self.user = user
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if tableView == nil {
//            tableView = UITableView()
//            resetButton = UIButton()
//        }
//        self.tableView.dataSource = self
//        self.tableView.delegate = self
//        if type == .Others {
//            resetButton.hidden = true
//        }
        initUserInfo()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.toolbarHidden = true
        let btn = UIButton(type: UIButtonType.Custom)
        if type == .Others {
            // here to 
            btn.frame = CGRectMake(0, 0, 50, 100);
            btn.setTitle("返回", forState: .Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btn.addTarget(self, action: #selector(SettingTableViewController.back), forControlEvents: UIControlEvents.TouchUpInside)
            let item = UIBarButtonItem(customView: btn)
            self.navigationItem.leftBarButtonItem = item
//            self.navigationBar.backgroundColor = UIColor(red: 49, green: 183, blue: 254, alpha: 1)

            self.navigationController?.navigationBar.backgroundColor = UIColor(red: 49, green: 183, blue: 254, alpha: 1)
            self.navigationController?.navigationBar.hidden = false
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 49, green: 183, blue: 254, alpha: 1)

        } else {
            // 退出
            let height:CGFloat = 100
            btn.frame = CGRectMake(0, self.tableView.frame.height-height, Screen.width, 50)
//            self.tableView.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
            self.tableView.contentInset.bottom = height
//            let url = NSURL(string: user.face_url)
            btn.setTitle("退出登入", forState: .Normal)
            btn.backgroundColor =  UIColor.redColor()
//            btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btn.addTarget(self, action: #selector(SettingTableViewController.exitToLogin), forControlEvents: UIControlEvents.TouchUpInside)
            self.tableView.addSubview(btn)
//            self.view.bringSubviewToFront(btn)

            
        }
        
    }
    
    func back()  {
        print("back")
        
        UserInfowindow.windowLevel = -1
        
//        UserInfowindow.sendSubviewToBack(self.view.window!)
        UserInfowindow.hidden = true 
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        if (type == .Others&&resetButton != nil) {
////            print(resetButton)
//            self.resetButton.removeFromSuperview()
//        }
    }
    
    func  initUserInfo() {
      
        if type ==  .me {
            user = User.mj_objectWithKeyValues(UserAngent.sharedInstance.getUserInfo())
        }
  
        
        headerView = userAvatarView(frame:CGRectMake(0,-headHeight,self.tableView.bounds.width,headHeight))
        headerView.backgroundColor = UIColor.redColor()
        self.tableView.addSubview(headerView)
        self.tableView.contentInset =  UIEdgeInsets(top: headHeight, left: 0, bottom: 0, right: 0)
        let url = NSURL(string: user.face_url)
        let avatar = UIImageView()
        if let avatarUrl = url {
            avatar.kf_setImageWithURL(avatarUrl, placeholderImage: nil, optionsInfo: nil, completionHandler: { (image, error, cacheType, imageURL) in
                self.headerView.avatar = image
            })
            avatar.kf_setImageWithURL(avatarUrl, placeholderImage: nil)
            
        }
        let attribute = PersonalAttributes()
        let (keyArray,valueArray) = attribute.keyValuePairs(user)
        for value in valueArray {
            if value !=  "" {
                let index = valueArray.indexOf(value)
                self.keys.append(keyArray[index!])
                self.values.append(value)
            }
            self.tableView.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return keys.count
    }
    
    @IBAction func exitToLogin() {
        let sheet = UIAlertController(title: "退出当前用户", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let action = UIAlertAction(title: "退出当前用户", style: UIAlertActionStyle.Destructive) { (exit) -> Void in
            UserAngent.sharedInstance.removeObjectForKey(USER_INFO)
            UserAngent.sharedInstance.removeObjectForKey(ACCESS_TOKEN)
            SegueToViewController.sharedInstance.implementationSegue(self, segueTo: OAUTH_VIEW_CONTROLLER)
            
        }
        sheet.addAction(action)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) -> Void in
            
        }))
        presentViewController(sheet, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingCell", forIndexPath: indexPath) as! SettingTableViewCell
        cell.keyLabel.text = keys[indexPath.row]
        cell.valueLabel.text =  values[indexPath.row]
        return cell
    }
    

    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        var scale:CGFloat = 1
        if scrollView.contentOffset.y < -headHeight{
            scale = abs(scrollView.contentOffset.y)/headHeight
            self.headerView.layer.position = CGPointMake(Screen.width/2.0, scrollView.contentOffset.y / 2.0)
            self.headerView.transform = CGAffineTransformMakeScale(scale, scale)
        }
    }
    
}