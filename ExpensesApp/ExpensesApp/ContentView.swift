//
//  ContentView.swift
//  ExpensesApp
//
//  Created by Briana Bayne on 1/16/24.
//

import SwiftUI

struct ExpenseItem {
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var item = [ExpenseItem]()
}

struct ContentView: View {
    @State private var expenses = Expenses()
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.item, id: \.name) { item in
                    Text(item.name)
                }
                .onDelete(perform: removeItems)
                // swipe to delete
            }
            .navigationTitle("Expense")
            // title
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
                    expenses.item.append(expense)
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.item.remove(atOffsets: offsets)
        // swipe to delete
    }
}

#Preview {
    ContentView()
}

