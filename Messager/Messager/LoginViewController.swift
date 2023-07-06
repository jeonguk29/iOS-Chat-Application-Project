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
            print("로그인 또는 등록 버튼 눌린것을 확인")
        } else {
            ProgressHUD.showFailed("ALL Fields are required")
            // 라이브러리 메서드 사용
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        // 비밀번호를 리셋
        if isDataInputedFor(type: "password") {
            print("비밀번호를 잃어버림 버튼 눌린것을 확인")
        } else {
            ProgressHUD.showFailed("Email is required.")
        }
    }
    
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        // 확인 이메일을 보내겠다.
        if isDataInputedFor(type: "password") {
            print("확인 이메일 전송 버튼 눌린것을 확인")
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
}

