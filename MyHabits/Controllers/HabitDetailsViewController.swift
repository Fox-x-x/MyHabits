//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Pavel Yurkov on 13.11.2020.
//

import UIKit

class HabitDetailsViewController: UIViewController {
    
    var habit: Habit? {
        didSet {
            guard let habit = habit else { return }
            title = habit.name
        }
    }
    
    private var currentHabit: Habit?
    
    private lazy var editItemButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editItemButtonTapped))
        button.tintColor = ColorPalette.primaryColor
        return button
    }()
    
    private lazy var activityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "АКТИВНОСТЬ"
        label.textColor = ColorPalette.eighthColor
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var habitsTableView: UITableView = {
        let htv = UITableView()
        htv.dataSource = self
        htv.delegate = self
        htv.showsVerticalScrollIndicator = false
        htv.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        htv.tintColor = ColorPalette.primaryColor
        return htv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editItemButton
        view.backgroundColor = ColorPalette.ninethColor
        setupLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    @objc private func editItemButtonTapped() {
        
    }

}

extension HabitDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = habitsTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        let date = HabitsStore.shared.dates[indexPath.row]
        cell.textLabel?.text = dateToString(date, withFormat: .medium)
        
        if HabitsStore.shared.habit(habit!, isTrackedIn: date) {
            cell.accessoryType = .checkmark
        }

        return cell
    }
     
}

extension HabitDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

private extension HabitDetailsViewController {
    
    func setupLayout() {
        
        view.addSubviews(activityLabel, habitsTableView)
        
        let constraints = [
            activityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: topbarHeight + 70),
            activityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            activityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            habitsTableView.topAnchor.constraint(equalTo: activityLabel.bottomAnchor, constant: 10),
            habitsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            habitsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            habitsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
