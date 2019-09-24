//
//  EpisodeCollectionViewCell.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/22/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import AlamofireImage

class EpisodeCollectionViewCell: UICollectionViewCell {
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var seasonLabel: UILabel!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var detailLabel: UILabel!
  private var viewModel: Episode?
  private var tapAction: CocoaAction?

  override var isSelected: Bool {
    didSet {
      if self.isSelected {
        tapAction?.execute()
      }
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    viewModel = nil
    tapAction = nil
    imageView.image = nil
  }

  func configure(with viewModel: EpisodeCellViewModel) {
    let (seasonText, titleText, detailText, imageUrl, tapAction) = viewModel.outputs()
    seasonLabel.text = seasonText
    titleLabel.text = titleText
    detailLabel.text = detailText
    if let imageUrl = imageUrl {
      imageView.af_setImage(withURL: imageUrl)
    }
    self.tapAction = tapAction
  }
}
