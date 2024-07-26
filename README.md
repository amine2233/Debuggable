# Debuggable

Swift Error management

## Installation

### Swift Package Manager 

```swift
dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
]
```

## Test

### Linux
```bash
docker run --rm --privileged --interactive --tty --volume "$(pwd):/src" --workdir "/src" swift:latest /bin/bash -c "swift package fetch && swift test"
```
