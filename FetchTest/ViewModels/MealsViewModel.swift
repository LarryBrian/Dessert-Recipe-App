//
//  MealsViewModel.swift
//  FetchTest
//
//  Created by Brian King on 6/11/24.
//

import Foundation

@Observable class MealsViewModel {
    var meals: [Meal] = []
    var selectedMeal: Meal?
    var urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
          self.urlSession = urlSession
      }
    
    func fetchDessertMeals() async throws {
        let dessertsUrl = URL(string: Constants().dessertMealsURL)
        guard let _url = dessertsUrl else { throw NetworkError.invalidURL }
        let request = URLRequest(url: _url)
        let (data, _) = try await urlSession.data(for: request)
        let fetchedData = try JSONDecoder().decode(MealsResponse.self, from: data)
       
        /// the below line could be seperated into individual high order functions for readability or kept as is for a more concise codebase (up to the team's codebase standards)
        self.meals = fetchedData.meals.compactMap({$0}).filter({$0.name?.isEmpty == false}).sorted(by: {$0.name ?? "" < $1.name ?? ""})
    }
    
    func fetchMealDetails() async throws {
        guard let _meal  = self.selectedMeal, let _id = _meal.mealID else { throw NetworkError.invalidData }
        let recipeURL = URL(string: Constants().mealDetailsURL.replacingLast(7, with: _id))
        guard let _url = recipeURL else { throw NetworkError.invalidURL }
        let request = URLRequest(url: _url)
        let (data, _) = try await urlSession.data(for: request)
        let fetchedData = try JSONDecoder().decode(MealsResponse.self, from: data)
        self.selectedMeal = fetchedData.meals.first
    }
}
