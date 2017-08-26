//
//  SelectorView.swift
//  Algonquin
//
//  Created by Peter Soboyejo on 8/26/17.
//  Copyright © 2017 Peter Soboyejo. All rights reserved.
//

import UIKit

@objc public class SelectorView: UIView {
    
    var contentHeight: CGFloat = 400
    private var contentView: UIView!
    private var titleLabel: UILabel!
    private var borderTopView: UIView!
    private var dropdownButton: UIButton!
    internal var optionsTableView: UITableView!
    internal var selectedOption: String!
    internal var choices: [String]!
    public var completionHandler: ((String)->Void)?
    
    let cellReuseIdentifier = "cell"
    
    open class func show(selections: [String]?, bounceUpTo: CGFloat?, topText: String?) -> SelectorView {
        let sizeSelectorPicker = SelectorView()
        sizeSelectorPicker.configureView(selections: selections, bounceUpTo: bounceUpTo, topText: topText)
        UIApplication.shared.keyWindow?.addSubview(sizeSelectorPicker)
        return sizeSelectorPicker
    }
    
    private func configureView(selections: [String]?, bounceUpTo: CGFloat?, topText: String?) {
        
        choices = selections!
        contentHeight = bounceUpTo!
        
        let screenSize = UIScreen.main.bounds.size
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: screenSize.width,
                            height: screenSize.height)
        
        contentView = UIView(frame: CGRect(x: 0,
                                           y: frame.height,
                                           width: frame.width,
                                           height: contentHeight))
        contentView.backgroundColor = .white
        contentView.isHidden = false
        addSubview(contentView)
        
        let titleView = UIView(frame: CGRect(origin: CGPoint.zero,
                                             size: CGSize(width: contentView.frame.width, height: 44)))
        titleView.backgroundColor = .white
        contentView.addSubview(titleView)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        titleLabel.font = UIFont(name: "Avenir Next", size: 15)!
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.center = CGPoint(x: contentView.frame.width / 2, y: 22)
        titleLabel.text = topText
        titleView.addSubview(titleLabel)
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SelectorView.dismissView(sender:)))
        titleView.addGestureRecognizer(tapGestureRecognizer)
        
        let downButtonImg = UIImage(named: "arrowDown")
        dropdownButton = UIButton(type: .custom)
        dropdownButton.addTarget(self, action: #selector(SelectorView.dismissView(sender:)), for: .touchUpInside)
        dropdownButton.setBackgroundImage(downButtonImg, for: .normal)
        dropdownButton.frame = CGRect(x: contentView.frame.width - 30, y: titleView.frame.height / 2.5, width: 16, height: 9)
        titleView.addSubview(dropdownButton)
        
        borderTopView = UIView(frame: CGRect(x: 0, y: titleView.frame.height, width: titleView.frame.width, height: 1))
        borderTopView.backgroundColor = UIColor(red: 0, green: 22.0/255.0, blue: 39.0/255.0, alpha: 1).withAlphaComponent(0.2)
        contentView.addSubview(borderTopView)
        
        // TableView Stuff
        optionsTableView = UITableView(frame: CGRect(x: 0, y: titleView.frame.height + 2, width: titleView.frame.width, height: contentView.frame.height - titleView.frame.height))
        optionsTableView.tableFooterView = UIView(frame: .zero)
        optionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        optionsTableView.separatorInset = .zero
        optionsTableView.layoutMargins = .zero
        optionsTableView.allowsSelection = true;
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        contentView.addSubview(optionsTableView)
        
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: .curveEaseIn, animations: {
            self.contentView.frame = CGRect(x: 0,
                                            y: self.frame.height - self.contentHeight,
                                            width: self.frame.width,
                                            height: self.contentHeight)
        }, completion: nil)
        
    }
    
    public func dismissView(sender: UIButton?=nil) {
        UIView.animate(withDuration: 0.3, animations: {
            // animate to show contentView
            self.contentView.frame = CGRect(x: 0,
                                            y: self.frame.height,
                                            width: self.frame.width,
                                            height: self.contentHeight)
        }) { (completed) in
            // Take String Value and pass it on via Method
            self.completionHandler?(self.selectedOption ?? self.choices[0])
            self.removeFromSuperview()
        }
    }
    
}

extension SelectorView: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.choices.count
    }
    
    // Note to self: First Param is designed for not accepting any name value towards the function
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell: UITableViewCell = optionsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        cell.tintColor = UIColor.black
        cell.selectionStyle = .none
        cell.textLabel?.text = self.choices[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 15)!
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath as IndexPath)
        cell?.accessoryType = .checkmark
        selectedOption = self.choices[indexPath.row]
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        optionsTableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
    }
    
}
