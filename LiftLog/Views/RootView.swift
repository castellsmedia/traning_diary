import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Главная")
                }
            WorkoutTabView()
                .tabItem {
                    Image(systemName: "figure.strengthtraining.traditional")
                    Text("Тренировки")
                }
        }
    }
}
