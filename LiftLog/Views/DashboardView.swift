import SwiftUI
import SwiftData
import Charts

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingStartWorkout = false
    @Query private var exercises: [Exercise]
    @Query private var workouts: [Workout]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("LiftLog")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Text("Track your progress")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showingStartWorkout = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                    
                    // KPI Cards
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Key Metrics")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            KPICard(title: "Bench 1RM", value: format1RM(for: "Bench Press"))
                            KPICard(title: "Squat 1RM", value: format1RM(for: "Squat"))
                            KPICard(title: "Deadlift 1RM", value: format1RM(for: "Deadlift"))
                            KPICard(title: "Body Weight", value: "—")
                        }
                        .padding(.horizontal)
                    }
                    
                    // Weekly Volume Chart
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Weekly Volume")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        let volumeData = weeklyVolume(ctx: modelContext, lastWeeks: 6)
                        if !volumeData.isEmpty {
                            Chart(volumeData, id: \.0) { week, volume in
                                BarMark(
                                    x: .value("Week", week, unit: .weekOfYear),
                                    y: .value("Volume", volume)
                                )
                                .foregroundStyle(.blue.gradient)
                            }
                            .frame(height: 200)
                            .padding(.horizontal)
                        } else {
                            Text("No volume data available")
                                .foregroundColor(.secondary)
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .background(.thinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .padding(.horizontal)
                        }
                    }
                    
                    // Quick Start Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Быстрый старт")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        Button(action: {
                            showingStartWorkout = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                Text("Начать тренировку")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                            }
                            .padding()
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                    }
                    
                    // Recent Workouts
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Workouts")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(workouts.prefix(3), id: \.id) { workout in
                                WorkoutCard(
                                    date: workout.date,
                                    exercises: workout.exercises.map { $0.exercise.name },
                                    duration: formatDuration(workout.duration)
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingStartWorkout) {
            StartWorkoutView()
        }
        .onAppear {
            seedIfEmpty()
        }
    }
    
    private func format1RM(for exerciseName: String) -> String {
        guard let exercise = exercises.first(where: { $0.name.localizedCaseInsensitiveContains(exerciseName) }) else {
            return "—"
        }
        
        if let oneRM = current1RM(ctx: modelContext, exercise: exercise) {
            return String(format: "%.0f kg", oneRM)
        } else {
            return "—"
        }
    }
    
    private func formatDuration(_ duration: TimeInterval?) -> String {
        guard let duration = duration else { return "N/A" }
        let minutes = Int(duration / 60)
        return "\(minutes) min"
    }
    
    private func seedIfEmpty() {
        if exercises.isEmpty {
            let benchPress = Exercise(name: "Bench Press", category: .chest)
            let squat = Exercise(name: "Squat", category: .legs)
            let deadlift = Exercise(name: "Deadlift", category: .legs)
            
            modelContext.insert(benchPress)
            modelContext.insert(squat)
            modelContext.insert(deadlift)
            
            try? modelContext.save()
        }
    }
}

struct WorkoutCard: View {
    let date: Date
    let exercises: [String]
    let duration: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(date, style: .date)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(date, style: .time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(duration)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(exercises, id: \.self) { exercise in
                    HStack {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 6))
                            .foregroundColor(.blue)
                        Text(exercise)
                            .font(.subheadline)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    DashboardView()
}
