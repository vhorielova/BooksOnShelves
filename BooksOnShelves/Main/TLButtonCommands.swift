import Foundation
import SwiftUI

protocol Command {
    func execute()
}

class SaveCommand: Command {
    private let viewModel: NewWishlistItemViewViewModel
    private let newItemPresented: Binding<Bool>
    
    init(viewModel: NewWishlistItemViewViewModel, newItemPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.newItemPresented = newItemPresented
    }
    
    func execute() {
        if viewModel.canSave {
            viewModel.save()
            newItemPresented.wrappedValue = false
        } else {
            viewModel.showAlert = true
        }
    }
}

class CreateAccountCommand: Command {
    private let viewModel: CreateAccountViewViewModel
    
    init(viewModel: CreateAccountViewViewModel) {
        self.viewModel = viewModel
    }
    
    func execute() {
        viewModel.createAcc()
    }
}

class LoginCommand: Command {
    private let viewModel: LoginViewViewModel
    
    init(viewModel: LoginViewViewModel) {
        self.viewModel = viewModel
    }
    
    func execute() {
        viewModel.login()
    }
}

class SaveBookCommand: Command {
    private let viewModel: NewBookViewViewModel
    private let newItemPresented: Binding<Bool>
    
    init(viewModel: NewBookViewViewModel, newItemPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.newItemPresented = newItemPresented
    }
    
    func execute() {
        if viewModel.canSave {
            viewModel.save()
            newItemPresented.wrappedValue = false
        } else {
            viewModel.showAlert = true
        }
    }
}

class LogoutCommand: Command {
    private let viewModel: ProfileViewViewModel
    
    init(viewModel: ProfileViewViewModel) {
        self.viewModel = viewModel
    }
    
    func execute() {
        viewModel.logout()
    }
}

class EditBookCommand: Command {
    private let viewModel: SingleBookViewModel
    private let showEditor: Binding<Bool>
    
    init(viewModel: SingleBookViewModel, showEditor: Binding<Bool>) {
        self.viewModel = viewModel
        self.showEditor = showEditor
    }
    
    func execute() {
        showEditor.wrappedValue = true
    }
}

class DeleteBookCommand: Command {
    private let viewModel: SingleBookViewModel
    private let showDeleteConfirmation: Binding<Bool>
    
    init(viewModel: SingleBookViewModel, showDeleteConfirmation: Binding<Bool>) {
        self.viewModel = viewModel
        self.showDeleteConfirmation = showDeleteConfirmation
    }
    
    func execute() {
        showDeleteConfirmation.wrappedValue = true
    }
}

class EditProfileCommand: Command {
    @Binding var isEditProfilePresented: Bool
    
    init(isEditProfilePresented: Binding<Bool>) {
        self._isEditProfilePresented = isEditProfilePresented
    }
    
    func execute() {
        isEditProfilePresented = true
    }
}

class SaveEditedProfile: Command {
    private let viewModel: EditProfileViewViewModel
    
    init(viewModel: EditProfileViewViewModel) {
        self.viewModel = viewModel
    }
    
    func execute() {
        viewModel.updateProfile()
    }
}

class SaveEditedBook: Command {
    private let viewModel: EditBookViewViewModel
    
    init(viewModel: EditBookViewViewModel) {
        self.viewModel = viewModel
    }
    
    func execute() {
        viewModel.updateBook()
    }
}
