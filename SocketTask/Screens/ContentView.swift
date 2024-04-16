//
//  ContentView.swift
//  SocketTask
//
//  Created by Tim Nazar on 4/16/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var vm = ContentViewModel(socketService: WaxpeerService())

    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section(content: {
                    receivedMessages
                }, header: {
                    headerView
                })
            }
        }
    }

    private var headerView: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(edges: .all)
            VStack {
                button
                    .padding(.top, 42)
                    .background(.white)
                Text(vm.instructionsText)
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)

                if !vm.receivedMessages.isEmpty {
                    Text("Received Messages:")
                        .font(.title3)
                        .padding(.top, 24)
                        .padding(.bottom, 16)
                }
            }
        }
    }

    private var button: some View {
        Button(action: {
            withAnimation {
                vm.handleTap()
            }
        }, label: {
            VStack {
                if case .connecting = vm.socketService.status {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: vm.buttonImage)
                        .font(.system(size: 32))
                }
                Text(vm.buttonTitle)
                    .font(.system(size: 16, design: .rounded))
                    .padding(.top, 6)
            }
        })
        .buttonStyle(CircularButtonStyle(backgroundColor: vm.buttonBackgroundColor))
    }

    private var receivedMessages: some View {
        VStack(spacing: 16) {
            ForEach(vm.receivedMessages, id: \.self) { message in
                Text(message)
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ContentView()
}
