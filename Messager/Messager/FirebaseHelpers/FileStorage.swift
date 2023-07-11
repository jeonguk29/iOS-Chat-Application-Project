//
//  FileStorage.swift
//  Messager
//
//  Created by 정정욱 on 2023/07/11.
//

import Foundation
import FirebaseStorage // 여기서 이미지를 업로드 할 것임
import ProgressHUD

let storage = Storage.storage()

class FileStorage {
    /*
     Firebase 저장소의 이미지이므로 이미지를 업로드하면 firebase가 있는 링크를 얻게 됩니다.
     우리를 위해 이미지를 저장했으며 링크를 저장하겠습니다.
     해당 이미지에 액세스하여 다운로드하려는 경우 해당 링크를 사용하여 이동합니다.
     */
    //MARK: - Images
    
    // 이미지와 파이어베이스 저장 경로를 전달 받음
    class func uploadImage(_ image: UIImage, directory: String, completion: @escaping (_ documentLink: String?) -> Void) {
        
        // completion 즉 아래 코드에서는 이미지가 업로드 되면 알람을 받기위한 코드임
        // 우리가 받고 싶은것은 이미지를 저장한 링크임
        let storageRef = storage.reference(forURL: kFILEREFERENCE).child(directory)
        // Storage를 엑세스
        
        // UI 이미지를 데이터로 변환하려고 합니다. 파이어베이스에 UIImage자체를 저장 할 수 없음
        let imageData = image.jpegData(compressionQuality: 0.6) // 압축 값을 던져줌
        
        var task: StorageUploadTask!
        
        task = storageRef.putData(imageData!, metadata: nil, completion: { (metadata, error) in
            
            task.removeAllObservers() // 업로드하자마자 알림을 받지 않도록 모든 관찰자를 제거하는 작업을 말할 것입니다.
            ProgressHUD.dismiss()
            
            if error != nil {
                print("error uploading image \(error!.localizedDescription)")
                return
            }
            
            // 오류가 없다면
            storageRef.downloadURL { (url, error) in
                
                guard let downloadUrl = url  else {
                    completion(nil)
                    return
                } // 다운로드가 없다면 기능을 종료
                
                completion(downloadUrl.absoluteString)
                // 절대 문자열이 아니므로 파일이 저장된 링크를 제공
            }
        })
        
        
        // 파일이 업로드 되는 비율을 표시하기 위한 코드
        task.observe(StorageTaskStatus.progress) { (snapshot) in
            
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        }
        /*
         이것이 우리가 호출하는 관찰자입니다.
         그리고 여기에서 이 관찰자가 더 이상 필요하지 않으면 모든 관찰자를 제거하도록 요청한 다음
         업로드 한 파일의 양을 보여줌.
         */
    }
    

    class func downloadImage(imageUrl: String, completion: @escaping (_ image: UIImage?) -> Void) {
        
        // 먼저 imageUrl를 확인해야함
        let imageFileName = fileNameFrom(fileUrl: imageUrl)
        
        // 로컬 디렉에 존재하지 않는 경우에만 다운로드
        if fileExistsAtPath(path: imageFileName) {
            //get it locally
//            print("We have local image")

            if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(fileName: imageFileName)) {

                completion(contentsOfFile)
            } else {
                print("couldnt convert local image")
                completion(UIImage(named: "avatar"))
            }

        } else {
            //download from FB
//            print("Lets get from FB")

            if imageUrl != "" {
                /*
                 Firebrace에서 다운로드하기 전에 내 사용자가 빈 문자열인지 확인하고 싶습니다.
                 그래서 당신이 아픈 이미지가 빈 문자열과 같지 않다면 그것은 우리가 어떤 종류의 링크를 가지고 있다는 것을 의미합니다.
                 거기에서 콘텐츠를 계속 다운로드할 수 있습니다.
                 */

                let documentUrl = URL(string: imageUrl)

                let downloadQueue = DispatchQueue(label: "imageDownloadQueue")

                downloadQueue.async {

                    let data = NSData(contentsOf: documentUrl!)

                    if data != nil {

                        //Save locally
                        FileStorage.saveFileLocally(fileData: data!, fileName: imageFileName)

                        DispatchQueue.main.async {
                            completion(UIImage(data: data! as Data))
                        }

                    } else {
                        print("no document in database")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    

    
    //MARK: - Save Locally
    class func saveFileLocally(fileData: NSData, fileName: String) {
        // 성공하면 이전파일을 대체 
        let docUrl = getDocumentsURL().appendingPathComponent(fileName, isDirectory: false)
        fileData.write(to: docUrl, atomically: true)
    }

    
}



//Helpers

// 그리고 여기에 세 가지 함수가 있을 것입니다. 그 중 두 가지는 파일 디렉토리가 있는 위치를 반환할 것입니다.
// 세 번째 기능은 다운로드하기 전에 파일이 존재하는지 확인합니다.
func fileInDocumentsDirectory(fileName: String) -> String {
    return getDocumentsURL().appendingPathComponent(fileName).path
}

func getDocumentsURL() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    // 배열을 반환함
}

func fileExistsAtPath(path: String) -> Bool {
    // 마지막으로 해당 이름을 가진 파일이 있는지 여부를 알려줍니다.
    return FileManager.default.fileExists(atPath: fileInDocumentsDirectory(fileName: path))
}
