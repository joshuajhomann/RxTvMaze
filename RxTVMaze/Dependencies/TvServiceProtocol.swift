//
//  TVServiceProtocol.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/23/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import RxSwift

@propertyWrapper
struct TVServiceInjected {
  var wrappedValue: TVServiceProtocol {
    get {
      return Dependencies.shared.tvService
    }
  }
}

protocol TVServiceProtocol {
  func search(query: String) -> Single<[Show]>
  func episodes(showId: Int) -> Single<[Episode]>
}
