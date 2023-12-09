//
//  StyledBackgroundImageWidgetPreview.swift
//  DaysUntil
//
//  Created by Robert J. Sarvis Jr on 12/8/23.
//

import SwiftUI

extension Image {
  func styledBackgroundImageWidgetPreview() -> some View {
    self
      .resizable()
      .aspectRatio(contentMode: .fill)
      .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
      .shadow(radius: 10)
      .frame(width: 200, height: 200)
  }
}
