//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Pavel Yurkov on 07.11.2020.
//

import UIKit

class HabitViewController: UIViewController {
    
    var isInEditMode: Bool?
    var habit: CustomHabit?
    
    init(isInEditMode: Bool, coder aDecoder: NSCoder) {
        self.isInEditMode = isInEditMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // кнопка "сохранить"
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveButtonTapped))
        button.tintColor = ColorPalette.primaryColor
        return button
    }()
    
    // кнопка "отмена"
    private lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelButtonTapped))
        button.tintColor = ColorPalette.primaryColor
        return button
    }()
    
    // контейнер для всего контента на экране
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    // label "название"
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = ColorPalette.tenthColor
        label.text = "НАЗВАНИЕ"
        return label
    }()
    
    // textField с описанием привычки
    private lazy var descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .systemGray2
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        return textField
    }()
    
    // label "цвет"
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = ColorPalette.tenthColor
        label.text = "ЦВЕТ"
        return label
    }()
    
    // view с сэмплом выбранного цвета
    private lazy var colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.layer.cornerRadius = 15
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colorViewTapped)))
        return view
    }()
    
    // label "время"
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = ColorPalette.tenthColor
        label.text = "ВРЕМЯ"
        return label
    }()
    
    // container для label'ов с информацией от DatePicker (1-дата, 2-время)
    private lazy var datePickerLabelsContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    // DatePicker label для дня
    private lazy var datePickerDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = ColorPalette.tenthColor
        label.text = "Каждый день в "
        return label
    }()
    
    // DatePicker label для времени
    private lazy var datePickerTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = ColorPalette.primaryColor
        label.text = getCurrentTime()
        return label
    }()
    
    // DatePicker
    private lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.preferredDatePickerStyle = .wheels
        dp.datePickerMode = .time
        dp.timeZone = NSTimeZone.local
        dp.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return dp
    }()
    
    // button "удалить привычку"
    private lazy var deleteHabitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(ColorPalette.eleventhColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.addTarget(self, action: #selector(deleteHabitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItems = [saveButton]
        navigationItem.leftBarButtonItems = [cancelButton]
        
        if let mode = isInEditMode {
            
            if isInEditMode == true {
                print("Редактирование")
                title = "Править"
                
                setupLayout(mode)
                
                if let habitToEdit = habit {
                    setupHabitDetails(habitToEdit.habit)
                }
            } else {
                print("Создание")
                title = "Создать"
                setupLayout(mode)
            }
        }
        
    }
    
    // MARK: "Сохранить" tapped
    @objc private func saveButtonTapped() {
        
        // если поле с названием привычки заполнено, то всё ок
        if !descriptionTextField.text!.isEmpty {
            
            let newHabit = Habit(name: descriptionTextField.text!, date: datePicker.date, color: colorView.backgroundColor!)
            if isInEditMode == true {
                editHabit(newHabit, atIndex: habit!.index)
            } else {
                let store = HabitsStore.shared
                store.habits.append(newHabit)
            }
            
            self.navigationController?.dismiss(animated: true, completion: nil)
            
        } else {
            // если не заполнено, показываем alert
            let alert = UIAlertController(title: "Опаньки...", message: "Вы не вписали название привычки", preferredStyle: .alert)
            let okAlertAction = UIAlertAction(title: "ща впишу:)", style: .default) { (_) in
                print("нажата кнопка OK в алерте")
            }
            alert.addAction(okAlertAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    // MARK: "Удалить" tapped
    @objc private func deleteHabitButtonTapped() {
        if let habitToDelete = habit {
            
            let alert = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку '\(habitToDelete.habit.name)'", preferredStyle: .alert)
            
            let cancellAlertAction = UIAlertAction(title: "Отмена", style: .cancel) { (_) in
            }
            alert.addAction(cancellAlertAction)
            
            let okAlertAction = UIAlertAction(title: "Удалить", style: .default) { (_) in
                HabitsStore.shared.habits.remove(at: habitToDelete.index)
                
                self.navigationController?.pushViewController(HabitsViewController(), animated: false)
                self.navigationController?.viewControllers.removeFirst()
            }
            alert.addAction(okAlertAction)
            
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    // нажатие на кнопку "Отмена"
    @objc private func cancelButtonTapped() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // обработка нажатия на цветной круг
    @objc private func colorViewTapped() {
        let colorPickerViewController = UIColorPickerViewController()
        colorPickerViewController.supportsAlpha = false
        colorPickerViewController.delegate = self
        self.navigationController?.present(colorPickerViewController, animated: true, completion: nil)
    }
    
    // обработка изменений в datePicker (забираем из него значение времени)
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        datePickerTimeLabel.text = dateToString(sender.date, withFormat: "hh:mm a")
    }
    
    // возвращает текущее время
    private func getCurrentTime() -> String {
        let now = Date()
        let time: String = dateToString(now, withFormat: "hh:mm a")
        
        return time
    }
    
    // MARK: редактирование привычки
    private func editHabit(_ habit: Habit, atIndex index: Int) {
        HabitsStore.shared.habits[index].name = habit.name
        HabitsStore.shared.habits[index].date = habit.date
        HabitsStore.shared.habits[index].color = habit.color
    }
    
    // MARK: Setup habit details if in edit mode
    private func setupHabitDetails(_ habit: Habit) {
        descriptionTextField.text = habit.name
        descriptionTextField.textColor = habit.color
        colorView.backgroundColor = habit.color
        datePickerTimeLabel.text = dateToString(habit.date, withFormat: "hh:mm a")
        datePicker.date = habit.date
    }
    
    // MARK: Layout for editing mode
    private func setupLayout(_ isInEditMode: Bool) {
        
        view.addSubviewWithAutolayout(contentView)
        contentView.addSubviews(nameLabel, descriptionTextField, colorLabel, colorView, timeLabel, datePickerLabelsContainer, datePicker)
        datePickerLabelsContainer.addSubviews(datePickerDayLabel, datePickerTimeLabel)
        
        let editModeConstraints = [

            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            descriptionTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7),
            descriptionTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            colorLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 15),
            colorLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            colorLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            colorView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 7),
            colorView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 30),
            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor),

            timeLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 15),
            timeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            datePickerLabelsContainer.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
            datePickerLabelsContainer.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            datePickerLabelsContainer.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            datePickerDayLabel.topAnchor.constraint(equalTo: datePickerLabelsContainer.topAnchor),
            datePickerDayLabel.leadingAnchor.constraint(equalTo: datePickerLabelsContainer.leadingAnchor),
            datePickerDayLabel.centerYAnchor.constraint(equalTo: datePickerLabelsContainer.centerYAnchor),

            datePickerTimeLabel.topAnchor.constraint(equalTo: datePickerDayLabel.topAnchor),
            datePickerTimeLabel.leadingAnchor.constraint(equalTo: datePickerDayLabel.trailingAnchor),
            datePickerTimeLabel.trailingAnchor.constraint(equalTo: datePickerLabelsContainer.trailingAnchor),
            datePickerTimeLabel.centerYAnchor.constraint(equalTo: datePickerDayLabel.centerYAnchor),

            datePicker.topAnchor.constraint(equalTo: datePickerLabelsContainer.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            deleteHabitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            deleteHabitButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            deleteHabitButton.heightAnchor.constraint(equalToConstant: 44),
        ]
        
        let createModeConstraints = [
            
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            descriptionTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7),
            descriptionTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            colorLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 15),
            colorLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            colorLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            colorView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 7),
            colorView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 30),
            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor),

            timeLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 15),
            timeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            datePickerLabelsContainer.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
            datePickerLabelsContainer.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            datePickerLabelsContainer.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            datePickerDayLabel.topAnchor.constraint(equalTo: datePickerLabelsContainer.topAnchor),
            datePickerDayLabel.leadingAnchor.constraint(equalTo: datePickerLabelsContainer.leadingAnchor),
            datePickerDayLabel.centerYAnchor.constraint(equalTo: datePickerLabelsContainer.centerYAnchor),

            datePickerTimeLabel.topAnchor.constraint(equalTo: datePickerDayLabel.topAnchor),
            datePickerTimeLabel.leadingAnchor.constraint(equalTo: datePickerDayLabel.trailingAnchor),
            datePickerTimeLabel.trailingAnchor.constraint(equalTo: datePickerLabelsContainer.trailingAnchor),
            datePickerTimeLabel.centerYAnchor.constraint(equalTo: datePickerDayLabel.centerYAnchor),

            datePicker.topAnchor.constraint(equalTo: datePickerLabelsContainer.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ]
        
        if isInEditMode {
            contentView.addSubviewWithAutolayout(deleteHabitButton)
            NSLayoutConstraint.activate(editModeConstraints)
        } else {
            NSLayoutConstraint.activate(createModeConstraints)
        }
        
    }

}

// MARK: ScrollView Delegate
extension HabitViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
}

// MARK: UIColorPickerViewController Delegate
extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorView.backgroundColor = viewController.selectedColor
        if isInEditMode == true {
            descriptionTextField.textColor = viewController.selectedColor
        }
    }
}
