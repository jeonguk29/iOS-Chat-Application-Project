//
//  FCollectionReference.swift
//  Messager
//
//  Created by 정정욱 on 2023/07/06.
//

import Foundation

// 파이어베이스의 컬렉션 즉 데이터베이스의 테이블의 알맞게 접근 하기 위한 로직 코드이다.
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Recent
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
    // 파이어베이스의 테이블을 하나 가져오는 것
    
    //    FirebaseReference 함수는 Firestore 객체를 사용하여 전달된 FCollectionReference값을 사용하여 해당 컬렉션에 대한 참조를 가져옵니다. 따라서 자신이 사용하고 싶은 Firestore 컬렉션 이름을 FirebaseReference의 파라미터로 넘기면 해당 컬렉션의 참조 (핸들)를 반환 받을 수 있습니다. 이렇게 받은 참조를 사용하여 Firestore 데이터베이스의 Collection에서 다양한 작업들(추가, 업데이트, 삭제, 조회 등)을 수행할 수 있습니다.
}
