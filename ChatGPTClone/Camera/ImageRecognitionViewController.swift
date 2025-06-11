//
//  ImageRecognitionViewController.swift
//  ChatGPTClone
//
//  Created by Ulgen on 10.06.2025.
//

import UIKit
import CoreML
import Vision

class ImageRecognitionViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    var chosenImage = CIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func changeClicked(_ sender: Any) {
        let picker = UIImagePickerController()//UIImagePickerControllerDelegate,UINavigationControllerDelegate
        //bu iki protocolü eklememiz gerek
        picker.delegate = self
        
        picker.sourceType = .photoLibrary //kaynak galeri
        
        present (picker, animated: true,completion: nil)//picker'ı prsent etme
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {//bunu kullnaıcı seçtikten sonra ne yapacağımızı kullanmak için yazarız
        
        imageView.image = info[.originalImage] as? UIImage// Casting
        self.dismiss(animated: true) //bunu kapatıp kendi halime dönmek??
        
        if let ciImage = CIImage(image: imageView.image!){
            chosenImage = ciImage
            
        }
        
        recognizeImage(image: chosenImage)//resmi seçer seçmez çağırıcaz
        
        
        //şimdi bu resmi tanıma işlemi yapıcaz
        
        
        
        
        
    }
    
    func recognizeImage(image : CIImage){//deza vanatjı CIImage şeklinde görsel bekleyecek CoreImage kullanacak
        
        resultLabel.text = "Recognizing..."
        
        if let model = try? VNCoreMLModel(for: MobileNetV2().model){
            
            let request = VNCoreMLRequest(model: model) { vnrequest, error in
                
                if let results = vnrequest.results as? [VNClassificationObservation]{//results any objesi alıyordu onu cast ettik herhalde VNClassificationObservation bu sınıflandırma gözlemi dizisini yapar falan bir şey
                    //burada for loop ile birden fazla tahmın de gösterebiliriz ama biz topResult'ı göstericez şimdi
                    
                    if results.count > 0{
                        
                        let topResult = results.first
                        
                        DispatchQueue.main.async {
                            let confidenceLevel = (topResult?.confidence ?? 0) * 100
                            let rounded = Int(confidenceLevel * 100) / 100 // çarp böl rounded ol
                            self.resultLabel.text = "it's \(topResult!.identifier)   \(rounded)%"
                        }
                    }
                }
            }
            //Request bitti handler işlemine giricez
            let handler = VNImageRequestHandler(ciImage: image)
            DispatchQueue.global(qos: .userInitiated).async{
                do{
                    try handler.perform([request])
                    
                    
                    
                }catch let error as NSError{
                    print(error.localizedDescription)
                }
                
                
            }
            
            
            
        }
        
    }
}
