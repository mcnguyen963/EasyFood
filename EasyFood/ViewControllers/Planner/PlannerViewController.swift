//
//  PlannerViewController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 5/6/2024.
//

import UIKit

class PlannerViewController: UIViewController {
    @IBOutlet var IngredientsView: UIView!

    @IBOutlet var MealsView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        IngredientsView.alpha = 1
        MealsView.alpha = 0
        // Do any additional setup after loading the view.
    }

    @IBAction func switchView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            IngredientsView.reloadInputViews()
            IngredientsView.alpha = 1
            MealsView.alpha = 0
        } else {
            IngredientsView.reloadInputViews()

            IngredientsView.alpha = 0
            MealsView.alpha = 1
        }
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
