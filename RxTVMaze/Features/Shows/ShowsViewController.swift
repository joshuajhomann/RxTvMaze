//
//  ShowsViewController.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/14/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ShowsViewController: UIViewController {
  @IBOutlet private var tableView: UITableView!
  @IBOutlet private var searchBar: UISearchBar!
  @IBOutlet private var loadingView: LoadingView!
  private let viewModel: ShowsViewModel
  private let disposeBag = DisposeBag()
  
  init(viewModel: ShowsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Shows"

    let term = searchBar
      .searchTextField
      .rx
      .value
      .orEmpty
      .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .asObservable()

    tableView.register(
      UINib(nibName: String(describing: ShowTableViewCell.self), bundle: nil),
      forCellReuseIdentifier: String(describing: ShowTableViewCell.self)
    )
    tableView.tableFooterView = UIView()

    let (cells, loadingState) = viewModel.outputs(searchTerm: term)

    cells
      .drive(tableView.rx.items(cellIdentifier: String(describing: ShowTableViewCell.self), cellType: ShowTableViewCell.self)) { (row, viewModel, cell) in
        cell.configure(viewModel: viewModel)
      }
      .disposed(by: disposeBag)

    loadingView.setup(
      contentView: tableView,
      loadingState: loadingState
    )

    tableView
      .rx
      .willBeginDragging
      .asDriver()
      .drive(onNext: { [view] Void in
        view?.endEditing(true)
      })
      .disposed(by: disposeBag)
  }
}

