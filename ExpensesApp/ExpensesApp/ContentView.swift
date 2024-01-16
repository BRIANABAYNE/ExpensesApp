//
//  ContentView.swift
//  ExpensesApp
//
//  Created by Briana Bayne on 1/16/24.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    // Allowing the app to persist
    var items = [ExpenseItem]() {
        // property observer, will observe when the property changes
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.setValue(encoded, forKey: "Items")
                // Has to be the same, even case sensitive
            }
        }
    }
    
    // Allowing the app to persist
    init() {
        // Will read whatever in this as an data object
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try?
                // try and decode that data into an array of [expenseItems]. type of self , give me all of the array expenseitem
                JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        // if it fails, items is an empty array
        items = []
    }
}

struct ContentView: View {
    
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items, id: \.name) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text(item.amount, format: .currency(code: "USD"))
                    }
                }
                .onDelete(perform: removeItems)
                // swipe to delete
            }
            .navigationTitle("Expenses")
            .font(.caption2)
            // title
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
                // show another view here
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
        // swipe to delete
    }
}

#Preview {
    ContentView()
}

