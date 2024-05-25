//
//  TestViewController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 26/5/2024.
//

import UIKit

class TestViewController: UIViewController {
    @IBOutlet var butoonTes: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        butoonTes.setImage(UIImage(systemName: "heart.fill"), for: .normal)

        // Do any additional setup after loading the view.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
