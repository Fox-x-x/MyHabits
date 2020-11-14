//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Pavel Yurkov on 12.11.2020.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var motoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = ColorPalette.eighthColor
        label.text = "Всё получится!"
        return label
    }()
    
    private lazy var percentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = ColorPalette.eighthColor
        return label
    }()
    
    private lazy var progressBar: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .bar)
        view.trackTintColor = ColorPalette.ninethColor
        view.progressTintColor = ColorPalette.primaryColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupLayout()
        setProgress(HabitsStore.shared.todayProgress, withAnimation: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProgress(_ progress: Float, withAnimation animated: Bool) {
        progressBar.setProgress(progress, animated: animated)
        percentsLabel.text = String(format: "%.0f", progress * 100) + "%"
    }
    
}

private extension ProgressCollectionViewCell {
    func setupLayout() {
        
        contentView.addSubviews(containerView, progressBar)
        containerView.addSubviews(motoLabel, percentsLabel)
        
        let constraints = [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            progressBar.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10),
            progressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            progressBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            progressBar.heightAnchor.constraint(equalToConstant: 7),
            
            motoLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            motoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            motoLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            motoLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            percentsLabel.topAnchor.constraint(equalTo: motoLabel.topAnchor),
            percentsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            percentsLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
}
