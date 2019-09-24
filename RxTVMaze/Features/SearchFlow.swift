//
//  SearchFlow.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/14/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import UIKit
import RxSwift
import RxFlow

enum SearchStep: Step {
  case showSearch
  case showEpisodes(showId: Int)
  case showEpisodeDetail(episode: Episode)
}

class SearchFlow: Flow {
  var root: Presentable {
    return navigationController
  }

  private let navigationController = UINavigationController()

  func navigate(to step: Step) -> FlowContributors {
    switch step as? SearchStep {
    case .showSearch:
      let viewModel = ShowsViewModel()
      let viewController = ShowsViewController(viewModel: viewModel)
      navigationController.pushViewController(viewController, animated: false)
      return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    case .showEpisodes(let showId):
      let viewModel = EpisodesViewModel(showId: showId)
      let viewController = EpisodesViewController(viewModel: viewModel)
      navigationController.pushViewController(viewController, animated: true)
      return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    case .showEpisodeDetail(let episode):
      let viewModel = EpisodeDetailViewModel(episode: episode)
      let viewController = EpisodeDetailViewController(viewModel: viewModel)
      navigationController.topViewController?.present(viewController, animated: true)
      return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    case .none:
      fatalError()
    }
  }
}

