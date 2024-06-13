//
//  MealsViewModelTests.swift
//  FetchTestTests
//
//  Created by Brian King on 6/12/24.
//

import XCTest
@testable import FetchTest

class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: HTTPURLResponse?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        guard let data = mockData, let response = mockResponse else {
            throw NetworkError.noData
        }
        return (data, response)
    }
}

class MealsViewModelTests: XCTestCase {
    
    let mockMealsResponse = MealsResponse(meals: [
        Meal(id: UUID(), name: "Special Cheesecake", thumbnail: "", mealID: UUID().uuidString, area: "", instructions: "Do these instructions", ingredient1: "baking soda", ingredient2: "happiness", ingredient3: "joy", ingredient4: "frustration", measure1: "1 tsp", measure2: "boat load", measure3: "too much", measure4: "just a wee bit"),
        Meal(id: UUID(), name: "Unworldly Pie", thumbnail: "", mealID: UUID().uuidString, area: "", instructions: "Your guess is as good as mine", ingredient1: "sugar", ingredient2: "something devine", ingredient3: "moljnir", measure1: "1 spoon full", measure2: "1", measure3: "THE")
    ])
    
    var viewModel: MealsViewModel!
        var mockSession: MockURLSession!
        
        override func setUp() {
            super.setUp()
            mockSession = MockURLSession()
            viewModel = MealsViewModel(urlSession: mockSession)
        }
        
        override func tearDown() {
            viewModel = nil
            mockSession = nil
            super.tearDown()
        }
                
        func testFetchDessertMeals() async throws {
            mockSession.mockData = try JSONEncoder().encode(mockMealsResponse)
            mockSession.mockResponse = HTTPURLResponse(url: URL(string: Constants().dessertMealsURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                        
            try await viewModel.fetchDessertMeals()
                        
            XCTAssertEqual(viewModel.meals.count, mockMealsResponse.meals.count)
            XCTAssertEqual(viewModel.meals.first?.name, mockMealsResponse.meals.first?.name)
        }
        
        func testFetchMealDetails() async throws {
            viewModel.selectedMeal =  Meal(id: UUID(), name: "Unworldly Pie", thumbnail: "", mealID: UUID().uuidString, area: "", instructions: "Your guess is as good as mine", ingredient1: "sugar", ingredient2: "something devine", ingredient3: "moljnir", measure1: "1 spoon full", measure2: "1", measure3: "THE")
            
            mockSession.mockData = try JSONEncoder().encode(mockMealsResponse)
            mockSession.mockResponse = HTTPURLResponse(url: URL(string: Constants().mealDetailsURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            try await viewModel.fetchMealDetails()
                        
            XCTAssertEqual(viewModel.selectedMeal?.name, mockMealsResponse.meals.first?.name)
            XCTAssertEqual(viewModel.selectedMeal?.instructions, mockMealsResponse.meals.first?.instructions)
        }
    
    func testIngredientMeasurementComputedProperty() {
        let meal = mockMealsResponse.meals.first
        
        XCTAssertEqual(meal?.measuredIngredients.first?.ingredient, "baking soda")
        XCTAssertEqual(meal?.measuredIngredients.first?.measurement, "1 tsp")
    }
    
    func testReplacingStringHelper() {
        let text = "www.unitTest.com/testing"
        let result = text.replacingLast(7, with: "success")
        XCTAssertEqual(result, "www.unitTest.com/success")
    }
}
