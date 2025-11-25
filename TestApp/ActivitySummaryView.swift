import SwiftUI

struct ActivitySummaryView: View {
    @EnvironmentObject var hk: HealthKitManager

    var body: some View {
        HStack(spacing: 30) {
            VStack {
                ActivityRingView(progress: min(hk.todayActiveEnergy / 500, 1), color: .red)
                    .frame(width: 80, height: 80)
                Text("Move")
            }

            VStack {
                ActivityRingView(progress: min(hk.todayExerciseMinutes / 30, 1), color: .green)
                    .frame(width: 80, height: 80)
                Text("Exercise")
            }

            VStack {
                ActivityRingView(progress: min(Double(hk.todaySteps) / 10000, 1), color: .blue)
                    .frame(width: 80, height: 80)
                Text("Steps")
            }
        }
    }
}
