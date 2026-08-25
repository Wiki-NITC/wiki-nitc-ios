import Foundation

// swiftlint:disable orphaned_doc_comment
///  Provides a small utility for building canonical Wikipedia article URLs)
///  mirroring the behavior of legacy Obj-C helpers  and extensions that live in the client app
// swiftlint:enable orphaned_doc_comment

// MARK: - String helper
extension String {
    var denormalizedPageTitle: String {
        self.replacingOccurrences(of: " ", with: "_")
            .precomposedStringWithCanonicalMapping
    }
}

// MARK: - Language variant (associated object)
// Only this byte's *address* is used, as a unique key for the objc associated
// object below; its value is never read or written, so there is no data race.
// `nonisolated(unsafe)` is Apple's recommended annotation for associated-object
// keys under the Swift 6 language mode.
private nonisolated(unsafe) var wmfLanguageVariantKey: UInt8 = 0
extension NSURL {
    @objc var wmf_languageVariantCode: String? {
        get { objc_getAssociatedObject(self, &wmfLanguageVariantKey) as? String }
        set { objc_setAssociatedObject(self, &wmfLanguageVariantKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
}

extension URL {
    var wmf_languageVariantCode: String? {
        get { (self as NSURL).wmf_languageVariantCode }
        set { (self as NSURL).wmf_languageVariantCode = newValue }
    }

    /// Build article URL: https://<host>/wiki/<title> (Wikipedia) or https://<host>/<title> (NITC).
    func wmfURL(withTitle title: String, languageVariantCode: String? = nil) -> URL? {
        let normalized = title.denormalizedPageTitle

        guard var comps = URLComponents(url: self, resolvingAgainstBaseURL: false),
              comps.scheme != nil, comps.host != nil else { return nil }
        comps.path = ""
        guard let base = comps.url else { return nil }

        let url: URL
        if comps.host?.contains("fosscell.org") == true {
            // NITC Wiki uses root article paths: /<title>
            url = base.appendingPathComponent(normalized, isDirectory: false)
        } else {
            url = base
                .appendingPathComponent("wiki", isDirectory: false)
                .appendingPathComponent(normalized, isDirectory: false)
        }

        (url as NSURL).wmf_languageVariantCode = languageVariantCode
        return url
    }
}
