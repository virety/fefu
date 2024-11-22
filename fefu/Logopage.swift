//
//  Logopage.swift
//  fefu
//
//  Created by Вадим Семибратов on 22.11.2024.
//

import UIKit

class Logopage: UIViewController {
    @IBOutlet weak var downlogo: UIImageView!
    @IBOutlet weak var avecyclist: UIImageView!
    @IBOutlet weak var toolbarRegistration: UIToolbar!
    override func viewDidLoad() {
        super.viewDidLoad()
        let toolbarHeight: CGFloat = 140.0
        var toolbarFrame = toolbarRegistration.frame
        toolbarFrame.size.height = toolbarHeight
        toolbarRegistration.frame = toolbarFrame
        toolbarRegistration.autoresizingMask = .flexibleWidth
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        super.viewDidLoad()
        downlogo.image = UIImage(named: "downlogo")
        avecyclist.image = UIImage(named: "fefucyclist")
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        let activityVC = MainActivityViewController(nibName: "MainActivityViewController", bundle: nil)
        self.navigationController?.pushViewController(activityVC, animated: true)
    }
}
