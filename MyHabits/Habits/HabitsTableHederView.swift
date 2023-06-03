//
//  HabitsTableHederView.swift
//  MyHabits
//
//  Created by Matsulenko on 29.05.2023.
//

import UIKit

class HabitsTableHederView: UIView {
    
    private var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.text = "Всё получится!"
        label.textAlignment = .left
        
        return label
    }()
    
    private var contentView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 8.0
        view.backgroundColor = .white
        
        return view
    }()
    
    var todayProgress: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.textAlignment = .right
        
        return label
    }()
    
    var progressBar: UIProgressView = {
        var progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = UIColor(named: "ProgressBarBackground")
        progressView.progressTintColor = UIColor(named: "MyPurple")
        
        return progressView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(contentView)
        contentView.addSubview(title)
        contentView.addSubview(todayProgress)
        contentView.addSubview(progressBar)
    }
    
    private func setupView() {
        backgroundColor = UIColor(named: "MyLightGray")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -17),
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 22),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -18),
            contentView.heightAnchor.constraint(equalToConstant: 60),
            
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            title.widthAnchor.constraint(equalToConstant: 216),
            
            todayProgress.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            todayProgress.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            todayProgress.widthAnchor.constraint(equalToConstant: 95),
            
            progressBar.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: todayProgress.trailingAnchor),
            progressBar.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            progressBar.heightAnchor.constraint(equalToConstant: 7),
            ])
        
    }
}
