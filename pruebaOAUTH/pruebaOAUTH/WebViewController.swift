import UIKit
import OAuthSwift

class WebViewController: UIViewController, UIWebViewDelegate {
    
    var targetURL: NSURL? {
        didSet {
            loadAddressURL()
        }
    }
    let webView : UIWebView = UIWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.frame = UIScreen.mainScreen().applicationFrame
        self.webView.scalesPageToFit = true
        self.webView.delegate = self
        self.view.addSubview(self.webView)
        loadAddressURL()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    func loadAddressURL() {
        if let url = targetURL {
            let req = NSURLRequest(URL: url)
            self.webView.loadRequest(req)
        }
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL where  url.scheme == "oauth-swift"{
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                 
            })
        }
        return true
    }
}