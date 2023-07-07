// FirebaseUserListener.swift 파일을 생성
// Messager 프로젝트
// 파일 생성일 2023/07/06

import Foundation
import Firebase // Firebase 라이브러리를 임포트합니다.

// FirebaseUserListener 클래스를 정의합니다.
// 이 클래스는 Firebase의 Authentication 기능을 사용하여 사용자 로그인 및 회원가입을 관리합니다.
class FirebaseUserListener{
    
    static let shared = FirebaseUserListener() // 싱글톤 인스턴스 생성 - 안정적으로 하나의 인스턴스만 생성해서 다른 곳에서 공유합니다.
    
    private init () {}
    
    // 회원 가입 기능을 영역
    // 이메일, 비밀번호를 전달받아 Firebase 회원가입을 처리하고 결과값을 completion으로 반환합니다.
    
    //MARK: - Login
    func loginUserWithEmail(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        // 사용자를 로그인할때도, 등록할때도  Auth.auth()를 사용할 것임
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if error == nil && authDataResult!.user.isEmailVerified {
                // 에러가 없고 확인된 이메일이라면
                FirebaseUserListener.shared.downloadUserFromFirebase(userId: authDataResult!.user.uid, email: email)
                // 로컬에 저장된걸 그대로 사용하지 않고 사용자가 로그인할 때마다 사용자 개체의 새 복사본을 갖게 되도록 다운로드
                
                completion(error, true)
            } else {
                print("email is not verified")
                completion(error, false)
            }
        }
    }
    
    //MARK: - Register
    func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        
        // Auth.auth().createUser를 사용하여 파이어베이스로 사용자 생성 요청을 보냅니다.
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            
            // 요청 완료 후 결과값을 반환합니다.
            completion(error)
            
            // 에러가 없는 경우에만 계속 진행합니다.
            if error == nil {
                
                // 회원 가입 완료된 사용자에게 이메일 인증 메일을 발송합니다.
                authDataResult!.user.sendEmailVerification { (error) in
                    print("auth email sent with error: ", error?.localizedDescription)
                }
                
                // 회원 가입 완료된 유저에 대한 정보를 저장합니다.
                if authDataResult?.user != nil {
                    
                    // User 객체를 생성합니다.
                    let user = User(id: authDataResult!.user.uid, userName: email, email: email, pushId: "", avaterLink: "", status: "Hey there I'm using Messager")
                    
                    // 로컬 데이터베이스에 저장할 구현이 필요한 함수
                    saveUserLocally(user)
                    
                    // Firestore에 생성된 사용자 정보를 저장합니다.
                    self.saveUserToFireStore(user)
                }
            }
        }
    }
    
    //MARK: - Resend link methods
    // 확인 이메일 다시 보내기
    // 처음 메일 보낸것과 마찮가지 이며 현재 사용자가 있는지 확인하고 로그인을 다시 로드 하고 보내면 됨
    func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            // 확인 이메일을 다시 보내기 위해서는 리로드 해야함
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                // 다시 보내고 에러가 있으면 아래 코드 실행
                completion(error)
            })
        })
    }
    
    
    // MARK: - Password Reset
    func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        // 이메일과 함께 전달 (비밀번호 재설정 링크를 이메일로 보냄)
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
    
    //MARK: - Save users
    func saveUserToFireStore(_ user: User) {
        
        do {
            try FirebaseReference(.User).document(user.id).setData(from: user)
            // 해당 테이블(컬력션)에 고유 사용자 id에 사용자 데이터를 저장
            // https://juzero-space.tistory.com/304 파이어베이스 collection, doc 기본 구조, 개념
        } catch {
            print(error.localizedDescription, "adding user")
        }
    }
    
    
    //MARK: - Download
    
    func downloadUserFromFirebase(userId: String, email: String? = nil) {
        
        // FCollectionReference 파일에서 만든 메서드임
        FirebaseReference(.User).document(userId).getDocument { (querySnapshot, error) in
            
            guard let document = querySnapshot else {
                print("no document for user")
                return
            }
            
            // 요청해서 가져오는 것은 JSON임 키, 값 딕셔너리 형태로 오기 때문에 파싱을 해줘야함
            let result = Result {
                try? document.data(as: User.self)
            }
            
            switch result {  // 성공적으로 파싱했다면, userObject에 할당하고 로컬에 저장합니다.
            case .success(let userObject):
                if let user = userObject {
                    saveUserLocally(user) // 변환 성공하면 로컬에 저장
                } else {
                    print(" Document does not exist")
                }
            case .failure(let error): // 실패시
                print("Error decoding user ", error)
            }
        }
    }
    /*
     이 코드는 Firebase의 Firestore에서 유저 정보를 다운로드하는 기능을 하는 메서드인 `downloadUserFromFirebase`입니다. 이 메서드는 유저 ID와 email(optional)을 받아서 해당 유저의 정보를 가져오고, 가져온 정보를 파싱하여 로컬에 저장하는 역할을 합니다.

     메서드 내부에서는 Firebase SDK에서 제공하는 `getDocument` 메서드를 사용해서 해당 유저의 Firestore Document를 가져옵니다. 가져온 Document는 try-catch 문법을 사용하여 파싱이 가능한 Result 형태로 변환합니다. 변환된 결과에 따라 성공시에는 해당 유저 정보를 로컬에 저장하고, 실패시에는 에러 메시지를 출력해줍니다.
     
     guard let document = querySnapshot else { ... } 구문을 통해 Firestore에서 가져온 DocumentSnapshot을 옵셔널 바인딩해서 document 변수에 할당하고, 이후에는 해당 document에서 해당 User 객체를 파싱해서 저장하고 있습니다.

     위 코드에서 내부에서 호출되는 `saveUserLocally` 함수는 로컬 디비에 유저 정보를 저장하는 메서드로, 이 부분은 코드상에 작성되어 있지 않은 것 같으니, 유저 정보를 로컬에 저장하는 방식은 다른 부분에서 구현된 것으로 추정됩니다.
     */

    
    
}
