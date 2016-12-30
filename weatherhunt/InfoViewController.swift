//
//  InfoViewController.swift
//  weatherhunt
//
//  Created by Danny Varner on 12/30/16.
//  Copyright © 2016 Danny Varner. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class InfoViewController : UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var feedbackBtn: UIButton!
    
    override func viewDidLoad() {
        if(!MFMailComposeViewController.canSendMail()) {
            feedbackBtn.isHidden = true;
        }
    }

    @IBAction func provideFeedback(_ sender: Any) {
        let subject = "Feedback on Weather Hunter"
        let toRecipents = ["support@weatherhunt.com"]
        let mc = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(subject)
        mc.setMessageBody("", isHTML: false)
        mc.setToRecipients(toRecipents)
        // Present mail view controller on screen
        self.present(mc, animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
