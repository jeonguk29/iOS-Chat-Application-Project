//
//  SettingsTableViewController.swift
//  Messager
//
//  Created by David Kababyan on 20/08/2020.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    //MARK: - IBOutlets

    @IBOutlet var usernameLabel: UILabel!

    @IBOutlet var statusLabel: UILabel!
   
    @IBOutlet var avatarImageView: UIImageView!
    
    @IBOutlet var appVersionLabel: UILabel!
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showUserInfo() // 사용자 이미지등 사용자 정보를 화면이 보이기 전에 가져오기
        // 사용자가 이미지를 수정하면 새로고침해서 보이게 해줘야함
    }
    
    //MARK: - TableView Delegates
    // 섹션에 필요 없는 부분을 UIView 로 덮고 컬러 지정하여 없애기
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")

        return headerView
    }

    // 섹션간 간격 조절 0번째 섹션은 내비게이션 제목과 간격을 없애버리고 나머지 섹션간 10 간격
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // 0번째 섹션이라면 간격이 0.0 나머지 섹션 별 간격은 10.0
        return section == 0 ? 0.0 : 10.0
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        // 따라서 사용자가 셀을 선택할 때마다 해당 셀을 선택하려고 합니다. 즉 누르면 눌렀다는 것은 인식할 수 있게
        
        if indexPath.section == 0 && indexPath.row == 0 {
            //0섹션의 0로우면 세그위이를 타고 화면 전환
            performSegue(withIdentifier: "settingsToEditProfileSeg", sender: self)
        }
    }

    //MARK: - IBActions
    
    @IBAction func tellAFriendButtonPressed(_ sender: Any) {
        print("tell a friend")
    }
    
    @IBAction func termsAndConditionsButtonPressed(_ sender: Any) {
        print("show t&C")
    }
 
    
    // 로그아웃 기능 구현 
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        FirebaseUserListener.shared.logOutCurrentUser { (error) in

            if error == nil {
                // 로그아웃을 한다면 로그인 뷰를 보여주게 만들기
                let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
                // identifier를 이용하여 인스턴스를 생성하고 메인큐에서 화면 전환을 실행

                DispatchQueue.main.async {
                    loginView.modalPresentationStyle = .fullScreen
                    self.present(loginView, animated: true, completion: nil)
                }
            }
        }
    }
    
 
    
    
    //MARK: - UpdateUI
    private func showUserInfo() {
        
        if let user = User.currentUser {
            usernameLabel.text = user.userName
            statusLabel.text = user.status
            appVersionLabel.text = "App version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
            // 최상위 앱 정보를 담당하는 Messager에서 버전 정보를 가져옴 : 1.0 옵셔널로 나와서 as? String ?? ""
            // 다운 캐스팅
            
            if user.avatarLink != "" {
                // 다운로드 and 셋팅 아바타 이미지
//                FileStorage.downloadImage(imageUrl: user.avatarLink) { (avatarImage) in
//                    self.avatarImageView.image = avatarImage?.circleMasked
            }
        }
    }
    
}


