//
//  LoginTableViewController.swift
//  Algonquin
//
//  Created by Peter Soboyejo on 8/26/17.
//  Copyright © 2017 Peter Soboyejo. All rights reserved.
//

import RealmSwift
import UIKit
import SVProgressHUD

class LoginTableViewController: UITableViewController{
    
    var lastY: CGFloat = 0.0
    
    @IBOutlet weak var userid: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        loginButton.addTarget(self, action: #selector(LoginTableViewController.login(sender:)), for: .touchUpInside)
        
    }
    
    func login(sender: UIButton) {
        
        SVProgressHUD.show()
        
        if userid.text == "" || password.text == "" {
            let alert = UIAlertController(title: "Whoops", message: "You cannot leave any of the fields empty.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                print("Ok was clicked")
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        Client.shared.parser.getSummary(userid: userid.text!, password: password.text!) { summary, error in
            guard let summary = summary else {
                print("Error while Logging In")
                SVProgressHUD.showError(withStatus: "Error Occured while Logging you in, please check your credentials and try again.")
                return
            }
            
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                let account = Account()
                account.userid = self.userid.text!
                account.password = self.password.text!
                
                let realm = try! Realm()
                try! realm.write {
                    realm.add(account)
                }
                
                self.performSegue(withIdentifier: "afterLogin", sender: nil)
            }
        }
        
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

func scrollViewDidScroll(scrollView: UIScrollView) {
    let currentY = scrollView.contentOffset.y
    let currentBottomY = scrollView.frame.size.height + currentY
    if currentY > lastY {
        //"scrolling down"
        tableView.bounces = true
    } else {
        //"scrolling up"
        // Check that we are not in bottom bounce
        if currentBottomY < scrollView.contentSize.height + scrollView.contentInset.bottom {
            tableView.bounces = false
        }
    }
    lastY = scrollView.contentOffset.y
}
    
}
