import Foundation

struct ChildService {
    static func sendLocation(childId: String, lat: Double, lng: Double, token: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let body = ["lat": lat, "lng": lng]
        NetworkService.shared.patchRequest(to: .updateChildLocation(childId: childId), body: body, token: token) { result in
            switch result {
            case .success(_):
                print("✅ Location updated")
                completion(.success(()))
            case .failure(let error):
                print("❌ Failed to update location: \(error)")
                completion(.failure(error))
            }
        }
    }
}
