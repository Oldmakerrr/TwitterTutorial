//
//  UserService.swift
//  TwitterTutorial
//
//  Created by Apple on 26.07.2022.
//

import FirebaseAuth
import FirebaseDatabase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping (User) -> Void) {    
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
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let uid = snapshot.key
            do {
                let user = try User(uid: uid, dictionary: dictionary)
                users.append(user)
                completion(users)
            } catch {
                print("DEBUG: Error to create user")
            }
        }
    }

    func followUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { error, reference in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }

    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_USER_FOLLOWING.child(currentUid).removeValue { error, reference in
            REF_USER_FOLLOWERS.child(uid).removeValue(completionBlock: completion)
        }

    }

    func checkIfUserIsFollowed(uid: String, complition: @escaping (Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            complition(snapshot.exists())
        }
    }

    func fetchUserStats(uid: String, completion: @escaping (UserRelationStats) -> Void) {
        var followers: Int?
        var following: Int?
        let dispatchGroup = DispatchGroup()
        DispatchQueue.global().async(group: dispatchGroup) {
            dispatchGroup.enter()
            REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
                followers = snapshot.children.allObjects.count
                dispatchGroup.leave()
            }
            dispatchGroup.enter()
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                following = snapshot.children.allObjects.count
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            guard let followers = followers, let following = following else { return }
            let stats = UserRelationStats(followers: followers, following: following)
            completion(stats)
        }
    }

    func updateProfileImage(image: UIImage?, completion: @escaping(URL) -> Void) {
        guard let image = image,
              let imageData = image.jpegData(compressionQuality: 0.3),
              let uid = Auth.auth().currentUser?.uid else { return }
        let filename = UUID().uuidString
        let reference = STORAGE_PROFILE_IMAGES.child(filename)

        reference.putData(imageData) { metadata, error in
            reference.downloadURL { url, error in
                guard let url = url else { return }
                let profileImageUrl = url.absoluteString
                let values = ["profileImageUrl":profileImageUrl]
                REF_USERS.child(uid).updateChildValues(values) { error, reference in
                    completion(url)
                }
            }
        }
    }

    func saveUserData(user: User, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = ["fullname":user.fullname,
                      "username":user.username,
                      "bio": user.bio ?? ""]
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }

    func fetchUser(withUsername username: String, completion: @escaping(User) -> Void) {
        REF_USER_USERNAMES.child(username).observeSingleEvent(of: .value) { snapshot in
            guard let uid = snapshot.value as? String else { return }
            self.fetchUser(uid: uid, completion: completion)
        }
    }
}


