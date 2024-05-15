//
//  LogInViewController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 26/4/2024.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import UIKit

class LogInViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!

    @IBOutlet var passwordTextField: UITextField!
    weak var databaseController: DatabaseProtocol?
    let userDefault = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }

    @IBAction func signIn(_ sender: Any) {
        guard let userEmail = emailTextField.text, userEmail.isEmpty == false else {
            displayMessage(title: "Empty email addess ", message: "Please enter your email address")
            return
        }
        guard let userPassword = passwordTextField.text, userPassword.isEmpty == false else {
            displayMessage(title: "Empty password", message: "Please enter your password")
            return
        }
        databaseController?.getAuth1().signIn(withEmail: userEmail, password: userPassword) { _, Error in
            if Error != nil {
                self.displayMessage(title: "Error", message: Error.debugDescription.description)
            } else {
                self.toMainpage()
            }
        }
    }

    @IBAction func logOut(_ sender: Any) {
        databaseController?.logOut()
    }

    func toNewUser() {
        if databaseController?.getCurrentUser() != nil {
            performSegue(withIdentifier: "newAccrountSegue", sender: self)
        }
    }

    func toMainpage() {
        guard let currentUser = databaseController?.getCurrentUser() else {
            displayMessage(title: "Empty password", message: "Please enter your password")
            return
        }
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let secondVC = storyboard.instantiateViewController(identifier: "homeViewController")
//
//        show(secondVC, sender: nil)
        navigationItem.hidesBackButton = true

        performSegue(withIdentifier: "toMainSegue", sender: nil)
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
    @IBAction func forgotPassword(_ sender: Any) {
        performSegue(withIdentifier: "newAccrountSegue", sender: self)
    }
}
