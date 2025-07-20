import GRDB
import GRDBQuery
import SwiftUI
import WidgetKit

struct WidgetPreviewView: View {
    @Environment(\.appDatabase) private var appDatabase
    
    @State var allHolidays: [GRDBHoliday] = []
    @State var backgroundOptions: [GRDBBackgroundOption] = []
    @State var textOptions: [GRDBTextOption] = []
    
    @State private var displayOptions: [GRDBHolidayDisplayOptions] = []
    
    @State private var selectedHoliday: GRDBHoliday = HolidayCreation.createChristmasHolidayModel(christmasTimeInterval: Date.christmas?.timeIntervalSince1970 ?? Date().timeIntervalSince1970)
    @State private var selectedBackground: GRDBBackgroundOption = .init(id: BackgroundOptionId.ChristmasBackground1.rawValue, type: .image)
    @State private var selectedText: GRDBTextOption = .init(id: TextOptionId.ChristmasRed.rawValue)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    WidgetPickers(
                        allHolidays: $allHolidays,
                        backgroundOptions: $backgroundOptions,
                        textOptions: $textOptions,
                        selectedHoliday: $selectedHoliday,
                        selectedBackground: $selectedBackground,
                        selectedText: $selectedText,
                        onHolidayChangeSaved: {
                           onHolidayChangeSaved()
                        }
                    )
                    .onChange(of: selectedHoliday) { _, _ in
                       selectedHolidayChanged()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                
                Text("Widget Preview")
                    .font(.title3)
                
                ZStack {
                    if let backgroundImage = selectedBackground.image {
                        backgroundImage
                            .styledBackgroundImageWidgetPreview()
                    } else if let backgroundColor =
                                selectedBackground.color
                    {
                        backgroundColor
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .shadow(radius: 10)
                            .frame(width: 200, height: 200)
                    }
                    
                    DaysUntilWidgetEntryView(entry: .init(date: Date(), holiday: selectedHoliday, background: selectedBackground, text: selectedText))
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        if let url = URL(string: "https://shiner.rjs-app-dev.us/") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Image(systemName: "pawprint.circle")
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("DaysUntilWhen")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            loadState()
            setupDatabaseObservation()
        }
    }
    
    private func loadState() {
        do {
            try appDatabase.dbWriter.write { db in
                let holidays = try appDatabase.getAllHolidays(in: db)
                let userEnabledHolidayEntities = try appDatabase.getAllUserEnableHolidayEntities(in: db)
                allHolidays = holidays
                backgroundOptions = try appDatabase.getAllBackgroundOptions(in: db)
                textOptions = try appDatabase.getAllTextOptions(in: db)
                
                displayOptions = try appDatabase.getAllDisplayOptions(in: db)
                
                if let foundHoliday = HolidaysUtils.getSelectedHoliday(holidays: holidays, date: Date(), userEnabledHolidays: userEnabledHolidayEntities) {
                    selectedHoliday = foundHoliday
                    let displayOption = try appDatabase.getDisplayOptions(for: foundHoliday.variant, in: db)
                    
                    if let options = try displayOption?.getDisplayOptions(in: db), let backgroundOption = options.backgroundOption, let textOption = options.textOption {
                        selectedBackground = backgroundOption
                        selectedText = textOption
                    }
                }
            }
            
        } catch {
            print("failed load state")
        }
    }
    
    private func selectedHolidayChanged() {
        do {
            try appDatabase.dbWriter.write { db in
                displayOptions = try appDatabase.getAllDisplayOptions(in: db)
                
                let displayOption = try appDatabase.getDisplayOptions(for: selectedHoliday.variant, in: db)
                
                if let options = try displayOption?.getDisplayOptions(in: db), let backgroundOption = options.backgroundOption, let textOption = options.textOption {
                    selectedBackground = backgroundOption
                    selectedText = textOption
                }
            }
            
        } catch {}
    }
    
    private func setupDatabaseObservation() {
        let observation = DatabaseRegionObservation(tracking: GRDBHoliday.all())
        
        if let databasePool = appDatabase.databasePool {
            let _ = observation.start(in: databasePool) { _ in
                print("UH OH it's busted - observation shenanigans or some such fiddle faddle")
            } onChange: { (_: Database) in
                loadState()
            }
        }
    }
    
    private func onHolidayChangeSaved() {
        do {
            try appDatabase.updateDisplayOptions(for: selectedHoliday, withBackground: selectedBackground, withText: selectedText)
            
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("uh oh - failed holiday change saved")
        }
    }
}
