import Foundation

/// Product Tags: Remote Endpoints
///
public final class ProductTagsRemote: Remote {

    // MARK: - Product Tags

    /// Retrieves all of the `ProductTag` available. We rely on the endpoint
    /// defaults for `context`, ` sorting` and `orderby`: `date_gmt` and `asc`
    ///
    /// - Parameters:
    ///     - siteID: Site for which we'll fetch remote products tags.
    ///     - pageNumber: Number of page that should be retrieved.
    ///     - pageSize: Number of tags to be retrieved per page.
    ///     - completion: Closure to be executed upon completion.
    ///
    public func loadAllProductTags(for siteID: Int64,
                                         pageNumber: Int = Default.pageNumber,
                                         pageSize: Int = Default.pageSize,
                                         completion: @escaping (Result<[ProductTag], Error>) -> Void) {
        let parameters = [
            ParameterKey.page: String(pageNumber),
            ParameterKey.perPage: String(pageSize)
        ]

        let path = Path.tags
        let request = JetpackRequest(wooApiVersion: .mark3, method: .get, siteID: siteID, path: path, parameters: parameters)
        let mapper = ProductTagListMapper(siteID: siteID)

        enqueue(request, mapper: mapper, completion: completion)
    }

    /// Create new multiple `ProductTag` entities.
    ///
    /// - Parameters:
    ///     - siteID: Site for which we'll add a new product tag.
    ///     - names: Tags names.
    ///     - completion: Closure to be executed upon completion.
    ///
    public func createProductTags(for siteID: Int64,
                                      names: [String],
                                      completion: @escaping (Result<[ProductTag], Error>) -> Void) {

        let parameters = [
            ParameterKey.create: names.map {[ParameterKey.name: $0]}.flatMap {$0}
        ]

        let path = Path.tagsBatchCreate
        let request = JetpackRequest(wooApiVersion: .mark3, method: .post, siteID: siteID, path: path, parameters: parameters)
        let mapper = ProductTagListMapper(siteID: siteID)

        enqueue(request, mapper: mapper, completion: completion)
    }

}


// MARK: - Constants
//
public extension ProductTagsRemote {
    enum Default {
        public static let pageSize: Int = 25
        public static let pageNumber: Int = 1
    }

    private enum Path {
        static let tags = "products/tags"
        static let tagsBatchCreate = "products/tags/batch"
    }

    private enum ParameterKey {
        static let page: String = "page"
        static let perPage: String = "per_page"
        static let name: String = "name"
        static let create: String = "create"
    }
}