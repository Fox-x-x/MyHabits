//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Pavel Yurkov on 10.11.2020.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    var habit: Habit? {
        didSet {
            guard let habit = habit else { return }
            nameLabel.text = habit.name
            nameLabel.textColor = habit.color
            timeLabel.text = habit.dateString
            howOftenLabel.text = "Подряд: " + inSequence(habit)
            
            tickCircle.layer.borderColor = habit.color.cgColor
            
            if habit.isAlreadyTakenToday {
                tickCircle.backgroundColor = habit.color
            } else {
                tickCircle.backgroundColor = .white
            }
            
        }
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "Выпить стакан воды и сходить посрать по-царски"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = ColorPalette.eighthColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var howOftenLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Подряд: 3"
        label.textColor = ColorPalette.sixthColor
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    lazy var tickCircle: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.cornerRadius = 18
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}

private extension HabitCollectionViewCell {
    func setupLayout() {
        contentView.addSubviews(nameLabel, timeLabel, howOftenLabel, tickCircle)
        
        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            howOftenLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            howOftenLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            tickCircle.widthAnchor.constraint(equalToConstant: 36),
            tickCircle.heightAnchor.constraint(equalTo: tickCircle.widthAnchor),
            tickCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tickCircle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // подсчитывает сколько раз была затрэкана привычка
    func inSequence(_ habit: Habit) -> String {
        let dates = HabitsStore.shared.dates
        var count = 0
        for date in dates {
            if HabitsStore.shared.habit(habit, isTrackedIn: date) {
                count += 1
            }
        }
        
        return String(count)
    }
}
