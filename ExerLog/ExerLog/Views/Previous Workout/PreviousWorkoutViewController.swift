//
//  PreviousWorkoutViewController.swift
//  ExerLog
//
//  Created by kalle hålldén on 2018-11-18.
//  Copyright © 2018 kalle hålldén. All rights reserved.
//

import UIKit

class PreviousWorkoutViewController: UIViewController {

    private static var workout: Workout!
    let saver = Saver()
    
    func setWorkout(workout1: Workout) {
        print("This is the exercises: \(workout1.getExercises().count)")
        PreviousWorkoutViewController.workout = workout1
    }
    
    func getWorkout() -> Workout {
        return PreviousWorkoutViewController.workout
    }
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false;
        return view
    }()
    private var rows = [[UITextField]]()
    
    private let viewScroller: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false;
        return view
    }()
    
    private var masterStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var rowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.heightAnchor.constraint(equalToConstant: 250).isActive = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        
        return scroll
    }()
    
    func statButton() -> UIButton {
        let button:UIButton = {
            let btn = UIButton(type:.system)
            btn.backgroundColor = Colors.greens
            btn.setTitle("Total Volume: 0.0", for: .normal)
            btn.tintColor = Colors.grey
            btn.layer.cornerRadius = 0
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
        }()
        return button
    }
    private var statButt = UIButton()
    
    private func setStatBut() {
        self.statButt = statButton()
    }
    
    func getButton() -> UIButton {
        return statButt
    }
    
    func autoLayoutConstraint() {
        contentView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        contentView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //contentView.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
        contentView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.backgroundColor = Colors.grey
        let master = setUpMasterStack()
        contentView.addSubview(master)
        master.topAnchor.constraint(equalTo: contentView.topAnchor, constant: view.frame.height * 0.12).isActive = true
        master.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        master.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        master.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
    }

    
    func addButton() -> UIButton {
        let button:UIButton = {
            let btn = UIButton(type:.system)
            if (TabBarViewController.theme.getTheme()) {
                btn.backgroundColor = Colors.grey
                btn.tintColor = Colors.greens
            } else {
                btn.backgroundColor = Colors.grey
                btn.tintColor = Colors.greens
            }
            btn.layer.cornerRadius = 15
            btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
        }()
        return button
    }
    
    func barButton() -> UIBarButtonItem {
        let button:UIBarButtonItem = {
            let btn = UIBarButtonItem()
            btn.tintColor = Colors.greens
            btn.target = self
            return btn
        }()
        return button
    }
    
    private var topStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func topRow() -> UIStackView {
        let filler = addButton()
        filler.backgroundColor = Colors.greens
        
        let stack = topStack
        let add = addButton()
        
        let save = barButton()
        let delete = barButton()
        
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = save
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = delete
        //add.setBackgroundImage(#imageLiteral(resourceName: "addIcon12"), for: .normal)
        add.setImage(#imageLiteral(resourceName: "addIcon12"), for: .normal)
//        add.titleLabel?.font = UIFont.boldSystemFont(ofSize: 50.0)
        add.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        save.title = "Done"
        save.action = #selector(self.saveAction)
        delete.title = "Delete"
        delete.action = #selector(self.deleteAction)
    
        stack.addArrangedSubview(add)
        
        return stack
    }
    
    func setUpMasterStack() -> UIStackView {
//
//        var num = 0
//        for subview in masterStackView.arrangedSubviews {
//            masterStackView.removeArrangedSubview(subview)
//            subview.removeFromSuperview()
//            num += 1
//            print("This is num: \(num)")
//        }
        
        setStatBut()
        let statbutton = getButton()
        statbutton.titleLabel?.font = UIFont(name: "Avenir next", size: 20.0)!
        statbutton.addTarget(self, action: #selector(statAction), for: .touchUpInside)
        
        let top = topRow()
        masterStackView.addArrangedSubview(statbutton)
        
        let labelRow = createRowOfLabels()
        masterStackView.addArrangedSubview(labelRow)
        
        print(getWorkout().getExercises().count)
        for exercise in getWorkout().getExercises() {
            let row = setUpRowOfTextFields(exercise: exercise)
            rowStack.addArrangedSubview(row)
        }
        scrollView.addSubview(rowStack)
        rowStack.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        rowStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        rowStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        rowStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        rowStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        rowStack.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        rowStack.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        scrollView.isScrollEnabled = true
        
        masterStackView.addArrangedSubview(scrollView)
        masterStackView.addArrangedSubview(top)
        //let addbutton = addButton()
        // addbutton.addTarget(self, action: #selector(action), for: .touchUpInside)
        //masterStackView.addArrangedSubview(addbutton)
        
        return masterStackView
    }
    func setupStackViewHorizontal(stackview: UIStackView) {
        stackview.alignment = .center
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        stackview.spacing = 5
        stackview.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setUpTextFields(textField: UITextField) {
        print("We are in")
        let colors = Colors()
        textField.backgroundColor = Colors.grey
        
        textField.setBottomBorder(isDark: colors.isDarkTheme(), lineColor: Colors.greens!)
        //textField.borderStyle = .none
        textField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        textField.textColor = Colors.greens
        textField.font = UIFont.boldSystemFont(ofSize: 17)
        textField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setUpRowOfTextFields(exercise: Exercise) -> UIStackView {
        let widtdthTextField = (view.frame.width - 100) / 5
        let stackview = UIStackView()
        let stackview2 = UIStackView()
        let stackview3 = UIStackView()
        var textFieldArray = [UITextField]()
        
        let textfield1 = textfieldMaker()
        textfield1.widthAnchor.constraint(equalToConstant: 100)
        textFieldArray.append(textfield1)
        textfield1.text = exercise.getName()
        for num in 1...4 {
            let textField = textfieldMaker()
            textField.textAlignment = .center
            
            if (num < 3) {
                stackview2.addArrangedSubview(textField)
                if (num == 1) {
                    textField.text = String(exercise.getReps())
                } else if (num == 2) {
                    textField.text = String(exercise.getSets())
                }
            } else {
                stackview3.addArrangedSubview(textField)
                if (num == 3) {
                    textField.text = String(exercise.getWeight())
                } else if (num == 4) {
                    textField.text = String(exercise.getRest())
                }
            }
            textFieldArray.append(textField)
            textField.widthAnchor.constraint(equalToConstant: widtdthTextField)
        }
        setupStackViewHorizontal(stackview: stackview2)
        setupStackViewHorizontal(stackview: stackview3)
        setupStackViewHorizontal(stackview: stackview)
        
        stackview.addArrangedSubview(textfield1)
        stackview.addArrangedSubview(stackview2)
        stackview.addArrangedSubview(stackview3)
        rows.append(textFieldArray)
        
        return stackview
    }
    
    func startWorkout() {
        for row in rowStack.arrangedSubviews {
            rowStack.removeArrangedSubview(row)
            row.removeFromSuperview()
        }
        rows.removeAll()
        autoLayoutConstraint()
    }
    
    
    func addNewExercise(exerciseNum: Int) {
        getWorkout().clearExercises()
        for array in rows {
            getWorkout().addNewExercise(name: array[0].text!, reps: array[1].text!, sets: array[2].text!, weight: array[3].text!, rest: array[4].text!)
        }
        print(getWorkout().getExercises().count)
        print(getWorkout().getTotalReps())
    }
    
    var rowCount = 1;
    func addRow() {
        let row = createRowOfTextFields()
        rowStack.addArrangedSubview(row)
        addNewExercise(exerciseNum: rowCount)
        rowCount += 1
    }
    
    func textfieldMaker() -> UITextField {
        let thisTextField: UITextField = {
            let txtField = UITextField()
            txtField.heightAnchor.constraint(equalToConstant: 25).isActive = true
            setUpTextFields(textField: txtField)
            txtField.translatesAutoresizingMaskIntoConstraints = false
            
            return txtField
        }()
        return thisTextField
    }
    
    // UI element creation
    
    // Creates and returns a stackview containing five textfields which represent one row in the
    // addWorkoutView
    func createRowOfTextFields() -> UIStackView {
        let widtdthTextField = (view.frame.width - 100) / 5
        let stackview = UIStackView()
        let stackview2 = UIStackView()
        let stackview3 = UIStackView()
        var textFieldArray = [UITextField]()
        
        let textfield = textfieldMaker()
        textfield.widthAnchor.constraint(equalToConstant: 100)
        textFieldArray.append(textfield)
        for num in 1...4 {
            let textField = textfieldMaker()
            textField.textAlignment = .center
            if (num < 3) {
                stackview2.addArrangedSubview(textField)
            } else {
                stackview3.addArrangedSubview(textField)
            }
            textFieldArray.append(textField)
            textField.widthAnchor.constraint(equalToConstant: widtdthTextField)
        }
        setupStackViewHorizontal(stackview: stackview2)
        setupStackViewHorizontal(stackview: stackview3)
        setupStackViewHorizontal(stackview: stackview)
        
        stackview.addArrangedSubview(textfield)
        stackview.addArrangedSubview(stackview2)
        stackview.addArrangedSubview(stackview3)
        rows.append(textFieldArray)
        
        return stackview
    }
    
    // returns a stackview that contains a row of labels which describe the textfields
    func createRowOfLabels() -> UIStackView {
        let stackview = UIStackView()
        let stackview2 = UIStackView()
        let stackview3 = UIStackView()
        for num in 1...5 {
            let label = UILabel()
            label.font = UIFont(name: "Avenir next", size: 16.0)!
            if (num == 1) {
                label.text = "Exercise"
                stackview.addArrangedSubview(label)
            }
            if (num == 2) {
                label.text = "Reps"
                stackview2.addArrangedSubview(label)
            }
            if (num == 3) {
                label.text = "Sets"
                stackview2.addArrangedSubview(label)
            }
            if (num == 4) {
                label.text = "Weight"
                stackview3.addArrangedSubview(label)
            }
            if (num == 5) {
                label.text = "Rest"
                stackview3.addArrangedSubview(label)
            }
            label.textColor = Colors.whites
        }
        setupStackViewHorizontal(stackview: stackview2)
        setupStackViewHorizontal(stackview: stackview3)
        setupStackViewHorizontal(stackview: stackview)
        
        stackview.addArrangedSubview(stackview2)
        stackview.addArrangedSubview(stackview3)
        return stackview
    }
    
    // Actions
    var clickcount = 0
    
   // Code for the add button below the rows of exercises
    @objc func addAction(sender:UIButton!) {
            addRow()
            changeStatLabel(button: getButton())
    }
    
    @objc func backAction(sender:UIButton!) {
        regSegue()
    }
    
 @objc func saveAction()  {
        getWorkout().clearExercises()
        for array in rows {
            if (!checkIfEmpty(array: array)) {
                getWorkout().addNewExercise(name: array[0].text!, reps: array[1].text!, sets: array[2].text!, weight: array[3].text!, rest: array[4].text!)
            }
        }
        saveWorkout(workout: getWorkout())
        regSegue()
    }
    
    func checkIfEmpty(array: [UITextField]) -> Bool {
        for field in array {
                if (!field.text!.isEmpty) {
                    return false
                }
        }
        return true
    }
    
    @objc func deleteAction() {
        deleteWorkout(workout1: getWorkout())

    }
    
    func deleteWorkout(workout1: Workout) {
        let log = TabBarViewController.workoutLog
        let index = log.getWorkoutList().firstIndex(of: workout1)
        log.removeWorkoutAt(index: index!)
        let tab = TabBarViewController()
        saver.deleteOldFile(path: saver.getPathWorkout())
        tab.setWorkoutList(log: log)
        saver.save(path: saver.getPathWorkout())
        regSegue()
    }
    
    func regSegue(){
        let page = NavigationViewController()
        present(page, animated: true, completion: nil)
    }
    

    
    func changeStatLabel(button: UIButton) {
        //let button = getButton()
        if (clickcount == 0) {
            print("hello")
            button.setTitle("Total Volume: \(getWorkout().getTotalReps())", for: .normal)
        } else if (clickcount == 1) {
            button.setTitle("Total Load: \(getWorkout().getTotalWeight())kg", for: .normal)
        } else {
            button.setTitle("Total sets: \(getWorkout().getTotalSets())", for: .normal)
        }
    }
    
    @objc func statAction(sender:UIButton!) {
        if (clickcount == 0) {
            clickcount += 1
            sender.setTitle("Total Load: \(getWorkout().getTotalWeight())kg", for: .normal)
        } else if (clickcount == 1) {
            sender.setTitle("Total sets: \(getWorkout().getTotalSets())", for: .normal)
            clickcount += 1
        } else {
            sender.setTitle("Total Volume: \(getWorkout().getTotalReps())", for: .normal)
            clickcount = 0
        }
    }
    
    @objc func save() {
        let tab = TabBarViewController()
        saver.deleteOldFile(path: saver.getPathWorkout())
        let bar = BarChartViewController()
        bar.setFresh(hasbeenLaunched: false)
        bar.setDiaryLaunch(hasbeenLaunched: true)
        saveWorkout(workout: getWorkout())
    }
    
    @objc func add() {
        addRow()
        changeStatLabel(button: getButton())
    }
    
    func saveWorkout(workout: Workout) {
        print("Hey you")
        if (workout.getExercises().count != 0 && workout.getTotalReps() != 0) {
            let log = TabBarViewController.workoutLog
            print("total workouts: \(log.getWorkoutList().count)")
            let tab = TabBarViewController()
            saver.deleteOldFile(path: saver.getPathWorkout())
            tab.setWorkoutList(log: log)
            saver.save(path: saver.getPathWorkout())
            
            for wout in TabBarViewController.workoutLog.getWorkoutList() {
                print("reps: \(wout.getTotalReps())")
                print("Date: \(wout.getDate())")
            }
        }
    }
    
    func saveButton() -> UIBarButtonItem {
        let button:UIBarButtonItem = {
            let btn = UIBarButtonItem()
            btn.title = "Save"
            btn.tintColor = Colors.greens
            btn.action = #selector(self.save)
            btn.target = self
            return btn
        }()
        return button
    }
    
    func adderButton() -> UIBarButtonItem {
        let button:UIBarButtonItem = {
            let btn = UIBarButtonItem()
            btn.title = "add"
            //btn.image = #imageLiteral(resourceName: "addIcon")
            btn.tintColor = Colors.greens
            btn.action = #selector(self.add)
            btn.target = self
            return btn
        }()
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.addSubview(contentView)
        self.navigationItem.title = "Date: \(getWorkout().getDate())"
        let textAttributes = [NSAttributedStringKey.foregroundColor: Colors.darkGreen]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        startWorkout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

