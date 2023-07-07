//
//  SceneDelegate.swift
//  Messager
//
//  Created by 정정욱 on 2023/07/05.
//

import UIKit
import FirebaseAuth
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var authListener: AuthStateDidChangeListenerHandle?
//    로그인한 로그인 사용자에 변경 사항이 있으면 계속 듣는 것입니다.
//AddStateDidChangeListener 메소드를 사용하여 Firebase 로그인 상태를 관리할 때 이 변수가 사용됩니다. 이 변수는 등록된 Firebase 로그인 이벤트 리스너를 추적합니다. 즉, 위 코드는 앱의 UIWindow 객체와 Firebase 로그인 상태 변경 이벤트를 추적하는 Firebase 리스너 이벤트 핸들러에 대한 옵셔널 변수를 선언하는 것입니다.


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // 이 메서드를 사용하여 UIWindow `window`를 제공된 UIWindowScene `scene`에 선택적으로 구성하고 연결합니다.
                 // 스토리보드를 사용하는 경우 `window` 속성이 자동으로 초기화되고 장면에 연결됩니다.
                 // 이 대리자는 연결 장면이나 세션이 새 것임을 의미하지 않습니다(대신 `application:configurationForConnectingSceneSession` 참조).
        
        autoLogin()
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
    //Firebase의 좋은 점은 변경 사항이 있으면 수신 대기하는 편리한 기능이 있다는 것입니다.
    //현재 사용자가 로그아웃했거나 변경된 사항이 있으면 항상 알림을 받습니다.
    //MARK: - Autologin
    func autoLogin() {
        
        authListener = Auth.auth().addStateDidChangeListener({ (auth, user) in
            // 인증자와 사용자 개체를 얻음
            //  이 메소드는 인증 상태가 변경되었을 때 호출되고, 인증자와 사용자의 정보를 가져옵니다.
            
            Auth.auth().removeStateDidChangeListener(self.authListener!)
            //  리스너 상태를 제거하고 리스너의 이름을 전달할 것입니다.
            // 만약 리스너를 꼭 제거하지 않는다면, 앱은 인증 정보를 관리하는 Firebase 서버와 계속적인 통신을 요청하게 됩니다. 그리고 이는 사용자나 앱에 불필요한 부하를 줍니다. 따라서, 사용자가 로그인하거나 상태가 변경된 경우, 이 메소드를 호출하여 해당 리스너를 제거합니다. 이를 통해 앱 성능을 최적화하고 Firebase Auth 인증과 관련된 오류를 줄일 수 있습니다.
            
            // 즉 인증된 사용자라면 정보를 가져오고 지속적인 통신을 중지
            
            // 사용자 기본값이 사용자이며, 로그인한 사용자 일때
            if user != nil && userDefaults.object(forKey: kCURRENTUSER) != nil {
                // 로그인 뷰가 아니라 애플리케이션 보기를 할 수 있음 
                DispatchQueue.main.async {
                    self.goToApp()
                }
            }
            //    사용자가 인증되고 기존에 저장된 사용자 정보가 있다면 (`user`와 `kCURRENTUSER`)`self.goToApp()` 메서드를 호출하여 자동으로 메인으로 이동하게 됩니다.
        })
    }


    
    private func goToApp() {
        
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "MainView") as! UITabBarController
        
        self.window?.rootViewController = mainView
        //window는 우리 응용프로그램이 얻는 첫 번째 창입니다. 처음 얻는 창에 루트뷰 컨트롤러 즉 진입점을
        /*
         `self.window?.rootViewController = mainView` 코드는 앱의 `UIWindow` 객체의 루트 뷰 컨트롤러를 설정하는 것입니다.

         `UIWindow` 객체는 앱의 모든 뷰 계층의 루트 역할을 하며, 모든 subview를 포함하는 컨테이너 역할을 합니다. `rootViewController`는 이 `UIWindow`에서 표시되어야 하는 첫 번째 뷰 컨트롤러입니다. 따라서 `rootViewController`의 설정은 앱의 시작점과도 같습니다.

         해당 코드에서는 `mainView` 매개변수를 통해 전달된 객체가 앱의 루트 뷰 컨트롤러로 설정됩니다. 이 프로퍼티에 대입하여, 해당 뷰 컨트롤러 객체가 앱의 기본 뷰와 함께 로드됩니다. 이렇게 함으로써 `mainView`가 앱에서 첫 번째 화면으로 표시될 수 있습니다.
         */
    }

 
}

