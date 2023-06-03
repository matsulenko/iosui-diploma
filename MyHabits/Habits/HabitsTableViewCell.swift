//
//  HabitsTableViewCell.swift
//  MyHabits
//
//  Created by Matsulenko on 29.05.2023.
//

import UIKit

class HabitsTableViewCell: UITableViewCell {
    
    static let id = "HabitsTableViewCell"
    
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        label.numberOfLines = 2
        
        return label
    }()
    
    private let dateString: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        label.textColor = .systemGray2
        label.numberOfLines = 1
        
        return label
    }()
    
    private let count: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 1
        
        return label
    }()
    
    var circle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 18.0
        view.layer.borderWidth = 2.0

        return view
    }()
    
    private var tick: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.isUserInteractionEnabled = true

        return imageView
    }()
    
    private var background: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 8.0
        view.backgroundColor = .white
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(named: "MyLightGray")
    }
    
    private func addSubviews() {
        contentView.addSubview(background)
        background.addSubview(title)
        background.addSubview(dateString)
        background.addSubview(count)
        background.addSubview(circle)
        background.addSubview(tick)
    }
    
    func configure(with habit: Habit) {
        title.text = habit.name
        title.textColor = habit.color
        dateString.text = habit.dateString
        count.text = "Cчётчик: " + String(habit.trackDates.count)
        circle.layer.borderColor = habit.color.cgColor
        tick.tintColor = habit.color
        
        if habit.isAlreadyTakenToday {
            tick.alpha = 1
        } else {
            tick.alpha = 0
        }
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
            
            title.topAnchor.constraint(equalTo: background.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: circle.leadingAnchor, constant: -40),
            
            dateString.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            dateString.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20),
            dateString.trailingAnchor.constraint(equalTo: circle.leadingAnchor, constant: -40),
            
            count.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -20),
            count.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20),
            count.trailingAnchor.constraint(equalTo: circle.leadingAnchor, constant: -40),
            
            circle.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            circle.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -26),
            circle.widthAnchor.constraint(equalToConstant: 36),
            circle.heightAnchor.constraint(equalTo: circle.widthAnchor),
            
            tick.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
            tick.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            tick.widthAnchor.constraint(equalToConstant: 39),
            tick.heightAnchor.constraint(equalTo: tick.widthAnchor),
            
            contentView.heightAnchor.constraint(equalToConstant: 130),
            ])
    }
}
