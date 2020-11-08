//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Pavel Yurkov on 05.11.2020.
//

import UIKit

class HabitsViewController: UIViewController {
    
    // кнопка добавления привычки
    private lazy var addBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        button.tintColor = ColorPalette.primaryColor
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Привычки"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = addBarButton
        
    }
    
    @objc private func addTapped() {
        let habitViewController = UINavigationController(rootViewController: HabitViewController())
        self.navigationController?.present(habitViewController, animated: true, completion: nil)
    }

}
