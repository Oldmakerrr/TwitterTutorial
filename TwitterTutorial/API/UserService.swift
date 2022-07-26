//
//  UserService.swift
//  TwitterTutorial
//
//  Created by Apple on 26.07.2022.
//

import FirebaseAuth
import FirebaseDatabase

struct UserService {
    
    static let shared = UserService()
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
    
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            do {
                let user = try User(uid: uid, dictionary: dictionary)
            } catch {
                print("DEBUG: Error to create user")
            }
        }
    }
}
