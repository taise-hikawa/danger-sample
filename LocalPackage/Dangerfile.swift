//
//  Danger.swift
//  LocalPackage
//
//  Created by 樋川大聖 on 2025/01/30.
//

import Danger
import Foundation

private let danger = Danger()
private let prChecker = PRChecker(danger: danger)

prChecker.checkPRSize()
prChecker.lintChangedFiles()

private class PRChecker {
    private let danger: DangerDSL
    private let pullRequest: GitHub.PullRequest
    private let currentRelativePath: String

    private let bigPRThreshold = 400
    private let fileChangesThreshold = 15

    init(danger: DangerDSL, currentRelativePath: String = "./LocalPackage") {
        self.danger = danger
        // Ensure GitHub is available; otherwise, terminate.
        guard let github = danger.github else {
            fatalError("Unable to retrieve GitHub information.")
        }
        self.pullRequest = github.pullRequest
        self.currentRelativePath = currentRelativePath
    }

    /// Checks the PR size and warns if it exceeds the set thresholds.
    func checkPRSize() {
        let linesAdded = pullRequest.additions ?? 0
        let linesDeleted = pullRequest.deletions ?? 0
        let filesChanged = pullRequest.changedFiles ?? 0

        if linesAdded + linesDeleted > bigPRThreshold || filesChanged > fileChangesThreshold {
            warn("""
                Pull Request size seems large. 
                If this Pull Request contains multiple changes, please split each into separate PRs,
                this will enable faster & easier review.
                """)
        }
    }

    /// Runs SwiftLint on the changed files.
    func lintChangedFiles() {
        let files = danger.git.createdFiles + danger.git.modifiedFiles
        let prefix = extractPrefix(from: currentRelativePath)
        let convertedFiles = files.map { file -> String in
            if file.hasPrefix(prefix) {
                var relative = file.dropFirst(prefix.count)
                if relative.hasPrefix("/") {
                    relative.removeFirst()
                }
                return String(relative)
            } else {
                return computeRelativePath(from: prefix, to: file)
            }
        }
        SwiftLint.lint(.files(convertedFiles), inline: true, configFile: "../.swiftlint.yml")
    }
}
// MARK: - Private Helpers
extension PRChecker {
    /// Removes the leading "./" from the path if present.
    private func extractPrefix(from path: String) -> String {
        if path.hasPrefix("./") {
            return String(path.dropFirst(2))
        } else {
            return path
        }
    }

    /// Computes the relative path from the `base` path to the `target` path.
    private func computeRelativePath(from base: String, to target: String) -> String {
        // Prepend "/" to both base and target to simulate absolute paths, then standardize them.
        let baseURL = URL(fileURLWithPath: "/" + base).standardized
        let targetURL = URL(fileURLWithPath: "/" + target).standardized

        // Split both URLs into their path components.
        let baseComponents = baseURL.pathComponents
        let targetComponents = targetURL.pathComponents

        // Determine the index where the two paths diverge.
        var commonIndex = 0
        while commonIndex < baseComponents.count &&
                commonIndex < targetComponents.count &&
                baseComponents[commonIndex] == targetComponents[commonIndex] {
            commonIndex += 1
        }

        // For each remaining component in the base, add a ".." to go up one level.
        var relativeComponents = [String]()
        for _ in commonIndex..<baseComponents.count {
            relativeComponents.append("..")
        }

        // Append the remaining components from the target path.
        relativeComponents.append(contentsOf: targetComponents[commonIndex...])

        // Join all components to form the final relative path; return "." if empty.
        let result = relativeComponents.joined(separator: "/")
        return result.isEmpty ? "." : result
    }
}
