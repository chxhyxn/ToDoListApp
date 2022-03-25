//
//  ViewController.swift
//  ToDoListApp
//
//  Created by chxhyxn on 2022/03/08.
//

import UIKit

class TodoListViewController: UIViewController {

    let todoListViewModel = TodoViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        todoListViewModel.loadTasks()
    }
}

extension TodoListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return todoListViewModel.numOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return todoListViewModel.todayTodos.count
        }else {
            return todoListViewModel.upcompingTodos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoListCell", for: indexPath) as? TodoListCell else {
            return UICollectionViewCell()
        }
        var todo: Todo
        if indexPath.section == 0 {
            todo = todoListViewModel.todayTodos[indexPath.item]
        }else {
            todo = todoListViewModel.upcompingTodos[indexPath.item]
        }
        cell.updateUI(todo: todo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TodoListHeaderView", for: indexPath) as? TodoListHeaderView else {
                return UICollectionReusableView()
            }
            
            guard let section = TodoViewModel.Section(rawValue: indexPath.section) else {
                return UICollectionReusableView()
            }
            
            header.lblTitleSection.text = section.title
            
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    
}

extension TodoListViewController: UICollectionViewDelegate {
    
}

extension TodoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }
}



class TodoListHeaderView: UICollectionReusableView {
    @IBOutlet weak var lblTitleSection: UILabel!
    
}

class TodoListCell: UICollectionViewCell {
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblTodo: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var viewStrikeThrough: UIView!
    
    @IBOutlet weak var viewStrikeThroughWidth: NSLayoutConstraint!
    
    var doneButtonTapHandler: ((Bool) -> Void)?
    var deleteButtonTapHandler: (() -> Void)?
    
    // 용도를 모르겠음
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    // 용도를 모르겠음
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    private func showViewStrikeThrough(_ show: Bool) {
        if show {
            viewStrikeThroughWidth.constant = lblTodo.bounds.width*1.05
        }else {
            viewStrikeThroughWidth.constant = 0
        }
    }
    
    func updateUI(todo: Todo) {
        self.btnCheck.isSelected = todo.isDone
        self.lblTodo.text = todo.detail
        self.lblTodo.alpha = todo.isDone ? 0.2 : 1
        self.btnDelete.isHidden = !todo.isDone
        showViewStrikeThrough(todo.isDone)
    }
    
    func reset() {
        lblTodo.alpha = 1
        btnCheck.isSelected = false
        btnDelete.isHidden = true
        showViewStrikeThrough(false)
    }
    @IBAction func tapBtnCheck(_ sender: UIButton) {
        let isDone = !btnCheck.isSelected
        doneButtonTapHandler?(isDone)
        //이거 하다맘
    }
    
    @IBAction func tapBtnDelete(_ sender: UIButton) {
        deleteButtonTapHandler?()
        //이거 하다맘
    }
}
