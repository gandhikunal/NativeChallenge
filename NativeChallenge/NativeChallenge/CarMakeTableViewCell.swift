//
//  CarMakeTableViewCell.swift
//  NativeChallenge
//
//  Created by KunalGandhi on 10.05.22.
//

import UIKit

class CarMakeTableViewCell: UITableViewCell {

    override var reuseIdentifier: String? {
        return "carmakecell"
    }
    var viewmodel: CarMakeCellViewModel?
    let makeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(makeLabel)
        let leading = NSLayoutConstraint(item: makeLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 20.0)
        let trailing = NSLayoutConstraint(item: makeLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let top = NSLayoutConstraint(item: makeLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: makeLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func prepareForReuse() {
        viewmodel = nil
    }
}
