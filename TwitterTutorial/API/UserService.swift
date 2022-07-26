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
    
    func fetchUser(completion: @escaping (User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
    
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            do {
                let user = try User(uid: uid, dictionary: dictionary)
                completion(user)
            } catch {
                print("DEBUG: Error to create user")
            }
        }
    }
}
