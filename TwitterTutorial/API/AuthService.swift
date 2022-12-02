//
//  AuthService.swift
//  TwitterTutorial
//
//  Created by Apple on 26.07.2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping (Error?, DatabaseReference) -> Void) {
        let email = credentials.email
        let password = credentials.password
        let username = credentials.username
        let fullname = credentials.fullname
        
        uploadProfileImage(profileImage: credentials.profileImage) { profileImageUrl in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    print("DEBUG: Error is: \(error.localizedDescription)")
                    return
                }
                guard let uid = result?.user.uid else { return }
                
                let values = ["email": email,
                              "username": username,
                              "fullname": fullname,
                              "profileImageUrl": profileImageUrl]
                
                REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
            }
        }
    }
    
    
    private func uploadProfileImage(profileImage: UIImage, completion: @escaping (String) -> Void) {
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = UUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        storageRef.putData(imageData) { meta, error in
            storageRef.downloadURL { url, error in
                guard let profileUrl = url?.absoluteString else { return }
                completion(profileUrl)
            }
        }
    }
}
