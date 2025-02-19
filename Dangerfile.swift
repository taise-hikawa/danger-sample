//
//  Danger.swift
//  LocalPackage
//
//  Created by 樋川大聖 on 2025/01/30.
//

import Danger
import Foundation

private let danger = Danger()
private let pullRequest: danger.github!.pullRequest
private let linesAdded = pullRequest.additions ?? 0
private let linesDeleted = pullRequest.deletions ?? 0
private let filesChanged = pullRequest.changedFiles ?? 0
private let bigPRThreshold = 1 // test
private let fileChangesThreshold = 15

if linesAdded + linesDeleted > bigPRThreshold || filesChanged > fileChangesThreshold {
    warn("""
                Pull Request size seems large.
                If this Pull Request contains multiple changes, please split each into separate PRs,
                this will enable faster & easier review.
                """)
}
SwiftLint.lint(inline: true, configFile: ".swiftlint.yml")
