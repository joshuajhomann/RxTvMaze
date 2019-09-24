//
//  EpisodeDetailViewController.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/23/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EpisodeDetailViewController: UIViewController {
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var seasonLabel: UILabel!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var detailLabel: UILabel!
  private let viewModel: EpisodeDetailViewModel
  
  init(viewModel: EpisodeDetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    let (seasonText, titleText, detailText, imageUrl) = viewModel.outputs()
    seasonLabel.text = seasonText
    titleLabel.text = titleText
    detailLabel.text = detailText
    if let imageUrl = imageUrl {
      imageView.af_setImage(withURL: imageUrl)
    }
  }
}
