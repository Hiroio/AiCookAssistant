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
  private static let cloudKitContainerIdentifier = "iCloud.DeliNoteContainer"
  
  let container: NSPersistentContainer
  let viewContext: NSManagedObjectContext
  
  
  init(){
	 let loadedContainer = NSPersistentCloudKitContainer(name: "DataModelApp")
	 
	 guard let storeDescription = loadedContainer.persistentStoreDescriptions.first else {
		fatalError("Failed to configure Core Data persistent store description")
	 }
	 
	 storeDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
		containerIdentifier: Self.cloudKitContainerIdentifier
	 )
	 storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
	 storeDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
	 
	 loadedContainer.loadPersistentStores { _, error in
		if let error{
		  print("Failed to load contained \(error.localizedDescription)")
		}else{
		  print("Container succesfuly loaded with name: DataModelApp")
		}
	 }
	 loadedContainer.viewContext.automaticallyMergesChangesFromParent = true
	 loadedContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
	 
	 self.container = loadedContainer
	 self.viewContext = loadedContainer.viewContext
  }
  
  @discardableResult
  func save() -> Bool {
	 do{
		try viewContext.save()
		return true
	 }catch{
		print("Failed to save")
		return false
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
  
  @discardableResult
  func createRecipe(recipe: UIRecipeModel) -> Bool {
	 let entity = RecipeEntity(context: viewContext)
	 entity.id = UUID()
	 entity.name = recipe.name
	 entity.desc = recipe.description
	 entity.time = Int32(recipe.time)
	 entity.difficulty = Int16(recipe.difficulty)
	 entity.timesCooked = 0
	 entity.imageUrl = recipe.imageUrl
	 entity.ingredientsUI = recipe.ingredients
	 entity.macros = recipe.macros
	 entity.cookingTip = recipe.cookingTip
	 entity.instructionsUI = recipe.instructions
	 entity.isRecommended = recipe.isRecommended
	 entity.recommendedDate = recipe.recommendedDate
//	 TODO: entity.originIngredientsPrompt
//	 TODO: entity.quickIdeaType
	 
	 entity.dateCreated = Date()
	 
	 return save()
  }
  
  private func fetchSingleRecipe(id: UUID) throws -> RecipeEntity? {
	 let request: NSFetchRequest<RecipeEntity> = NSFetchRequest(entityName: "RecipeEntity")
	 
	 request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
	 
	 return try viewContext.fetch(request).first
  }
  
  @discardableResult
  func toggleFavorite(_ id: UUID) -> Bool {
	 if let recipe = try? fetchSingleRecipe(id: id){
		recipe.isFavorite.toggle()
		return save()
	 }
	 return false
  }
  
  @discardableResult
  func incrementTimesCooked(_ id: UUID) -> Bool {
	 if let recipe = try? fetchSingleRecipe(id: id){
		recipe.timesCooked += 1
		return save()
	 }
	 return false
  }
  
  @discardableResult
  func saveRecomended(_ id: UUID) -> Bool {
	 if let recipe = try? fetchSingleRecipe(id: id){
		recipe.isRecommended = false
		return save()
	 }
	 return false
  }
  
  func deleteRecomended(_ id: UUID) -> Bool {
	 if let recipe = try? fetchSingleRecipe(id: id){
		viewContext.delete(recipe)
		return save()
	 }
	 return false
  }
  
  @discardableResult
  func deleteRecipe(_ id: UUID) -> Bool {
	 if let recipe = try? fetchSingleRecipe(id: id){
		viewContext.delete(recipe)
		return save()
	 }
	 return false
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
	 entity.cookingIdentity = CookingIdentityEnum.comfortCook.rawValue
	 entity.allergies = ""
	 entity.avoid = ""
	 entity.freeGenerationsUsed = 0
	 entity.freeIdeasUsed = 0
	 entity.freeScanUses = 0
	 entity.latestRefreshDate = Date()
	 
	 save()
	 return entity
  }
  
  
  func editUser(user: UserModel) {
	 let entity = fetchUser()
	 
	 entity.username = user.username
	 entity.cookingIdentity = user.cookingIdentity.rawValue
	 entity.allergies = user.alergieIngredients.joined(separator: "|")
	 entity.avoid = user.avoidIngredients.joined(separator: "|")
	 entity.freeGenerationsUsed = Int16(user.freeGenerationsUsed)
	 entity.freeScanUses = Int16(user.freeScanUses)
	 entity.freeIdeasUsed = Int16(user.freeIdeasUsed)
	 entity.latestRefreshDate = user.latestRefreshDate
	 
	 save()
  }
// MARK: Free Functionality
  func addCameraUse(){
	 let entity = fetchUser()
	 entity.freeScanUses += 1
	 save()
  }
  
  func addGenerationUse(){
	 let entity = fetchUser()
	 entity.freeGenerationsUsed += 1
	 save()
  }
  
  func addIdeaGenerationUse(){
	 let entity = fetchUser()
	 entity.freeIdeasUsed += 1
	 save()
  }
}

//MARK: Ingredients
extension CoreDataManager{
  func fetchIngredients() -> [IngredientsEntity]{
	 let request: NSFetchRequest<IngredientsEntity> = NSFetchRequest(entityName: "IngredientsEntity")
	 
	 if let entities = try? viewContext.fetch(request){
		return entities
	 }else{
		return []
	 }
  }
  
  func createIngredients(ingredient: IngredientModel) {
	 let entity = IngredientsEntity(context: viewContext)
	 entity.id = ingredient.id
	 entity.name = ingredient.name
	 entity.category = ingredient.category.rawValue
	 entity.isFavorite = ingredient.isFavorite
	 
	 save()
  }
  
  func toggleFavorite(ingredient: IngredientModel){
	 let request: NSFetchRequest<IngredientsEntity> = NSFetchRequest(entityName: "IngredientsEntity")
	 
	 request.predicate = NSPredicate(format: "id == %@", ingredient.id as CVarArg)
	 
	 if let entity = try? viewContext.fetch(request).first {
		entity.isFavorite.toggle()
	 }
	 save()
  }
  
  func deleteIngredients(ingredients: [IngredientModel]){
	 let ids = ingredients.map(\.id)
	 guard !ids.isEmpty else { return }
	 
	 let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "IngredientsEntity")
	 fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
	 
	 let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
	 deleteRequest.resultType = .resultTypeObjectIDs
	 
	 do {
		let result = try viewContext.execute(deleteRequest) as? NSBatchDeleteResult
		let objectIDs = result?.result as? [NSManagedObjectID] ?? []
		
		NSManagedObjectContext.mergeChanges(
		  fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs],
		  into: [viewContext]
		)
	 } catch {
		print("Failed to batch delete ingredients: \(error.localizedDescription)")
	 }
  }
}
