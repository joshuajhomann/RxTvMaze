//
//  EpisodeDetailViewModel.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/23/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import Foundation
import RxFlow
import RxSwift
import RxCocoa
import RxDataSources
import Action

struct EpisodeDetailViewModel: Stepper {
  var steps: PublishRelay<Step> = .init()
  typealias Output = (
    seasonText: String,
    titleText: String,
    detailText: String,
    imageUrl: URL?
  )
  let episode: Episode
  func outputs() -> Output {
    let seasonText = "Season \(episode.season) Episode \(episode.number)"
    let titleText = episode.name
    let detailText = (episode
      .summary ?? "")
      .replacingOccurrences(of: "<p>", with: "")
      .replacingOccurrences(of: "</p>", with: "")
    let imageUrl = episode.image?.medium
    return (seasonText, titleText, detailText, imageUrl)
  }
}
