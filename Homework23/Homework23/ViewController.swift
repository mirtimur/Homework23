import UIKit
import WebKit

class ViewController: UIViewController{
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: [URL?] = [URL(string: "https://www.apple.com")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        collectionView.register(UINib(nibName: "TabCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TabCollectionViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let urlString = "https://www.apple.com"
        guard let url: URL = URL(string: urlString) else { return }
        
        let urlRequst: URLRequest = URLRequest(url: url)
        webView.load(urlRequst)
        textField.text = urlString
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if webView.canGoBack {
            webView.goBack()
            textField.text = webView.url?.absoluteString
        }
    }
    
    @IBAction func forwardButtonPressed(_ sender: UIButton) {
        if webView.canGoForward {
            webView.goForward()
            textField.text = webView.url?.absoluteString
        }
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        var googleUrl = URL(string: "https://www.google.com")
        dataSource.append(googleUrl)
        collectionView.reloadData()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard  let urlString = textField.text,
               let url: URL = URL(string: urlString) else { return false }
        
        let urlRequst: URLRequest = URLRequest(url: url)
        webView.load(urlRequst)
        textField.resignFirstResponder()
        return true
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCollectionViewCell", for: indexPath) as? TabCollectionViewCell else { return UICollectionViewCell() }
        
        cell.websiteLabel.text = dataSource[indexPath.item]?.absoluteString
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / CGFloat(dataSource.count)
        
        return CGSize(width: width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = dataSource[indexPath.item] else { return }
        
        let urlRequst: URLRequest = URLRequest(url: url)
        webView.load(urlRequst)
    }
}
