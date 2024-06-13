//
//  MealDetailView.swift
//  FetchTest
//
//  Created by Brian King on 6/11/24.
//

import SwiftUI

struct MealDetailView: View {
    @State var viewModel: MealsViewModel
    @State var showDataErrorAlert = false
    
    var body: some View {
        ScrollView {
            VStack {
                MealImage(urlString: viewModel.selectedMeal?.thumbnail)
                    .frame(width: 150, height: 150)
                Text(viewModel.selectedMeal?.name ?? "Not Available")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                            
                OrangeDivider()
                
                VStack(alignment: .leading, spacing: 8) {
                    IngredientBody(viewModel: viewModel)
                    OrangeDivider()
                        .padding(.vertical, 12)
                    InstructionBody(viewModel: viewModel)
                    Spacer()
                }
            }
            .padding()
        }
        .alert(isPresented: $showDataErrorAlert) {
            Alert(
                title: Text("Important message"),
                message: Text("There was an error retrieving your recipe"),
                dismissButton: .default(Text("OK"))
            )
        }
        .task {
            do {
                try await viewModel.fetchMealDetails()
            } catch {
                showDataErrorAlert.toggle()
            }
        }
    }
}

struct IngredientBody: View {
    let viewModel: MealsViewModel
    
    var body: some View {
            HStack {
                Text("Ingredients:")
                    .font(.title2)
                    .bold()
                    .padding(.top, 20)
                    .padding(.bottom, 6)
                Spacer()
            }
            
            if let _meal = viewModel.selectedMeal {
                ForEach(_meal.measuredIngredients, id: \.self) { measuredIngredient in
                    HStack {
                        Text("\(measuredIngredient.ingredient)")
                        Spacer()
                        Text("\(measuredIngredient.measurement)")
                    }
                }
            }
    }
}

struct InstructionBody: View {
    let viewModel: MealsViewModel
    
    var body: some View {
            HStack {
                Text("Instructions:")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 6)
                Spacer()
            }
            
            if let _meal = viewModel.selectedMeal {
                Text(_meal.instructions ?? "N/A")
            }
    }
}

#Preview {
    let viewModel = MealsViewModel()
    viewModel.selectedMeal = Meal(name: "NY Cheesecake")
    return MealDetailView(viewModel: viewModel)
}
