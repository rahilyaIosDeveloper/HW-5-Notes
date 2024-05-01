////
////  ViewController.swift
////  HW 5 Notes
////
////  Created by Rahilya Nazaralieva on 27/4/24.
////
//

import UIKit
import SnapKit


protocol HomeViewProtocol {
    func doneNotes(allNotes: [String])
}

class HomeView: UIViewController {
    
    private var controller: HomeControllerProtocol?
    
    private var allNotes: [String] = []
    
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Search"
        view.layer.cornerRadius = 10
        view.backgroundImage = UIImage()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Notes"
        view.textColor = UIColor(hex: "#262626")
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return view
    }()
    
    private lazy var notesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        view.dataSource = self
        view.delegate = self
        view.register(NoteCell.self, forCellWithReuseIdentifier: NoteCell.reuseId)
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("+", for: .normal)
        view.backgroundColor = .red
        view.layer.cornerRadius = 42/2
        view.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        view.setTitleColor(.white, for: .normal)
        return view
    }()
    
    
    private func setupNavigationItem() {
        title = "Home"
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func settingsButtonTapped() {
        let vc = SettingsController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        controller = HomeController(view: self)
        controller?.takeNotes()
        setupNavigationItem()
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(36)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(22)
            make.leading.equalTo(40)
            make.height.equalTo(42)
        }
        
        view.addSubview(notesCollectionView)
        notesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-133)
            make.height.width.equalTo(42)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
}

extension HomeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allNotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCell.reuseId, for: indexPath) as! NoteCell
        cell.fill(title: allNotes[indexPath.row])
        return cell
    }
}

extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { 
        return CGSize(width: (collectionView.frame.width - 12) / 2, height: 100)

    }
}

extension HomeView: HomeViewProtocol {
    func doneNotes(allNotes: [String]) {
        self.allNotes = allNotes
        notesCollectionView.reloadData()
    }
    
    
}
