//
//  Translation.swift
//  TranslateMe
//
//  Created by Kiran Brahmatewari on 3/30/25.
//

import Foundation

struct TranslationResponse: Codable {
    let responseData: ResponseData
    
    struct ResponseData: Codable {
        let translatedText: String
    }
}

struct Translation: Hashable, Identifiable, Codable {
    let id: String
    let translatedText: String
}
