//
//  LevelViewController.swift
//  What's the color
//
//  Created by SARVADHI on 15/07/23.
//

import UIKit
import StoreKit

class LevelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnLevelClicked(_ sender: UIButton) {
        var count = 0
        
        switch sender.tag {
        case 101:
            count = 3
        case 102:
            count = 6
        case 103:
            count = 10
        default: break
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.count = Double(count)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func infoAction(_ sender: Any) {
        let alert = UIAlertController(title: "Welcome to What's the color", message: "Hello User, \n Welcome to our Color Guessing Game! Test your color identification skills and become a master of hues. Perfect for designers and creative minds. Download now and let the colors inspire your creativity!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Understood", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func rateAction(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let activityItems : NSArray = ["itms-apps://itunes.apple.com/us/app/apple-store/id6447046704?mt=8"]
        let activityVC : UIActivityViewController = UIActivityViewController(activityItems: activityItems as! [Any], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
}
