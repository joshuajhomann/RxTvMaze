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
  let steps = PublishRelay<Step>()
  @TVServiceInjected var tvService: TVServiceProtocol
  func outputs(searchTerm: Observable<String>) -> Driver<[ShowCellViewModel]> {
    searchTerm.flatMapLatest { [tvService, weak steps] term -> Observable<[ShowCellViewModel]> in
      guard !term.isEmpty else {
        return .just([])
      }
      return tvService
        .search(query: term)
        .map { [weak steps] shows in
          shows.map { [weak steps] show in
            let tapAction = CocoaAction { [weak steps] in
              steps?.accept(SearchStep.showEpisodes(showId: show.id))
            }
            return ShowCellViewModel(show: show, tapAction: tapAction)
          }
        }
      .asObservable()
    }.asDriver(onErrorJustReturn: [])
  }
}
