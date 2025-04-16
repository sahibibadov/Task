//
//  ProfileController.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//


import UIKit

final class ProfileController: BaseViewController {
    
    private lazy var logOutBtn: ResuableButton = {
        let b = ResuableButton()
        b.setTitle("Logout", for: .normal)
        b.anchorSize(.init(width: 300, height: 40))
        return b
    }()
    
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
    }
    
    override func configureView() {
        super.configureView()
        view.addSubview(logOutBtn)
    }
    
    override func configureConstraint() {
        super.configureConstraint()
        logOutBtn.centerToView(to: view)
    }
    
    override func configureTargets() {
        super.configureTargets()
        logOutBtn.addTarget(self, action: #selector(signOut), for: .touchUpInside)
    }
    
    @objc fileprivate func signOut (){
        viewModel.logOut()
    }
}
