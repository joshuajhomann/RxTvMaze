//
//  Dependencies.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/23/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import Foundation

struct Dependencies {
  private (set) var tvService: TVServiceProtocol
  static let shared = Dependencies()
  private init () {
    #if TEST
      tvService = MockTVService()
    #else
      tvService = TVService()
    #endif
  }
}
