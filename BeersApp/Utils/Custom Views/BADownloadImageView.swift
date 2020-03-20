//
//  BADownloadImageView.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 6.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit
import Kingfisher

class BADownloadImageView: UIView {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("BADownloadImageView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func populateImage(withURL: URL){
        imageView.kf.setImage(with: withURL)
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
}
