//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Matsulenko on 27.05.2023.
//
 
import UIKit

class HabitViewController: UIViewController {
    
    var onWillDismiss: (() -> Void)?
    private var habit: Habit? = nil
    
    var isDeleted = false
    
    var habitNameValue: String?

    private lazy var habitNameTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 1
        label.text = "НАЗВАНИЕ"
        return label
    }()
    
    private lazy var setHabitNameValue: UITextField = { [unowned self] in
        let textField = UITextField()
        
        if habit != nil {
            textField.text = habit?.name
            habitNameValue = habit?.name
        }
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        textField.textColor = UIColor(named: "MyBlue")
        textField.tintColor = UIColor(named: "MyBlue")
        textField.autocapitalizationType = .sentences
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.addTarget(self, action: #selector(setNewHabitNameValue), for: .editingChanged)
        
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var habitColorTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 1
        label.text = "ЦВЕТ"
        return label
    }()
        
    private var colorValue: UIColor = UIColor(named: "MyOrange") ?? .black
    
    private lazy var setColorValue: UIView = {
        
        if habit != nil {
            colorValue = habit!.color
        }
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = colorValue
        view.layer.cornerRadius = 15.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(makeColorPicker))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
        
    private lazy var habitTimeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 1
        label.text = "ВРЕМЯ"
        return label
    }()
    
    private var timeStringValue: String = "11:00 AM"
    
    private lazy var habitTimeText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 1
        label.text = "Каждый день в "
        return label
    }()
    
    private lazy var pickedHabitTime: UITextField = { [unowned self] in
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = timeStringValue
        textField.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        textField.textColor = UIColor(named: "MyPurple")
        textField.tintColor = .white

        textField.delegate = self
        
        return textField
    }()
    
    private lazy var deleteHabitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить привычку", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        button.setTitleColor(.systemRed, for: .normal)
        button.contentMode = .center

        button.addTarget(self, action: #selector(deleteHabitAlert(_:)), for: .touchUpInside)
                
        return button
    }()
       
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setupView()
        setupConstraints()
    }
    
    func chosenHabit(_ chosenHabit: Habit) {
        habit = chosenHabit
    }
    
    private func addSubviews() {
        view.addSubview(habitNameTitle)
        view.addSubview(setHabitNameValue)
        view.addSubview(habitColorTitle)
        view.addSubview(setColorValue)
        view.addSubview(habitTimeTitle)
        view.addSubview(habitTimeText)
        view.addSubview(pickedHabitTime)
        view.addSubview(deleteHabitButton)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        if habit != nil {
            title = "Изменить"
        } else {
            title = "Создать"
        }
        navigationBarBackground()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(closeView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveTapped))
        navigationController?.navigationBar.tintColor = UIColor(named: "MyPurple")
        
        setTime()
    }
    
    private func navigationBarBackground() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "NavigationBarBackground")
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc
    private func setNewHabitNameValue(_ textField: UITextField) {
        habitNameValue = textField.text
    }
    
    @objc
    private func saveTapped() {
        saveHabit(title: habitNameValue ?? "Без названия", timeString: timeStringValue, color: colorValue)
    }

    private func saveHabit(title: String, timeString: String, color: UIColor) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_gb")
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let time = formatter.date(from: timeString)!
        let newHabit = Habit(name: title, date: time, color: color)
        
        if habit != nil {
            if let i = HabitsStore.shared.habits.firstIndex(where: { $0 === habit }) {
                HabitsStore.shared.habits[i].name = title
                HabitsStore.shared.habits[i].date = time
                HabitsStore.shared.habits[i].color = color
            }
        }
        else {
            HabitsStore.shared.habits.append(newHabit)
        }
        closeView()
    }

    @objc
    private func makeColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = UIColor(named: "MyOrange") ?? .systemOrange
        colorPicker.supportsAlpha = true
        colorPicker.title = "Выберите цвет"
        present(colorPicker, animated: true, completion: nil)
    }
    
    private func setTime() {
        var time = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_gb")
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        if habit != nil {
            time = habit!.date
        }
        
        timeStringValue = formatter.string(from: time)
        pickedHabitTime.text = timeStringValue

        
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.addTarget(self, action: #selector(timePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        pickedHabitTime.inputView = timePicker
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        toolbar.tintColor = UIColor(named: "MyPurple")
        pickedHabitTime.inputAccessoryView = toolbar
    }
    
    @objc
    private func donePressed() {
        self.view.endEditing(true)
    }
    
    @objc
    private func timePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_gb")
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        timeStringValue = formatter.string(from: sender.date)
        pickedHabitTime.text = timeStringValue
    }
    
    @objc
    private func closeView() {
        dismiss(animated: true, completion: onWillDismiss)
    }
    
    @objc
    func deleteHabitAlert(_ sender: UIButton) {
        var alertMessage: String
        
        if habitNameValue == nil {
            alertMessage = "Вы хотите удалить привычку?"
        } else {
            alertMessage = "Вы хотите удалить привычку \"" + habitNameValue! + "\"?"
        }

        let alert = UIAlertController(title: "Удалить привычку", message: alertMessage, preferredStyle: .alert)

        alert.addAction(
            UIAlertAction(
                title: "Отмена",
                style: .cancel,
                handler: nil
            )
        )

        alert.addAction(
            UIAlertAction(
                title: "Удалить",
                style: .destructive,
                handler: { (_) in
                    self.deleteHabit()
                }
            )
        )

        present(alert, animated: true)
    }
    
    private func deleteHabit() {
        if habit != nil {
            if let i = HabitsStore.shared.habits.firstIndex(where: { $0 === habit }) {
                HabitsStore.shared.habits.remove(at: i)
                isDeleted = true
                closeView()
            }
        } else {
            closeView()
        }
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        let leading: CGFloat = 16
        let trailing: CGFloat = -16
        let defaultConstraint1: CGFloat = 7
        let defaultConstraint2: CGFloat = 15
        let top: CGFloat = 21
        let bottom: CGFloat = -18
        
        NSLayoutConstraint.activate([
            habitNameTitle.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: top),
            habitNameTitle.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: leading),
            habitNameTitle.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: trailing),
            
            setHabitNameValue.topAnchor.constraint(equalTo: habitNameTitle.bottomAnchor, constant: defaultConstraint1),
            setHabitNameValue.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: leading),
            setHabitNameValue.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: trailing),
            
            habitColorTitle.topAnchor.constraint(equalTo: setHabitNameValue.bottomAnchor, constant: defaultConstraint2),
            habitColorTitle.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: leading),
            habitColorTitle.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: trailing),
            
            setColorValue.topAnchor.constraint(equalTo: habitColorTitle.bottomAnchor, constant: defaultConstraint1),
            setColorValue.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: leading),
            setColorValue.heightAnchor.constraint(equalToConstant: 30),
            setColorValue.widthAnchor.constraint(equalToConstant: 30),
            
            habitTimeTitle.topAnchor.constraint(equalTo: setColorValue.bottomAnchor, constant: defaultConstraint2),
            habitTimeTitle.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: leading),
            habitTimeTitle.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: trailing),
            
            habitTimeText.topAnchor.constraint(equalTo: habitTimeTitle.bottomAnchor, constant: defaultConstraint1),
            habitTimeText.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: leading),
            
            pickedHabitTime.topAnchor.constraint(equalTo: habitTimeTitle.bottomAnchor, constant: defaultConstraint1),
            pickedHabitTime.leadingAnchor.constraint(equalTo: habitTimeText.trailingAnchor, constant: 0),
            pickedHabitTime.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: trailing),
            
            deleteHabitButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: bottom),
            deleteHabitButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: leading),
            deleteHabitButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: trailing),
            ])
    }

}

extension HabitViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorValue = viewController.selectedColor
        setColorValue.backgroundColor = colorValue
    }
}
