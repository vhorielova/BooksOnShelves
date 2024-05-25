//
//  SortBooksTests.swift
//  BooksOnShelvesTests
//
//  Created by Віка Горєлова on 11.03.2024.
//

import XCTest
@testable import BooksOnShelves

final class MergeSortInBooksViewViewModelTests: XCTestCase {
    
    let viewModel = ListOfBooksViewViewModel(userId: "")
    let singleBook_1: Book = Book(id: "1", title: "1", author: "1", rate: "1")
    let singleBook_2: Book = Book(id: "2", title: "2", author: "2", rate: "2")
    let singleBook_3: Book = Book(id: "3", title: "3", author: "3", rate: "3")
    let singleBook_4: Book = Book(id: "4", title: "4", author: "4", rate: "4")
    let singleBook_5: Book = Book(id: "5", title: "5", author: "5", rate: "5")
    
    func testSuccessfulSortByTitle(){
        //Arrage
        let valueToCompare:Int = 0
        let items: [Book] = [singleBook_1, singleBook_3, singleBook_2, singleBook_5, singleBook_4]
        let expectedResult: [Book] = [singleBook_1, singleBook_2, singleBook_3, singleBook_4, singleBook_5]
        //Act
        let sortItems = viewModel.mergeSort(items, valueToCompare: valueToCompare)
        //Assert
        XCTAssertEqual(sortItems, expectedResult)
    }
    
    func testSuccessfulSortByAuthour(){
        //Arrage
        let valueToCompare:Int = 1
        let items: [Book] = [singleBook_1, singleBook_3, singleBook_2, singleBook_5, singleBook_4]
        let expectedResult: [Book] = [singleBook_1, singleBook_2, singleBook_3, singleBook_4, singleBook_5]
        //Act
        let sortItems = viewModel.mergeSort(items, valueToCompare: valueToCompare)
        //Assert
        XCTAssertEqual(sortItems, expectedResult)
    }
    
    func testSuccessfulSortByRate(){
        //Arrage
        let valueToCompare:Int = 2
        let items: [Book] = [singleBook_1, singleBook_3, singleBook_2, singleBook_5, singleBook_4]
        let expectedResult: [Book] = [singleBook_1, singleBook_2, singleBook_3, singleBook_4, singleBook_5]
        //Act
        let sortItems = viewModel.mergeSort(items, valueToCompare: valueToCompare)
        //Assert
        XCTAssertEqual(sortItems, expectedResult)
    }
    
    func testSuccessfulSortOfEmptyArrayByTitle(){
        //Arrage
        let valueToCompare:Int = 0
        let items: [Book] = []
        let expectedResult: [Book] = []
        //Act
        let sortItems = viewModel.mergeSort(items, valueToCompare: valueToCompare)
        //Assert
        XCTAssertEqual(sortItems, expectedResult)
    }
    
    func testSuccessfulSortOfEmptyArrayByAuthour(){
        //Arrage
        let valueToCompare:Int = 1
        let items: [Book] = []
        let expectedResult: [Book] = []
        //Act
        let sortItems = viewModel.mergeSort(items, valueToCompare: valueToCompare)
        //Assert
        XCTAssertEqual(sortItems, expectedResult)
    }
    
    func testSuccessfulSortOfEmptyArrayByRate(){
        //Arrage
        let valueToCompare:Int = 2
        let items: [Book] = []
        let expectedResult: [Book] = []
        //Act
        let sortItems = viewModel.mergeSort(items, valueToCompare: valueToCompare)
        //Assert
        XCTAssertEqual(sortItems, expectedResult)
    }
    
    func testSuccessfulSortOfSameItemsByTitle(){
        //Arrage
        let valueToCompare:Int = 0
        let items: [Book] = [singleBook_1, singleBook_1, singleBook_1, singleBook_1, singleBook_1]
        let expectedResult = [singleBook_1, singleBook_1, singleBook_1, singleBook_1, singleBook_1]
        //Act
        let sortItems = viewModel.mergeSort(items, valueToCompare: valueToCompare)
        //Assert
        XCTAssertEqual(sortItems, expectedResult)
    }
    
    func testSuccessfulSortOfSameItemsByAuthour(){
        //Arrage
        let valueToCompare:Int = 1
        let items: [Book] = [singleBook_1, singleBook_1, singleBook_1, singleBook_1, singleBook_1]
        let expectedResult = [singleBook_1, singleBook_1, singleBook_1, singleBook_1, singleBook_1]
        //Act
        let sortItems = viewModel.mergeSort(items, valueToCompare: valueToCompare)
        //Assert
        XCTAssertEqual(sortItems, expectedResult)
    }
    
    func testSuccessfulSortOfSameItemsByRate(){
        //Arrage
        let valueToCompare:Int = 2
        let items: [Book] = [singleBook_1, singleBook_1, singleBook_1, singleBook_1, singleBook_1]
        let expectedResult = [singleBook_1, singleBook_1, singleBook_1, singleBook_1, singleBook_1]
        //Act
        let sortItems = viewModel.mergeSort(items, valueToCompare: valueToCompare)
        //Assert
        XCTAssertEqual(sortItems, expectedResult)
    }
}
