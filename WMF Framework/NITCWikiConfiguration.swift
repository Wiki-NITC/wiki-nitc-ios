import Foundation

/// NITCWiki feature flags and configuration.
///
/// This struct provides capability flags that gate WMF-specific features
/// for the NITC Wiki build. It allows the app to cleanly disable services
/// that are unavailable on the NITC wiki deployment (wiki.fosscell.org)
/// without removing code that would make upstream merges harder.
///
/// Usage:
///     if NITCWikiFeatureFlags.current.isNITCWiki {
///         // NITC-specific behavior
///     }
///
///     if NITCWikiFeatureFlags.current.hasDonations {
///         // Show donation UI
///     }
@objc public class NITCWikiFeatureFlags: NSObject {

    /// Master flag: true when running the NITC Wiki build.
    @objc public let isNITCWiki: Bool

    /// RESTBase-compatible API is available at `/api/rest_v1`.
    @objc public let hasRESTBaseCompatibleAPI: Bool

    /// MediaWiki REST API is available at `/rest.php`.
    @objc public let hasMediaWikiREST: Bool

    /// Wikimedia Commons integration is available.
    @objc public let hasCommons: Bool

    /// Wikidata integration is available.
    @objc public let hasWikidata: Bool

    /// EventGate / Event Platform telemetry is available.
    @objc public let hasEventPlatform: Bool

    /// Push notifications (APNs + server-side Echo) are available.
    @objc public let hasPushNotifications: Bool

    /// Donation / fundraising campaign flows are available.
    @objc public let hasDonations: Bool

    /// The wiki has multiple language editions (subdomains like en.*, fr.*, etc.).
    @objc public let hasMultilingualProjects: Bool

    /// Remote reading-list sync is available.
    @objc public let hasReadingListSync: Bool

    /// WMF announcements / fundraising banners are available.
    @objc public let hasAnnouncements: Bool

    /// Year in Review feature is available.
    @objc public let hasYearInReview: Bool

    /// Suggested edits / growth tasks are available.
    @objc public let hasSuggestedEdits: Bool

    // MARK: - Initialization

    private init(
        isNITCWiki: Bool,
        hasRESTBaseCompatibleAPI: Bool,
        hasMediaWikiREST: Bool,
        hasCommons: Bool,
        hasWikidata: Bool,
        hasEventPlatform: Bool,
        hasPushNotifications: Bool,
        hasDonations: Bool,
        hasMultilingualProjects: Bool,
        hasReadingListSync: Bool,
        hasAnnouncements: Bool,
        hasYearInReview: Bool,
        hasSuggestedEdits: Bool
    ) {
        self.isNITCWiki = isNITCWiki
        self.hasRESTBaseCompatibleAPI = hasRESTBaseCompatibleAPI
        self.hasMediaWikiREST = hasMediaWikiREST
        self.hasCommons = hasCommons
        self.hasWikidata = hasWikidata
        self.hasEventPlatform = hasEventPlatform
        self.hasPushNotifications = hasPushNotifications
        self.hasDonations = hasDonations
        self.hasMultilingualProjects = hasMultilingualProjects
        self.hasReadingListSync = hasReadingListSync
        self.hasAnnouncements = hasAnnouncements
        self.hasYearInReview = hasYearInReview
        self.hasSuggestedEdits = hasSuggestedEdits
    }

    // MARK: - Presets

    /// Standard Wikipedia / Wikimedia configuration (all features enabled).
    @objc public static let wikipedia = NITCWikiFeatureFlags(
        isNITCWiki: false,
        hasRESTBaseCompatibleAPI: true,
        hasMediaWikiREST: true,
        hasCommons: true,
        hasWikidata: true,
        hasEventPlatform: true,
        hasPushNotifications: true,
        hasDonations: true,
        hasMultilingualProjects: true,
        hasReadingListSync: true,
        hasAnnouncements: true,
        hasYearInReview: true,
        hasSuggestedEdits: true
    )

    /// NITC Wiki configuration — services unavailable on wiki.fosscell.org are disabled.
    @objc public static let nitcWiki = NITCWikiFeatureFlags(
        isNITCWiki: true,
        hasRESTBaseCompatibleAPI: true,   // Live check: /api/rest_v1 responds 200
        hasMediaWikiREST: true,           // Live check: /rest.php responds 200
        hasCommons: false,                // No Commons
        hasWikidata: false,               // No Wikidata
        hasEventPlatform: false,          // No EventGate
        hasPushNotifications: false,      // No APNs + Echo push infra
        hasDonations: false,              // No donations
        hasMultilingualProjects: false,   // Single-host wiki
        hasReadingListSync: false,        // No remote sync
        hasAnnouncements: false,          // No WMF announcements
        hasYearInReview: false,           // No Year in Review
        hasSuggestedEdits: false          // No Suggested Edits / growth tasks
    )

    // MARK: - Current

    /// The active feature flags for this build.
    @objc public static let current: NITCWikiFeatureFlags = {
        // When built with the NITC_WIKI Swift active compilation condition,
        // use the NITC feature set. Otherwise use the standard Wikipedia set.
        //
        // NOTE: For development/testing, you can temporarily force this to
        // `.nitcWiki` without the compiler flag.
        #if NITC_WIKI
        return .nitcWiki
        #else
        return .nitcWiki  // Temporarily defaulting to NITC for development
        #endif
    }()
}
