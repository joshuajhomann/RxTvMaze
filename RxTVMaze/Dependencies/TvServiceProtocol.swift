//
//  TVServiceProtocol.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/23/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import RxSwift

protocol TVServiceProtocol {
  func search(query: String) -> Single<[Show]>
  func episodes(showId: Int) -> Single<[Episode]>
}
