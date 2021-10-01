//
//  Copyright (c) 2019 KxCoding <kky0317@gmail.com>
//


import UIKit


enum Type: Int {
    case directory
    case file
}


struct Content {
    let url: URL
    
    var name: String {
        let values = try? url.resourceValues(forKeys: [.localizedNameKey])
        return values?.localizedName ?? "???"
    }
    
    var size: Int {
        let values = try? url.resourceValues(forKeys: [.fileSizeKey])
        return values?.fileSize ?? 0
    }
    
    var type: Type {
        let values = try? url.resourceValues(forKeys: [.isDirectoryKey])
        return values?.isDirectory == true ? .directory : .file
    }
    
    var isExcludedFromBackup: Bool {
        let values = try? url.resourceValues(forKeys: [.isExcludedFromBackupKey])
        return values?.isExcludedFromBackup ??  false
    }
}



class FileManagerTableViewController: UITableViewController {
    
    var currentDirectoryUrl: URL?
    // 경로를 url로 처리한다. URL구조체는 파일과 네트워크 url을 표시할 수 있다.
    
    var contents = [Content]()
    
    var formatter: ByteCountFormatter = {
        let f = ByteCountFormatter()
        f.isAdaptive = true
        f.includesUnit = true
        return f
    }()
    
    
    func refreshContents() {
        contents.removeAll()
        
        defer {
            tableView.reloadData()
        }
        
        guard let url = currentDirectoryUrl else {
            fatalError()
        }
        
        do {
            let properties: [URLResourceKey] = [.localizedNameKey, .isDirectoryKey, .fileSizeKey, .isExcludedFromBackupKey]
            
            let currentCOntentUrls = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: properties, options: .skipsHiddenFiles)
            
            for url in currentCOntentUrls {
                let content = Content(url: url)
                contents.append(content)
            }
            
            contents.sort { lhs, rhs -> Bool in
                if lhs.type == rhs.type {
                    return lhs.name.lowercased() < rhs.name.lowercased()
                }
                
                return lhs.type.rawValue < rhs.type.rawValue
            }
            
        } catch {
            print(error)
        }
        
    }
    
    func updateNavigationTitle() {
        guard let url = currentDirectoryUrl else {
            navigationItem.title = "???"
            return
        }
        
        do {
            let values = try url.resourceValues(forKeys: [.localizedNameKey])
            navigationItem.title = values.localizedName
        } catch {
            print(error)
        }
        
    }
    
    func move(to url: URL) {
        // 특정 디렉토리를 탭했을 때 디렉토리로 이동하도록
        
        do {
            let reachable = try url.checkResourceIsReachable()
            // 파일이나 디렉토리가 정상적으로 접근할 수 잇을 때 true
            if !reachable {
                return
            }
        } catch {
            print(error)
            return
        }
        
        if #available(iOS 13.0, *) {
            if let vc = storyboard?.instantiateViewController(identifier: "FileManagerTableViewController") as? FileManagerTableViewController {
                vc.currentDirectoryUrl = url
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        
    }
    
    
    func addDirectory(named: String) {
        guard let url = currentDirectoryUrl?.appendingPathComponent(named, isDirectory: true) else {
            return
        }
        
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            // 디렉토리 생성
            refreshContents()
            // 테이블 뷰 업데이트 디
        } catch {
            
        }
    }
    
    func addTextFile() {
        guard let sourceUrl = Bundle.main.url(forResource: "lorem", withExtension: "txt") else { return }
        // UTI 혹은 파일이름(과 확장자) 로 파일을 구분함
        
        guard let targetUrl = currentDirectoryUrl?.appendingPathComponent("lorem")
                .appendingPathExtension("txt") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: sourceUrl)
            try data.write(to: targetUrl)
            
            refreshContents()
        } catch {
            print(error)
        }
    }
    
    func addImageFile() {
        guard let sourceUrl = Bundle.main.url(forResource: "fireworks", withExtension: "png") else {
            return
        }
        
        guard let targetUrl = currentDirectoryUrl?.appendingPathComponent("fireworks")
                .appendingPathExtension("png") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: sourceUrl)
            try data.write(to: targetUrl)
            refreshContents()
        } catch {
            print(error)
        }
    }
    
    func open(content: Content) {
        
    }
    
    func deleteDirectory(at url: URL) {
        
    }
    
    func deleteFile(at url: URL) {
        
    }
    
    func renameItem(at url: URL) {
        
    }
    
    func updateBackupProperty(of url: URL, exclude: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshContents()
        updateNavigationTitle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? TextViewController {
            vc.url = sender as? URL
        } else if let vc = segue.destination.children.first as? ImageViewController {
            vc.url = sender as? URL
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentDirectoryUrl == nil {
            currentDirectoryUrl = URL(fileURLWithPath: NSHomeDirectory())
            // NSHomeDirectory : 사용자의 홈 디렉토리를 리턴
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let target = contents[indexPath.row]
        
        switch target.type {
        case .directory:
            cell.textLabel?.text = "[\(target.name)]"
            cell.detailTextLabel?.text = nil
            cell.accessoryType = .disclosureIndicator
        case .file:
            print(target.size)
            cell.textLabel?.text = target.name
            cell.detailTextLabel?.text = formatter.string(fromByteCount: Int64(target.size))
            cell.accessoryType = .none
        }
        
        if target.isExcludedFromBackup {
            cell.textLabel?.textColor = UIColor.lightGray
        } else {
            cell.textLabel?.textColor = UIColor.black
        }
        
        cell.detailTextLabel?.textColor = cell.textLabel?.textColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let renameAction = UITableViewRowAction(style: .default, title: "Rename") { [weak self] (action, indexPath) in
            if let target = self?.contents[indexPath.row] {
                self?.renameItem(at: target.url)
            }
        }
        renameAction.backgroundColor = UIColor.darkGray
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
            if let target = self?.contents[indexPath.row] {
                switch target.type {
                case .directory:
                    self?.deleteDirectory(at: target.url)
                case .file:
                    self?.deleteFile(at: target.url)
                }
            }
        }
        
        var actions = [deleteAction, renameAction]
        
        let target = contents[indexPath.row]
        
        if target.isExcludedFromBackup {
            let includeAction = UITableViewRowAction(style: .default, title: "Include to Backup") { [weak self] (action, indexPath) in
                if let target = self?.contents[indexPath.row] {
                    self?.updateBackupProperty(of: target.url, exclude: false)
                }
            }
            includeAction.backgroundColor = UIColor.blue
            
            actions.append(includeAction)
        } else {
            let excludeAction = UITableViewRowAction(style: .default, title: "Exclude from Backup") { [weak self] (action, indexPath) in
                if let target = self?.contents[indexPath.row] {
                    self?.updateBackupProperty(of: target.url, exclude: true)
                }
            }
            excludeAction.backgroundColor = UIColor.blue
            
            actions.append(excludeAction)
        }
        
        return actions
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let target = contents[indexPath.row]
        
        switch target.type {
        case .directory:
            move(to: target.url)
        case .file:
            open(content: target)
        }
    }
    
    @IBAction func showDirectoryMenu(_ sender: Any) {
        let menu = UIAlertController(title: "Directory Menu", message: nil, preferredStyle: .actionSheet)
        
        let addDirectoryAction = UIAlertAction(title: "Add Directory", style: .default) { [ weak self](action) in
            self?.showNameInputAlert()
        }
        menu.addAction(addDirectoryAction)
        
        let addTextFileAction = UIAlertAction(title: "Add Text File", style: .default) { [weak self] (action) in
            self?.addTextFile()
        }
        menu.addAction(addTextFileAction)
        
        let addImageFileAction = UIAlertAction(title: "Add Image File", style: .default) { [weak self] (action) in
            self?.addImageFile()
        }
        menu.addAction(addImageFileAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        menu.addAction(cancelAction)
        
        if let pc = menu.popoverPresentationController {
            pc.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(menu, animated: true, completion: nil)
    }
    
    func showNameInputAlert() {
        let inputAlert = UIAlertController(title: "Input Name", message: nil, preferredStyle: .alert)
        
        inputAlert.addTextField { (nameField) in
            nameField.placeholder = "Input Name"
        }
        
        let createAction = UIAlertAction(title: "Create", style: .default) { [weak self] (action) in
            if let name = inputAlert.textFields?.first?.text {
                self?.addDirectory(named: name)
            }
        }
        inputAlert.addAction(createAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        inputAlert.addAction(cancelAction)
        
        present(inputAlert, animated: true, completion: nil)
    }
    
    func showNotSupportedAlert() {
        let alert = UIAlertController(title: "File Not Supported", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
