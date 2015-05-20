//
//  ViewController.swift
//  pruebaOAUTH
//
//  Created by lorenzo gonzalez on 5/20/15.
//  Copyright (c) 2015 lorenzo gonzalez. All rights reserved.
//

import UIKit
import OAuthSwift

let Instagram =
[
    "consumerKey": "7615dc25d8844347871578ceddef9333",
    "consumerSecret": "8541a64964f640f781fe2cac622a4c0e"
]

class ViewController: UIViewController, OAuthSwiftURLHandlerType {

    
    var urlToHandle: NSURL?
    
    @IBAction func loginInstagram(sender: AnyObject) {
       doOAuthInstagram()
        
    }
    
    
    func doOAuthInstagram(){
        let oauthswift = OAuth2Swift(
            consumerKey:    Instagram["consumerKey"]!,
            consumerSecret: Instagram["consumerSecret"]!,
            authorizeUrl:   "https://api.instagram.com/oauth/authorize",
            responseType:   "token"
        )
        
        let state: String = generateStateWithLength(20) as String
        oauthswift.authorize_url_handler = self
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/instagram")!, scope: "likes+comments", state:state, success: {
            credential, response in
          //  self.showAlertView("Instagram", message: "oauth_token:\(credential.oauth_token)")
            let url :String = "https://api.instagram.com/v1/users/1574083/?access_token=\(credential.oauth_token)"
            let parameters :Dictionary = Dictionary<String, AnyObject>()
            oauthswift.client.get(url, parameters: parameters,
                success: {
                    data, response in
                    let jsonDict: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
                    println(jsonDict)
                }, failure: {(error:NSError!) -> Void in
                    println(error)
            })
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func handle(url: NSURL) {
        self.urlToHandle = url
        
        self.performSegueWithIdentifier("oauth", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "oauth" {
            if let webViewController = segue.destinationViewController as? WebViewController,
                url = self.urlToHandle
            {
                
                webViewController.targetURL = url
            }
        }
    }

}

