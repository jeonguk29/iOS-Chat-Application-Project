//
//  Constants.swift
//  Messager
//
//  Created by 정정욱 on 2023/07/06.
//

import Foundation

let userDefaults = UserDefaults.standard
/*
 `UserDefaults`는 간단한 값을 사용하려는 경우에 인기있는 데이터 저장 방식 중 하나입니다. 있는 데이터를 키-값 쌍으로 저장할 수 있습니다. 클라이언트 측에서 로컬에 간단한 설정 값을 저장할 필요가 있는 경우 자주 사용됩니다.

 `UserDefaults.standard`는 기본 UserDefaults 객체에 대한 참조를 반환합니다. 이 객체는 사용자의 기본 설정 데이터에 액세스하고 사용자 정의 설정 값을 저장할 수있는 객체입니다. 앱 내에서 사용자의 기본 설정 및 사용자 지정 설정을 저장하고 읽어 올 수 있습니다.

 해당 코드는 UserDefaults 클래스의 standard 프로퍼티를 사용하여 앱의 기본 UserDefaults 객체에 대한 참조를 만들고 있습니다. 이 참조를 사용하여 앱의 로컬 저장소에 데이터를 쓰거나 읽어 올 수 있습니다.
 */
public let kCURRENTUSER = "currentUser"
public let kFILEREFERENCE = "gs://messanger-32fda.appspot.com"
// 파이어베이스 Storage의 root경로
