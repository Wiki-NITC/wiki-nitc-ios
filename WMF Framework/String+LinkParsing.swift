/// Detect Wiki namespace in strings. For example, detect that "/wiki/Talk:Dog" is a talk page and "/wiki/Special:ApiSandbox" is a special page
extension String {
    static let namespaceRegex = try! NSRegularExpression(pattern: "^(.+?)_*:_*(.*)$")
    // Assumes the input is the remainder of a /wiki/ path
    func namespaceOfWikiResourcePath(with languageCode: String) -> PageNamespace {
        guard let namespaceString = String.namespaceRegex.firstReplacementString(in: self) else {
            return .main
        }
        return WikipediaURLTranslations.commonNamespace(for: namespaceString, in: languageCode) ?? .main
    }
    
    public func namespaceAndTitleOfWikiResourcePath(with languageCode: String) -> (namespace: PageNamespace, title: String) {
        guard let result = String.namespaceRegex.firstMatch(in: self) else {
            return (.main, self)
        }
        let namespaceString = String.namespaceRegex.replacementString(for: result, in: self, offset: 0, template: "$1")
        guard let namespace = WikipediaURLTranslations.commonNamespace(for: namespaceString, in: languageCode) else {
            return (.main, self)
        }
        let title = String.namespaceRegex.replacementString(for: result, in: self, offset: 0, template: "$2")
        return (namespace, title)
    }
    
    static let wikiResourceRegex = try! NSRegularExpression(pattern: "^/wiki/(.+)$", options: .caseInsensitive)
    // NITC Wiki: article paths are at root /<title>, not /wiki/<title>
    // Match any path that doesn't look like a known script/API path
    static let nitcWikiResourceRegex = try! NSRegularExpression(pattern: "^/([^/]+.*)$", options: .caseInsensitive)
    // Known NITC non-article path prefixes to exclude from root article matching
    private static let nitcNonArticlePrefixes = ["api.php", "rest.php", "api/", "index.php", "load.php", "thumb/", "images/", "skins/", "extensions/", "resources/"]
    
    var wikiResourcePath: String? {
        if NITCWikiFeatureFlags.current.isNITCWiki {
            // For NITC, try /wiki/ first (for compatibility), then root path
            if let wikiMatch = String.wikiResourceRegex.firstReplacementString(in: self) {
                return wikiMatch
            }
            // Match root paths but exclude known script/API paths
            guard let rootMatch = String.nitcWikiResourceRegex.firstReplacementString(in: self) else {
                return nil
            }
            for prefix in String.nitcNonArticlePrefixes {
                if rootMatch.hasPrefix(prefix) {
                    return nil
                }
            }
            return rootMatch
        }
        return String.wikiResourceRegex.firstReplacementString(in: self)
    }
    
    static let wResourceRegex = try! NSRegularExpression(pattern: "^/w/(.+)$", options: .caseInsensitive)
    public var wResourcePath: String? {
        if NITCWikiFeatureFlags.current.isNITCWiki {
            // NITC Wiki: script paths are at root, e.g. /index.php instead of /w/index.php
            // Try /w/ first for compatibility, then root
            if let wMatch = String.wResourceRegex.firstReplacementString(in: self) {
                return wMatch
            }
            // Check if path starts with a known script
            let pathWithoutSlash = String(self.dropFirst()) // remove leading /
            if pathWithoutSlash.hasPrefix("index.php") {
                return pathWithoutSlash
            }
            return nil
        }
        return String.wResourceRegex.firstReplacementString(in: self)
    }
    
    public var fullRange: NSRange {
        return NSRange(startIndex..<endIndex, in: self)
    }

    public func extractingArticleTitleFromTalkPage(languageCode: String) -> String? {
        if let namespaceString = String.namespaceRegex.firstReplacementString(in: self) {
            let namespaceStringWithColon = "\(namespaceString):"
            if namespaceOfWikiResourcePath(with: languageCode) == .talk {
                return replacingOccurrences(of: namespaceStringWithColon, with: "")
            }
        }
        return nil
    }

}

/// Page title transformation
public extension String {
    var percentEncodedPageTitleForPathComponents: String? {
        return denormalizedPageTitle?.addingPercentEncoding(withAllowedCharacters: .encodeURIComponentAllowed)
    }

     var normalizedPageTitle: String? {
        return replacingOccurrences(of: "_", with: " ").precomposedStringWithCanonicalMapping
     }
    
     var denormalizedPageTitle: String? {
        return replacingOccurrences(of: " ", with: "_").precomposedStringWithCanonicalMapping
     }
    
    var asTalkPageFragment: String? {
        let denormalizedName = replacingOccurrences(of: " ", with: "_")
        let unlinkedName = denormalizedName.replacingOccurrences(of: "[[", with: "").replacingOccurrences(of: "]]", with: "")
        return unlinkedName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.wmf_encodeURIComponentAllowed())
    }
    
    // assumes string is already normalized
    var googleFormPercentEncodedPageTitle: String? {
        return googleFormPageTitle?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    var googleFormPageTitle: String? {
        return replacingOccurrences(of: " ", with: "+").precomposedStringWithCanonicalMapping
    }
    
    var unescapedNormalizedPageTitle: String? {
        return removingPercentEncoding?.normalizedPageTitle
    }
    
    var isReferenceFragment: Bool {
        return contains("ref_")
    }
    
    var isCitationFragment: Bool {
        return contains("cite_note")
    }
    
    var isEndNoteFragment: Bool {
        return contains("endnote_")
    }
}

@objc extension NSString {
    /// Deprecated - use namespace methods
    @objc var wmf_isWikiResource: Bool {
        return (self as String).wikiResourcePath != nil
    }
    
    /// Deprecated - use swift methods
    @objc var wmf_pathWithoutWikiPrefix: String? {
        return (self as String).wikiResourcePath
    }
    
    /// Deprecated - use swift methods
    @objc var wmf_denormalizedPageTitle: String? {
        return (self as String).denormalizedPageTitle
    }
    
    /// Deprecated - use swift methods
    @objc var wmf_normalizedPageTitle: String? {
        return (self as String).normalizedPageTitle
    }
    
    /// Deprecated - use swift methods
    @objc var wmf_unescapedNormalizedPageTitle: String? {
        return (self as String).unescapedNormalizedPageTitle
    }
    
    /// Deprecated - use swift methods
    @objc var wmf_isReferenceFragment: Bool {
        return (self as String).isReferenceFragment
    }
    
    /// Deprecated - use swift methods
    @objc var wmf_isCitationFragment: Bool {
        return (self as String).isCitationFragment
    }
    
    /// Deprecated - use swift methods
    @objc var wmf_isEndNoteFragment: Bool {
        return (self as String).isEndNoteFragment
    }
}
