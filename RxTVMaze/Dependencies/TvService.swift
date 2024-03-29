//
//  TvService.swift
//  RxTVMaze
//
//  Created by Joshua Homann on 9/21/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import Moya
import RxSwift

struct TVService: TVServiceProtocol {
  private let provider = MoyaProvider<TVMazeService>()
  private func decoded<SomeDecodable: Decodable> (type: SomeDecodable.Type, from target: TVMazeService) -> Single<SomeDecodable> {
    Single<Data>.create { [provider] observer in
      var cancellable: Cancellable?
      cancellable = provider.request(target) { result in
        switch result {
        case .success(let response):
          observer(.success(response.data))
        case .failure(let error):
          observer(.error(error))
        }
      }
      return Disposables.create {
        cancellable?.cancel()
      }
    }
    .map { try JSONDecoder().decode(SomeDecodable.self, from: $0) }
  }
  func search(query: String) -> Single<[Show]> {
    decoded(type: [ShowResults].self, from: .search(query: query))
      .map { $0.map { $0.show } }
  }
  func episodes(showId: Int) -> Single<[Episode]> {
    decoded(type: [Episode].self, from: .episodes(showId: showId))
  }
}

enum TVMazeService {
  case search(query: String)
  case episodes(showId: Int)
}

extension TVMazeService: TargetType {
  var sampleData: Data {
    return Data()
  }

  var headers: [String : String]? {
    [:]
  }

  var baseURL: URL { URL(string: "http://api.tvmaze.com")! }

  var path: String {
    switch self {
    case .search:
      return "search/shows"
    case .episodes(let showId):
      return "shows/\(showId)/episodes"
    }
  }

  var method: Moya.Method {
    switch self {
    case .episodes, .search:
      return .get
    }
  }

  var parameterEncoding: ParameterEncoding {
    switch self {
    case .episodes, .search:
      return URLEncoding.default
    }
  }

  var task: Task {
    switch self {
    case .episodes:
      return .requestPlain
    case .search(let query):
      return .requestParameters(parameters: ["q": query], encoding: URLEncoding.default)
    }
  }
}
