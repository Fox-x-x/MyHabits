//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Pavel Yurkov on 05.11.2020.
//

import UIKit

class InfoViewController: UIViewController {
    
    // контейнер для всего контента на экране
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    // scrollView для возможности скролла экрана, если контента очень много
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    // title label для отображения заголовка текста
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = ColorPalette.tenthColor
        label.text = "Привычка за 21 день"
        return label
    }()
    
    // информационный текст
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        tv.isEditable = false
        // убраем паддинги слева-справа
        let padding = tv.textContainer.lineFragmentPadding
        tv.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        // загружаем текст из txt файла
        tv.text = tv.loadTextFromFile("info-text")
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Информация"
        
        setupLayout()
    }
    
    // MARK: настраиваем layout
    private func setupLayout() {
        
        view.addSubviewWithAutolayout(scrollView)
        scrollView.addSubviewWithAutolayout(contentView)
        
        contentView.addSubviews(titleLabel, textView)
        
        let constraints = [
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

}

// MARK: ScrollView Delegate
extension InfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
}
