//
//  EditProfileTableViewController.swift
//  Messager
//
//  Created by 정정욱 on 2023/07/10.
//

import UIKit
import Gallery
import ProgressHUD


class EditProfileTableViewController: UITableViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    //MARK: - Vars
    var gallery: GalleryController!

    
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
        showImageGallery() // 이미지 수정 버튼 누르면 갤러리 구현
    }
    

    //MARK: - UpdateUI
    private func showUserInfo() {
        
        if let user = User.currentUser {
            usernameTextField.text = user.userName
            statusLabel.text = user.status
            
            if user.avatarLink != "" {
                //   set 아바타
                FileStorage.downloadImage(imageUrl: user.avatarLink) { (avatarImage) in
                    self.avatarImageView.image = avatarImage
                }
            }
        }
    }
    
    
    
    
    //MARK: - Configure
    private func configureTextField() {
        usernameTextField.delegate = self
        usernameTextField.clearButtonMode = .whileEditing
    }
    
    //MARK: - Gallery
    private func showImageGallery() {
        // 갤러리를 보여주는 방법
        self.gallery = GalleryController() // 1.갤러리 초기화
        self.gallery.delegate = self // 2. 해당 뷰컨은 이미지 갤러리의 대리자로 설정
        
        Config.tabsToShow = [.imageTab, .cameraTab] // 3. 갤러리 설정 앨범 목록 탭, 사진 찍는 탭
        Config.Camera.imageLimit = 1 // 4. 최대 이미지 선택 개수 1개
        Config.initialTab = .imageTab // 초기 탭을 결정하는데 사용됩니다. 이 값을 .imageTab으로 설정하면, 애플리케이션 실행 시 초기 탭이 이미지 탭으로 설정됩니다.
        
        self.present(gallery, animated: true, completion: nil) //5. 갤러리 이동
    }
    
    //MARK: - UploadImages
    private func uploadAvatarImage(_ image: UIImage) {
        
        let fileDirectory = "Avatars/" + "_\(User.currentID)" + ".jpg"
        
        FileStorage.uploadImage(image, directory: fileDirectory) { (avatarLink) in
            
            if var user = User.currentUser {
                user.avatarLink = avatarLink ?? ""
                saveUserLocally(user)
                FirebaseUserListener.shared.saveUserToFireStore(user)
            }
            // 로컬에도 아바타 이미지 조저장
            // 이렇게 하는 이유는 이렇게 하면 이미지에 훨씬 빠르게 액세스할 수 있기 때문입니다.
            FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 1.0)! as NSData, fileName: User.currentID)
        }
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


// 아래와 같은 코드가 실행되려면 사용자에게 허가를 받아야함
extension EditProfileTableViewController : GalleryControllerDelegate {
    
    // 사용자가 여러 이미지, 이미지 배열을 선택했을 때 알려줍니다.
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            //resolve는 비동기 적으로 UI이미지로 변환해줌
            images.first!.resolve { (avatarImage) in
                // 변환된 UI이미지 avatarImage 를 파이어베이스에 업로드 할 것임
                
                if avatarImage != nil {
                    self.uploadAvatarImage(avatarImage!) // 그전에 이미지 업로드 한걸 화면에 보여주기
                    self.avatarImageView.image = avatarImage
                } else {
                    ProgressHUD.showError("Couldn't select image!")
                }
            }
        }
        
        controller.dismiss(animated: true, completion: nil) // 사용자가 선택할때마다 그냥 무시합니다?
    }
    
    // 사용자가 비디오를 클릭했을때
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    

    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
        //이 메서드는 GalleryController에서 이미지 선택을 마치고 Lightbox 모드로 변경할 때 호출됩니다. 메서드 내부에서는, GalleryController를 Lightbox 모드로 변경하는 것을 담당하는 dismiss(animated:completion:) 메서드를 호출하고 있습니다. 이후, 선택한 이미지를 뷰어로 보여주기 위해 Lightbox 모드로 전환됩니다.
    }
    
    // 사용자가 취소 했을때 : 갤러리를 닫을 것임
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
