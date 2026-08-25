# NITC Wiki iOS Port — Changes Checklist

Tracking all changes made to port the Wikimedia iOS app to NITCWiki targeting `wiki.fosscell.org`.

## Phase 1: NITCWiki Build Configuration & Feature Flags
- [ ] `[NEW] WMF Framework/NITCWikiConfiguration.swift` — Feature flags struct with capability booleans
- [ ] `[MODIFY] WMF Framework/Configuration.swift` — Add NITC domain, paths, and configuration factory

## Phase 2: Domain and URL Path Fixes
- [ ] `[MODIFY] Wikipedia/Code/APIURLComponentsBuilder.swift` — NITC hosts and root API paths
- [ ] `[MODIFY] Wikipedia/Code/NSURL+WMFLinkParsing.m` — `/api.php` instead of `/w/api.php`
- [ ] `[MODIFY] Wikipedia/Code/NSURLComponents+WMFLinkParsing.m` — Root article paths, no language subdomain
- [ ] `[MODIFY] WMFData/Sources/WMFData/Utility/WMFURLUtils.swift` — Skip `/wiki/` prefix
- [ ] `[MODIFY] WMF Framework/String+LinkParsing.swift` — NITC-aware path regexes
- [ ] `[MODIFY] WMF Framework/Router.swift` — Recognize NITC wiki URLs

## Phase 3: Single-Language Wiki & WikimediaProject
- [ ] `[MODIFY] Wikipedia/Code/WikimediaProject.swift` — Recognize `wiki.fosscell.org` as NITC project
- [ ] `[MODIFY] WMF Framework/Configuration.swift` — Skip language subdomain in API URL builders

## Phase 4: Feature Gating (Disable WMF-Only Services)
- [ ] `[MODIFY] WMF Framework/Event Platform/EventPlatformClient.swift` — No-op event submission
- [ ] `[MODIFY] Wikipedia/Code/DonateCoordinator.swift` — Gate donation flows
- [ ] `[MODIFY] WMF Framework/Remote Notifications/RemoteNotificationsController.swift` — Gate push
- [ ] `[MODIFY] WMF Framework/WMFExploreFeedContentController.m` — Simplify feed
- [ ] `[MODIFY] WMF Framework/ReadingListsAPIController.swift` — Disable sync

## Phase 5: App Identity, Info.plist & Entitlements
- [ ] `[MODIFY] Wikipedia/Wikipedia-Info.plist` — URL scheme, activity types, permissions
- [ ] `[MODIFY] Wikipedia/Wikipedia.entitlements` — Associated domains, app groups

## Phase 6: Branding — Strings & Assets
- [ ] `[MODIFY] English Localizable.strings` — App name, search hints, about text
- [ ] `[MODIFY] English InfoPlist.strings` — Bundle display name
