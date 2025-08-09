import Foundation

// MARK: - One RM Calculation Service
class OneRMService {
    static let shared = OneRMService()
    
    private init() {}
    
    // Brzycki Formula: 1RM = weight × (36 / (37 - reps))
    func calculateBrzycki(weight: Double, reps: Int) -> Double {
        guard reps > 0 && reps <= 10 else { return weight }
        return weight * (36.0 / (37.0 - Double(reps)))
    }
    
    // Epley Formula: 1RM = weight × (1 + reps/30)
    func calculateEpley(weight: Double, reps: Int) -> Double {
        guard reps > 0 else { return weight }
        return weight * (1.0 + Double(reps) / 30.0)
    }
    
    // Lombardi Formula: 1RM = weight × reps^0.1
    func calculateLombardi(weight: Double, reps: Int) -> Double {
        guard reps > 0 else { return weight }
        return weight * pow(Double(reps), 0.1)
    }
    
    // Average of multiple formulas for better accuracy
    func calculateOneRM(weight: Double, reps: Int) -> Double {
        guard reps > 0 else { return weight }
        
        let brzycki = calculateBrzycki(weight: weight, reps: reps)
        let epley = calculateEpley(weight: weight, reps: reps)
        let lombardi = calculateLombardi(weight: weight, reps: reps)
        
        return (brzycki + epley + lombardi) / 3.0
    }
    
    // Calculate percentage of 1RM
    func calculatePercentage(oneRM: Double, percentage: Double) -> Double {
        return oneRM * (percentage / 100.0)
    }
    
    // Get recommended weight for target reps at given percentage
    func getRecommendedWeight(oneRM: Double, targetReps: Int, percentage: Double) -> Double {
        let targetWeight = calculatePercentage(oneRM: oneRM, percentage: percentage)
        
        // Adjust based on rep range
        let adjustmentFactor: Double
        switch targetReps {
        case 1...3:
            adjustmentFactor = 1.0
        case 4...6:
            adjustmentFactor = 0.95
        case 7...10:
            adjustmentFactor = 0.90
        case 11...15:
            adjustmentFactor = 0.85
        default:
            adjustmentFactor = 0.80
        }
        
        return targetWeight * adjustmentFactor
    }
    
    // Calculate training zones
    enum TrainingZone: String, CaseIterable {
        case strength = "Strength"
        case hypertrophy = "Hypertrophy"
        case endurance = "Endurance"
        case power = "Power"
        
        var percentageRange: ClosedRange<Double> {
            switch self {
            case .strength: return 85...95
            case .hypertrophy: return 70...85
            case .endurance: return 50...70
            case .power: return 80...90
            }
        }
        
        var repRange: ClosedRange<Int> {
            switch self {
            case .strength: return 1...5
            case .hypertrophy: return 6...12
            case .endurance: return 12...20
            case .power: return 1...3
            }
        }
        
        var color: String {
            switch self {
            case .strength: return "red"
            case .hypertrophy: return "orange"
            case .endurance: return "green"
            case .power: return "purple"
            }
        }
    }
    
    func getTrainingZone(for percentage: Double) -> TrainingZone? {
        return TrainingZone.allCases.first { zone in
            zone.percentageRange.contains(percentage)
        }
    }
}
