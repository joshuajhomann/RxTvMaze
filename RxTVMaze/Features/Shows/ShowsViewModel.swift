//
//  ShowViewModel.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/21/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import Foundation
import RxFlow
import RxSwift
import RxCocoa
import Action

class ShowsViewModel: Stepper {
  typealias Output = (cellViewModels: Driver<[ShowCellViewModel]>, loadingState: Driver<LoadingState>)
  let steps = PublishRelay<Step>()
  let tvService: TVServiceProtocol
  
  init(tvService: TVServiceProtocol) {
    self.tvService = tvService
  }

  func outputs(searchTerm: Observable<String>) -> Output {
    let loadingStateRelay = BehaviorRelay<LoadingState>(value: .loaded)

    let cells = searchTerm.flatMapLatest { [tvService, weak steps] term -> Observable<[ShowCellViewModel]> in
      guard !term.isEmpty else {
        loadingStateRelay.accept(.loaded)
        return .just([])
      }
      loadingStateRelay.accept(.loading)
      return tvService
        .search(query: term)
        .catchError { error in
          loadingStateRelay.accept(.error)
          return .just([])
        }
        .map { [weak steps] shows -> [ShowCellViewModel] in
          let viewModels = shows.map { [weak steps] show -> ShowCellViewModel in
            let tapAction = CocoaAction { [weak steps] in
              steps?.accept(SearchStep.showEpisodes(showId: show.id))
            }
            return ShowCellViewModel(show: show, tapAction: tapAction)
          }
          loadingStateRelay.accept(viewModels.isEmpty ? .empty : .loaded)
          return viewModels
        }
        .asObservable()
    }

    return (cellViewModels: cells.asDriver(onErrorJustReturn: []),
            loadingState: loadingStateRelay.asDriver())
  }
}
