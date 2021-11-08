# About TOMLKit

## Getting Started

Once you have installed TOMLKit, you will usually create a ``TOMLTable``, or decode a TOML document into a Swift structure.

## Creating TOML Values

### Tables

TOML tables are key-value pairs, similar to a Swift `Dictionary`. They can also be embedded inside one another.

To create a empty ``TOMLTable``, use the ``TOMLTable/init(inline:)`` initializer, where `inline` makes the table an inline table:

```toml
# `inline` is true.
inlineTable = { field1 = "", ... }
```

or a regular table:

```toml
# `inline` is false.
[regularTable]
field1 = ""
...
```

To create a ``TOMLTable`` with values, use one of the below methods:

#### From a Dictionary

```swift
let table = TOMLTable(["string": "Hello, World!", "int": 345025, "double": 025307.350])

// Or use `TOMLTable`'s `ExpressibleByDictionaryLiteral` conformance.
let table = ["string": "Hello, World!", "int": 345025, "double": 025307.350] as TOMLTable
```

#### From a TOML String

```swift
let toml = """
string = "Hello, World!"
int = 523053
double = 3250.34
"""

do {
   let table = try TOMLTable(string: toml)
} catch let error as TOMLParseError {
   // TOMLParseError occurs when the TOML document is invalid.

   /// `error.source.begin` contains the line and column where the error started,
   /// and `error.source.end` contains the line where the error ended.
    print(error.source.begin)
    print(error.source.end)
}
```

To insert values, make sure the value conforms to ``TOMLValueConvertible``, then use the ``TOMLTable/subscript(_:)-76dpr``, or the ``TOMLTable/insert(_:at:)`` method:

```swift
let table = TOMLTable()

table["string"] = "Hello, World!"
table.insert(127, at: "int")
table["table"] = TOMLTable(["string 1": "Hello, Again!"], inline: true)
table["table"] = TOMLTable(["string 2": "Hello, Again!"], inline: false)

// Insert an integer using an octal representation.
table.insert(TOMLInt(0o755, options: .formatAsOctal), at: "octalInt")
```

#### Conversion

```swift
let table: TOMLTable = ...

// Convert to TOML using default settings.
let toml1 = table.convert()

// Convert to JSON using default settings.
let json = table.convert(to: .json)

// Convert to YAML using default settings.
let yaml = table.convert(to: .yaml)

// Convert to TOML with custom settings.
let toml2 = table.convert(to: .toml, options: [.quoteDateAndTimes, .allowMultilineStrings])
```

### Arrays

TOML arrays are similar to a Swift `Array`. They can be embedded inside one another.

To create a empty ``TOMLArray``, use the ``TOMLArray/init()`` initializer.

To create a ``TOMLArray`` with values, use one of the below methods:

```swift
let array = TOMLArray(
	[
		"Hello, World!",
		"Hello, Again!",
		3294923,
		2350.53,
		TOMLTable(["string": "string 1"])
	]
)

// Or use `TOMLArray`'s `ExpressibleByArrayLiteral` conformance.
let array = [
	"Hello, World!",
	"Hello, Again!",
	3294923,
	2350.53,
	TOMLTable(["string": "string 1"])
] as TOMLArray
```

To insert values, use the ``TOMLArray/subscript(_:)-6f1f``, the ``TOMLArray/append(_:)`` method, or the ``TOMLArray/insert(_:at:)`` method:

```swift
let array = TOMLArray()

array.append("Hello, World")
array.insert(TOMLInt(0x123abc, options: .formatAsHexadecimal), at: 1)
array[0] = TOMLTable(["double": 02734.23])
```

### Dates

```swift
// Create a `TOMLDate` from numerical values.
let date = TOMLDate(year: 2021, month: 6, day: 10)

// Create a `TOMLDate` from `Foundation.Date`
import Foundation

let date2 = TOMLDate(date: Date())
let table = TOMLTable(["Date1": date, "Date2": date2])
```

### Times

```swift
// Create a `TOMLTime` from numerical values.
let time = TOMLTime(hour: 12, minute: 27, second: 49)
let table = TOMLTable(["time": time])
```

### Date and Time

```swift
// Create a `TOMLDateTime` from numerical values.
let dateTime = TOMLDateTime(
	date: TOMLDate(year: 2021, month: 5, day: 20),
	time: TOMLTime(hour: 4, minute: 27, second: 5, nanoSecond: 294),
	offset: TOMLTimeOffset(offset: 0)
)

// Create a `TOMLDateTime` from `Foundation.Date`
import Foundation
let dateTime2 = TOMLDateTime(date: Date())

let table = TOMLTable(["DateTime": dateTime, "DateTime2": dateTime2])
```

### `Data`

```swift
import Foundation

let data = Data([0x01, 0x02, 0x03])

// `data` will be encoded as Base64.
let table = TOMLTable(["data": data])
```

### Integers

Integers that don't need to be formatted will be converted to a ``TOMLInt`` automatically.
Use the ``TOMLInt/init(_:options:)`` initializer to format integers as octal, hexadecimal, or binary values.

## Retrieving TOML values

### From Tables

```swift
let table: TOMLTable = ...

if let string = table["string"]?.string {
   print(string)
}

if let bool = table["bool"]?.bool {
   print(bool)
}

if let double = table["InnerTable"]?["InnerInnerTable"]?["InnerInnerInnerTable"]?["double"]?.double {
print(double)
}

...
```

### From Arrays

```swift
let array: TOMLArray = ...

if let string = array[0].string? {
   print(string)
}

if let bool = array[1].bool? {
   print(bool)
}

if let double = array[2][0]?.double? {
   print(double)
}

for value in array {
   print(value)
}
```

## Encoding `struct` to TOML

```swift
struct TestStruct: Encodable {
	let string: String = "Hello, World!"
	let int: Int = 200823
}

let toml = try TOMLEncoder().encode(TestStruct())

print(toml)
```

## Decoding TOML to `struct`

```swift
struct TestStruct: Decodable {
	let string: String
	let int: Int
}

let testStruct = try TOMLDecoder().decode(TestStruct.self, from: "string = \"Hello, World!\"\nint = 405347")

print(testStruct)
```

