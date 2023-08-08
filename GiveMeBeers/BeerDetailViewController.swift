//
//  BeerDetailViewController.swift
//  GiveMeBeers
//
//  Created by 서동운 on 8/8/23.
//

import UIKit
import Kingfisher
import Alamofire

enum Scene {
    case detail
    case recommend
}

class BeerDetailViewController: UIViewController {
    
    var scene: Scene = .detail
    var beer: Beer?
    
    static var identifier: String {
        String(describing: Self.self)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var recommendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if scene == .recommend {
            titleLabel.text = "오늘의 맥주 추천!!"
            recommendButton.addTarget(self, action: #selector(recommend), for: .touchUpInside)
            recommendButton.isHidden = false
            recommend()
        } else {
            update(data: beer)
        }
    }
    
    @objc private func recommend() {
        let url = "https://api.punkapi.com/v2/beers/random"
        AF.request(url).validate().responseDecodable(of: [Beer].self) { response in
            switch response.result {
            case .success(let beers):
                self.update(data: beers.first!)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func update(data: Beer?) {
        guard let data else { return }
        imageView.kf.setImage(with: URL(string: data.image_url))
        nameLabel.text = data.name
        descriptionLabel.text = data.description
    }
}
