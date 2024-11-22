//
//  ViewController.swift
//  fefu
//
//  Created by Вадим Семибратов on 20.11.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var Back: UIImageView!
    @IBOutlet weak var Logo: UIImageView!
    @IBOutlet weak var Activitylogo: UILabel!
    @IBOutlet weak var titleHome: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        Back.image = UIImage(named: "Group 49")
        Logo.image = UIImage(named: "logo")
        titleHome.font = UIFont.boldSystemFont(ofSize: titleHome.font.pointSize)
        let text = "ACTIVITY"
        let attributedString = NSMutableAttributedString(string: text)
        let letterSpacing: CGFloat = 10.0
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: range)
        
        Activitylogo.attributedText = attributedString
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
  

    @IBAction func didTapMyButton(_ sender: Any) {
        let controller = NewController(nibName: "NewController", bundle: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func Accountlog(_ sender: Any) {
        let controller = Logopage(nibName: "Logopage", bundle: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
}
