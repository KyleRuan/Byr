//
//  APIClient.swift
//  Byr
//
//  Created by Jason on /10/14.
//  Copyright © 2016年 KYLERUAN. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

 let baseurl = "http://bbs.byr.cn"
//http://bbs.byr.cn/oauth2/token

// 	"http:bbs.byr.cn/open/thread/Basketball/592235.json"

// http://bbs.byr.cn/open/attachment/Photo/253920/1216?oauth_token=3140fd026627ac9fba09e638794c4dc4
class APIClinet {
    static let sharedInstance = APIClinet()
    
  private  func getJSONData(path:String,parameters:[String:AnyObject]?, success: (JSON) -> Void, failure: (NSError) -> Void){
        
        Alamofire.request(.GET, baseurl+path, parameters: parameters).responseSwiftyJSON{
            (request,response ,result ,error) in
            if let err = error {
                failure(err)
            } else {
                success(result)
            }
        }
        
    }
    
    //可以在这个添加token是否是合适
  private func postJSONData(path:String,parameter:[String:AnyObject]?,success:(JSON) -> Void,failure:(NSError)->Void){
        Alamofire.request(.POST, baseurl+path, parameters: parameter).responseSwiftyJSON{
            (request,response ,result ,error) in
             print(request)
            print(response)
            if let err = error {
                failure(err)
            } else {
                success(result)
            }
        }
        
    }
    
    
    
    
    func getUserInfo(token:AnyObject,userId:String,success:((JSON)->Void),failure:((NSError)->Void)) {
        let param = [ACCESS_TOKEN:token]
        print(userId)
//        http://bbs.byr.cn/open/user/query/weiyuhan.json
        self.getJSONData("/open/user/query/\(userId).json", parameters: param, success: success, failure: failure)
    }
    

    func getSectionInfo(token:AnyObject,name:String,success:((JSON)->Void),failure:((NSError)->Void)){

    
    let param = [ACCESS_TOKEN:token]
        self.getJSONData("/open/section/\(name).json", parameters: param, success: success, failure: failure)
    
    }
    
    
    func getTopics(token:AnyObject,thread:String,type:String,success:((JSON)->Void),failure:((NSError)->Void)){
        //
        
        let param = [ACCESS_TOKEN:token]
        self.getJSONData("/open/\(thread)/\(type).json", parameters: param, success: success, failure: failure)
        
    }
    
    
    func getTopTenTopics(token:AnyObject,type:String,success:(JSON)->Void,failure:(NSError)->Void){
//
        let param = [ACCESS_TOKEN:token]
        self.getJSONData("/open/widget/\(type).json", parameters: param, success: success, failure: failure)
    }
//    /board/:name.(xml|json)

//    mode	false	int 最小0 最大6 默认2	表示版面文章列表的模式，分别是
//    = 0 以id为顺序列表
//    = 1 文摘区列表
//    = 2 同主题(web顺序)列表
//    = 3 精华区列表
//    = 4 回收站列表
//    = 5 废纸篓列表
//    = 6 同主题(发表顺序)列表
//    count	false	int 最小1 最大50 默认30	每页文章的数量
//    page	false	int 默认1
    
    func getTopicList(token:AnyObject,name:String,mode:Int = 2,page:Int,success:(JSON)->Void,failure:(NSError)->Void){
//
        let param = [ACCESS_TOKEN:token,"mode":mode,"page":page]
         self.getJSONData("/open/board/\(name).json", parameters: param, success: success, failure: failure)
    }
    

    func getAuthorizedUserInfo(token:AnyObject,success:(JSON)->Void,failure:(NSError)->Void){
        let param = [ACCESS_TOKEN:token]
        self.getJSONData("/open/user/getinfo.json", parameters: param, success: success, failure: failure)
    }
    
    func getOneTopicDetail(token:AnyObject,path:String,page:Int,success:(JSON)->Void,failure:(NSError)->Void){
        let param = [ACCESS_TOKEN:token,"page":page]
//
        self.getJSONData("/open/threads/\(path).json", parameters: param, success:success, failure: failure)
    }
    
    
    
    
    
    
    func isTokenLegal(uid:AnyObject,token:AnyObject,success:(JSON)->Void,failure:(NSError)->Void){
        let param = ["uid":uid,"token":token]
        self.getJSONData("isTokenLegal", parameters: param, success: success, failure: failure)
    }

    
    func getACCESSToken(success:(JSON)->Void,failure:(NSError)->Void){
        let param = ["response_type":RESPONSE_TYPE,"client_id":CLIENT_ID,"redirect_uri":REDIRECT_URI]
        self.getJSONData("/oauth2/authorize", parameters: param, success: success, failure: failure)
        
    }
    //http://bbs.byr.cn/oauth2/token
    
    func getACCESSToken(refresh_token:AnyObject,success:(JSON)->Void,failure:(NSError)->Void) {
        
//        let refresh_token = UserAngent.sharedInstance.getRefreshToken()!
        let param = ["client_id":CLIENT_ID,"client_secret":CLIENT_SECRET,"grant_type":"refresh_token","refresh_token":refresh_token]
        
        self.postJSONData("/oauth2/token", parameter: param, success: success, failure: failure)
    }
    
//    请求方式 POST
//    
//    请求参数
//    参数	必选	含义
//    client_id	true	开发者申请通过后分配的id,对应于appkey
//    client_secret	true	开发者申请通过后得到的秘钥
//    grant_type	true	授权类型，此处为 "refresh_token"
//    refresh_token	true	上一步返回的refresh_token
 
    

    
    
    
    
}




    
        
        
        
        
        