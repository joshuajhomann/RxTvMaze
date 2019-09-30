//
//  EpisodesViewController.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/21/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class EpisodesViewController: UIViewController {
  typealias DataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<Int,EpisodeCellViewModel>>
  @IBOutlet private var searchBar: UISearchBar!
  @IBOutlet private var collectionView: UICollectionView!
  @IBOutlet private var loadingView: LoadingView!
  private let viewModel: EpisodesViewModel
  private let disposeBag = DisposeBag()
  private var dataSource: DataSource?
  init(viewModel: EpisodesViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Episodes"
    let refreshControl = UIRefreshControl()
    refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
    collectionView.refreshControl = refreshControl
    //collectionView.collectionViewLayout = createLayout()
    collectionView.register(UINib(nibName: String(describing: EpisodeCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: EpisodeCollectionViewCell.self))

    let load =  refreshControl
      .rx
      .controlEvent(.valueChanged)
      .map { _ in () }
      .startWith(())
      .asObservable()

    let dataSource = DataSource(configureCell: { _, collectionView, indexPath, viewModel in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: EpisodeCollectionViewCell.self), for: indexPath)
      (cell as? EpisodeCollectionViewCell)?.configure(with: viewModel)
      return cell
    })

    self.dataSource = dataSource

    let filter = searchBar
      .searchTextField
      .rx
      .value
      .orEmpty
      .debounce(.microseconds(250), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .asObservable()

    let outputs = viewModel.outputs(load: load, filter: filter)

    collectionView.backgroundView = loadingView

    loadingView.setup(
      loadingState: outputs.loadingState
    )
    
    outputs
      .loadingState
      .map { $0 == .loading }
      .drive(refreshControl.rx.isRefreshing)
      .disposed(by: disposeBag)

    outputs
      .sections
      .drive(collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

  }

  private func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout {
      (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

      let leadingItem = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalHeight(1.0)))
      leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75),
                                           heightDimension: .fractionalHeight(0.40)),
        subitems: [leadingItem])
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuous

      return section
    }
    return layout
  }
}
