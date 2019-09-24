//
//  ShowViewModelSpec.swift
//  RxTVMazeTests
//
//  Created by Joshua Homann on 9/23/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import Quick
import Nimble
import RxNimble
import RxBlocking
import RxCocoa
import RxFlow

@testable import RxTVMaze
class ShowViewModelSpec: QuickSpec {
  override func spec() {
    describe("SearchViewModel") {
      context("when given an empty search term") {
        it("should return an empty array of cells") {
          let viewModel = ShowsViewModel()
          let cells = try? viewModel.outputs(searchTerm: .just("")).asObservable().toBlocking().first()
          expect(cells?.count).to(equal(0))
        }
      }
    }
    describe("SearchViewModel") {
      context("when given a search term") {
        it("should return the sample data with 10 items") {
          let viewModel = ShowsViewModel()
          let cells = try? viewModel.outputs(searchTerm: .just("Game of")).asObservable().toBlocking().first()
          expect(cells?.count).to(equal(10))
        }
      }
    }
    describe("ShowCellViewModel") {
      context("when initialized with game of thrones") {
        it("should have the title 'Game of Thrones") {
          let viewModel = ShowsViewModel()
          let cellViewModels = try! viewModel.outputs(searchTerm: .just("Game of")).asObservable().toBlocking().first()!
          let (name, _) = cellViewModels[0].outputs()
          expect(name).to(equal("Game of Thrones"))
        }
      }
    }
    describe("ShowCellViewModel") {
      context("when initialized with game of thrones") {
        it("should have an action that emits the ") {
          let viewModel = ShowsViewModel()
          let cellViewModels = try! viewModel.outputs(searchTerm: .just("Game of")).asObservable().toBlocking().first()!
          let (_, action) = cellViewModels[0].outputs()
          let steps: BehaviorRelay<Step?> = .init(value: nil)
          let disposable = viewModel.steps.bind(to: steps)
          expect{
            action.execute()
            if case .showEpisodes(let showId) = (steps.value as? SearchStep) {
              return showId == 82
            }
            return false
          }.toEventually(beTrue())
          disposable.dispose()
        }
      }
    }
  }
}
