//
//  ViewController+Coredata.swift
//  MeusJogos
//
//  Created by Vinicius on 28/08/22.
//

import CoreData
import UIKit

extension UIViewController {
    
    var context: NSManagedObjectContext {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
