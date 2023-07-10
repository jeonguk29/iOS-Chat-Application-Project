//
//  EditProfileTableViewController.swift
//  Messager
//
//  Created by 정정욱 on 2023/07/10.
//

import UIKit


class EditProfileTableViewController: UITableViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    


    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        configureTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        showUserInfo() // SettingsTableViewController 와 똑같이 사용자 정보를 표시
    }


    //MARK: - TableviewDelegate
    // SettingsTableViewController 에서 복사한 코드 불필요한 제목 없애기
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 0.0 : 30.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        // 상태뷰 전환
        if indexPath.section == 1 && indexPath.row == 0 {
            performSegue(withIdentifier: "editProfileToStatusSeg", sender: self)
        }
    }
    
    //MARK: - IBActions
    @IBAction func editButtonPressed(_ sender: Any) {
      //  showImageGallery()
    }
    

    //MARK: - UpdateUI
    private func showUserInfo() {
        
        if let user = User.currentUser {
            usernameTextField.text = user.userName
            statusLabel.text = user.status
            
            if user.avatarLink != "" {
                // set 아바타
//                FileStorage.downloadImage(imageUrl: user.avatarLink) { (avatarImage) in
//                    self.avatarImageView.image = avatarImage?.circleMasked
//                }
            }
        }
    }
    
    
    
    
    //MARK: - Configure
    private func configureTextField() {
        usernameTextField.delegate = self
        usernameTextField.clearButtonMode = .whileEditing
    }


}


extension EditProfileTableViewController : UITextFieldDelegate {

    // 사용자가 UITextField의 Return 키를 눌렀을 때 호출되는 콜백 함수입니다. 이 메서드를 구현하면, 사용자가 Return 키를 누르면 실행되는 코드를 작성할 수 있습니다. 일반적으로, 이 메서드 내에서 다음 입력 필드로 포커스를 이동시키거나, 키보드를 숨기는 등의 동작을 수행합니다.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // usernameTextField 이랑 같다면
        if textField == usernameTextField {
            
            // 비어있지 않다면 즉 닉네임을 수정했다면
            if textField.text != "" {

                // 사용자 닉네임을 업데이트
                if var user = User.currentUser {
                    user.userName = textField.text!
                    saveUserLocally(user) // 로컬데이터 수정
                    FirebaseUserListener.shared.saveUserToFireStore(user) // 파이어베이스 수정
                }
            }

            textField.resignFirstResponder() // 키보드를 반환 (응답 객체 사임)
            return false // 왜? false 아래는 true?
        }

        return true // 돌아가라
    }
}

