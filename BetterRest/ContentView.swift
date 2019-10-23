//
//  ContentView.swift
//  BetterRest
//
//  Created by Jonathan Go on 10/22/19.
//  Copyright © 2019 SonnerStudio. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @State private var sleepAmount = 8.0
  @State private var wakeUp = defaultWakeTime
  @State private var coffeeAmount = 1
  
  @State private var alertTitle = ""
  @State private var alertMessage = ""
  @State private var showingAlert = false

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("⏰ When do you want to wake up?").font(.headline)) {
          DatePicker("Please enter a time",
                   selection: $wakeUp,
                   displayedComponents: .hourAndMinute)
            .labelsHidden()
            .datePickerStyle(WheelDatePickerStyle())
        }
        
        Section(header: Text("🛏 Desired amount of sleep").font(.headline)) {
          Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
            Text("\(sleepAmount, specifier: "%g") hours")
          }
        }
         
        Section(header: Text("☕️ Daily coffee intake").font(.headline)) {
//          Picker("Coffe intake", selection: $coffeeAmount) {
//              ForEach(1...20, id: \.self) { i in
//                  Text("\(i) \(i == 1 ? "cup" : "cups")")
//              }
//          }
//          .id("coffee")
//          .labelsHidden()
//          .pickerStyle(WheelPickerStyle())
          Stepper(value: $coffeeAmount, in: 1...20) {
              if coffeeAmount == 1 {
                  Text("1 cup")
              }
              else {
                  Text("\(coffeeAmount) cups")
              }
          }
        }
        
        Section(header: Text("Recommended bed time").font(.headline)) {
            Text("\(calculateBedtime)")
                .font(.title)
        }
      }
      .navigationBarTitle(Text("BetterRest").foregroundColor(.blue))
//      .navigationBarItems(trailing:
//        Button(action: calculateBedtime) {
//          Text("Calculate")
//        })
//        .alert(isPresented: $showingAlert) {
//          Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//      }
    }
  }
  
  static var defaultWakeTime: Date {
    var components = DateComponents()
    components.hour = 7
    components.minute = 0
    return Calendar.current.date(from: components) ?? Date()
  }
    
  var calculateBedtime: String {
    let model = SleepCalculator()
    
    let components = Calendar.current.dateComponents([.hour, .minute], from:  wakeUp)
    let hour = (components.hour ?? 0) * 60 * 60
    let minute = (components.minute ?? 0) * 60
    
    var message: String //for last challenge
    do {
      let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
      
      let sleepTime = wakeUp - prediction.actualSleep
      
      let formatter = DateFormatter()
      formatter.timeStyle = .short
      
      message = formatter.string(from: sleepTime)
      //alertMessage = formatter.string(from: sleepTime)
      //alertTitle = "Your ideal bedtime is..."
    } catch {
      message = "Error calculating bedtime"
      //alertTitle = "Error"
      //alertMessage = "Sorry, there was a problem calculating your bedtime."
    }
    return message
    //showingAlert = true
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//      Form {
//        DatePicker("Please enter a date", selection: $wakeUp, in: Date()..., displayedComponents: .date)
//        Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
//          Text("\(sleepAmount, specifier: "%g") hours")
//        }
//      }
