//
//  AddCelebrityController.swift
//  CelebEthnicity
//
//  Created by User on 18.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import Firebase

class AddCelebrityController: UIViewController {

//    override var next: UIResponder? {
//        get {
//            return nil
//        }
//    }
    
    lazy var queryTextField: UITextField = {
       let tf = UITextField()
        tf.text = "ali-larter"
        tf.backgroundColor = .white
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.delegate = self
        return tf
    }()
    
    var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    var originalHTML: String!
    var imgHTML: String!
    
    lazy var parceManager = HTMLParcingManager(rootViewController: self)
    
    var heights = [Height]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentView)
        contentView.fillSuperview()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissHandler))
        view.addGestureRecognizer(tapGesture)
        
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
//        let startChar = Unicode.Scalar("A").value
//        let endChar = Unicode.Scalar("Z").value
//
//        for alphabet in startChar...endChar {
//
//            if let char = Unicode.Scalar(alphabet)?.description {
//                collectHeights(letter: char) { (heights) in
//                    heights.forEach({ self.uploadToFirestore(heigh: $0) })
//                }
//            }
//        }
        
        
        fetchHeighs { [weak self] (array) in

            self?.heights = array ?? []
            
            for i in 1...77 {
                self?.collectUrls(page: i) { [weak self] urls in
                    
                    urls.forEach({
                        sleep(2)
                        self?.collectdataForCeleb(url: $0, completion: { (celebrity) in
                            
                            self?.uploadToFirestore(celeb: celebrity)
                            
                        })
                    })
                }
            }
        }
    }
    
    @objc func dismissHandler() {
        dismiss(animated: true, completion: nil)
    }
    
    func collectHeights(letter: String, completion: ([Height])->()) {
        
        var components = URLComponents()
        components.scheme = "http"
        components.host = "celebheights.com"
        components.path = "/s/all\(letter).html"
        
        parceManager.downloadHTML(urlString: components.string)
        var titles = parceManager.parse(cssQuery: ".sAZ2 a")!.compactMap({ $0.text }).filter({ $0 != "" })
        var heights = parceManager.parse(cssQuery: ".sAZ2")!.compactMap({ $0.text }).filter({ $0 != "" })
        
        heights.enumerated().forEach({ (string) in
            
            heights[string.offset] = string.element.replacingOccurrences(of: titles[string.offset], with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        })
    
        print("a")
        
        let cmValues = heights.map({ $0.slice(from: "(", to: ")")?.replacingOccurrences(of: "cm", with: "") }).map({ $0 ?? "0" }).map({ Int($0) })
    
        let heightsClass = heights.enumerated().compactMap({ Height(name: titles[$0.offset], height: $0.element, value: cmValues[$0.offset]) })
        
        completion(heightsClass)
    }
    
    
    func collectUrls(page: Int, completion: ([URL])->()) {
        
        var components = URLComponents()
        components.scheme = "http"
        components.host = "ethnicelebs.com"
        components.path = "/all-celebs"
        components.queryItems = [URLQueryItem(name: "pg", value: "\(page)")]
        
        parceManager.downloadHTML(urlString: components.string)
        let newHtml = parceManager.parse(cssQuery: ".ddsg-wrapper")?.first!.html
        parceManager.changeHtml(newHtml)
        let htmls = parceManager.parse(cssQuery: "ul li ul a[href]")?.compactMap({ $0.html.html2AttributedString })
        
        var links = [URL]()
        
        htmls?.forEach({ (string) in
            
            string.enumerateAttribute(.link, in: NSRange(location: 0, length: string.length), options: [.longestEffectiveRangeNotRequired], using: { (link, _, _) in
                
                links.append(link as! URL)
                
                if links.count == htmls?.count {
                    completion(links)
                }
            })
            
        })
        
    }
    
    func collectdataForCeleb(celebName: String? = nil, url: URL? = nil, completion: @escaping (Celebrity)->()) {
        
        if let url = url {
            originalHTML = parceManager.downloadHTML(urlString: url.absoluteString)
            
        } else {
            var components = URLComponents()
            components.scheme = "http"
            components.host = "ethnicelebs.com"
            components.path = "/\(celebName ?? "")"
            originalHTML = parceManager.downloadHTML(urlString: components.string)
        }
        
        let items = parceManager.parse(cssQuery: "p")
        
        let categories = (parceManager.parse(cssQuery: ".clean-grid-entry-meta-single-cats")?.first?.text ?? "").replacingOccurrences(of: "Posted in", with: "").trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ", ").flatMap({ $0.components(separatedBy: " ").dropFirst() })
        
        let name = parceManager.parse(cssQuery: ".entry-title")?.first?.text ?? ""
        let birthName = items?.first(where: { $0.text.contains(CelebtiryTags.birthName.rawValue) })?.text.replacingOccurrences(of: CelebtiryTags.birthName.rawValue, with: "").trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let birthPlace = items?.first(where: { $0.text.contains(CelebtiryTags.birthPlace.rawValue) })?.text.replacingOccurrences(of: CelebtiryTags.birthPlace.rawValue, with: "").trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let dateOfBirth = items?.first(where: { $0.text.contains(CelebtiryTags.dateOfBirth.rawValue) })?.text.replacingOccurrences(of: CelebtiryTags.dateOfBirth.rawValue, with: "").trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let deathPlace = items?.first(where: { $0.text.contains(CelebtiryTags.placeOfDeath.rawValue) })?.text.replacingOccurrences(of: CelebtiryTags.placeOfDeath.rawValue, with: "").trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let dateOfDeath = items?.first(where: { $0.text.contains(CelebtiryTags.dateOfDeath.rawValue) })?.text.replacingOccurrences(of: CelebtiryTags.dateOfDeath.rawValue, with: "").trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let ethnicity = (items?.first(where: { $0.text.contains(CelebtiryTags.ethnicity.rawValue) })?.text.replacingOccurrences(of: CelebtiryTags.ethnicity.rawValue, with: "") ?? "").components(separatedBy: ", ").compactMap({ Ethnicity(name: $0, percent: nil) })
        let tags = parceManager.parse(cssQuery: "a[href*=tag]")?.compactMap({ $0.text }) ?? []
        
        let similarHTML = parceManager.parse(cssQuery: ".yarpp-related")?.first?.html
        parceManager.changeHtml(similarHTML)
        let similar = parceManager.parse(cssQuery: "a[href]")?.compactMap({ $0.text }) ?? []
        
        let celeb = Celebrity(name: name, picture: nil, birthName: birthName, birthPlace: birthPlace, dateOfBith: dateOfBirth, ethnicity: ethnicity, tags: tags, similar: similar, deathPlace: deathPlace, dateOfDeath: dateOfDeath, categories: categories)
        
        appendDescription(celeb: celeb) { (celeb, _) in
            
            if let celeb = celeb {
                self.appendImage(celeb: celeb, completion: { (celeb, _) in
                    
                    if let celeb = celeb {
                        self.appendHeight(celeb: celeb, completion: { (celeb, _) in
                            
                            if let celeb = celeb {
                                completion(celeb)
                            }
                        })
                    }
                })
            }
        }
    }
    
    func appendHeight(celeb: Celebrity, completion: @escaping (Celebrity?, Error?)->()) {
        
        let height = self.heights.first(where: { $0.name == celeb.name })
        celeb.height = height
        completion(celeb, nil)
        
        
//        let db = Firestore.firestore()
//        let settings = db.settings
//        settings.areTimestampsInSnapshotsEnabled = true
//        db.settings = settings
//
//        let docRef = db.collection("heights").document(celeb.name!)
//
//        docRef.getDocument { (document, error) in
//            if let json = document?.data() {
//                let height = Height(JSON: json)
//                celeb.height = height
//                completion(celeb, nil)
//            } else {
//                completion(nil, nil)
//            }
//        }
    }
    
    func fetchHeighs(completion: @escaping ([Height]?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection("heights").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(nil)
            } else {
                let heights = querySnapshot?.documents.compactMap({ Height(JSON: $0.data()) })
                completion(heights)
            }
        }
    }
    
    func appendDescription(celeb: Celebrity, completion: @escaping (Celebrity?, Error?)->()) {
        let string = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&titles=\(celeb.name!)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        
        let task = URLSession.shared.dataTask(with: URL(string: string!)!) { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                if let query = json?["query"] as? [String: Any] {
                    if let pages = query["pages"] as? [String: Any] {
                        if let pageId = pages[pages.keys.first!] as? [String: Any] {
                            if let extract = pageId["extract"] as? String {

                                celeb.description = extract
                                completion(celeb, nil)
                            } else {
                                completion(celeb, nil)
                            }
                        }
                    }
                }
            } catch {
                print(error)
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    func appendImage(celeb: Celebrity, completion: @escaping (Celebrity?, Error?)->()) {
        parceManager.changeHtml(originalHTML)
        imgHTML = parceManager.parse(cssQuery: "img[src$=.jpg]")?.first?.html
        
        if let html = imgHTML {
        
            let types: NSTextCheckingResult.CheckingType = .link
            let detector = try? NSDataDetector(types: types.rawValue)
            
            guard let detect = detector else {
                return
            }
            
            let matches = detect.matches(in: html, options: .reportCompletion, range: NSMakeRange(0, html.count))
            
            celeb.picture = matches.first?.url?.absoluteString
            completion(celeb, nil)
        } else {
            completion(celeb, nil)
        }
        

//        let string = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=pageimages&exintro&explaintext&redirects=1&titles=\(celeb.name!)&pithumbsize=500".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
//
//        let task = URLSession.shared.dataTask(with: URL(string: string!)!) { (data, response, error) in
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
//                if let query = json?["query"] as? [String: Any] {
//                    if let pages = query["pages"] as? [String: Any] {
//                        if let pageId = pages[pages.keys.first!] as? [String: Any] {
//                            if let thumbnail = pageId["thumbnail"] as? [String: Any] {
//                                if let source = thumbnail["source"] as? String {
//
//                                    celeb.picture = source
//                                    completion(celeb, nil)
//                                }
//                            } else {
//                                completion(celeb, nil)
//                            }
//                        }
//                    }
//                }
//            } catch {
//                print(error)
//                completion(nil, error)
//            }
//        }
//
//        task.resume()
    }
    
    func uploadToFirestore(heigh: Height) {
        let db = Firestore.firestore()

        let data = [
            "name": heigh.name ?? "",
            "height": heigh.height ?? "",
            "value": heigh.value ?? 0
            ] as [String : Any]

        db.collection("heights").document(heigh.name!).setData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func uploadToFirestore(celeb: Celebrity) {
        let db = Firestore.firestore()
        
        let ethnisityNames = celeb.ethnicity?.compactMap({ $0.name })
        
        let timestamp = FieldValue.serverTimestamp()
        
        let dict1 = [
            "name": celeb.name ?? "",
            "picture": celeb.picture ?? "",
            "birthName": celeb.birthName ?? "",
            "dateOfBirth": celeb.dateOfBith ?? "",
            "birthPlace": celeb.birthPlace ?? "",
            "dateOfDeath": celeb.dateOfDeath ?? "",
            "deathPlace": celeb.deathPlace ?? "",
            "ethnicity": ethnisityNames ?? []
        
            ] as [String : Any]
        
        let dict2 = ["height": ["name": "", "height": celeb.height?.height ?? "", "value": celeb.height?.value ?? 0]]
        
        let dict3 = [
            "description": celeb.description ?? "",
            "tags": celeb.tags ?? [],
            "similar": celeb.similar ?? [],
            "categories": celeb.categories ?? [],
            "lastUpdate": timestamp
            
            ] as [String : Any]
        
        let data = dict1.merging(dict2, uniquingKeysWith:{ $1 }).merging(dict3, uniquingKeysWith:{ $1 })
        
        db.collection("celebrities").document(celeb.name!).setData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}

enum CelebtiryTags: String {
    case birthName = "Birth Name:"
    case birthPlace = "Place of Birth:"
    case dateOfBirth = "Date of Birth:"
    case dateOfDeath = "Date of Death:"
    case placeOfDeath = "Place of Death:"
    case ethnicity = "Ethnicity:"
}

extension AddCelebrityController: UITextFieldDelegate {
    
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        
        
        
        
        return true
    }
    
    
}
