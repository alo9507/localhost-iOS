import Foundation
import UIKit

extension UIImageView {
    func loadImageUsingCache(withUrl url: String) {
        
        guard let imageUrl = URL(string: url) else {
            return
        }
        
        let cache = URLCache.shared
        let request = URLRequest(url: imageUrl)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let _ = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            } else {
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                    }.resume()
            }
        }
    }
    
    func roundCorners() {
        layer.masksToBounds = true
        clipsToBounds = true
        layer.cornerRadius = frame.width/2
    }
}
