//
//  MediaViewController.swift
//  LockBox701
//
//  Created by mac on 7/31/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class MediaViewController: UIViewController {
    
    
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    
    let viewModel = ViewModel()
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMedia()
        
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setupMedia() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        imagePicker.delegate = self
        viewModel.load()
        for cont in viewModel.content {
            print(cont.path!)
        }
        //MARK: Set up reload observer
        NotificationCenter.default.addObserver(forName: Notification.Name("Reload"), object: nil, queue: .main) { [unowned self] _ in
            self.mediaCollectionView.reloadData()
        }
    }

}


extension MediaViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionCell.identifier, for: indexPath) as! MediaCollectionCell
        let content = viewModel.content[indexPath.row]
        cell.content = content
        return cell
    }
    
    
}


extension MediaViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 135)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        viewModel.currentContent = viewModel.content[indexPath.row]
        viewModel.index = indexPath.row
        detailVC.viewModel = viewModel
        
        navigationController?.view.backgroundColor = .white
        navigationController?.pushViewController(detailVC, animated: true)
        //TODO: GoTo Detail View with delete option
    }
}


extension MediaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {return}
        let isVideo = mediaType == "public.movie" ? true : false
        
        switch isVideo {
        case true:
            //TODO: Implement for video
            break
        case false:
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let data = image.jpegData(compressionQuality: 1) else {return}
            FileService().save(data, isVideo: false)
            viewModel.save(data: data, isVid: false)
        }
    }
    
}
