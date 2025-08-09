import Foundation
import SwiftData

func weekStart(_ date: Date) -> Date {
    var cal = Calendar.current
    cal.firstWeekday = 2 // Monday
    let comps = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
    return cal.date(from: comps) ?? Calendar.current.startOfDay(for: date)
}

func current1RM(ctx: ModelContext, exercise: Exercise) -> Double? {
    let since = Calendar.current.date(byAdding: .day, value: -60, to: Date())!
    
    // Fetch all workouts with this exercise
    let workoutFD = FetchDescriptor<Workout>(predicate: #Predicate { workout in
        workout.date >= since
    })
    let workouts = (try? ctx.fetch(workoutFD)) ?? []
    
    var allSets: [(weight: Double, reps: Int)] = []
    
    for workout in workouts {
        for workoutExercise in workout.exercises {
            if workoutExercise.exercise.id == exercise.id {
                for set in workoutExercise.sets {
                    if set.reps >= 1 && set.reps <= 10 {
                        allSets.append((weight: set.weight, reps: set.reps))
                    }
                }
            }
        }
    }
    
    return medianOneRM(from: allSets)
}

func weeklyVolume(ctx: ModelContext, lastWeeks: Int = 6) -> [(Date, Double)] {
    let fd = FetchDescriptor<Workout>()
    let workouts = (try? ctx.fetch(fd)) ?? []
    var dict: [Date: Double] = [:]
    
    for workout in workouts {
        let key = weekStart(workout.date)
        var weeklyVolume: Double = 0
        
        for workoutExercise in workout.exercises {
            for set in workoutExercise.sets {
                weeklyVolume += set.weight * Double(set.reps)
            }
        }
        
        dict[key, default: 0] += weeklyVolume
    }
    
    let sorted = dict.keys.sorted(by: <)
    let last = Array(sorted.suffix(lastWeeks))
    return last.map { ($0, dict[$0] ?? 0) }
}

func medianOneRM(from pairs: [(weight: Double, reps: Int)]) -> Double? {
    guard !pairs.isEmpty else { return nil }
    let oneRMs = pairs.map { pair in
        OneRMService.shared.calculateEpley(weight: pair.weight, reps: pair.reps)
    }
    let sorted = oneRMs.sorted()
    let mid = sorted.count / 2
    if sorted.count % 2 == 0 {
        return (sorted[mid - 1] + sorted[mid]) / 2
    } else {
        return sorted[mid]
    }
}
