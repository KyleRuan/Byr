//
//  RKURLRichTextRun.swift
//  BYR
//
//  Created by Jason on 15/12/3.
//  Copyright © 2015年 KYLERUAN. All rights reserved.
//

import Foundation


class RKURLRichTextRun:RKBaseRichTextRun {

  var  result:Array<RKBaseAnalysedResult>! = []
  func analyseText(inout text: NSString, entity: TopicModelEnity?) {
    let  regexStr = "\\[url=[a-zA-z]+://[^\\s]*\\[/url\\]"
    let regex = try! NSRegularExpression(pattern: regexStr, options: [])
    let arrayOfAllMathchedURL = regex.matchesInString(text as String, options: [], range: NSMakeRange(0, text.length))
    var offset = 0
    for  url in arrayOfAllMathchedURL {
      var urlText = RKBaseAnalysedResult(type: RKRichTextRunType.RKRichTextRunTypeURL)
      let urlr = NSMakeRange(url.range.location-offset, url.range.length)
      let urlString = text.substringWithRange(urlr) as NSString
      let tempRange = urlString.rangeOfString("[url=")
      //urls = http://guiyou.wangx.in
      //应该是「贵邮」
      let urls = urlString.substringFromIndex(tempRange.location+tempRange.length).componentsSeparatedByString("]")[0]
      let contentString = urlString.substringFromIndex(tempRange.location+tempRange.length).componentsSeparatedByString("]")[1].componentsSeparatedByString("[")[0]
      let length = text.length
      text = text.stringByReplacingCharactersInRange(urlr, withString: contentString)
      offset += length - text.length
      urlText.range = text.rangeOfString(contentString)
      urlText.data = urls
      result.append(urlText)
    }
  }

  func drawRichText(size:CGSize) ->[AnyObject] {
    var tmpArray:Array<TYLinkTextStorage> = []
    for drawText in result where drawText.type == RKRichTextRunType.RKRichTextRunTypeURL{
    let  urlStorage = TYLinkTextStorage()
    urlStorage.range = drawText.range!
    urlStorage.linkData = drawText.data
    tmpArray.append(urlStorage)
  }
    return tmpArray
  }
}
