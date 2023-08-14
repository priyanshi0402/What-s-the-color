//
//  ViewController.swift
//  What's the color
//
//  Created by SARVADHI on 13/07/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnNewGame: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var collectionWidth: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblHexString: UILabel!
    
    var colors: [String] = []
    var count = 6.0
    var randomColorHexString = generateRandomColorHexString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Guess the Hex"
        self.newGame()
//        self.count = Double(self.colors.count)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let itemWidth: CGFloat = 80
        let requiredWidth = itemWidth * CGFloat(count)
        print(requiredWidth)
        // Check if the required width exceeds the screen size
        let screenWidth = UIScreen.main.bounds.width
        if requiredWidth > screenWidth {
            // Calculate the maximum number of items that can fit within the screen width
            let maximumItems = Int(screenWidth / itemWidth)
            // Calculate the adjusted width per item
            let adjustedWidth = screenWidth / CGFloat(maximumItems)
            print(((adjustedWidth * CGFloat(count)) - 20))
            self.collectionWidth.constant = ((screenWidth) - 40)
        } else {
            self.collectionWidth.constant = (requiredWidth - 40)
        }
        
        // Do any additional setup after loading the view.
    }
    
    func newGame() {
        self.lblHexString.text = randomColorHexString
        for _ in 1...Int(self.count-1) {
            self.colors.append(generateRandomColorHexString())
        }
        print(self.colors)
        let randomIndex = Int(arc4random_uniform(UInt32(self.colors.count)))
        self.colors.insert(randomColorHexString, at: randomIndex)
        print(self.colors)
        self.btnNewGame.isHidden = true
        self.lblMessage.isHidden = true
    }

    @IBAction func btnNewGameClicked(_ sender: Any) {
        self.colors.removeAll()
        self.randomColorHexString = generateRandomColorHexString()
        self.lblHexString.text = randomColorHexString
        self.newGame()
        self.collectionView.reloadData()
    }
    
    
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.colorView.cornerRadius = cell.bounds.width/2
        cell.colorView.backgroundColor = hexStringToUIColor(hex: self.colors[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.btnNewGame.isHidden {
            self.lblMessage.isHidden = false
            if self.randomColorHexString == self.colors[indexPath.row] {
                self.lblMessage.text = "Yay! Correct!"
                self.btnNewGame.isHidden = false
            } else {
                self.lblMessage.text = "Opps! Try again! that color was \(self.colors[indexPath.row])"
                self.colors.remove(at: indexPath.row)
                collectionView.reloadData()
            }
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = count >= 5 ? 5.0 : 3.0
        if count == 3 {
            size = 3.5
        } else if count == 6 {
            size = 4.5
        } else {
            size = 5
        }
        return CGSize(width: collectionView.frame.width/(size), height: collectionView.frame.width/size)
    }
    
}

func generateRandomColorHexString() -> String {
    let red = Int.random(in: 0...255)
    let green = Int.random(in: 0...255)
    let blue = Int.random(in: 0...255)

    let hexString = String(format: "#%02X%02X%02X", red, green, blue)
    return hexString
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
