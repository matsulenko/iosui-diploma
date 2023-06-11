//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Matsulenko on 01.06.2023.
//

import UIKit

final class HabitDetailsViewController: UIViewController {
    
    private var habit: Habit? = nil
    private var dates: [Date] = []
    private var data: [String] = []
    
    let cellReuseIdentifier = "cell"
    
    private var tableView: UITableView = {
        var tableView = UITableView.init(
            frame: .zero,
            style: .plain
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupTable()
        setupView()
        setupConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    func chosenHabit(_ chosenHabit: Habit) {
        habit = chosenHabit
    }
    
    private func daysBefore(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days*(-1), to: Date())!
    }
    
    private func setupTable() {
        setupData()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupData() {
        
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = .init(identifier: "ru_RU")
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            formatter.doesRelativeDateFormatting = true
            return formatter
        }()
        
        for i in 1...4 {
            var date: Date {
                return daysBefore(i)
            }
            dates.append(date)
            data.append(dateFormatter.string(from: date))
        }
        
    }
    
    private func setupView() {
        tableView.backgroundColor = UIColor(named: "MyLightGray")
        view.backgroundColor = UIColor(named: "MyLightGray")
        title = habit?.name
        navigationBarBackground()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Изменить", style: .plain, target: self, action: #selector(changeTapped))
        navigationController?.navigationBar.tintColor = UIColor(named: "MyPurple")
    }
    
    private func navigationBarBackground() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "NavigationBarBackground")
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    @objc
    private func changeTapped() {
        let habitViewController = HabitViewController()
        habitViewController.onWillDismiss = { [weak self] in
            if habitViewController.isDeleted {
                self?.navigationController?.popToRootViewController(animated: true)
            }
            self?.title = habitViewController.habitNameValue
        }
        habitViewController.chosenHabit(habit!)
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
    
    private func popToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension HabitDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as UITableViewCell?)!
        
        cell.textLabel?.text = self.data[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        
        if habit != nil {
            if HabitsStore.shared.habit(habit!, isTrackedIn: dates[indexPath.row]) {
                cell.accessoryType = .checkmark
                cell.accessoryView = nil
                cell.tintColor = UIColor(named: "MyPurple")
            }
            cell.backgroundColor = .white
        }
        
        return cell
        
    }
    
    func tableView(
            _ tableView: UITableView,
            titleForHeaderInSection section: Int
        ) -> String? {
            "АКТИВНОСТЬ"
        }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .systemGray
        header.textLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)

    }
}
