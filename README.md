# MMRealmWrapper
An easy way to manage your Realm Database with Swift

This library uses library from [RealmManager](https://github.com/markcdb/RealmManager) by [markcdb](https://github.com/markcdb) - trying to make it easier to manage your own databases with REALM. 

## Requirements

- iOS 9 
- ARC

## Installation

MMRealmWrapper is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MMRealmWrapper'
```
## How it works

### Initialize DB

1.- Parameter version: version number of your DB. Increment your version number when you have to update your db file.

```swift public func configureDB(version: UInt64) ```
    
### Initialize SHARED DB

1.- ApplicationGroupIdentifier: Application Security Group Identifier defined on iTunesConnect account like app.identifier.com
2.- version: version number of your DB. Increment your version number when you have to update your db file.   
    ```swift public configureSharedDB(ApplicationGroupIdentifier:String, version: UInt64)```

### Save or Update Objects

1.  - Save Realm Object
    ```swift
    public func save(T: Object)```
    
2.  - Save Realm Object with completion: returns success or not for this task.
    ```swift
    public func saveWithCompletion(T: Object?, completion: @escaping (_ success : Bool) -> Void) ```
    
3.  - Save an Array of Realm Objects with completion: returns success or not for this task.
    ```swift
    public func saveArrayObjects(T: [Object], completion: @escaping (_ success : Bool) -> Void) ```

### Get Objects

1.  - Get array of objects by class
    ```swift
    public func getAllListOf(T: Object, completionHandler: @escaping(_ result:[Object]) -> Void)```
    
2.  - Get unique object by Identifier
    ```swift
    public func getFetchObject(T: Object, objectID: String, completionHandler: @escaping(_ result:Object?) -> Void)```
    
3.  - Get unique object by custom primary key for Realm Object
    ```swift
    public func getFetchObjectWithCustomPrimareyKey(T: Object, objectPrimaryKey: String, objectPrimaryKeyValue: String, completionHandler: @escaping(_ result:Object?) -> Void)```
    
4.  - Get list of objects by condition
    ```swift
    public func getFetchList(T: Object, condition: String?, completionHandler: @escaping(_ result:[Object]) -> Void)```
    
### Delete Objects

1.  - Delete object providing Identifier
    ```swift
    public func deleteObjectById(T: Object, objectID: String, completionHandler: @escaping(_ success:Bool) -> Void)```
    
2.  - Delete object providing your own customPrimareyKey
    ```swift
    public func deleteObjectByCustomPrimaryKey(T: Object, objectPrimaryKey: String, objectPrimaryKeyValue: String, completionHandler: @escaping(_ success:Bool) -> Void)```
    
3.  - Delete object / objects by condition
    ```swift
    public func deleteObjectByCondition(T: Object, condition: String, completionHandler: @escaping(_ success:Bool) -> Void)```
    
4.  - Delete all objects of class
    ```swift
    public func deleteAllObjectWithCompletion(T: Object, completionHandler: @escaping(_ success:Bool) -> Void)```
    
5.  - Delete object providing a object
    ```swift
    public func deleteObjectWithCompletion(T: Object, completionHandler: @escaping(_ success:Bool) -> Void)```

## Author

iMark21, marques.jm@icloud.com

## License

MMRealmWrapper is available under the MIT license. See the LICENSE file for more info.
