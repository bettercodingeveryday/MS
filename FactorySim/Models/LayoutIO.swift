import Foundation

struct LayoutIO {
    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }()

    private static let decoder: JSONDecoder = {
        JSONDecoder()
    }()

    static func save(layout: FactoryLayout, to url: URL) throws {
        let data = try encoder.encode(layout)
        try data.write(to: url)
    }

    static func load(from url: URL) throws -> FactoryLayout {
        let data = try Data(contentsOf: url)
        return try decoder.decode(FactoryLayout.self, from: data)
    }

    static func sampleJSON() throws -> Data {
        try encoder.encode(FactoryLayout.sample())
    }
}
