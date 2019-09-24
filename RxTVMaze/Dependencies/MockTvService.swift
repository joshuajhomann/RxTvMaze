//
//  MockTvService.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/23/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import RxSwift

struct MockTVService: TVServiceProtocol {
  func search(query: String) -> Single<[Show]> {
    let shows = (try? JSONDecoder().decode([Show].self, from: TVMazeService.episodes(showId: 0).sampleData)) ?? []
    return Observable.just(shows).asSingle()
  }

  func episodes(showId: Int) -> Single<[Episode]> {
    let episodes = (try? JSONDecoder().decode([Episode].self, from: TVMazeService.episodes(showId: 0).sampleData)) ?? []
    return Observable.just(episodes).asSingle()
  }
}
