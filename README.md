# AnchorKit

An AutoLayout library inspired by [SnapKit](https://github.com/SnapKit/SnapKit).

# Usage

If you are familiar with SnapKit, you already know how to use AnchorKit, just with a little change.

### Install new constraints.

```swift
view.anc.installConstraints { make in
    make.edges.equalToSuperview(.safeArea)
}
```

### Reinstall constraints.

```swift
view.anc.reinstallConstraints { make in
    make.edges.equalToSuperview(.safeArea)
}
```

### Custom Dimension

view1.anc.reinstallConstraints { _ in
    let d1 = view3.anc.left.spaceAfter(view1.anc.left)
    let d1 = view4.anc.top.spaceAfter(view2.anc.top)

    make.left. edges.equalToSuperview(.safeArea)
}