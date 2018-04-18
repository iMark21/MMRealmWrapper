//
//  Database.swift
//  coinmarketcap
//
//  Created by Juan Miguel Marques Morilla on 15/2/18.
//  Copyright © 2018 Juan Miguel Marqués Morilla. All rights reserved.
//

import Foundation
import RealmSwift
import RealmManager
import Realm

class Database: NSObject {
    
    static let shared = Database()
    
    /// Initializate DB default
    ///
    /// - Parameter version: version number of your DB. Increment your version number when you have to update your db file.
    public func configureDB(version: UInt64){
        let config = Realm.Configuration(schemaVersion: version, migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < version) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
        })
        Realm.Configuration.defaultConfiguration = config
    }
    
    /// Initializate shared DB
    ///
    /// - Parameters:
    ///   - ApplicationGroupIdentifier: Application Security Group Identifier defined on iTunesConnect account like app.identifier.com
    ///   - version: version number of your DB. Increment your version number when you have to update your db file.
    func configureSharedDB(ApplicationGroupIdentifier:String, version: UInt64){
        let AppGroupContainerUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: ApplicationGroupIdentifier)
        let realmPath = AppGroupContainerUrl?.appendingPathComponent("db.realm")
        var config = Realm.Configuration(schemaVersion: version, migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < version) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
        })
        config.fileURL = realmPath
        Realm.Configuration.defaultConfiguration = config
    }
    
    /// Save Object without waiting until finished
    ///
    /// - Parameter T: Realm Object
    public func save(T: Object)  {
        RealmManager.addOrUpdate(model: String(describing: T.self), object: T, completionHandler: { (error) in
        })
    }
    
    /// Save Object waiting until task this is finished
    ///
    /// - Parameters:
    ///   - T: Realm Object
    ///   - completion: returns success or not for this task.
    public func saveWithCompletion(T: Object?, completion: @escaping (_ success : Bool) -> Void)  {
        if T == nil {
            completion (false)
        }
        RealmManager.addOrUpdate(model: String(describing: T.self), object: T, completionHandler: { (error) in
            if (error == nil){
                completion (true)
            }else{
                completion (false)
            }
        })
    }
    
    
    /// Save Array of Objects waiting until this task is finished
    ///
    /// - Parameters:
    ///   - T: Array of Realm Objects
    ///   - completion: Returns success or not for this task.
    public func saveArrayObjects(T: [Object], completion: @escaping (_ success : Bool) -> Void) {
        let numberObjects : Int = T.count
        var savedObjects : Int = 0
        RealmManager.addOrUpdate(model: String(describing: T.self), object: T, completionHandler: { (error) in
            savedObjects = savedObjects+1
            if (savedObjects == numberObjects) {
                completion (true)
            }
        })
    }
    
    
    /// Get array of objects by class
    ///
    /// - Parameters:
    ///   - T: Realm Object like ObjectNameClass()
    ///   - completionHandler: Returns array list of objects
    public func getAllListOf(T: Object, completionHandler: @escaping(_ result:[Object]) -> Void)  {
        //Fetches all objects inside 'Class' model class
        RealmManager.fetch(model: String(describing: T.classForCoder), condition: nil, completionHandler: { (result) in
            let arrayMutable : NSMutableArray = []
            for T in result {
                arrayMutable.add(T)
            }
            completionHandler (arrayMutable.copy() as! [Object])
        })
    }
    
    /// Get unique object by Identifier
    ///
    /// - Parameters:
    ///   - T: Realm Object like ObjectNameClass()
    ///   - objectID: Identifier of Object assuming that key of object is 'id'
    ///   - completionHandler: Return object or nil if not exist
    public func getFetchObject(T: Object, objectID: String, completionHandler: @escaping(_ result:Object?) -> Void)  {
        getAllListOf(T: T) { (objects) in
            var condition : String = ""
            if objects.count > 0{
                let object : Object = objects.first!
                let primaryKeyValue : Any = object.value(forKey: "id") as Any
                if primaryKeyValue is String {
                    condition = "id == '\(objectID)'"
                }else{
                    condition = "id == \(objectID)"
                }
                RealmManager.fetch(model: String(describing: T.classForCoder), condition: condition, completionHandler: { (result) in
                    let arrayMutable : NSMutableArray = []
                    for T in result {
                        arrayMutable.add(T)
                    }
                    if arrayMutable.count > 0 {
                        let object: Object = arrayMutable.firstObject as! Object
                        completionHandler (object)
                    }else{
                        completionHandler (nil)
                    }
                })
            }else{
                completionHandler (nil)
            }
        }
    }
    
    
    /// Get unique object by CustomPrimareyKey
    ///
    /// - Parameters:
    ///   - T: Realm Object like ObjectNameClass()
    ///   - objectPrimaryKey: Primary Key defined for Object
    ///   - objectPrimaryKeyValue: Primary Key Value for Object that you want to look for.
    ///   - completionHandler: Return object or nil if not exist
    public func getFetchObjectWithCustomPrimareyKey(T: Object, objectPrimaryKey: String, objectPrimaryKeyValue: String, completionHandler: @escaping(_ result:Object?) -> Void)  {
        getAllListOf(T: T) { (objects) in
            var condition : String = ""
            if objects.count > 0{
                let object : Object = objects.first!
                let primaryKeyValue : Any = object.value(forKey: "id") as Any
                if primaryKeyValue is String {
                    condition = "\(objectPrimaryKey) == \(objectPrimaryKeyValue)"
                }else{
                    condition = "\(objectPrimaryKey) == '\(objectPrimaryKeyValue)'"
                }
                RealmManager.fetch(model: String(describing: T.classForCoder), condition:condition, completionHandler: { (result) in
                    let arrayMutable : NSMutableArray = []
                    for T in result {
                        arrayMutable.add(T)
                    }
                    if arrayMutable.count > 0 {
                        let object: Object = arrayMutable.firstObject as! Object
                        completionHandler (object)
                    }else{
                        completionHandler (nil)
                    }
                })
            }else{
                completionHandler (nil)
            }
        }
    }
    
    
    /// Get list of object by condition
    ///
    /// - Parameters:
    ///   - T: Realm Object like ObjectNameClass()
    ///   - condition: Optional parameter with condition like -> condition: "keyParam == valueParam AND keyParam == valueParam"
    ///   - completionHandler: Returns array list of objects by condition
    public func getFetchList(T: Object, condition: String?, completionHandler: @escaping(_ result:[Object]) -> Void)  {
        RealmManager.fetch(model: String(describing: T.classForCoder), condition: condition, completionHandler: { (result) in
            let arrayMutable : NSMutableArray = []
            for T in result {
                arrayMutable.add(T)
            }
            completionHandler (arrayMutable as! [Object])
        })
    }
    
    /// Delete object providing Identifier
    ///
    /// - Parameters:
    ///   - T: Realm Object like ObjectNameClass()
    ///   - objectID: Identifier of Object assuming that key of object is 'id'
    ///   - completionHandler: Return if operation is completed properly
    public func deleteObjectById(T: Object, objectID: String, completionHandler: @escaping(_ success:Bool) -> Void)  {
        getAllListOf(T: T) { (objects) in
            var condition : String = ""
            if objects.count > 0{
                let object : Object = objects.first!
                let primaryKeyValue : Any = object.value(forKey: "id") as Any
                if primaryKeyValue is String {
                    condition = "id == '\(objectID)'"
                }else{
                    condition = "id == \(objectID)"
                }
                RealmManager.delete(model: String(describing: T.self), condition: condition, completionHandler: { (error) in
                    if (error == nil){
                        completionHandler (true)
                    }else{
                        completionHandler (false)
                    }
                })
            }else{
                completionHandler (true) //all content is deleted
            }
        }
    }
    
    
    /// Delete object providing your own customPrimareyKey
    ///
    /// - Parameters:
    ///   - T: Realm Object like ObjectNameClass()
    ///   - objectPrimaryKey: Primary Key defined for Object
    ///   - objectPrimaryKeyValue: Primary Key Value for Object that you want to look for.
    ///   - completionHandler: Return if operation is completed properly
    public func deleteObjectByCustomPrimaryKey(T: Object, objectPrimaryKey: String, objectPrimaryKeyValue: String, completionHandler: @escaping(_ success:Bool) -> Void)  {
        getAllListOf(T: T) { (objects) in
            var condition : String = ""
            if objects.count > 0{
                let object : Object = objects.first!
                let primaryKeyValue : Any = object.value(forKey: "objectPrimaryKey") as Any
                if primaryKeyValue is String {
                    condition = "\(objectPrimaryKey) == '\(objectPrimaryKeyValue)'"
                }else{
                    condition = "\(objectPrimaryKey) == '\(objectPrimaryKeyValue)'"
                }
                RealmManager.delete(model: String(describing: T.self), condition: condition, completionHandler: { (error) in
                    if (error == nil){
                        completionHandler (true)
                    }else{
                        completionHandler (false)
                    }
                })
            }else{
                completionHandler (true) //all content is deleted
            }
        }
    }
    
    /// Delete object / objects by condition
    ///
    /// - Parameters:
    ///   - T: Realm Object like ObjectNameClass()
    ///   - condition: Optional parameter with condition like -> condition: "keyParam == valueParam AND keyParam == valueParam"
    ///   - completionHandler: Return if operation is completed properly
    public func deleteObjectByCondition(T: Object, condition: String, completionHandler: @escaping(_ success:Bool) -> Void)  {
        getFetchList(T: T, condition: condition) { (objects) in
            if objects.count > 0 {
                let totalObjectToDelete: Int = objects.count
                var counter: Int = 0
                for object in objects{
                    self.deleteObjectWithCompletion(T: object, completionHandler: { (success) in
                        counter = counter+1
                        if counter == totalObjectToDelete{
                            completionHandler (true)
                        }
                    })
                }
            }else{
                completionHandler (true) // all objects deleted
            }
        }
    }
    
    
    /// Delete all objects of class
    ///
    /// - Parameters:
    ///   - T: Realm Object like ObjectNameClass()
    ///   - completionHandler: Return if operation is completed properly
    public func deleteAllObjectWithCompletion(T: Object, completionHandler: @escaping(_ success:Bool) -> Void)  {
        let realm = try! Realm()
        let allObjects = realm.objects(Object.self)
        do {
            try! realm.write({
                realm.delete(allObjects)
                completionHandler (true)
            })
        }
    }
    
    /// Delete object providing a object
    ///
    /// - Parameters:
    ///   - T: Object to delete
    ///   - completionHandler: Return if operation is completed properly
    public func deleteObjectWithCompletion(T: Object, completionHandler: @escaping(_ success:Bool) -> Void)  {
        RealmManager.deleteObject(object: T) { (error) in
            if error == nil{
                completionHandler (true)
            }else{
                completionHandler (false)
            }
        }
    }
}
