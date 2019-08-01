//
//  DetailViewController.swift
//  LockBox701
//
//  Created by Consultant on 8/1/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var mediaImage: UIImageView!
    
    var viewModel: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = FileService().load(from: (viewModel?.currentContent!.path)!) else { return }
        mediaImage.image = UIImage(contentsOfFile: url.path)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteTapped))
    }
    
    @objc func deleteTapped() {
        let alert = UIAlertController(title: "Are you sure?", message: "Are you sure you want to delete this content from this collection?", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { [weak self] _  in
            self!.deleteMedia()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

        
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
    func deleteMedia(){
        viewModel!.delete(path: (viewModel?.currentContent!.path)!, isVid: false, index: (viewModel?.index)!)
        let alert = UIAlertController(title: "Content Deleted", message: "This content has been removed from the collection", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { [weak self] action in
            self?.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
