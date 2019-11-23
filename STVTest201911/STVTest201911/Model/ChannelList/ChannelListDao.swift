//
//  ChannelListDao.swift
//  STVTest201911
//
//  Created by STV-M025 on 2019/11/23.
//  Copyright © 2019 STV-M025. All rights reserved.
//

import RealmSwift

final class ChannelListDao <T: ChannelListData> {
    let realm: Realm
    
    init() {
        try! realm = Realm()
        log?.info(Realm.Configuration.defaultConfiguration.fileURL!)
        defer {
            realm.invalidate()
        }
    }
    
    /**
     * 新規主キー発行
     */
    func newId() -> Int? {
        guard let key = T.primaryKey() else {
            //primaryKey未設定
            return nil
        }
        
        let realm = try! Realm()
        return (realm.objects(T.self).max(ofProperty: key) as Int? ?? 0) + 1
    }
    
    /**
     * 全件取得
     */
    func findAll() -> Results<T> {
        return realm.objects(T.self)
    }
    
    /**
     * 1件目のみ取得
     */
    func findFirst() -> T? {
        return findAll().first
    }
    
    /**
     * 指定キーのレコードを取得
     */
    func findFirst(key: AnyObject) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: key)
    }
    
    /**
     * 最後のレコードを取得
     */
    func findLast() -> T? {
        return findAll().last
    }
    
    /**
     * レコード追加
     */
    func add(object :T) {
        do {
            try realm.write {
                realm.add(object, update: .error)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// 複数件のレコードを追加
    ///
    /// - Parameter objects: 複数件のレコード
    func add(objects: [T]) {
        do {
            try realm.write {
                realm.add(objects, update: .error)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /**
     * T: RealmSwift.Object で primaryKey()が実装されている時のみ有効
     */
    @discardableResult
    func update(object: T, block:(() -> Void)? = nil) -> Bool {
        do {
            try realm.write {
                block?()
                realm.add(object, update: .all)
            }
            return true
        } catch let error {
            print(error.localizedDescription)
        }
        return false
    }
    
    @discardableResult
    func update(objects: [T], block:(() -> Void)? = nil) -> Bool {
        do {
            try realm.write {
                block?()
                realm.add(objects, update: .all)
            }
            return true
        } catch let error {
            print(error.localizedDescription)
        }
        return false
    }
    
    /**
     * レコード削除
     */
    func delete(object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /**
     * レコード全削除
     */
    func deleteAll() {
        let objs = realm.objects(T.self)
        do {
            try realm.write {
                realm.delete(objs)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
