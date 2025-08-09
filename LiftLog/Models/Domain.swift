import Foundation
import SwiftData

// MARK: - Exercise Models
@Model
class Exercise {
    var id: UUID
    var name: String
    var category: ExerciseCategory
    var oneRM: Double?
    var notes: String
    
    init(name: String, category: ExerciseCategory, oneRM: Double? = nil) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.oneRM = oneRM
        self.notes = ""
    }
}

enum ExerciseCategory: String, CaseIterable, Codable, Hashable {
    case chest = "Chest"
    case back = "Back"
    case shoulders = "Shoulders"
    case biceps = "Biceps"
    case triceps = "Triceps"
    case legs = "Legs"
    case core = "Core"
    case cardio = "Cardio"
    
    var icon: String {
        switch self {
        case .chest: return "heart.fill"
        case .back: return "figure.strengthtraining.traditional"
        case .shoulders: return "figure.arms.open"
        case .biceps: return "figure.strengthtraining.functional"
        case .triceps: return "figure.strengthtraining.traditional"
        case .legs: return "figure.walk"
        case .core: return "figure.core.training"
        case .cardio: return "heart.circle.fill"
        }
    }
}

// MARK: - Workout Models
@Model
class Workout {
    var id: UUID
    var date: Date
    var exercises: [WorkoutExercise]
    var notes: String
    var duration: TimeInterval?
    
    init(date: Date = Date(), exercises: [WorkoutExercise] = []) {
        self.id = UUID()
        self.date = date
        self.exercises = exercises
        self.notes = ""
    }
}

@Model
class WorkoutExercise {
    var id: UUID
    var exercise: Exercise
    var sets: [ExerciseSet]
    
    init(exercise: Exercise, sets: [ExerciseSet] = []) {
        self.id = UUID()
        self.exercise = exercise
        self.sets = sets
    }
}

@Model
class ExerciseSet {
    var id: UUID
    var weight: Double
    var reps: Int
    var isCompleted: Bool
    var notes: String
    
    init(weight: Double, reps: Int) {
        self.id = UUID()
        self.weight = weight
        self.reps = reps
        self.isCompleted = false
        self.notes = ""
    }
}

// MARK: - One RM Calculation
extension Exercise {
    func calculateOneRM() -> Double? {
        guard let oneRM = oneRM else { return nil }
        return oneRM
    }
    
    func updateOneRM(from sets: [ExerciseSet]) {
        guard let maxSet = sets.max(by: { $0.weight < $1.weight }) else { return }
        let estimatedOneRM = maxSet.weight * (1 + Double(maxSet.reps) / 30.0)
        self.oneRM = estimatedOneRM
    }
}
