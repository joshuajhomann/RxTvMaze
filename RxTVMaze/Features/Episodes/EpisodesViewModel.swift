//
//  EpisodesViewModel.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/21/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import Foundation
import RxFlow
import RxSwift
import RxCocoa
import RxDataSources
import Action

class EpisodesViewModel: Stepper {
  typealias Output = (sections: Driver<[Section]>, loadingState: Driver<LoadingState>)
  typealias Section = AnimatableSectionModel<Int, EpisodeCellViewModel>
  let steps = PublishRelay<Step>()
  let tvService: TVServiceProtocol
  private let showId: Int

  init(tvService:TVServiceProtocol, showId: Int) {
    self.showId = showId
    self.tvService = tvService
  }
  
  func outputs(load: Observable<Void>, filter: Observable<String>) -> Output {
    let loadingStateRelay = BehaviorRelay<LoadingState>(value: .loaded)

    let allEpisodes = load
      .flatMapLatest { [tvService, showId] Void -> Observable<[Episode]> in
        loadingStateRelay.accept(.loading)
        return tvService
          .episodes(showId: showId)
          .catchError({error in
            loadingStateRelay.accept(.error)
            return .just([])
          })
          .asObservable()
      }

    let sections = Observable
      .combineLatest( allEpisodes, filter)
      .map { [weak steps] combined -> [Section] in
        let (episodes, term) = combined
        let filteredEpisodes = term.isEmpty
          ? episodes
          : episodes.filter { ($0.summary ?? "").contains(term) }
        let grouped = Dictionary(grouping: filteredEpisodes, by: { $0.season })
        let sections = grouped
          .keys
          .sorted()
          .compactMap { [weak steps]  sectionId -> Section in
            let viewModels = (grouped[sectionId] ?? []).map { [weak steps] episode -> EpisodeCellViewModel in
              let tapAction = CocoaAction { [weak steps]  in
                steps?.accept(SearchStep.showEpisodeDetail(episode: episode))
              }
              return EpisodeCellViewModel(episode: episode, tapAction: tapAction)
              }
            return Section(model: sectionId, items: viewModels)
          }
        if loadingStateRelay.value == .loading {
          loadingStateRelay.accept(sections.isEmpty ? .empty : .loaded)
        }
        return sections
      }
      .asDriver(onErrorJustReturn: [])

    return (sections: sections,
            loadingState: loadingStateRelay.asDriver().debug())
  }
}

struct EpisodeCellViewModel: Equatable, IdentifiableType, Stepper {
  var steps: PublishRelay<Step> = .init()
  typealias Output = (
    seasonText: String,
    titleText: String,
    detailText: String,
    imageUrl: URL?,
    tapAction: CocoaAction
  )
  let episode: Episode
  let tapAction: CocoaAction
  var identity: Int { episode.id }
  func outputs() -> Output {
    let seasonText = "Season \(episode.season) Episode \(episode.number)"
    let titleText = episode.name
    let detailText = (episode
      .summary ?? "")
      .replacingOccurrences(of: "<p>", with: "")
      .replacingOccurrences(of: "</p>", with: "")
    let imageUrl = episode.image?.medium
    return (seasonText, titleText, detailText, imageUrl, tapAction)
  }
  static func == (lhs: EpisodeCellViewModel, rhs: EpisodeCellViewModel) -> Bool {
    return lhs.episode.id == rhs.episode.id &&
      lhs.episode.name == rhs.episode.name &&
      lhs.episode.season == rhs.episode.season &&
      lhs.episode.url == rhs.episode.url &&
      lhs.episode.summary == rhs.episode.summary
  }
}
