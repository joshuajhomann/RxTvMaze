//
//  LoadingView.swift
//  RxTvMaze
//
//  Created by Joshua Homann on 9/28/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum LoadingState {
  case loading, error, empty, loaded
}

class LoadingView: UIView {
  enum DefaultableView {
    case standard, custom(UIView)
  }

  private var loadingView: UIView?
  private var errorView: UIView?
  private var emptyView: UIView?
  private var contentView: UIView?
  private var disposeBag = DisposeBag()
  func setup(
    contentView: UIView? = nil,
    loadingView loadingViewWrapper: DefaultableView = .standard,
    errorView errorViewWrapper: DefaultableView = .standard,
    emptyView emptyViewWrapper: DefaultableView = .standard,
    loadingState: Driver<LoadingState>
  ) {

    switch loadingViewWrapper {
    case .standard:
      let loadingView = UINib(nibName: String(describing: StandardLoadingView.self), bundle: nil).instantiate(withOwner: nil, options: nil).first as! StandardLoadingView
      loadingView.isHidden = true
      loadingView.translatesAutoresizingMaskIntoConstraints = false
      addSubview(loadingView)
      NSLayoutConstraint.activate([
        loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
        loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
        loadingView.topAnchor.constraint(equalTo: topAnchor),
        loadingView.bottomAnchor.constraint(equalTo: bottomAnchor)
      ])
      self.loadingView = loadingView
    case .custom(let view):
      loadingView = view
    }

    switch errorViewWrapper {
    case .standard:
      let errorView = UINib(nibName: String(describing: StandardErrorView.self), bundle: nil).instantiate(withOwner: nil, options: nil).first as! StandardErrorView
      errorView.isHidden = true
      errorView.translatesAutoresizingMaskIntoConstraints = false
      addSubview(errorView)
      NSLayoutConstraint.activate([
        errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
        errorView.trailingAnchor.constraint(equalTo: trailingAnchor),
        errorView.topAnchor.constraint(equalTo: topAnchor),
        errorView.bottomAnchor.constraint(equalTo: bottomAnchor)
      ])
      self.errorView = errorView
    case .custom(let view):
      self.loadingView = view
    }

    switch emptyViewWrapper {
    case .standard:
      let emptyView = UINib(nibName: String(describing: StandardEmptyView.self), bundle: nil).instantiate(withOwner: nil, options: nil).first as! StandardEmptyView
      emptyView.isHidden = true
      emptyView.translatesAutoresizingMaskIntoConstraints = false
      addSubview(emptyView)
      NSLayoutConstraint.activate([
        emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
        emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
        emptyView.topAnchor.constraint(equalTo: topAnchor),
        emptyView.bottomAnchor.constraint(equalTo: bottomAnchor)
      ])
      self.emptyView = emptyView
    case .custom(let view):
      self.loadingView = view
    }

    self.contentView = contentView

    if let contentView = contentView {
      loadingState
        .map{ $0 != .loaded}
        .drive(contentView.rx.isHidden)
      .disposed(by: disposeBag)
    }

    guard let loadingView = loadingView,
      let errorView = errorView,
      let emptyView = emptyView else {
        return
    }

    loadingState
      .map{ $0 != .loading}
      .drive(loadingView.rx.isHidden)
      .disposed(by: disposeBag)

    loadingState
      .map{ $0 != .error}
      .drive(errorView.rx.isHidden)
      .disposed(by: disposeBag)

    loadingState
      .map{ $0 != .empty}
      .drive(emptyView.rx.isHidden)
      .disposed(by: disposeBag)

  }

}
