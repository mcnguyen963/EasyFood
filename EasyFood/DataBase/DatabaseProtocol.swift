//
//  DatabaseProtocol.swift
//  EasyFood
//
//  Created by Nick Nguyen on 26/4/2024.
//
import Firebase
import FirebaseAuth
import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case team
    case heroes
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType { get set }
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func logIn(email: String, password: String)
    func logOut()
    func register(email: String, password: String)
    func getCurrentUser() -> FirebaseAuth.User
    func getAuth1() -> FirebaseAuth.Auth
    func isLogIn() -> Bool
}
