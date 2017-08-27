//
//  SettingsTableViewController.swift
//  Algonquin
//
//  Created by Peter Soboyejo on 8/26/17.
//  Copyright © 2017 Peter Soboyejo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SafariServices
import MessageUI

class SettingsTableViewController : UITableViewController, MFMailComposeViewControllerDelegate {
    
    let realm = try! Realm()
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionLabel.text = "\(Bundle.main.releaseVersionNumber!) (\(Bundle.main.buildVersionNumber!))"
    
    }
    
    func openTwitter(_ username: String) {
        let urls = ["tweetbot://current/user_profile/\(username)", "twitterrific://current/profile?screen_name=\(username)", "twitter://user?screen_name=\(username)"]
        for url in urls {
            if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                return
            }
        }
        openURL("https://twitter.com/\(username)")
    }
    
    func openURL(_ string: String) {
        if let url = URL(string: string) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        } else if indexPath.section == 0 && indexPath.row == 1 {
            openURL("https://github.com/dzt/algonquin")
        } else if indexPath.section == 0 && indexPath.row == 2 {
            try! self.realm.write {
                self.realm.deleteAll()
            }
            return self.performSegue(withIdentifier: "signOut", sender: nil)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            print("Version")
        } else if indexPath.section == 1 && indexPath.row == 1 {
            openURL("https://gist.githubusercontent.com/dzt/8759e669bbe5d8733c7fd723ac8abfba/raw/fe5bde830d0c5eee27fb9735a593dadff34a8caf/acknowledgements")
        } else {
            openURL("https://keybase.io/pxtvr")
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["thepcmrtim@gmail.com"])
        mailComposerVC.setSubject("Algonquin App")
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
        
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
