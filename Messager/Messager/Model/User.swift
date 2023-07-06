//
//  User.swift
//  Messager
//
//  Created by 정정욱 on 2023/07/06.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

// User 모델은 Codable 프로토콜을 채택하였으므로, JSON 데이터와 User 객체 간의 상호 변환이 가능합니다. Firebase에서 데이터를 가져오거나 저장할 때 유용합니다.
struct User: Codable, Equatable {
    var id = ""             // 사용자 고유 ID
    var userName: String    // 사용자 이름
    var email: String       // 사용자 이메일
    var pushId = ""         // 사용자 push id(알림)
    var avaterLink = ""     // 사용자 아바타 링크
    var status: String      // 사용자 상태
    
    static var currentID: String { //현재 로그인한 사용자의 UID를 반환하는 연산 프로퍼티입니다.
        return Auth.auth().currentUser!.uid
        // 현재 인증된 사용자를 가져온 후, uid 속성을 통해 사용자의 고유 식별자를 가져옵니다.
    }
    
    // 사용자가 없을 수도 있으니 옵셔널로 지정
    // 현재 로그인한 사용자를 나타내는 User 객체를 반환하는 연산 프로퍼티입니다.
    static var currentUser: User? {
        if Auth.auth().currentUser != nil {
            // 사용자가 로그인 할때마다 키 값 사전을 만들 것임
            if let dictionary = UserDefaults.standard.data(forKey: kCURRENTUSER){
                // 따라서 인증된 현재 사용자가 있고 사용자 기본값에 저장된 항목이 있는 경우 kCURRENTUSER 를 키 값으로 사용하여 값을 가져옴
                let decoder = JSONDecoder()
                do {
                    let userObject = try decoder.decode(User.self, from: dictionary)
                    return userObject
                } catch {
                    print("Error decoding user from user defaults", error.localizedDescription)
                }
            }
        }
        return nil
    }
    
    static func == (lhs:User, rhs: User) -> Bool {
        lhs.id == rhs.id
        // 왼쪽 오른쪽 유저 객체가 동등한 id를 가지고 있으면 내 애플리케이션을 실행 시키겠다.
//        그래서 우리는 이러한 모든 매개변수를 사용하여 사용자 객체를 생성하고 몇 가지 도우미 변수도 생성했습니다.
//        현재 ID 또는 현재 사용자를 가져올 것입니다.
//        그리고 이 사용자를 기반으로 등록 또는 인증을 위해 Firebase와 통신할 수 있습니다.
//        사용자는 사용자로 로그인하고 이 사용자를 FIREBASE 데이터베이스에 저장합니다.
    }
}
