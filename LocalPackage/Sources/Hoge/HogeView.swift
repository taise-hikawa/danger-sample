//
//  HogeView.swift
//  LocalPackage
//
//  Created by 樋川大聖 on 2025/01/30.
//

import SwiftUI

public struct HogeView: View {
    public init() {}
    public var body: some View {
        VStack {
            Text("This is HogeViewThis")
            Text("This one line is intended to cause a violation of lint and test for warnings. hoge hoge hoge hoge hoge hoge hoge hoge hoge hoge hoge")
        }

    }
}
