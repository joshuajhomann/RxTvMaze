//
//  ShowTableViewCell.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/21/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class ShowTableViewCell: UITableViewCell {
  @IBOutlet private var titleLabel: UILabel!
  private var viewModel: ShowCellViewModel?
  private var tapAction: CocoaAction?
  override func prepareForReuse() {
    super.prepareForReuse()
    tapAction = nil
    viewModel = nil
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    guard selected else {
      return
    }
    tapAction?.execute()
  }

  func configure(viewModel: ShowCellViewModel) {
    let (titleText, tapAction) = viewModel.outputs()
    titleLabel.text = titleText
    self.viewModel = viewModel
    self.tapAction = tapAction
  }

}
