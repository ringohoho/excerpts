//
//  ShareView.swift
//  excerpt
//
//  Created by Richard on 2023/9/13.
//

import SwiftUI

struct ShareView: View {
    @Binding var isPresented: Bool

    var excerpt: Excerpt

    func dismiss() {
        self.isPresented = false
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        VStack(alignment: .trailing) {
                            Text(self.excerpt.content)
                                .font(.custom("SourceHanSerifSC-Regular", size: 18))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 10)

                            if !self.excerpt.book.isEmpty {
                                Text(self.excerpt.book)
                                    .font(.custom("SourceHanSerifSC-Regular", size: 18))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            if !self.excerpt.author.isEmpty {
                                Text(self.excerpt.author)
                                    .font(.custom("SourceHanSerifSC-Regular", size: 18))
                                    .padding(.trailing, 2)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }

//                            HStack(spacing: 0) {
//                                Spacer()
//
//                                Text("——")
//                                    .font(.custom("SourceHanSerifSC-Regular", size: 18))
//                                    .padding(.trailing, 6)
//
//                                if !self.excerpt.author.isEmpty {
//                                    Text(self.excerpt.author)
//                                        .font(.custom("SourceHanSerifSC-Regular", size: 18))
//                                        .padding(.trailing, 2)
//                                }
//                                if !self.excerpt.book.isEmpty {
//                                    Text("《\(self.excerpt.book)》")
//                                        .font(.custom("SourceHanSerifSC-Regular", size: 18))
//                                }
//                            }
//                            .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(18)
                    }
                    .background(Color.white)
                    .foregroundStyle(.black)
                    .padding([.leading, .trailing], 15)
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                    .onTapGesture {
                        self.dismiss()
                    }
                }
//                .background(Color.blue)
                .onTapGesture {
                    self.dismiss()
                }

//                HStack {
//                    Text("Btn1")
//                        .background(Color.purple)
//
//                    Text("Btn2")
//                        .background(Color.yellow)
//                }
//                .frame(width: geometry.size.width, height: 40)
//                .background(Color.green)
            }
            .padding(0)
        }
    }
}

#Preview("Share Dark") {
    MainView(excerpts[0], sharing: true)
        .preferredColorScheme(.dark)
}

#Preview("Share Short Light") {
    MainView(Excerpt(id: UUID(), content: "你好。", book: "一本书", author: "谁"), sharing: true)
}

#Preview("Share Long") {
    MainView(Excerpt(id: UUID(), content: excerpts[0].content + "\n" + excerpts[0].content, book: "这是一本名字超长的书：甚至还有副标题", author: "名字超长的作者·甚至还有 Last Name"), sharing: true)
}
