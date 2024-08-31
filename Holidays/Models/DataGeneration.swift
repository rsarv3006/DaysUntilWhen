import Observation
import SwiftData
import OSLog

private let logger = Logger(subsystem: "BackyardBirdsData", category: "DataGeneration")

// MARK: - Data Generation

@Model public class DataGeneration {
    public var initializationDate: Date?
    public var lastSimulationDate: Date?
    
    public var requiresInitialDataGeneration: Bool {
        initializationDate == nil
    }
    
    public init(initializationDate: Date?, lastSimulationDate: Date?, includeEarlyAccessSpecies: Bool = false) {
        self.initializationDate = initializationDate
        self.lastSimulationDate = lastSimulationDate
    }
    
    private func simulateHistoricalEvents(context: ModelContext) throws {
        try generateInitialData(context: context)
    }
    
    private func generateInitialData(context: ModelContext) throws {
        logger.info("Generating initial data...")
        
        try loadBackgroundOptions(modelContext: context)
        try loadTextOptions(context: context)
        try loadDisplayOptions(context: context)
        try loadInitialHolidays(context: context)
        
        try deleteHolidaysInThePast(modelContext: context)
        
        logger.info("Completed generating initial data")
        initializationDate = .now
    }
    
    private static func instance(with modelContext: ModelContext) -> DataGeneration {
        if let result = try! modelContext.fetch(FetchDescriptor<DataGeneration>()).first {
            return result
        } else {
            let instance = DataGeneration(
                initializationDate: nil,
                lastSimulationDate: nil
            )
            modelContext.insert(instance)
            return instance
        }
    }
    
    public static func generateAllData(context: ModelContext) {
        let instance = instance(with: context)
        logger.info("Attempting to statically simulate historical events...")
        do {
            try instance.simulateHistoricalEvents(context: context)
        } catch {
            logger.error("Failed to simulate historical events: \(error.localizedDescription)")
        }
        
    }
}

public extension DataGeneration {
    static let container = try! ModelContainer(for: schema, configurations: [.init(isStoredInMemoryOnly: DataGenerationOptions.inMemoryPersistence)])
    
    static let schema = SwiftData.Schema([
        DataGeneration.self,
        Holiday.self,
        HolidayDisplayOptions.self,
        BackgroundOption.self,
        TextOption.self
    ])
}
