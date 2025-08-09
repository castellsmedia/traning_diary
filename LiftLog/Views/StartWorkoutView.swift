import SwiftUI

struct StartWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var workout = Workout()
    @State private var selectedCategory: ExerciseCategory = .chest
    @State private var showingExercisePicker = false
    @State private var workoutStartTime = Date()
    @State private var isWorkoutActive = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(.blue)
                        
                        Spacer()
                        
                        Text("New Workout")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button("Start") {
                            startWorkout()
                        }
                        .foregroundColor(.blue)
                        .disabled(workout.exercises.isEmpty)
                    }
                    .padding(.horizontal)
                    
                    // Workout Timer
                    if isWorkoutActive {
                        WorkoutTimerView(startTime: workoutStartTime)
                    }
                }
                .padding(.top)
                
                // Exercise List
                if workout.exercises.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "dumbbell")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No exercises added")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Text("Tap the button below to add your first exercise")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .padding()
                } else {
                    List {
                        ForEach(workout.exercises.indices, id: \.self) { index in
                            WorkoutExerciseRow(
                                workoutExercise: $workout.exercises[index],
                                onDelete: {
                                    workout.exercises.remove(at: index)
                                }
                            )
                        }
                        .onMove(perform: moveExercises)
                    }
                }
                
                // Add Exercise Button
                VStack(spacing: 16) {
                    Divider()
                    
                    Button(action: {
                        showingExercisePicker = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                            Text("Add Exercise")
                                .font(.headline)
                        }
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingExercisePicker) {
            ExercisePickerView(
                selectedCategory: $selectedCategory,
                onExerciseSelected: { exercise in
                    addExercise(exercise)
                }
            )
        }
    }
    
    private func startWorkout() {
        workoutStartTime = Date()
        isWorkoutActive = true
        workout.date = Date()
    }
    
    private func addExercise(_ exercise: Exercise) {
        let workoutExercise = WorkoutExercise(exercise: exercise)
        workout.exercises.append(workoutExercise)
    }
    
    private func moveExercises(from source: IndexSet, to destination: Int) {
        workout.exercises.move(fromOffsets: source, toOffset: destination)
    }
}

struct WorkoutTimerView: View {
    let startTime: Date
    @State private var elapsedTime: TimeInterval = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Workout Time")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(timeString(from: elapsedTime))
                .font(.title2)
                .fontWeight(.bold)
                .monospacedDigit()
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
        .onReceive(timer) { _ in
            elapsedTime = Date().timeIntervalSince(startTime)
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

struct WorkoutExerciseRow: View {
    @Binding var workoutExercise: WorkoutExercise
    let onDelete: () -> Void
    @State private var showingSetEditor = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(workoutExercise.exercise.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(workoutExercise.exercise.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            
            if workoutExercise.sets.isEmpty {
                Button("Add Set") {
                    showingSetEditor = true
                }
                .foregroundColor(.blue)
            } else {
                VStack(spacing: 8) {
                    ForEach(workoutExercise.sets.indices, id: \.self) { index in
                        SetRow(set: $workoutExercise.sets[index])
                    }
                    
                    Button("Add Set") {
                        showingSetEditor = true
                    }
                    .foregroundColor(.blue)
                    .font(.caption)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .sheet(isPresented: $showingSetEditor) {
            SetEditorView { weight, reps in
                let newSet = ExerciseSet(weight: weight, reps: reps)
                workoutExercise.sets.append(newSet)
            }
        }
    }
}

struct SetRow: View {
    @Binding var set: ExerciseSet
    
    var body: some View {
        HStack {
            Text("Set \(set.id)")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 40, alignment: .leading)
            
            Text("\(Int(set.weight)) lbs")
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text("×")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("\(set.reps) reps")
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            Button(action: {
                set.isCompleted.toggle()
            }) {
                Image(systemName: set.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(set.isCompleted ? .green : .gray)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(set.isCompleted ? Color.green.opacity(0.1) : Color.clear)
        .cornerRadius(8)
    }
}

struct ExercisePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCategory: ExerciseCategory
    let onExerciseSelected: (Exercise) -> Void
    
    @State private var searchText = ""
    
    private let sampleExercises: [Exercise] = [
        Exercise(name: "Bench Press", category: .chest),
        Exercise(name: "Incline Bench Press", category: .chest),
        Exercise(name: "Decline Bench Press", category: .chest),
        Exercise(name: "Dumbbell Flyes", category: .chest),
        Exercise(name: "Pull-ups", category: .back),
        Exercise(name: "Deadlifts", category: .back),
        Exercise(name: "Barbell Rows", category: .back),
        Exercise(name: "Lat Pulldowns", category: .back),
        Exercise(name: "Overhead Press", category: .shoulders),
        Exercise(name: "Lateral Raises", category: .shoulders),
        Exercise(name: "Squats", category: .legs),
        Exercise(name: "Deadlifts", category: .legs),
        Exercise(name: "Leg Press", category: .legs),
        Exercise(name: "Bicep Curls", category: .biceps),
        Exercise(name: "Tricep Dips", category: .triceps)
    ]
    
    var filteredExercises: [Exercise] {
        if searchText.isEmpty {
            return sampleExercises.filter { $0.category == selectedCategory }
        } else {
            return sampleExercises.filter { exercise in
                exercise.category == selectedCategory &&
                exercise.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Category Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(ExerciseCategory.allCases, id: \.self) { category in
                            CategoryButton(
                                category: category,
                                isSelected: category == selectedCategory
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                Divider()
                
                // Exercise List
                List(filteredExercises, id: \.id) { exercise in
                    Button(action: {
                        onExerciseSelected(exercise)
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: exercise.category.icon)
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            
                            Text(exercise.name)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search exercises")
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CategoryButton: View {
    let category: ExerciseCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: category.icon)
                    .font(.title3)
                
                Text(category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : .blue)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

struct SetEditorView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (Double, Int) -> Void
    
    @State private var weight: Double = 135
    @State private var reps: Int = 8
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text("Weight")
                        .font(.headline)
                    
                    HStack {
                        Button("-") {
                            if weight > 0 { weight -= 5 }
                        }
                        .font(.title2)
                        .foregroundColor(.blue)
                        
                        Spacer()
                        
                        Text("\(Int(weight)) lbs")
                            .font(.title)
                            .fontWeight(.bold)
                            .monospacedDigit()
                        
                        Spacer()
                        
                        Button("+") {
                            weight += 5
                        }
                        .font(.title2)
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 40)
                }
                
                VStack(spacing: 16) {
                    Text("Reps")
                        .font(.headline)
                    
                    HStack {
                        Button("-") {
                            if reps > 1 { reps -= 1 }
                        }
                        .font(.title2)
                        .foregroundColor(.blue)
                        
                        Spacer()
                        
                        Text("\(reps)")
                            .font(.title)
                            .fontWeight(.bold)
                            .monospacedDigit()
                        
                        Spacer()
                        
                        Button("+") {
                            reps += 1
                        }
                        .font(.title2)
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 40)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Set")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(weight, reps)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    StartWorkoutView()
}
