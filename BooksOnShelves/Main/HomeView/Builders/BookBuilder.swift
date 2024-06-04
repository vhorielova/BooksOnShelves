import Foundation

class BookBuilder {
    private var id: String = UUID().uuidString
    private var title: String = ""
    private var author: String = ""
    private var rate: Int = 0
    private var imageUrl: String? = nil
    private var description: String = ""
    private var note: String = ""
    
    func setId(_ id: String) -> BookBuilder {
        self.id = id
        return self
    }
    
    func setTitle(_ title: String) -> BookBuilder {
        self.title = title
        return self
    }
    
    func setAuthor(_ author: String) -> BookBuilder {
        self.author = author
        return self
    }
    
    func setRate(_ rate: Int) -> BookBuilder {
        self.rate = rate
        return self
    }
    
    func setImageUrl(_ imageUrl: String?) -> BookBuilder {
        self.imageUrl = imageUrl
        return self
    }
    
    func setDescription(_ description: String) -> BookBuilder {
        self.description = description
        return self
    }
    
    func setNote(_ note: String) -> BookBuilder {
        self.note = note
        return self
    }
    
    func build() -> Book {
        return Book(id: id, title: title, author: author, rate: rate, imageUrl: imageUrl, description: description, note: note)
    }
}
