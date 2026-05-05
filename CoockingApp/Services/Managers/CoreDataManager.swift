//
//  CoreDataManager.swift
//  CoockingApp
//
//  Created by user on 03.05.2026.
//

import Foundation
import CoreData

class CoreDataManager {
  static let shared = CoreDataManager()
  
  let container: NSPersistentContainer
  let viewContext: NSManagedObjectContext
  
  
  init(){
	 let loadedContainer = NSPersistentContainer(name: "DataModelApp")
	 loadedContainer.loadPersistentStores { _, error in
		if let error{
		  print("Failed to load contained \(error.localizedDescription)")
		}else{
		  print("Container succesfuly loaded with name: DataModelApp")
		}
	 }
	 
	 self.container = loadedContainer
	 self.viewContext = loadedContainer.viewContext
  }
  
  func save() {
	 do{
		try viewContext.save()
	 }catch{
		print("Failed to save")
	 }
  }
}


//MARK: RECIPE Functions
extension CoreDataManager{
  func fetchRecipes() -> [RecipeEntity]{
	 let request: NSFetchRequest<RecipeEntity> = NSFetchRequest(entityName: "RecipeEntity")
	 
	 if let result = try? viewContext.fetch(request){
		return result
	 }else{
		return []
	 }
	 
  }
  
  func createRecipe(recipe: UIRecipeModel) {
	 let entity = RecipeEntity(context: viewContext)
	 entity.id = UUID()
	 entity.name = recipe.name
	 entity.desc = recipe.description
	 entity.time = Int32(recipe.time)
	 entity.difficulty = Int16(recipe.difficulty)
	 entity.timesCooked = 0
	 entity.imageUrl = recipe.imageUrl
	 entity.ingredientsUI = recipe.ingredients
	 entity.instructionsUI = recipe.instructions
//	 TODO: entity.originIngredientsPrompt
//	 TODO: entity.quickIdeaType
	 
	 entity.dateCreated = Date()
	 
	 save()
  }
}




//MARK: USER DATA
extension CoreDataManager{
  func fetchUser() -> UserEntity{
	 let request: NSFetchRequest<UserEntity> = NSFetchRequest(entityName: "UserEntity")
	 
	 if let entity = try? viewContext.fetch(request).first{
		return entity
	 }else{
		return createUser()
	 }
  }
  
  
  func createUser() -> UserEntity{
	 let entity = UserEntity(context: viewContext)
	 entity.username = "New Chef"
	 
	 save()
	 return entity
  }
  
  
  func editUser(user: UserModel) {
	 let entity = fetchUser()
	 
	 entity.allergies = user.alergieIngredients.joined(separator: "|")
	 entity.avoid = user.avoidIngredients.joined(separator: "|")
	 
	 save()
  }
}
