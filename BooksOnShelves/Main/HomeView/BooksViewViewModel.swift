import Foundation

class BooksViewViewModel: ObservableObject {
    //private let items: [Book]
    //@Published var valueToCompare: Int = 1
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    
    private func merge(_ leftArray: [Book], _ rightArray: [Book], valueToCompare: Int) -> [Book] {
        var leftIndex: Int = 0
        var rightIndex: Int = 0
        var leftValue: String
        var rightValue: String
        var mergedArray: [Book] = []

        while leftIndex < leftArray.count && rightIndex < rightArray.count {
            if(valueToCompare == 0){
                leftValue = leftArray[leftIndex].author
                rightValue = rightArray[rightIndex].author
            }
            else if(valueToCompare == 1){
                leftValue = leftArray[leftIndex].title
                rightValue = rightArray[rightIndex].title
            }
            else{
                leftValue = leftArray[leftIndex].rate
                rightValue = rightArray[rightIndex].rate
            }
            
            
            if (leftValue < rightValue) {
                mergedArray.append(leftArray[leftIndex])
                leftIndex += 1
            } else {
                mergedArray.append(rightArray[rightIndex])
                rightIndex += 1
            }
        }

        mergedArray += Array(leftArray[leftIndex...])
        mergedArray += Array(rightArray[rightIndex...])

        return mergedArray
    }
    
    func getMerge(_ leftArray: [Book], _ rightArray: [Book], valueToCompare: Int) -> [Book]{
        return merge(leftArray, rightArray, valueToCompare: valueToCompare)
    }
    
    func mergeSort(_ items: [Book], valueToCompare: Int) -> [Book] {
        guard items.count > 1 else { return items }

        let middleIndex = items.count / 2
        let leftArray = mergeSort(Array(items[0..<middleIndex]), valueToCompare: valueToCompare)
        let rightArray = mergeSort(Array(items[middleIndex..<items.count]), valueToCompare: valueToCompare)

        print(valueToCompare)
        return merge(leftArray, rightArray, valueToCompare: valueToCompare)
    }
    
}
