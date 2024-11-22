//
//  NewController.swift
//  fefu
//
//  Created by Вадим Семибратов on 22.11.2024.
//

import UIKit

class NewController: UIViewController {

    @IBOutlet weak var toolbarRegistration: UIToolbar!
    override func viewDidLoad() {
        super.viewDidLoad()
        let toolbarHeight: CGFloat = 140.0
        var toolbarFrame = toolbarRegistration.frame
        toolbarFrame.size.height = toolbarHeight
        toolbarRegistration.frame = toolbarFrame
        toolbarRegistration.autoresizingMask = .flexibleWidth
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        downlogo.image = UIImage(named: "downlogo")
        let menu = UIMenu(title: "", children: [
            UIAction(title: "Мужчина", handler: { _ in self.updateGender("Мужчина") }),
            UIAction(title: "Женщина", handler: { _ in self.updateGender("Женщина") }),
        ])
        
        btn_select_gender.menu = menu
        btn_select_gender.showsMenuAsPrimaryAction = true
    }
    
    @IBOutlet weak var btn_select_gender: UIButton!
    @IBOutlet weak var downlogo: UIImageView!

    func updateGender(_ gender: String) {
        btn_select_gender.setTitle(gender, for: .normal)
    }
}
