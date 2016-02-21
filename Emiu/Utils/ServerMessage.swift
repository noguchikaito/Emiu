//
//  ServerMessage.swift
//  Emiu
//
//  Created by Triomphe on 2016/01/31.
//  Copyright © 2016年 noguchikaito. All rights reserved.
//

import Foundation

class ServerMessage : NSObject,NSXMLParserDelegate {
    
    static let ud = NSUserDefaults.standardUserDefaults()
    static let xmlPars = XmlParser()

    static func getResultBySql(url:String,command:String) -> Bool{
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let url = NSURL(string: url)
        let req = NSMutableURLRequest(URL: url!)
        req.HTTPMethod = "POST"
        let httpBodyStr = command
        req.HTTPBody = httpBodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        var result = false
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            if(data != nil){
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                if (err == nil) {
                    result = strData.length > 0 ? true : false
                    print(strData)
                }else{
                    print(err)
                }
            }
        })
        task.resume()
        sleep(1)
        return result
    }
    
    static func getDataBySql(url:String,command:String,block:(NSData) -> ()){
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let url = NSURL(string: url)
        let req = NSMutableURLRequest(URL: url!)
        var dataStr = String()
        req.HTTPMethod = "POST"
        let httpBodyStr = command
        req.HTTPBody = httpBodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            if(data != nil){
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                print(strData)
                if (err == nil) {
                    //dataStr = strData as String
                    print(dataStr)
                    block(data!)
                }else{
                    print(err)
                }
            }

        })
        task.resume()
    }

    
    static func loginAccount(id:String,pass:String) -> Bool{
        let url = "http://triomphe28.php.xdomain.jp/login.php"
        let httpBodyStr = "roginId=" + id + "&roginPass=" + pass
        let result = getResultBySql(url,command: httpBodyStr)
        if(result){
            ud.setObject(id, forKey: "userId")
            ud.setObject(pass, forKey: "userPass")
        }
        return result
    }
    
    static func insertUserData(type:Int,data:String) -> Bool{
        let url = "http://triomphe28.php.xdomain.jp/insertUserData.php"
        let tmpId = ud.objectForKey("userId")
        var result = false
        if((tmpId) != nil){
            let id = ud.objectForKey("userId") as! String
            let httpBodyStr = "userId=" + id + "&type=" + String(type) + "&data=" + data
            result = getResultBySql(url,command:httpBodyStr)
        }
        return result
    }
    
    static func deleteUserData() -> Bool{
        let url = "http://triomphe28.php.xdomain.jp/deleteUserData.php"
        let tmpId = ud.objectForKey("userId")
        var result = false
        if((tmpId) != nil){
            let id = ud.objectForKey("userId") as! String
            let httpBodyStr = "userId=" + id
            result = getResultBySql(url,command:httpBodyStr)
        }
        return result
    }
    
    static func selectUserData(block:(NSArray) -> ()){
        let url = "http://triomphe28.php.xdomain.jp/selectUserData.php"
        let tmpId = ud.objectForKey("userId")
        if((tmpId) != nil){
            let id = ud.objectForKey("userId") as! String
            let httpBodyStr = "userId=" + id
            getDataBySql(url,command:httpBodyStr,block:{(data) in
                var items = NSArray()
                if(data.length != 0){
                    let strData = NSString(data: data, encoding: NSUTF8StringEncoding)!
                    items = StrUtil.transformDivideByKeyword(strData as String, key: "<result>")
                    block(items)
                }
            })
        }
    }
    
    static func selectFriendData(block:(NSArray) -> ()){
        let url = "http://triomphe28.php.xdomain.jp/selectFriendData.php"
        let tmpId = ud.objectForKey("userId")
        if((tmpId) != nil){
            let id = ud.objectForKey("userId") as! String
            let httpBodyStr = "userId=" + id
            getDataBySql(url,command:httpBodyStr,block:{(data) in
                let items:NSArray? = NSArray()
                if(data.length != 0){
                    do {
                        xmlPars.initParse(data)

                        if(items != nil){
                            block(items!)                        
                        }
                    } catch {
                        // Error handling...
                    }
                }
            })
        }
    }
    
    static func updateFriendData(friendId:String,contactId:String) -> Bool{
        let url = "http://triomphe28.php.xdomain.jp/updateFriendList.php"
        let tmpId = ud.objectForKey("userId")
        var result = false
        if((tmpId) != nil){
            let id = ud.objectForKey("userId") as! String
            print(friendId + " " + contactId)
            let httpBodyStr = "userId=" + id + "&friendId=" + friendId + "&contactId=" + contactId
            result = getResultBySql(url,command:httpBodyStr)
        }
        return result
    }
    
    /*
    
    var _ParseKey = String()
    var _Items: [String]? = nil
    var _Item: String? = nil
    
    func parserDidStartDocument(parser: NSXMLParser!)
    {
        // Itemオブジェクトを格納するItems配列の初期化など
    }
    
    func parserDidEndDocument(parser: NSXMLParser!)
    {
        // XMLから読み込んだ情報より画面を更新する処理など
    }
    
    func parser(parser: NSXMLParser,didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        var _Items = NSArray()
        var _Item = String()
        _ParseKey = elementName
        
        if elementName == "Items" {
            // Itemオブジェクトを保存するItems配列を初期化
            _Items = []
            
        } else if elementName == "Item" {
            // Itemオブジェクトの初期化
            _Item = ""
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        if _ParseKey == "result" {
            _Items?.append(string)
        }else{
            print(string)
        }
    }
*/
}
