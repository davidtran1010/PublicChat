//
//  SocketIOManager.swift
//  publicchat
//
//  Created by DavidTran on 2/12/18.
//  Copyright © 2018 DavidTran. All rights reserved.
//

import Foundation
import SocketIO
import Starscream
import UserNotifications
struct ServerInfo {
    static let ip = "http://192.168.1.4"
    static let port = "1337"
}
class ChatDataStore{
    static var myId = ""
    static var CurrentUserList = [FriendModel]()
    static var HistoryChatDic = [String:[ChatModel]]()
}
class SocketIOManager:NSObject, URLSessionDelegate{
    var chatListView: ChatListView?
    var chatView: ChatView?
    static let sharedInstance = SocketIOManager()
   
   // var ssl = SSLSecurity(certs: [], usePublicKeys: false)
   // var socket = SocketIOClient(
    
    let url = URL(string: ServerInfo.ip + ":" + ServerInfo.port)

   
    
    var socket: SocketIOClient!
  
    private var messageList = [ChatModel]()
    override init() {
        super.init()
        socket = SocketIOClient.init(socketURL: url!)//, config: [.log(true),.secure(true),.sessionDelegate(self)])
        
        
        socket.on("updateId"){ (data, ack) in
            let reponse = data[0] as! String
            ChatDataStore.myId = reponse
        }
        socket.on("updateFriendList") { (data, ack) in
            ChatDataStore.CurrentUserList.removeAll()
            let reponse = data[0] as! [String:String]
            for (id,name) in reponse{
                ChatDataStore.CurrentUserList.append(FriendModel.init(id: id, name: name, photoURL: ""))
            }
            self.chatListView?.updateChatList()
        }
        socket.on("newChatMessage") { (data, ack) in
            print(data)
            let dataDic = data[0] as! [String:String]
            let fromFriendID = dataDic["fromId"]!
            let message = dataDic["message"]!
            let friendModel = FriendModel.init(id: fromFriendID, name: fromFriendID, photoURL: "")
            let chatModel = ChatModel.init(MyInfo: nil, FriendInfo: friendModel, MyMessage: nil, FriendMessage: message)
            //ChatDataStore.HistoryChatDic["jhj"]
            if ChatDataStore.HistoryChatDic[fromFriendID] == nil{
                ChatDataStore.HistoryChatDic[fromFriendID] = [ChatModel]()
            }
            ChatDataStore.HistoryChatDic[fromFriendID]!.append(chatModel)
          
            // Notify current Chat View update message
            self.chatView?.updateChatModelList()
            
            // Notify to user for new message
            let content = UNMutableNotificationContent()
            content.title = "Public Chat New Message"
            content.subtitle = fromFriendID
            content.body = message
            let request = UNNotificationRequest(identifier: fromFriendID+"ms", content: content, trigger: nil)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if error == nil{
                    print("send message")
                }
                print(error)
            })
            
        }
    }
    func establishConnection(){
        socket.connect()
//        socket.on("connect") { (data, ack) in
//            onConnectedEvent()
//        }
    }
    func closeConnection(){
        socket.disconnect()
    }
    func changeName(name:String){
        socket.emit("updateNickName", name)
    }
    func sendMessage(message:String, toUserID:String){
        let myId = ChatDataStore.myId
        socket.emit("newChatMessage", toUserID, message, myId)
        self.chatView?.updateChatModelList()
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        
        // Adapted from OWASP https://www.owasp.org/index.php/Certificate_and_Public_Key_Pinning#iOS
        
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                var secresult = SecTrustResultType.invalid
                let status = SecTrustEvaluate(serverTrust, &secresult)
                
                if(errSecSuccess == status) {
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                        let serverCertificateData = SecCertificateCopyData(serverCertificate)
                        let data = CFDataGetBytePtr(serverCertificateData);
                        let size = CFDataGetLength(serverCertificateData);
                        let cert1 = NSData(bytes: data, length: size)
                        let file_der = Bundle.main.path(forResource: "heroku", ofType: "crt")
                        
                        if let file = file_der {
                            if let cert2 = NSData(contentsOfFile: file) {
                                if cert1.isEqual(to: cert2 as Data) {
                                    completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Pinning failed
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        print("loi xac thuc ssl")
    }
    
}

class NSURLSessionPinningDelegate: NSObject, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        
        // Adapted from OWASP https://www.owasp.org/index.php/Certificate_and_Public_Key_Pinning#iOS
        
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                var secresult = SecTrustResultType.invalid
                let status = SecTrustEvaluate(serverTrust, &secresult)
                
                if(errSecSuccess == status) {
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                        let serverCertificateData = SecCertificateCopyData(serverCertificate)
                        let data = CFDataGetBytePtr(serverCertificateData);
                        let size = CFDataGetLength(serverCertificateData);
                        let cert1 = NSData(bytes: data, length: size)
                        let file_der = Bundle.main.path(forResource: "myCA", ofType: "der")
                        
                        if let file = file_der {
                            if let cert2 = NSData(contentsOfFile: file) {
                                if cert1.isEqual(to: cert2 as Data) {
                                    completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Pinning failed
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
    
}
