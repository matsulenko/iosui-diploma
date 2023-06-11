//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Matsulenko on 25.05.2023.
//

/*
 Доработать:
 2. Изменение привычек при нажатии
 3. Удаление существующей привычки
 
*/

import UIKit

final class HabitsViewController: UIViewController {
    
    private var data = HabitsStore.shared.habits
    private var headerView = HabitsTableHederView()
    
    private var tableView: UITableView = {
        var tableView = UITableView.init(
            frame: .zero,
            style: .grouped
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setupTable()
        setupView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        data = HabitsStore.shared.habits
        setProgress()
        tableView.reloadData()
        setupView()
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupTable() {
        setProgress()
        tableView.setAndLayoutTableHeaderView(headerView)
        tableView.register(HabitsTableViewCell.self, forCellReuseIdentifier: HabitsTableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func setProgress() {
        let progress: Float = HabitsStore.shared.todayProgress
        let todayProgress = Int(100 * HabitsStore.shared.todayProgress)
        headerView.progressBar.setProgress(progress, animated: true)
        headerView.todayProgress.text = String(todayProgress) + "%"
    }
    
    func setupView() {
        view.backgroundColor = UIColor(named: "MyLightGray")
        title = "Сегодня"
        navigationController?.navigationBar.isHidden = false
        navigationBarBackground()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(buttonPressed(_:)))
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "MyPurple")

    }
    
    private func navigationBarBackground() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "NavigationBarBackground")
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance        
    }
    
    @objc func buttonPressed(_ sender: UIBarButtonItem) {
        
        let habitViewController = HabitViewController()
        let navHabitViewController: UINavigationController = UINavigationController(rootViewController: habitViewController)
        navHabitViewController.modalPresentationStyle = .fullScreen
        self.present(navHabitViewController, animated: true, completion: nil)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
        ])
    }
    
}

extension HabitsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HabitsTableViewCell.id, for: indexPath) as? HabitsTableViewCell else { return UITableViewCell() }
        let habit = data[indexPath.section]
            cell.configure(with: habit)
        cell.selectionStyle = .none
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeStatus(recognizer:)))
        cell.circle.isUserInteractionEnabled = true
        cell.circle.addGestureRecognizer(tapGesture)

        return cell
        
    }
    ///
    @objc
    func changeStatus(recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizer.State.ended {
            let swipeLocation = recognizer.location(in: self.tableView)
            if let swipedIndexPath = tableView.indexPathForRow(at: swipeLocation) {
                if self.tableView.cellForRow(at: swipedIndexPath) != nil {
                    let section = swipedIndexPath.section
                    let habit = data[section]
                    if habit.isAlreadyTakenToday == false {
                        HabitsStore.shared.track(habit)
                        HabitsStore.shared.save()
                        data = HabitsStore.shared.habits
                        setProgress()
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        12
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        let nextViewController = HabitDetailsViewController()
        
        let selectedHabit = data[indexPath.section]
        nextViewController.chosenHabit(selectedHabit)
        
        navigationController?.pushViewController(
            nextViewController,
            animated: true
        )
    }
        
}

extension UITableView {
    func setAndLayoutTableHeaderView(_ header: UIView) {
        self.tableHeaderView = header
        self.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
        header.setNeedsLayout()
        header.layoutIfNeeded()
        header.frame.size =  header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.tableHeaderView = header
    }
}


