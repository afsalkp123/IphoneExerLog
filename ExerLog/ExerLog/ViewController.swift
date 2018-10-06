

import UIKit

class ViewController: UIViewController {
    
    let grey = UIColor(red: 40, green: 40, blue: 45, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = grey
      
        
        
        let workout = Workout()
        workout.addNewExercise(name: "Bench Press", reps: "12", sets: "3", weight: "20,3kg", rest: "60s")
        workout.addNewExercise(name: "Deadlift", reps: "5", sets: "5", weight: "122,5kg", rest: "120s")
        workout.addNewExercise(name: "Squat", reps: "8", sets: "3", weight: "180kg", rest: "120s")
        
        print(workout.getExercises().count)
        let list = workout.getExercises()
        
        workout.setTotalWeight(listExercise: list)
        workout.setTotalReps(listExercise: list)
        workout.setTotalSets(listExercise: list)
        print("\(workout.getTotalWeight()) kg")
        print("\(workout.getTotalReps()) reps")
        print("\(workout.getTotalSets())  sets")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

