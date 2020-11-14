//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Pavel Yurkov on 07.11.2020.
//

import UIKit

class HabitViewController: UIViewController {
    
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
    
    // scrollView для возможности скролла экрана, если контента очень много
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Создать"
        navigationItem.rightBarButtonItems = [saveButton]
        navigationItem.leftBarButtonItems = [cancelButton]
        
        setupLayout()
    }
    
    // нажатие на кнопку "Сохранить"
    @objc private func saveButtonTapped() {
        
        // если после с названием привычки заполнено, то всё ок
        if !descriptionTextField.text!.isEmpty {
            let newHabit = Habit(name: descriptionTextField.text!, date: datePicker.date, color: colorView.backgroundColor!)
            let store = HabitsStore.shared
            store.habits.append(newHabit)
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
    
    // MARK: Layout
    private func setupLayout() {
        
        view.addSubviewWithAutolayout(scrollView)
        scrollView.addSubviewWithAutolayout(contentView)
        contentView.addSubviews(nameLabel, descriptionTextField, colorLabel, colorView, timeLabel, datePickerLabelsContainer, datePicker)
        datePickerLabelsContainer.addSubviews(datePickerDayLabel, datePickerTimeLabel)
        
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
        
        NSLayoutConstraint.activate(constraints)
        
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
    }
}
