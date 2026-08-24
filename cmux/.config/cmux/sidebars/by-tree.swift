func bucket(_ dir) -> String {
  if dir.hasPrefix("/Users/chinmay/workspace") || dir.hasPrefix("~/workspace") { return "workspace" }
  if dir.hasPrefix("/Users/chinmay/tribe") || dir.hasPrefix("~/tribe") { return "tribe" }
  return "other"
}

func tint(_ w) -> String {
  let b = bucket(w.directory)
  if b == "workspace" { return "#39A78E" }
  if b == "tribe" { return "#C9A0DC" }
  return "#E48400"
}

func glyph(_ w) -> String {
  let b = bucket(w.directory)
  if b == "workspace" { return "hammer.fill" }
  if b == "tribe" { return "building.2.fill" }
  return "folder.fill"
}

func leaf(_ dir) -> String {
  let parts = dir.split(separator: "/")
  if parts.count > 0 { return String(parts[parts.count - 1]) }
  return dir
}

func hasBranch(_ w) -> Bool {
  return w.branch != nil && w.branch != ""
}

func hasMessage(_ w) -> Bool {
  return w.latestMessage != nil && w.latestMessage != ""
}

func hasProgressLabel(_ w) -> Bool {
  return w.progress != nil && w.progress.label != nil && w.progress.label != ""
}

func hasPR(_ w) -> Bool {
  return w.pr != nil && w.pr.label != nil && w.pr.label != ""
}

func dot() -> some View {
  Text("·").font(.system(size: 10)).foregroundColor(.tertiary).opacity(0.7)
}

func meta(_ w) -> some View {
  HStack(spacing: 4) {
    Text(leaf(w.directory))
      .font(.system(size: 10, design: .monospaced))
      .foregroundColor(.secondary)
      .lineLimit(1)
    if hasProgressLabel(w) {
      dot()
      Text(w.progress.label).font(.system(size: 10)).foregroundColor(tint(w)).lineLimit(1)
    }
    if hasPR(w) {
      dot()
      Text(w.pr.label)
        .font(.system(size: 10, design: .monospaced))
        .foregroundColor(w.pr.stale == true ? .tertiary : "#4C9DF0")
        .lineLimit(1)
    }
    if !hasPR(w) && hasBranch(w) {
      dot()
      Text(w.dirty == true ? "\(w.branch)*" : w.branch)
        .font(.system(size: 10, design: .monospaced))
        .foregroundColor(.tertiary)
        .lineLimit(1)
    }
    if w.tabCount > 1 {
      dot()
      Text("\(w.tabCount) tabs").font(.system(size: 10)).foregroundColor(.tertiary)
    }
  }
}

func portLine(_ w) -> some View {
  HStack(spacing: 4) {
    ForEach(w.ports.prefix(8)) { p in
      Text(":\(p)").font(.system(size: 10, design: .monospaced)).foregroundColor("#89A894")
    }
    if w.portCount > 8 {
      Text("+\(w.portCount - 8)").font(.system(size: 10)).foregroundColor("#89A894")
    }
  }
}

func row(_ w) -> some View {
  Button(action: { cmux("workspace.select", workspace_id: w.id) }) {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 5) {
        if w.pinned {
          Image(systemName: "pin.fill").font(.system(size: 9)).foregroundColor(.tertiary)
        }
        Image(systemName: glyph(w))
          .font(.system(size: 10))
          .foregroundColor(tint(w))
          .opacity(w.selected ? 1.0 : 0.7)
        Text(w.title)
          .font(.system(size: 12))
          .fontWeight(w.selected ? .semibold : .regular)
          .foregroundColor(w.selected ? .primary : .secondary)
          .lineLimit(1).truncationMode(.tail)
        Spacer()
        if w.portCount > 2 {
          HStack(spacing: 3) {
            Image(systemName: "server.rack").font(.system(size: 9))
            Text("\(w.portCount)").font(.system(size: 9, design: .monospaced))
          }
          .foregroundColor("#89A894")
        }
        if w.unread > 0 {
          Text("\(w.unread)")
            .font(.system(size: 9, design: .monospaced)).bold()
            .foregroundColor("#0B0B0C")
            .padding(3)
            .background { Circle().foregroundColor(tint(w)) }
        }
      }
      meta(w)
      if w.portCount > 0 {
        portLine(w)
      }
      if hasMessage(w) {
        Text(w.latestMessage)
          .font(.system(size: 10))
          .foregroundColor(.tertiary)
          .lineLimit(2).truncationMode(.tail)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(6)
    .background {
      RoundedRectangle(cornerRadius: 6)
        .foregroundColor(w.selected ? tint(w) : "#FFFFFF")
        .opacity(w.selected ? 0.14 : 0.001)
    }
    .overlay {
      RoundedRectangle(cornerRadius: 6)
        .stroke(tint(w), lineWidth: 1)
        .opacity(w.selected ? 0.4 : 0.0)
    }
    .contentShape(Rectangle())
  }
}

VStack(alignment: .leading, spacing: 0) {
  Reorderable(workspaces.prefix(30), move: "workspace.reorder") { w in
    VStack(alignment: .leading, spacing: 0) {
      row(w)
      Spacer().frame(height: 10)
    }
  }
  Spacer()
}
.padding(4)
