//
//  ViewController.swift
//  Messager
//
//  Created by 정정욱 on 2023/07/05.
//

import UIKit

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
    
    
    
    
    // MARK: - View LiftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldDelegates()
    }
    
    
    // MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: Any) {
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
    }
    
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
    }
    
    @IBAction func singUpButtonPressed(_ sender: Any) {
    }
    
    
    // MARK: - Setup
    private func setupTextFieldDelegates() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        //print("텍스트 필드가 변경 되었다")
        updatePlaceholderLabels(textField: textField)
    }
    
    
    // MARK: - Animations
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
}

