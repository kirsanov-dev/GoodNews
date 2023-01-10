//
//  ArticleViewModel.swift
//  GoodNews
//
//  Created by Oleg Kirsanov on 10.01.2023.
//

import Foundation
import RxSwift
import RxCocoa

struct ArticleListViewModel {
    let articleViewModels: [ArticleViewModel]
}

extension ArticleListViewModel {
    init(_ articles: [Article]) {
        articleViewModels = articles.compactMap(ArticleViewModel.init)
    }
}

extension ArticleListViewModel {
    func articleAt(_ index: Int) -> ArticleViewModel {
        return articleViewModels[index]
    }
}

struct ArticleViewModel {
    let article: Article

    init(_ article: Article) {
        self.article = article
    }
}

extension ArticleViewModel {
    var title: Observable<String> {
        return Observable.just(article.title)
    }

    var description: Observable<String> {
        return Observable.just(article.description)
    }
}
