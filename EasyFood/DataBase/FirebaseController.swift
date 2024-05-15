//
//  FirebaseController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 26/4/2024.
//

import Firebase
import FirebaseFirestoreSwift
import UIKit

class FirebaseController: NSObject, DatabaseProtocol {
    let DEFAULT_TEAM_NAME = "Default Team"
    var listeners = MulticastDelegate<DatabaseListener>()

    var authController: Auth
    var database: Firestore
    var heroesRef: CollectionReference?
    var teamsRef: CollectionReference?
    var currentUser: FirebaseAuth.User?

    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()

        super.init()
    }

    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
    }

    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }

    func cleanup() {}

    func logIn(email: String, password: String) {
        authController.signIn(withEmail: email, password: password)
        currentUser = authController.currentUser
    }

    func register(email: String, password: String) {
        do {
            authController.createUser(withEmail: email, password: password)

        } catch {
            fatalError("Firebase Authentication Failed with Error\(String(describing: error))")
        }
    }

    func logOut() {
        do {
            try authController.signOut()

        } catch {
            fatalError("Firebase Authentication Failed to log out")
        }
    }

    func getCurrentUser() -> FirebaseAuth.User {
        return authController.currentUser!
    }

    func getAuth1() -> FirebaseAuth.Auth {
        return authController
    }

    func isLogIn() -> Bool {
        if let user = authController.currentUser {
            if user != nil {
                return true
            }
        }
        return false
    }
}
