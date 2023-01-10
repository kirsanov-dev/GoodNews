//
//  GoodNewsTableViewController.swift
//  GoodNews
//
//  Created by Oleg Kirsanov on 24.11.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class GoodNewsTableViewController: UITableViewController {

    let disposeBag = DisposeBag()

    private var articleListViewModel: ArticleListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        populateNews()
    }

    private func setupTableView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc func refreshTableView() {
        populateNews()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListViewModel == nil ? 0 : articleListViewModel.articleViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell else {
            fatalError("No such cell")
        }

        let articleVM = articleListViewModel.articleAt(indexPath.row)

        articleVM.title.asDriver(onErrorJustReturn: "")
            .drive(cell.titleLabel.rx.text)
            .disposed(by: disposeBag)

        articleVM.description.asDriver(onErrorJustReturn: "")
            .drive(cell.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        return cell
    }

    private func populateNews() {
        let base = "https://newsapi.org"
        let path = "/v2/everything"
        let parameters = "?q=apple&apiKey=a423628733044835985b7f17faa57a8c"
        let url = URL(string: base + path + parameters)!

        let resource = Resource<ArticlesList>(url: url)

        URLRequest.load(resource: resource)
            .subscribe(onNext: { [weak self] response in
                let articles = response?.articles
                if let articles = articles {
                    self?.articleListViewModel = ArticleListViewModel(articles)
                }
                DispatchQueue.main.async {
                    UIView.transition(
                        with: self?.tableView ?? UITableView(),
                        duration: 0.35,
                        options: .transitionCrossDissolve,
                        animations: {
                            self?.tableView.reloadData()
                        }
                    )

                    self?.refreshControl?.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
}
