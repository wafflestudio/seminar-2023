//
//  UserInfoRepository.swift
//  Seminar0Solution
//
//  Created by user on 2023/09/23.
//

import Foundation

enum UserDefaultsKey: String {
    case userInfo
}

protocol UserInfoRepositoryProtocol {
    func getUserInfo() -> UserInfo?
    func setUserInfo(_ userInfo: UserInfo)
}

class UserInfoRepository: UserInfoRepositoryProtocol {
    let storage = UserDefaults.standard

    func getUserInfo() -> UserInfo? {
        guard let data = storage.data(forKey: UserDefaultsKey.userInfo.rawValue) else { return nil }

        let decoder = JSONDecoder()
        return try? decoder.decode(UserInfo.self, from: data)
    }

    func setUserInfo(_ userInfo: UserInfo) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(userInfo) {
            storage.set(encodedData, forKey: UserDefaultsKey.userInfo.rawValue)
        }
    }
}
