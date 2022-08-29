//
//  EditOrAddViewController.swift
//  MeusJogos
//
//  Created by Vinicius on 28/08/22.
//

import UIKit

class EditOrAddViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var consoleTextField: UITextField!
    @IBOutlet weak var releaseDate: UIDatePicker!
    @IBOutlet weak var addEditButton: UIButton!
    @IBOutlet weak var buttonCover: UIButton!
    @IBOutlet weak var imageViewCover: UIImageView!
    
    var game: Game!
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    var consolesManager = ConsolesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareConsoleTextField()
        
        if game != nil {
            title = "Editar jogo"
            addEditButton.setTitle("ALTERAR", for: .normal)
            titleTextField.text = game.title
            if let console = game.console, let index = consolesManager.consoles.index(of: console) {
                consoleTextField.text = console.name
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            imageViewCover.image = game.cover as? UIImage
            if let releaseDate = game.releaseDate {
                self.releaseDate.date = releaseDate
            }
            if game.cover != nil {
                buttonCover.setTitle(nil, for: .normal)
            }
            
        }
    }
    
    func prepareConsoleTextField() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolBar.tintColor = UIColor(named: "main")
    
        let buttonCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        
        let buttonDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let buttonFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.items = [buttonDone,buttonFlexibleSpace, buttonCancel]
        
        consoleTextField.inputView = pickerView
        consoleTextField.inputAccessoryView = toolBar
    }
    
    @objc func cancel() {
        consoleTextField.resignFirstResponder()
    }
    
    @objc func done() {
        consoleTextField.text = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)].name
        
        cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        consolesManager.loadConsoles(with: context)
    }
    
    @IBAction func addEditCover(_ sender: Any) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde quer escolher?", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        let libraryAction = UIAlertAction(title: "Biblioteca", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        let photosAction = UIAlertAction(title: "Album de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func addEditGame(_ sender: Any) {
        if game == nil {
            game = Game(context: context)
        }
        game.title = titleTextField.text
        game.releaseDate = releaseDate.date
        if !consoleTextField.text!.isEmpty {
            let console = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)]
            game.console = console
        }
        game.cover = imageViewCover.image
        do {
        try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
extension EditOrAddViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consolesManager.consoles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = consolesManager.consoles[row]
        return console.name
    }
}

extension EditOrAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageViewCover.image = image
        buttonCover.setTitle(nil, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
