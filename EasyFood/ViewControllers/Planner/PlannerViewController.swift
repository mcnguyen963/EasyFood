//
//  PlannerViewController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 5/6/2024.
//

import UIKit

class PlannerViewController: UIViewController {
    @IBOutlet var PlannedMealView: UIView!

    @IBOutlet var ShoppingChecklistView: UIView!
    var selectedId: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        PlannedMealView.alpha = 0
        ShoppingChecklistView.alpha = 1
    }

    @IBAction func switchView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            PlannedMealView.reloadInputViews()
            PlannedMealView.alpha = 1
            ShoppingChecklistView.alpha = 0
        } else {
            PlannedMealView.reloadInputViews()

            PlannedMealView.alpha = 0
            ShoppingChecklistView.alpha = 1
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
