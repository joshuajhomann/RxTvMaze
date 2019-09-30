//
//  MockTvService.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/23/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import RxSwift
@testable import RxTvMaze

class MockTVService: TVServiceProtocol {
  lazy var sampleShowsData: Data = {
    try! Data(contentsOf: Bundle(for: Self.self).url(forResource: "Shows", withExtension: "json")!)
  }()

  lazy var sampleEpisodesData: Data = {
    try! Data(contentsOf:  Bundle(for: Self.self).url(forResource: "Episodes", withExtension: "json")!)
  }()

  func search(query: String) -> Single<[Show]> {
    let shows = (try? JSONDecoder()
      .decode([ShowResults].self, from: sampleShowsData)
      .map { $0.show }
      ) ?? []
    return Observable.just(shows).asSingle()
  }

  func episodes(showId: Int) -> Single<[Episode]> {
    let episodes = (try? JSONDecoder().decode([Episode].self, from: sampleEpisodesData)) ?? []
    return Observable.just(episodes).asSingle()
  }
}
