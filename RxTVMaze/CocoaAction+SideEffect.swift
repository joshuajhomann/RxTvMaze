//
//  CocoaAction+SideEffect.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/23/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import Action
import RxSwift

extension CocoaAction {
  convenience init(sideEffect: @escaping () -> Void) {
    self.init(workFactory: {
      Observable
        .just(())
        .do(onNext: { Void in
          sideEffect()
        })
    })
  }
}
