//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Pavel Yurkov on 05.11.2020.
//

import UIKit

class HabitsViewController: UIViewController {
    
    // кнопка добавления привычки
    private lazy var addBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        button.tintColor = ColorPalette.primaryColor
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            HabitCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: HabitCollectionViewCell.self)
        )
        collectionView.register(
            ProgressCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self)
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = ColorPalette.ninethColor

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Сегодня"
        navigationItem.rightBarButtonItem = addBarButtonItem
        
        setupLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.reloadData()
        
    }
    
    @objc private func addButtonTapped() {
        let habitViewController = UINavigationController(rootViewController: HabitViewController(isInEditMode: false, coder: NSCoder()))
        habitViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(habitViewController, animated: true, completion: nil)
    }
    
    @objc private func tickViewTapped(sender: CustomTapGestureRecognizer) {
        
        let habit = HabitsStore.shared.habits[sender.indexPath!.item]
        
        if !habit.isAlreadyTakenToday {
            let cell = collectionView.cellForItem(at: sender.indexPath!) as! HabitCollectionViewCell
            cell.tickCircle.backgroundColor = habit.color
            HabitsStore.shared.track(habit)
            
            collectionView.reloadData()
        }
        
    }

}

extension HabitsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return HabitsStore.shared.habits.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: HabitCollectionViewCell.self),
                for: indexPath
            ) as! HabitCollectionViewCell
            
            cell.habit = HabitsStore.shared.habits[indexPath.item]
            
            let tapGestureRecognizer = CustomTapGestureRecognizer(target: self, action: #selector(tickViewTapped(sender:)))
            tapGestureRecognizer.indexPath = indexPath
            cell.tickCircle.addGestureRecognizer(tapGestureRecognizer)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: ProgressCollectionViewCell.self),
                for: indexPath
            ) as! ProgressCollectionViewCell
            cell.setProgress(HabitsStore.shared.todayProgress, withAnimation: true)
            return cell
        }
        
    }
    
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    var offset: CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width - offset * 2
        if indexPath.section == 1 {
            return CGSize(width: width, height: 130)
        } else {
            return CGSize(width: width, height: 60)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 22, left: .zero, bottom: .zero, right: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let habitDetailsViewController = HabitDetailsViewController()
            
            let habit = CustomHabit(habit: HabitsStore.shared.habits[indexPath.item], index: indexPath.item)
            habitDetailsViewController.habit = habit
            navigationController?.pushViewController(habitDetailsViewController, animated: true)
        }
        
    }
}

private extension HabitsViewController {
    
    func setupLayout() {
        view.addSubviewWithAutolayout(collectionView)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
