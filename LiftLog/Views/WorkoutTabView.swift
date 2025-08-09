import SwiftUI

struct WorkoutTabView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("Начать тренировку") { StartWorkoutView() }
                }
            }
            .navigationTitle("Тренировки")
        }
    }
}
