//
//  TodayWidgetFavouriteCell.swift
//  todayWidget
//
//  Created by Yavor Stanoev on 24.04.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class TodayWidgetFavouriteCell: UIView {
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var beerImageView: BADownloadImageViewWithBorder!
    @IBOutlet weak var beerNameLabel: UILabel!
    
    @IBOutlet weak var fabBeerButton: UIButton!
    
    var favBeerButtonAction: (() -> ())?
    
    //MARK: Lyfecylce Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func setup() {
        Bundle.main.loadNibNamed("TodayWidgetFavouriteCell", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    @IBAction func favBeerButtonPressed(_ sender: UIButton) {
        self.favBeerButtonAction!()
    }
    
}
