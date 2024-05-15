//
//  RegisterViewController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 26/4/2024.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!

    @IBOutlet var passwordTextField: UITextField!

    @IBOutlet var rePasswordTextField: UITextField!
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
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
    @IBAction func onSubmit(_ sender: Any) {
        guard let userEmail = emailTextField.text, userEmail.isEmpty == false else {
            displayMessage(title: "Empty email addess ", message: "Please enter your email address")
            return
        }
        guard let userPassword = passwordTextField.text, userPassword.isEmpty == false else {
            displayMessage(title: "Empty password", message: "Please enter your password")
            return
        }
        guard let reUserPassword = rePasswordTextField.text, reUserPassword.isEmpty == false else {
            displayMessage(title: "Empty re-password", message: "Please re-enter your password")
            return
        }
        if reUserPassword != userPassword {
            displayMessage(title: "Password not match", message: "Please Re-enter your password")
        }

        do {
            try databaseController?.register(email: userEmail, password: userPassword)
            displayMessage(title: "Successfull", message: "Your Account has been Create")
        }
        catch {
            displayMessage(title: "error", message: "error")
        }
    }
}

extension UIViewController {
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
                                                handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
