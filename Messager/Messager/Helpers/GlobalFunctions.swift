//
//  GlobalFunctions.swift
//  Messager
//
//  Created by 정정욱 on 2023/07/11.
//

import Foundation
import UIKit
import AVFoundation


// 요청 URL에서 사용자 이름, JPG 확장자를 분리 
func fileNameFrom(fileUrl: String) -> String {
    return ((fileUrl.components(separatedBy: "_").last)!.components(separatedBy: "?").first!).components(separatedBy: ".").first!
}
