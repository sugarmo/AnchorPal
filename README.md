# AnchorPal

![](https://img.shields.io/cocoapods/v/AnchorPal?style=for-the-badge)

An AutoLayout library inspired by [SnapKit](https://github.com/SnapKit/SnapKit).

# Installation

**CocodPods**

Add this line to your Podfile

```ruby
pod 'AnchorPal'
```

**Manually**

Add `AnchorPal.xcodeproj` to your current project.

# Usage

If you are familiar with SnapKit, you already know how to use AnchorPal, just with a little changes.

### Install new constraints.

```swift
view.anc.installConstraints { the in
    the.xEdges.equalToSuperview()
    // with a optional parameter, you can easily refer to the layoutGuides of superview
    the.yEdges.equalToSuperview(\.safeArea)
}
```

### Reinstall constraints.

```swift
view.anc.reinstallConstraints { the in
    the.height.equalTo(newValue)
}
```

### Make constraints without installing.

```swift
let constaints = view.anc.makeConstraints { the in
    the.edges.equalToSuperview(\.safeArea)
}

// Activate them later
constraints.activate()
```

## Inset

**Note**: We don't use `first.relationTo(second).inset(x)` format, because it's ambiguous.

When we say `first.>=(second).inset(x)`, it can be "The first item has a greater value than second item insetting x.", but also can be "The inset from second item to first item is greater than x.". We want to be clear about the intent.

```swift
view.anc.installConstraints { the in
    the.edges.insetFromSuperview().equalTo(30)
}
// or 
view.anc.installConstraints { the in
    the.edges.insetFrom(otherView).greaterEqualTo(30)
}
```

### Set dynamic constraint constant.

```swift
view.anc.installConstraints { the in
    the.width.equalTo { position -> CGFloat in
        // return a CGFloat as the new constant
        // position is the info about the current anchor which is calling this closure
        return newWidth
    }
}

// update constants later
view.anc.updateConstraintConstants()
```

### Custom Dimension (iOS 10+, tvOS 10+, macOS 10.12+)

```swift
view1.anc.reinstallConstraints { the in
    let space1 = the.trailing.spaceBefore(view2.anc.leading)
    let space2 = the.bottom.spaceBefore(view3.anc.top)
    space1.equalTo(space2)
}
```

### System Spacing (iOS 11+, tvOS 11+, macOS 11+)

```swift
// custom dimension to system spcaing
view1.anc.reinstallConstraints { the in
    the.leading.spaceAfter(view2.anc.trailing).equalToSystemSpacing().multiply(2)
}

// or anchor to anchor 
view1.anc.reinstallConstraints { the in
    the.leading.equalToSystemSpacingAfter(view2.anc.trailing).multiply(2)
}
```

### Install or make constraints within static function.

```swift
// Sometimes you just don't want to bind these constraints to any view.
Anc.installConstraints {
    view1.anc.edges.equalToSuperview(\.safeArea)
    view2.anc.top.equalTo(view1.anc.bottom).plus(20)
}
```

### Install or make constraints outside the closure.

```swift
// make and install
view1.anc.edges.equalToSuperview(\.safeArea).active()
view2.anc.top.equalTo(view1.anc.bottom).plus(20).active()

// or just make
let constraint1 = view1.anc.edges.equalToSuperview(\.safeArea)
let constraint2 = view2.anc.top.equalTo(view1.anc.bottom).plus(20)
```

### About the relation name.

We change the `lessThanOrEqualTo` to `lessEqualTo`, and `greaterThanOrEqualTo` to `greaterEqualTo`, just be shorter, but still has no ambiguity.

# Closing

AnchorPal is designed to be flexbile and readable, hope you can enjoy it, if don't, please feel free to tell us.
