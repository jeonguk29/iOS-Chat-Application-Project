//
//  ViewController.swift
//  Messager
//
//  Created by 정정욱 on 2023/07/05.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {

    
    // MARK: - IBOutlets
    //labels
    
    @IBOutlet var emailLabelOutlet: UILabel!
    @IBOutlet var passwordLabelOutlet: UILabel!
    @IBOutlet var repeatLabelOutlet: UILabel!
    @IBOutlet var singUpLabel: UILabel!
    
    //textFields
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var repeatPasswordTextField: UITextField!
    //Buttons
    
    @IBOutlet var loginButtonOutlet: UIButton!
    @IBOutlet var signUpButtonOutlet: UIButton!
    @IBOutlet var resendEmailButtonOutlet: UIButton!
    
    
    //Views
    @IBOutlet var repeatPasswordLineView: UIView!
    // 로그인/회원가입에 따라 해당 뷰를 보여줄지 말지 정할 것임
    
    
    // MARK: - vars
    var isLogin = true
    
    
    // MARK: - View LiftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUIFor(login: true)
        setupTextFieldDelegates()
        setupBackgroundTap()
    }
    
    
    // MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: Any) {
        // case에 따라 텍스트 필드에 누락된 값이 없는지 확인하는 메서드
        if isDataInputedFor(type: isLogin ? "login" : "registration") {
            //login or register
            //print("로그인 또는 등록 버튼 눌린것을 확인")
            isLogin ? loginUser() : registerUser()
        } else {
            ProgressHUD.showFailed("ALL Fields are required")
            // 라이브러리 메서드 사용
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        // 비밀번호를 리셋
        if isDataInputedFor(type: "password") {
            //print("비밀번호를 잃어버림 버튼 눌린것을 확인")
            resetPassword()
        } else {
            ProgressHUD.showFailed("Email is required.")
        }
    }
    
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        // 확인 이메일을 보내겠다.
        if isDataInputedFor(type: "password") {
          //  print("확인 이메일 전송 버튼 눌린것을 확인")
            resendVerificationEmail()
        } else {
            ProgressHUD.showFailed("Email is required.")
        }
    }
    
    @IBAction func singUpButtonPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == "Login")
        // 위코드는 사용자가 로그인 모드에 있음을 의미하며, 그렇지 않으면 false를 전달
        isLogin.toggle()
    }
    
    
    // MARK: - Setup
    private func setupTextFieldDelegates() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //.addTarget(_:action:for:)은 UIControl 클래스의 메서드로, 컨트롤 이벤트가 발생했을 때 특정 액션을 실행할 수 있도록 타겟을 추가하는 역할을 합니다.
        
        /*
                 #selector 라는건 여기에 메모리 주소를 담아서 어떤 메서드를 가리킬 것인지 알려주는 것임
                 그리고 이기법은 오브젝트 c에서 사용하는 기법이라 해당 함수 앞에  @objc 키워드를 붙여줘야함
        */
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        //print("텍스트 필드가 변경 되었다")
        updatePlaceholderLabels(textField: textField)
    }
    
    
    // 앱 실행시 키보드가 올라오고 배경 선택시 키보드 내려가는 기능을 구현
    private func setupBackgroundTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap(){
        view.endEditing(false)  // 키보드를 호출한 모든 보기에 대해 키보드를 비활성화
    }
    
    
    
    // MARK: - Animations
    
    // 로그인 여부에 따라 다른 화면을 보여주기 위한 함수
    private func updateUIFor(login: Bool){
        loginButtonOutlet.setImage(UIImage(named: login ? "loginBtn" : "registerBtn"), for: .normal)
        signUpButtonOutlet.setTitle(login ? "SingUp" : "Login", for: .normal)
        singUpLabel.text = login ? "Don't have an account" : "Have an account?"
        
        UIView.animate(withDuration: 0.5) {
            self.repeatPasswordTextField.isHidden = login
            self.repeatLabelOutlet.isHidden = login
            self.repeatPasswordLineView.isHidden = login
        }
        
//        UIView.animate(withDuration: 0.5)는 0.5초 동안 애니메이션을 수행하도록 설정합니다. 이는 withDuration 매개변수에 애니메이션의 지속 시간을 초 단위로 전달하여 설정합니다.
//
//        중괄호 {} 내부에는 애니메이션 블록이 위치하며, 애니메이션 블록 내부에서는 애니메이션을 수행할 뷰들의 속성을 변경할 수 있습니다. 애니메이션 블록 내부에서 속성의 변경이 이루어지면, 애니메이션 시간 동안 해당 변경이 일어나게 됩니다. 뷰들이 부드럽게 숨기거나 보여지는 효과를 보이게 됩니다.
    }
    
    private func updatePlaceholderLabels(textField: UITextField) {
        switch textField {
        case emailTextField:
            emailLabelOutlet.text = textField.hasText ? "Email" : ""
        case passwordTextField:
            passwordLabelOutlet.text = textField.hasText ? "Password" : ""
        default:
            repeatLabelOutlet.text = textField.hasText ? "Repeat Password" : ""
        }
        //hasText 속성은 부울(Boolean) 값이며, true라면 텍스트 필드에 텍스트가 있음을 나타냄
        
    }
    
    
    
    // MARK: - Helpers
    
    // 사용자가 로그인, 등록, 비밀번호 분실 같은 상황에서 각각의 텍스트필드에 정상적인 값을 입력하는지 확인하기위한 메서드
    private func isDataInputedFor(type: String) -> Bool{
        
        switch type {
        case "login" :
            return emailTextField.text != "" && passwordTextField.text != ""
        case "registration" :
            return emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""
        default :
            return emailTextField.text != ""
        }
    }
    
    private func loginUser() {
        FirebaseUserListener.shared.loginUserWithEmail(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            
            if error == nil {
                if isEmailVerified { // 이메일이 확인 된 경우
                    print("user has logged in with email", User.currentUser?.email)
                    self.goToApp()
                } else {// 실패시
                    ProgressHUD.showFailed("Please verify email.")
                    self.resendEmailButtonOutlet.isHidden = false
                }
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
            
        }
    }

    private func registerUser() {
        
        if passwordTextField.text! == repeatPasswordTextField.text! {
            // 비밀번호, 비밀번호 확인이 일치하면 회원가입을 위해, 파이어베이스 등록을 위해 FirebaseUserListener를 사용
            FirebaseUserListener.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
                if error == nil {
                    ProgressHUD.showSuccess("Verification email sent.")
                    self.resendEmailButtonOutlet.isHidden = false
                    // 에러가 없다면 사용자에게 확인 메일을 보냈다고 전송, 가렸던 버튼도 보이게 만들기
                } else {
                    ProgressHUD.showFailed(error!.localizedDescription)
                }
            }
            
        } else {
            ProgressHUD.showFailed("The Passwords don't match")
        }
    }
    
    private func resetPassword() {
        FirebaseUserListener.shared.resetPasswordFor(email: emailTextField.text!) { (error) in
            
            if error == nil {
                ProgressHUD.showSuccess("Reset link sent to email.")
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    private func resendVerificationEmail() {
        FirebaseUserListener.shared.resendVerificationEmail(email: emailTextField.text!) { (error) in
            
            if error == nil {
                ProgressHUD.showSuccess("New verification email sent.")
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
                print(error!.localizedDescription)
            }
        }
    }
    
    
    
    
    // MARK: - Navigation
    private func goToApp(){
        //print("go to app")
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainView") as! UITabBarController
        
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
        // self는 현제 뷰컨을 말함 현제 뷰컨에서 present
        
/*
        위 코드는 앱 이용 중 로그인이 성공하고, 메인 화면으로 이동하는 코드입니다.
        `goToApp` 함수는 위 코드의 이름처럼 앱으로 진입하는 함수로, `private` 접근 제어자로 선언된 비공개 메서드입니다. 함수 내부에서는 `UIStoryboard`를 사용해서 `Main.storyboard`를 참조하고, "MainView"라는 identifier를 가진 `UITabBarController` 객체를 생성합니다.
        그리고, 이를 modal로 present하기 위해 `modalPresentationStyle` 속성을 `.fullScreen`으로 설정하고, `present(_:animated:completion:)` 메서드로 `mainView`를 present합니다. `animated`를 true로 설정하면, 화면 전환 시 애니메이션 효과가 적용됩니다.
        `present` 함수가 호출되는 시점에서 `self`는 로그인 화면에서 호출하는 경우가 많습니다. `present` 함수를 호출하면, 현재 뷰컨트롤러(`LoginViewController`)에서 `mainView`로 화면 전환이 일어나게 됩니다.
        즉, 이 함수는 로그인 이후, 메인 화면으로 들어가기 위해 `MainViewController` 객체를 생성하고 present함으로써, 화면을 전환하는 역할을 합니다.
 */
    }
        
}

