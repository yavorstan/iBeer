//
//  BAFiltersView.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 22.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BAFiltersView: UIView {
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var yeastFilter: BATextFilterView!
    @IBOutlet weak var hopsFilter: BATextFilterView!
    @IBOutlet weak var maltFilter: BATextFilterView!
    @IBOutlet weak var foodFilter: BATextFilterView!
    
    @IBOutlet weak var abvFilter: BAFromToFilterView!
    @IBOutlet weak var ibuFilter: BAFromToFilterView!
    @IBOutlet weak var ebcFilter: BAFromToFilterView!
    
    @IBOutlet weak var dateBeforeFilter: BADateFilterView!
    @IBOutlet weak var dateAfterFilter: BADateFilterView!
    
    var finalURLWithFilters = ""
    
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
        Bundle.main.loadNibNamed("BAFiltersView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollView.isDirectionalLockEnabled = true
        self.setupFiltersLabels()
    }
    
    //MARK: Util Methods
    private func setupFiltersLabels() {
        yeastFilter.setFilterDescriptionName(to: NSLocalizedString("yeast", comment: ""))
        hopsFilter.setFilterDescriptionName(to: NSLocalizedString("hops", comment: ""))
        maltFilter.setFilterDescriptionName(to: NSLocalizedString("malt", comment: ""))
        foodFilter.setFilterDescriptionName(to: NSLocalizedString("food", comment: ""))
        abvFilter.setFilterDescriptionName(to: "ABV")
        ibuFilter.setFilterDescriptionName(to: "IBU")
        ebcFilter.setFilterDescriptionName(to: "EBC")
        dateBeforeFilter.setFilterDescriptionName(to: NSLocalizedString("before", comment: ""))
        dateAfterFilter.setFilterDescriptionName(to: NSLocalizedString("after", comment: ""))
    }
    private func getSubviewsOfView(view: UIView) -> [UIView] {
        var subviewArray = [UIView]()
        if view.subviews.count == 0 {
            return subviewArray
        }
        for subview in view.subviews {
            subviewArray += self.getSubviewsOfView(view: subview)
            subviewArray.append(subview)
        }
        return subviewArray
    }
    
    //MARK: Methods on filtering
    func hasFilters() -> Bool {
        let allViews = getSubviewsOfView(view: self)
        for subview in allViews {
            if subview.conforms(to: Filterable.self) {
                let filterableSubview = subview as! Filterable
                if filterableSubview.hasFilter() {
                    return true
                }
            }
        }
        return false
    }
    
    func getFinalURL() -> String {
        let allViews = getSubviewsOfView(view: self)
        self.finalURLWithFilters = ""
        if hasFilters() {
            for subview in allViews {
                if subview.conforms(to: Filterable.self) {
                    let filterableSubview = subview as! Filterable
                    self.finalURLWithFilters += filterableSubview.getTextFieldInputForURL()
                }
            }
        }
        return self.finalURLWithFilters
    }
    
    func clearAllFilters() {
        let allView = getSubviewsOfView(view: self)
        for subview in allView {
            if subview.conforms(to: Filterable.self) {
                let filterableSubview = subview as! Filterable
                filterableSubview.clearFilter()
            }
        }
    }
    
}
