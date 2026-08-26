# NITC Wiki iOS Port — Changes Checklist

Tracking all changes made to port the Wikimedia iOS app to NITCWiki targeting `wiki.fosscell.org`.

## Phase 1: NITCWiki Build Configuration & Feature Flags
- [x] `[NEW] WMF Framework/NITCWikiConfiguration.swift` — Feature flags struct with capability booleans
- [x] `[MODIFY] WMF Framework/Configuration.swift` — Add NITC domain, paths, and configuration factory

## Phase 2: Domain and URL Path Fixes
- [x] `[MODIFY] Wikipedia/Code/APIURLComponentsBuilder.swift` — NITC hosts and root API paths
- [x] `[MODIFY] Wikipedia/Code/NSURL+WMFLinkParsing.m` — `/api.php` instead of `/w/api.php`
- [x] `[MODIFY] Wikipedia/Code/NSURLComponents+WMFLinkParsing.m` — Root article paths, no language subdomain
- [x] `[MODIFY] WMFData/Sources/WMFData/Utility/WMFURLUtils.swift` — Skip `/wiki/` prefix
- [x] `[MODIFY] WMF Framework/String+LinkParsing.swift` — NITC-aware path regexes
- [x] `[MODIFY] WMF Framework/Router.swift` — Recognize NITC wiki URLs

## Phase 3: Single-Language Wiki & WikimediaProject
- [x] `[MODIFY] Wikipedia/Code/WikimediaProject.swift` — Recognize `wiki.fosscell.org` as NITC project
- [x] `[MODIFY] WMF Framework/Configuration.swift` — Skip language subdomain in API URL builders

## Phase 4: Feature Gating (Disable WMF-Only Services)
- [x] `[MODIFY] WMF Framework/Event Platform/EventPlatformClient.swift` — No-op event submission
- [x] `[MODIFY] Wikipedia/Code/DonateCoordinator.swift` — Gate donation flows
- [x] `[MODIFY] WMF Framework/Remote Notifications/RemoteNotificationsController.swift` — Gate push
- [x] `[MODIFY] WMF Framework/WMFExploreFeedContentController.m` — Simplify feed
- [x] `[MODIFY] WMF Framework/ReadingListsAPIController.swift` — Disable sync

## Phase 5: App Identity, Info.plist & Entitlements
- [x] `[MODIFY] Wikipedia/Wikipedia-Info.plist` — URL scheme (`nitcwiki://`), user activities, permissions
- [x] `[MODIFY] Wikipedia/Wikipedia.entitlements` — Associated domains for `wiki.fosscell.org`

## Phase 6: Branding, Localization & Login Customizations
- [x] `[MODIFY] Wikipedia/Code/WMFLoginViewController.swift` — "Log in to your NITCWiki account", "Join NITCWiki."
- [x] `[MODIFY] Wikipedia/Code/WMFAccountCreationViewController.swift` — "Create a new NITCWiki account"
- [x] `[MODIFY] WMFLocalizations/CommonStrings.swift` — "NITCWiki", "Search NITCWiki", NITC about page URL, Privacy Policy and Terms of Use
- [x] `[MODIFY] WMFLocalizations/InfoPlist.strings` — Bundle display name "NITCWiki"

## Phase 7: WMFData & Auth Endpoint Alignment
- [x] `[MODIFY] WMFData/Sources/WMFData/Models/Shared/WMFProject.swift` — Retarget `siteURL` to `wiki.fosscell.org`
- [x] `[MODIFY] WMFData/Sources/WMFData/Extensions/URL+API.swift` — Retarget MediaWiki API (`/api.php`) and REST (`/rest.php/`)
- [x] `[MODIFY] Wikipedia/Code/NSURL+WMFLinkParsing.m` — Enforce `https://wiki.fosscell.org` as default site URL
- [x] `[MODIFY] Wikipedia/Code/MWKDataStore.m` — Enforce `https://wiki.fosscell.org` for `primarySiteURL`
- [x] `[MODIFY] Wikipedia/Code/MWKLanguageLinkController.m` — Enforce single `https://wiki.fosscell.org` in `preferredSiteURLs`
- [x] `[MODIFY] Wikipedia/Code/WMFAppViewController.swift` — Skip initial Wikipedia onboarding in NITC mode
- [x] `[MODIFY] Wikipedia/Code/APIURLComponentsBuilder.swift` — Strictly enforce NITC host in all RESTBase & MediaWiki production builders
- [x] `[MODIFY] Wikipedia/Code/ExploreViewController.swift` — Filter out non-NITC content groups from FRC feed predicate
- [x] `[MODIFY] WMF Framework/WMFExploreFeedContentController.m` — Purge legacy cached Wikipedia content groups on launch
- [x] `[MODIFY] Wikipedia/Code/WMFAccountLoginLogoutFetcher.swift` — Update `loginreturnurl` to dynamically use `siteURL.absoluteString` (instead of `wikipedia.org`)
- [x] `[MODIFY] Wikipedia/Code/WMFAccountCreator.swift` — Update `createreturnurl` to `siteURL.absoluteString`
- [x] `[MODIFY] Wikipedia/Code/WMFCurrentUserFetcher.swift` — Make `globaluserinfo` optional for standalone MediaWiki without CentralAuth extension
- [x] `[MODIFY] Wikipedia/Code/NSURL+WMFLinkParsing.m` — Fix `wmf_domain` to preserve `wiki.fosscell.org` host rather than stripping to `fosscell.org`
- [x] `[MODIFY] Wikipedia/Code/NSURLComponents+WMFLinkParsing.m` — Always resolve `wmf_hostWithDomain:subDomain:` to `wiki.fosscell.org` in NITC mode
- [x] `[MODIFY] Wikipedia/Code/URL+LinkParsing.swift` — Resolve relative wiki hrefs against root article path (`encodedWikiURL`)
- [x] `[MODIFY] Wikipedia/Code/LinkCoordinator.swift` — Prioritize NITC URL routing to native `ArticleViewController` for in-app cross links
- [x] `[MODIFY] WMF Framework/Configuration.swift` — Add `fosscell.org` to `inAppWebViewRoutingDomains`
- [x] `[MODIFY] WMF Framework/WMFExploreFeedContentController.m` — Add null-safe language code fallback (`?: @"en"`) in `updatedSortOrder` loop
