//
//  ShowsCellViewModel.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/23/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import Foundation
import RxFlow
import RxSwift
import RxCocoa
import Action

struct ShowCellViewModel {
  typealias Output = (title: String, tapAction: CocoaAction)
  let show: Show
  let tapAction: CocoaAction
  func outputs() -> Output  {
    (title: show.name, tapAction: tapAction)
  }
}
