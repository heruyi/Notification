//
//  HNotification.swift
//  Notification
//
//  Created by henry on 2016/9/27.
//  Copyright © 2016年 何如意. All rights reserved.
//

import UIKit
import Foundation
///模仿KVOController
internal typealias NotificationCallBackBlock = (EventInfo)->Void

class HNotificationCenter: NSObject {
    
    var observers:[NSNotification.Name : Observer] = Dictionary()
    
    weak var notificationCenter : AnyObject?
    
    init(_ obj:AnyObject) {
        self.notificationCenter = obj
    }
    
    // 订阅事件
    func subscribe(eventName:NSNotification.Name ,callBack:@escaping NotificationCallBackBlock) {
        
        if self.observers[eventName] != nil {
            return print("重复订阅: %@", eventName)
        }
        
        self.observers[eventName] = Observer.subscriber(eventName, block: callBack)
    }
    
    //发布事件
    func sendNotification(_ eventName:NSNotification.Name, userInfo:[AnyHashable: Any]?) -> Void {
        NotificationCenter.default.post(name: eventName,
                                        object: self, userInfo: userInfo)
    }
    
    //取消订阅
    func unsubscribe(_ eventName:NSNotification.Name) {
        self.observers.removeValue(forKey: eventName)
    }
    
    //取消订阅所有
    func unsubscribeAll() {
        self.observers.removeAll()
    }
    
    deinit{
        self.observers.removeAll()
    }
}

// MARK 保存事件信息
class EventInfo: NSObject {
    
    let userInfo:[AnyHashable : Any]?
    let eventName:NSNotification.Name
    let observer: Any?
    
    init(eventName:NSNotification.Name,
         observer:Any?,
         userInfo:[AnyHashable : Any]?){
        
        self.userInfo = userInfo
        self.eventName = eventName
        self.observer = observer
    }
}

// MARK 实际订阅类
 class Observer: NSObject {
    
    let eventName : NSNotification.Name
    let block:NotificationCallBackBlock
    
    init(eventName:NSNotification.Name,block:@escaping NotificationCallBackBlock){
        self.eventName = eventName
        self.block = block
    }
    
    class  func subscriber(_ eventName:NSNotification.Name,block:@escaping NotificationCallBackBlock) -> Observer {
        let obs = Observer.init(eventName: eventName, block: block)
        NotificationCenter.default.addObserver(obs, selector:#selector(Observer.notificationCallBack(_:)) , name: eventName, object: nil)
        return obs
    }
    
    func notificationCallBack(_ nt:Notification) {
        let event = EventInfo(eventName:nt.name ,observer:nt.object,userInfo:nt.userInfo)
        block(event)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: eventName, object: nil)
    }
}

// MARK
private var HNotificationKey = "HNotificationKey"

extension NSObject{
    var notification:HNotificationCenter{
        get{
            var obj = objc_getAssociatedObject(self,&HNotificationKey)
            if (obj != nil) {
                return obj as! HNotificationCenter
            }
            
            obj = HNotificationCenter.init(self)
            objc_setAssociatedObject(self, &HNotificationKey, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            return obj as! HNotificationCenter;
        }
    }
}

