//
//  Extensions.swift
//  Messager
//
//  Created by 정정욱 on 2023/07/11.
//

import UIKit
// 사용자 프로필 이미지의 라운드를 주기 위한 파일


extension UIImage {
    
    var isPortrait: Bool { return size.height > size.width }
    var isLandscape: Bool { return size.width > size.height }
    var breadth: CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect { return CGRect(origin: .zero, size: breadthSize) }
    
    var circleMasked: UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
/*
 이 코드는 이미지를 원형으로 만들어주는 코드예요. 주석을 한 줄씩 상세하게 적어드릴게요.

 1. import UIKit: 디자인 관련 기능을 사용하기 위해 UIKit을 불러옵니다.

 2. extension UIImage: 이미지를 원형으로 만드는 함수를 추가하기 위해, 이미지 관련 기능을 확장합니다.

 3. var isPortrait: 이미지가 세로가 긴 경우인지 확인하는 변수(참이면 세로가 길고, 거짓이면 가로가 길어요).

 4. var isLandscape: 이미지가 가로가 긴 경우인지 확인하는 변수(참이면 가로가 길고, 거짓이면 세로가 길어요).

 5. var breadth: 이미지의 가로와 세로 중 작은 값을 가져오는 변수(원형으로 만들기 위해 작은 쪽을 기준으로 잡아야 해요).

 6. var breadthSize: 이미지의 가로와 세로 크기 중 작은 쪽의 크기를 가져옵니다(가로=세로로 설정됩니다).

 7. var breadthRect: 작은 크기를 기준으로 한 정사각형 모양의 위치와 크기를 설정합니다.

 8. var circleMasked: 이미지를 원형으로 만들어주는 함수 입니다.
    - 가로와 세로 중 작은 쪽을 기준으로 이미지를 자릅니다.
    - 이미지에 원형의 경로를 설정하여 클립(잘라내기)합니다.
    - 잘라낸 이미지를 그립니다.
    - 완성된 원형 이미지를 반환합니다.
 */
