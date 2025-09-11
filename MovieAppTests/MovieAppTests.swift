//import XCTest
//@testable import MovieApp
//
//class MockNetworkService: NetworkServiceProtocol {
//    var dataToReturn: Data?
//    var errorToThrow: Error?
//
//    func fetch<T>(_ type: T.Type, from url: URL) async throws -> T where T : Decodable, T : Encodable {
//        if let error = errorToThrow {
//            throw error
//        }
//        guard let data = dataToReturn else {
//            throw NetworkError.noData
//        }
//
//        do {
//            let decoded = try JSONDecoder().decode(type, from: data)
//            return decoded
//        } catch {
//            throw NetworkError.decodingError(error)
//        }
//    }
//
//    func fetchData(from url: URL) async throws -> Data {
//        if let error = errorToThrow {
//            throw error
//        }
//        guard let data = dataToReturn else {
//            throw NetworkError.noData
//        }
//        return data
//    }
//}
//
//final class MovieAppTests: XCTestCase {
//    var mockNetworkService: MockNetworkService!
//    var tmdbService: TMDbService!
//
//    override func setUp() {
//        super.setUp()
//        mockNetworkService = MockNetworkService()
//        tmdbService = TMDbService(networkService: mockNetworkService)
//    }
//
//    override func tearDown() {
//        mockNetworkService = nil
//        tmdbService = nil
//        super.tearDown()
//    }
//
//    func testFetchPopularMoviesSuccess() async throws {
//        let jsonString = """
//        {
//          "page": 1,
//          "results": [
//            {
//              "id": 101,
//              "title": "Test Movie",
//              "poster_path": "/test.jpg"
//            }
//          ],
//          "total_results": 100,
//          "total_pages": 10
//        }
//        """
//
//        mockNetworkService.dataToReturn = Data(jsonString.utf8)
//
//        let response = try await tmdbService.fetchPopularMovies()
//        XCTAssertEqual(response.results.first?.id, 101)
//        XCTAssertEqual(response.results.first?.title, "Test Movie")
//    }
//
//    func testFetchPopularMoviesFailureNetworkError() async {
//        mockNetworkService.errorToThrow = NetworkError.networkError(URLError(.notConnectedToInternet))
//
//        do {
//            _ = try await tmdbService.fetchPopularMovies()
//            XCTFail("Expected network error to be thrown")
//        } catch let error as NetworkError {
//            switch error {
//            case .networkError:
//                XCTAssertTrue(true)
//            default:
//                XCTFail("Expected networkError but got \(error)")
//            }
//        } catch {
//            XCTFail("Unexpected error: \(error)")
//        }
//    }
//
//    func testFetchPopularMoviesFailureDecodingError() async {
//        let invalidJSON = """
//        { "invalid": "data" }
//        """
//        mockNetworkService.dataToReturn = Data(invalidJSON.utf8)
//
//        do {
//            _ = try await tmdbService.fetchPopularMovies()
//            XCTFail("Expected decoding error")
//        } catch let error as NetworkError {
//            switch error {
//            case .decodingError:
//                XCTAssertTrue(true)
//            default:
//                XCTFail("Expected decodingError but got \(error)")
//            }
//        } catch {
//            XCTFail("Unexpected error: \(error)")
//        }
//    }
//}
