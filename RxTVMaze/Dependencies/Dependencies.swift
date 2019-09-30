//
//  Dependencies.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/23/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import Foundation

class Dependencies {
  let tvService: TVServiceProtocol
  init () {
    tvService = TVService()
  }
}
