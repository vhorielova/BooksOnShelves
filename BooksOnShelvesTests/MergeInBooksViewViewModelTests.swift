//
//  MergeInBooksViewViewModelTests.swift
//  BooksOnShelvesTests
//
//  Created by Віка Горєлова on 11.03.2024.
//

import XCTest
@testable import BooksOnShelves

final class MergeInBooksViewViewModelTests: XCTestCase {
    
    let viewModel = ListOfBooksViewViewModel(userId: "", sortingStrategy: <#SortingStrategy#>)
    let singleBook_1: Book = Book(id: "1", title: "1", author: "1", rate: "1")
    let singleBook_2: Book = Book(id: "2", title: "2", author: "2", rate: "2")
    let singleBook_3: Book = Book(id: "3", title: "3", author: "3", rate: "3")
    let singleBook_4: Book = Book(id: "4", title: "4", author: "4", rate: "4")
    let singleBook_5: Book = Book(id: "5", title: "5", author: "5", rate: "5")
    
    func testSuccessfulMergeByTitle(){
        //Arrage
        let valueToCompare: Int = 0
        let leftArray: [Book] = [singleBook_1, singleBook_3, singleBook_5]
        let rightArray: [Book] = [singleBook_2, singleBook_4]
        let expectedArray: [Book] = [singleBook_1, singleBook_2, singleBook_3, singleBook_4, singleBook_5]
        //Act
        let mergeArrays = viewModel.getMerge(leftArray, rightArray, valueToCompare: valueToCompare)
        //Assert
        XCTAssertEqual(mergeArrays, expectedArray)
    }
    
    func testSuccessfulMergeByAuthour(){
        //Arrage
        let valueToCompare: Int = 1
        let leftArray: [Book] = [singleBook_1, singleBook_3, singleBook_5]
        let rightArray: [Book] = [singleBook_2, singleBook_4]
        let expectedArray: [Book] = [singleBook_1, singleBook_2, singleBook_3, singleBook_4, singleBook_5]
        //Act
        let mergeArrays = viewModel.getMerge(leftArray, rightArray, valueToCompare: valueToCompare)
        //Assert
        XCTAssertEqual(mergeArrays, expectedArray)
    }
    
    func testSuccessfulMergeByRate(){
        //Arrage
        let valueToCompare: Int = 2
        let leftArray: [Book] = [singleBook_1, singleBook_3, singleBook_5]
        let rightArray: [Book] = [singleBook_2, singleBook_4]
        let expectedArray: [Book] = [singleBook_1, singleBook_2, singleBook_3, singleBook_4, singleBook_5]
        //Act
        let mergeArrays = viewModel.getMerge(leftArray, rightArray, valueToCompare: valueToCompare)
        //Assert
        XCTAssertEqual(mergeArrays, expectedArray)
    }
    
    func testSuccessfulMergeOfFirstEmptyArrayByTitle(){
        //Arrage
        let valueToCompare: Int = 0
        let leftArray: [Book] = []
        let rightArray: [Book] = [singleBook_2, singleBook_4]
        let expectedArray: [Book] = [singleBook_2, singleBook_4]
        //Act
        let mergeArrays = viewModel.getMerge(leftArray, rightArray, valueToCompare: valueToCompare)
        //Assert
        XCTAssertEqual(mergeArrays, expectedArray)
    }
    
    func testSuccessfulMergeOfSecondEmptyArrayByTitle(){
        //Arrage
        let valueToCompare: Int = 0
        let leftArray: [Book] = [singleBook_2, singleBook_4]
        let rightArray: [Book] = []
        let expectedArray: [Book] = [singleBook_2, singleBook_4]
        //Act
        let mergeArrays = viewModel.getMerge(leftArray, rightArray, valueToCompare: valueToCompare)
        //Assert
        XCTAssertEqual(mergeArrays, expectedArray)
    }
    
    func testSuccessfulMergeOfEmptyArrayByTitle(){
        //Arrage
        let valueToCompare: Int = 0
        let leftArray: [Book] = []
        let rightArray: [Book] = []
        let expectedArray: [Book] = []
        //Act
        let mergeArrays = viewModel.getMerge(leftArray, rightArray, valueToCompare: valueToCompare)
        //Assert
        XCTAssertEqual(mergeArrays, expectedArray)
    }

}
