//
//  HomeController.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//

import UIKit

final class HomeController: BaseViewController {
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv =  UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(cell: CardCell.self)
        return cv
    }()
    
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.spacing = 20
        return stack
    }()
    
    private lazy var addButton: ResuableButton = {
        let btn = ResuableButton()
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 30
        btn.anchorSize(.init(width: 60, height: 60))
        return btn
    }()
    
    private lazy var transferButton: ResuableButton = {
        let btn = ResuableButton()
        btn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 30
        btn.anchorSize(.init(width: 60, height: 60))
        return btn
    }()
    
    private lazy var deleteButton: ResuableButton = {
        let btn = ResuableButton()
        btn.setImage(UIImage(systemName: "trash"), for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 30
        btn.anchorSize(.init(width: 60, height: 60))
        return btn
    }()
    
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureViewModel()
        
    }
    
    override func configureView() {
        super.configureView()
        view.addSubViews(collection,buttonStackView)
        buttonStackView.addArrangedSubviews(addButton,transferButton,deleteButton)
    }
    
    override func configureConstraint() {
        super.configureConstraint()
        
        collection.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
        )
        collection.anchorSize(.init(width: 0, height: 220))
        buttonStackView.anchor(
            top: collection.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 40,leading: 60, trailing: -60)
        )
        
    }
    
    override func configureTargets() {
        super.configureTargets()
        addButton.addTarget(self, action: #selector(addCard), for: .touchUpInside)
        transferButton.addTarget(self, action: #selector(showTransfer), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteCArd), for: .touchUpInside)
    }
    
    private func configureViewModel() {
        viewModel.callBack  = { [weak self] state in
            guard let self = self else {return}
            
            DispatchQueue.main.async {
                switch state {
                    case .success:
                        self.reloadCollection()
                    case .error(let error):
                        self.showMessage(title: "error", message: error)
                }
            }
        }
    }
    
    @objc
    fileprivate func addCard (){
        viewModel.addRandomCard()
        showMessage(title: "Card elave olundu")
        reloadCollection()
    }
    
    @objc
    fileprivate func showTransfer (){
        if viewModel.getCardsCount() <= 1 {
            showMessage(title: "Xeta", message: "En az iki kart olmalidir.")
        }else{
            viewModel.showTransfer()
        }
    }
    
    @objc
    fileprivate func deleteCArd (){
        viewModel.removeLastCard()
        showMessage(title: "Card silindi olundu")
        reloadCollection()
    }
    
    func reloadCollection (){
        DispatchQueue.main.async {
            self.collection.reloadData()
        }
        
    }
}


extension HomeController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCardsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CardCell = collectionView.dequeue(for: indexPath)
        let card = viewModel.getCard(index: indexPath.row)
        cell.configure(with: card)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collection.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = collection.frame.width
        let targetXContentOffset = targetContentOffset.pointee.x
        let newPageNumber = Int(round(targetXContentOffset / pageWidth))
        targetContentOffset.pointee = CGPoint(x: CGFloat(newPageNumber) * pageWidth, y: targetContentOffset.pointee.y)
    }
    
}
