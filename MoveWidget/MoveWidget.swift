//
//  MoveWidget.swift
//  MoveWidget
//
//  Created by bankiiee on 3/9/20.
//

import WidgetKit
import SwiftUI
import Intents
import Charts

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), step: 3500, configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), step: 0, configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, step: 350 * hourOffset, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let step: Int
    let configuration: ConfigurationIntent
}


struct MoveWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.blue)
            VStack(alignment: .leading) {
                HStack {
                    ZStack {
                        Circle()
                            .frame(width: 32.0, height: 32.0)
                            .foregroundColor(.white)
                        Image(systemName: "figure.walk")
                            .fixedSize()
                    }
                    VStack(alignment: .leading) {
                        Text("Step".uppercased())
                            .font(.caption)
                            .foregroundColor(.white)
                            .opacity(0.8)
                        Text(decimalFormat(number: entry.step))
                            .foregroundColor(.white)
                            .font(.title3)
                            .bold()
                    }
                    
                    
                }
                
                HStack(alignment: .center) {
                    Chart(data: [0.1, 0.3, 0.2, 0.5, 0.4, 0.9, 0.1])
                        .chartStyle(
                            LineChartStyle(.quadCurve, lineColor: .white, lineWidth: 5)
                        )
                }
                Spacer()
                
                HStack(alignment: .center) {
                    Text("Last Update").font(.system(size: 10))
                    Text(entry.date, style: .time).font(.system(size: 10))
                }
                .foregroundColor(.white)
                
            }
            .padding()
        }
    }
}

extension MoveWidgetEntryView {
    private func decimalFormat(number: Int) -> String {
        let amountFormat = NumberFormatter()
        amountFormat.numberStyle = .decimal
        return amountFormat.string(from: NSNumber(value: number)) ?? "N/A"
    }
}

@main
struct MoveWidget: Widget {
    let kind: String = "MoveWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MoveWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MoveWidget_Previews: PreviewProvider {
    static var previews: some View {
        MoveWidgetEntryView(entry: SimpleEntry(date: Date(), step: 98765, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        //        MoveWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
        //            .previewContext(WidgetPreviewContext(family: .systemMedium))
        //        MoveWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
        //            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
