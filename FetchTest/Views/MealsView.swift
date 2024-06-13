//
//  ContentView.swift
//  FetchTest
//
//  Created by Brian King on 6/10/24.
//

import SwiftUI

struct MealsView: View {
    @State var viewModel: MealsViewModel
    @State var showDataErrorAlert = false
    
    var body: some View {
        NavigationStack {
            DessertRecipesList(viewModel: viewModel)
        }
        .task {
            do {
                try await viewModel.fetchDessertMeals()
            } catch {
                showDataErrorAlert.toggle()
            }
        }
        .alert(isPresented: $showDataErrorAlert) {
            Alert(
                title: Text("Important message"),
                message: Text("There was an error retrieving Dessert Recipes"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct DessertRecipesList: View {
    @State var viewModel: MealsViewModel
    var body: some View {
        List {
            ForEach(viewModel.meals) { meal in
                ZStack(alignment: .leading) {
                    NavigationLink(destination: MealDetailView(viewModel: viewModel)
                        .onAppear {
                            self.viewModel.selectedMeal = meal
                        }) {EmptyView()}
                    DessertRow(meal: meal)
                        .padding(.vertical, 6)
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .navigationTitle(Text("Dessert Recipes"))
        .padding(.top, 12)
    }
}

struct DessertRow: View {
    let meal: Meal
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangleWithShadow()
            HStack {
                MealImage(urlString: meal.thumbnail)
                    .frame(width: 60, height: 60)
                    .padding(.leading, 12)
                    .padding(.vertical, 6)
                Text(meal.name ?? "")
                    .font(.title3)
                    .bold()
                    .padding()
            }
        }
    }
}


#Preview {
    let viewModel = MealsViewModel()
    viewModel.meals = [Meal(name: "Strawberry Sundae"), Meal(name: "New York Cheesecake")]
    return MealsView(viewModel: viewModel)
}
