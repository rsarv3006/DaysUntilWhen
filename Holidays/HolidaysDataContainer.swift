import SwiftUI
import SwiftData

struct HolidaysDataContainerViewModifier: ViewModifier {
    let container: ModelContainer
    
    init(inMemory: Bool) {
        container = try! ModelContainer(for: DataGeneration.schema, configurations: [ModelConfiguration(isStoredInMemoryOnly: inMemory)])
    }
    
    func body(content: Content) -> some View {
        content
            .generateData()
            .modelContainer(container)
    }
}

struct GenerateDataViewModifier: ViewModifier {
    @Environment(\.modelContext) private var modelContext
    
    func body(content: Content) -> some View {
        content.onAppear {
            DataGeneration.generateAllData(context: modelContext)
        }
    }
}

public extension View {
    func holidaysDataContainer(inMemory: Bool = DataGenerationOptions.inMemoryPersistence) -> some View {
        modifier(HolidaysDataContainerViewModifier(inMemory: inMemory))
    }
}

fileprivate extension View {
    func generateData() -> some View {
        modifier(GenerateDataViewModifier())
    }
}
