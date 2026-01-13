import Foundation

struct SunriseResponse: Codable {
    let results: SunriseResults
    let status: String
}

struct SunriseResults: Codable {
    let sunrise: String
    let sunset: String
    let solarNoon: String
    let dayLength: Int
    let civilTwilight_begin: String
    let civilTwilight_end: String
    let nauticalTwilight_begin: String
    let nauticalTwilight_end: String
    let astronomicalTwilight_begin: String
    let astronomicalTwilight_end: String

    enum CodingKeys: String, CodingKey {
        case sunrise, sunset
        case solarNoon = "solar_noon"
        case dayLength = "day_length"
        case civilTwilight_begin = "civil_twilight_begin"
        case civilTwilight_end = "civil_twilight_end"
        case nauticalTwilight_begin = "nautical_twilight_begin"
        case nauticalTwilight_end = "nautical_twilight_end"
        case astronomicalTwilight_begin = "astronomical_twilight_begin"
        case astronomicalTwilight_end = "astronomical_twilight_end"
    }
}

class SunriseService {
    func fetchSunriseTime(latitude: Double, longitude: Double, completion: @escaping (Result<Date, Error>) -> Void) {
        let urlString = "https://api.sunrise-sunset.org/json?lat=\(latitude)&lng=\(longitude)&formatted=0&date=today"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "SunriseService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "SunriseService", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let sunriseResponse = try decoder.decode(SunriseResponse.self, from: data)

                guard let sunriseDate = self.parseISO8601Date(sunriseResponse.results.sunrise) else {
                    completion(.failure(NSError(domain: "SunriseService", code: 3, userInfo: [NSLocalizedDescriptionKey: "Could not parse sunrise time"])))
                    return
                }

                let calendar = Calendar.current
                let now = Date()
                var components = calendar.dateComponents([.year, .month, .day], from: now)
                let sunriseComponents = calendar.dateComponents([.hour, .minute, .second], from: sunriseDate)

                components.hour = sunriseComponents.hour
                components.minute = sunriseComponents.minute
                components.second = sunriseComponents.second

                if let localSunriseDate = calendar.date(from: components) {
                    completion(.success(localSunriseDate))
                } else {
                    completion(.failure(NSError(domain: "SunriseService", code: 4, userInfo: [NSLocalizedDescriptionKey: "Could not create local sunrise date"])))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    func fetchTomorrowSunriseTime(latitude: Double, longitude: Double, completion: @escaping (Result<Date, Error>) -> Void) {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: tomorrow)

        let urlString = "https://api.sunrise-sunset.org/json?lat=\(latitude)&lng=\(longitude)&formatted=0&date=\(dateString)"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "SunriseService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "SunriseService", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let sunriseResponse = try decoder.decode(SunriseResponse.self, from: data)

                guard let sunriseDate = self.parseISO8601Date(sunriseResponse.results.sunrise) else {
                    completion(.failure(NSError(domain: "SunriseService", code: 3, userInfo: [NSLocalizedDescriptionKey: "Could not parse sunrise time"])))
                    return
                }

                let calendar = Calendar.current
                var components = calendar.dateComponents([.year, .month, .day], from: tomorrow)
                let sunriseComponents = calendar.dateComponents([.hour, .minute, .second], from: sunriseDate)

                components.hour = sunriseComponents.hour
                components.minute = sunriseComponents.minute
                components.second = sunriseComponents.second

                if let localSunriseDate = calendar.date(from: components) {
                    completion(.success(localSunriseDate))
                } else {
                    completion(.failure(NSError(domain: "SunriseService", code: 4, userInfo: [NSLocalizedDescriptionKey: "Could not create local sunrise date"])))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    // MARK: - Date Parsing Helper

    /// Parses ISO8601 date strings with or without fractional seconds
    private func parseISO8601Date(_ dateString: String) -> Date? {
        // Try with fractional seconds first
        let formatterWithFractional = ISO8601DateFormatter()
        formatterWithFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = formatterWithFractional.date(from: dateString) {
            return date
        }

        // Try without fractional seconds
        let formatterWithoutFractional = ISO8601DateFormatter()
        formatterWithoutFractional.formatOptions = [.withInternetDateTime]

        if let date = formatterWithoutFractional.date(from: dateString) {
            return date
        }

        // Try with DateFormatter as fallback (handles more formats)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        // Common ISO8601 formats the API might return
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ssXXXXX",
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        ]

        for format in formats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }

        return nil
    }
}
