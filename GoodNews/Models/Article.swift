//
//  Article.swift
//  GoodNews
//
//  Created by Oleg Kirsanov on 24.11.2022.
//

import Foundation

struct ArticlesList: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String
    let description: String
}
