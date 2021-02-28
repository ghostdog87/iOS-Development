//
//  ImageGalleryDocumentTableViewController.swift
//  ImageGallery
//
//  Created by Petar Stanev on 30.01.21.
//

import UIKit

class ImageGalleryDocumentTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    /// Table cell identifier name
    private let tableCellIdentifier = "DocumentCell"
    /// Number of sections in the table
    private let numberOfTableSections = 2
    /// Active gallery list section index
    private let activeGalleryListSection = 0
    /// Deleted gallery list section index
    private let recentlyDeletedGalleryListSection = 1
    /// All currently active galleries
    private(set) var activeImageGalleryList: [ImageGallery]!
    /// List of recently deleted galleries
    private var recentlyDeletedGalleryList: [ImageGallery]!
    /// All galleries
    private var allGalleries: [[ImageGallery]]  {
        return [activeImageGalleryList, recentlyDeletedGalleryList]
    }
    /// Returns a list with names of all active and recently deleted galleries
    private var existingNamesForImageGalleries: [String] {
        return activeImageGalleryList.map { $0.name } + recentlyDeletedGalleryList.map { $0.name }
    }
    
    @IBAction private func addImageGallery(_ sender: UIBarButtonItem) {
        let imageGallery = ImageGallery("Untitled".madeUnique(withRespectTo: existingNamesForImageGalleries),[])
        activeImageGalleryList.append(imageGallery)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeImageGalleryList = [ImageGallery("Untitled", [])]
        recentlyDeletedGalleryList = []
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfTableSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGalleries[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as? DocumentTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.textField.text = allGalleries[indexPath.section][indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        if indexPath.section == activeGalleryListSection {
            let removedGallery = activeImageGalleryList.remove(at: indexPath.row)
            recentlyDeletedGalleryList.append(removedGallery)
            tableView.moveRow(at: indexPath,
                              to: IndexPath(row: 0,
                                            section: recentlyDeletedGalleryListSection))
        } else {
            recentlyDeletedGalleryList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == activeGalleryListSection ? "Gallery list" : "Recently deleted galleries"
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section == recentlyDeletedGalleryListSection else { return nil }
        let undelete = undeleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [undelete])
    }
    
    /// Undelete action when swipping to the right
    /// - Parameter indexPath: Gallery position in the table
    /// - Returns: Action context
    private func undeleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let contextAction = UIContextualAction(style: .normal, title: "Undelete", handler: {
            [self] action, sourceView, completionHandler in
            tableView.performBatchUpdates({
                let undeletedGallery = recentlyDeletedGalleryList.remove(at: indexPath.row)
                activeImageGalleryList.append(undeletedGallery)
                tableView.moveRow(at: indexPath, to: IndexPath(row: activeImageGalleryList.count - 1,
                                                               section: activeGalleryListSection))
            })
            completionHandler(true)
        })
        contextAction.backgroundColor = .blue
        return contextAction
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeGallery(withGalleryAt: indexPath)
    }
    
    /// Changes currently active gallery in Image Gallery Collection view
    /// - Parameter indexPath: Gallery position in table
    private func changeGallery(withGalleryAt indexPath: IndexPath) {
        guard let viewController = imageGalleryController(),
              activeImageGalleryList.count > 0,
              indexPath.section == activeGalleryListSection else { return }
        
        viewController.imageGallery = activeImageGalleryList[indexPath.row]
    }
    
    /// Returns the instance of ImageGalleryCollectionViewController
    private func imageGalleryController() -> ImageGalleryCollectionViewController? {
        for currentViewController in splitViewController?.viewControllers ?? [] {
            guard let secondaryViewController = currentViewController.contents as? ImageGalleryCollectionViewController else { continue }
            return secondaryViewController
        }
        return nil
    }
}

extension ImageGalleryDocumentTableViewController: ImageGalleryTableViewCellDelegate {
    /// Delegate function from DocumentTableViewCell that updates gallery name
    /// - Parameters:
    ///   - name: Gallery name
    ///   - cell: Gallery position in the table
    func nameDidChange(_ name: String?, in cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell), let galleryName = name else { return }
        let gallery = allGalleries[indexPath.section][indexPath.row]
        gallery.name = galleryName
        if indexPath.section == activeGalleryListSection {
            activeImageGalleryList[indexPath.row] = gallery
        } else {
            recentlyDeletedGalleryList[indexPath.row] = gallery
        }
        tableView.reloadData()
    }
}

