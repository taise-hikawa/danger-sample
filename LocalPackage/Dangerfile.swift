//
//  Danger.swift
//  LocalPackage
//
//  Created by 樋川大聖 on 2025/01/30.
//

import Danger
let danger = Danger()

let github = danger.github
let pullRequest = github.pullRequest

let linesAdded = pullRequest.additions ?? 0
let linesDeleted = pullRequest.deletions ?? 0
let filesChanged = pullRequest.changedFiles ?? 0

var bigPRThreshold = 500;
if linesAdded + linesDeleted > bigPRThreshold || filesChanged > 15 {
    warn("Pull Request size seems large. If this Pull Request contains multiple changes, please split each into separate PRs, this will enable faster & easier review.");
}
