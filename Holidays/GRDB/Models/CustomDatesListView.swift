import SwiftUI
import GRDB

// MARK: - Main View

struct CustomDatesListView: View {
    @EnvironmentObject private var storekitStore: StorekitStore

    private let appDatabase: AppDatabase

    @State private var holidays: [GRDBHoliday] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var showingAdd: Bool = false

    init(appDatabase: AppDatabase) {
        self.appDatabase = appDatabase
    }

    var body: some View {
        ZStack {
            NavigationStack {
                Group {
                    if isLoading {
                        ProgressView("Loading…")
                    } else if holidays.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "calendar.badge.plus")
                                .font(.system(size: 40))
                                .foregroundColor(.secondary)
                            Text("No custom dates yet")
                                .font(.headline)
                            Text("Tap the + to add your first custom date.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 60)
                    } else {
                        List {
                            ForEach(holidays) { holiday in
                                HStack(spacing: 12) {
                                    Image(systemName: holiday.icon)
                                        .foregroundStyle(.tint)
                                    VStack(alignment: .leading) {
                                        Text(holiday.name)
                                            .font(.headline)
                                        if let date = holiday.date {
                                            Text(date.formatted(date: .abbreviated, time: .omitted))
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            .onDelete(perform: delete)
                        }
                        .listStyle(.insetGrouped)
                    }
                }
                .navigationTitle("Custom Dates")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button { showingAdd = true } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAdd, onDismiss: { Task { await load() } }) {
                    NavigationStack {
                        CustomDateScreen()
                    }
                }
                .task { await load() }
                .alert("Error", isPresented: Binding(get: { errorMessage != nil }, set: { _ in errorMessage = nil })) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(errorMessage ?? "Unknown error")
                }
            }

            PremiumFeatureOverlayView(message: "To create and track custom dates, please purchase the unlock feature from the settings screen.")
        }
    }

    private func load() async {
        isLoading = true
        errorMessage = nil
        do {
            let items: [GRDBHoliday] = try await appDatabase.dbWriter.read { db in
                try GRDBHoliday
                    .filter(GRDBHoliday.Columns.variant == HolidayVariant.custom)
                    .order(GRDBHoliday.Columns.id.desc)
                    .fetchAll(db)
            }
            await MainActor.run { holidays = items }
        } catch {
            await MainActor.run { errorMessage = error.localizedDescription }
        }
        isLoading = false
    }

    private func delete(at offsets: IndexSet) {
        Task {
            let idsToDelete = offsets.map { holidays[$0].id }
            do {
                try await appDatabase.dbWriter.write { db in
                    for id in idsToDelete {
                        try GRDBHoliday.deleteOne(db, key: id)
                    }
                }
                await load()
            } catch {
                await MainActor.run { errorMessage = error.localizedDescription }
            }
        }
    }
}

#Preview {
    // Provide your AppDatabase instance here, for example from a preview factory or in-memory database.
    // CustomDatesListView(appDatabase: .preview)
    Text("CustomDatesListView Preview requires an AppDatabase instance")
}
