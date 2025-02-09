//
//  OauthViewController.swift
//  Byr
//
//  Created by Jason on 15/10/17.
//  Copyright © 2015年 KYLERUAN. All rights reserved.
//

import UIKit
import JGProgressHUD
import Alamofire

class OauthViewController: UIViewController,UIWebViewDelegate {
  var hud = JGProgressHUD()
  @IBOutlet weak var webview: UIWebView!
  override func viewDidLoad() {
    super.viewDidLoad()
    webview.delegate = self
    webview.contentMode = UIViewContentMode.Center
    if  let url = NSURL(string: "http://bbs.byr.cn/oauth2/authorize?response_type=token&client_id=2a44821105d92482960593d94e4d042e&redirect_uri=http://bbs.byr.cn/oauth2/callback&state=2222"){
      webview.loadRequest(NSURLRequest(URL:url))
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func webViewDidStartLoad(webView: UIWebView) {
    hud.textLabel.text = "Loading..."
    hud.showInView(self.view, animated: true)
  }

  func webViewDidFinishLoad(webView: UIWebView) {
    defer{
      self.hud.dismiss()
    }
    if let requestURLString:NSString = webView.request?.URL?.absoluteString where requestURLString.containsString("access_token"){
      let access_token = NSURLComponents(string: requestURLString as String)?.fragment?.componentsSeparatedByString("&")[0].componentsSeparatedByString("=")[1]
      let refreshToken = NSURLComponents(string: requestURLString as String)?.fragment?.componentsSeparatedByString("&")[2].componentsSeparatedByString("=")[1]
      UserAngent.sharedInstance.setAccessToken(access_token)
      UserAngent.sharedInstance.setRefreshToken(refreshToken)
      webview.backgroundColor = UIColor.blueColor()
      self.performSegueWithIdentifier(SEGUE_FROM_LOGIN_TO_TABBAR, sender: self)
      APIClinet.sharedInstance.getAuthorizedUserInfo(access_token!, success: { (json) -> Void in
        UserAngent.sharedInstance.setUserInfo(json.object)
      }, failure: { (error) -> Void in
        self.hud.textLabel.text = error.description
      })
    }
  }
  // MARK: - Navigation
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if let identifier = segue.identifier where identifier == SEGUE_FROM_LOGIN_TO_TABBAR{
    }
  }


}
