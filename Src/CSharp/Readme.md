# SovereignTrust.SignalGraph

SignalGraph is a C# library for carrying execution results and structured feedback between application components. Use `Signal` for feedback alone or `Signal<T>` to include a typed result. It is part of the SovereignTrust protocol suite.

The NuGet package is named `SovereignTrust.SignalGraph`; its C# namespace is `SignalGraph`.

## Installation

```shell
dotnet add package SovereignTrust.SignalGraph
```

The library targets .NET Standard 2.0. Its direct package dependencies are:

- `Microsoft.Extensions.Logging.Abstractions` 9.0.4
- `Newtonsoft.Json` 13.0.3

NuGet restores these dependencies when you install the package.

## Quick start

```csharp
using System;
using Microsoft.Extensions.Logging.Abstractions;
using SignalGraph;

// Set once during application startup, before logging feedback.
Signal.Logger = NullLogger.Instance;

var signal = Signal.Start<string>("Hello, SignalGraph!");
signal.LogInformation("Operation completed.");

Console.WriteLine(signal.Result);
Console.WriteLine(signal.Success); // True
Console.WriteLine(signal.ToJson());
```

`Signal.Logger` is shared by all signals. Assign your application's `Microsoft.Extensions.Logging.ILogger` to forward feedback to its logging provider, or use `NullLogger.Instance` to keep feedback in the signal without emitting external logs. Information, warning, retry, and critical feedback methods throw if the logger has not been initialized.

## Results and feedback

The following examples assume the logger has been configured as above.

```csharp
using SignalGraph;

// Feedback without a result.
var feedback = Signal.Start();
feedback.LogWarning("Some optional data was unavailable.");

// Feedback with a typed result.
Signal<int> result = Signal.Start<int>(42);
result.LogInformation("Answer calculated.");

// Entries can also be classified by nature.
var entry = result.LogWarning("Using a cached answer.");
entry.Nature = SignalFeedbackNature.Operations;
```

`Entries` contains the feedback records, including their message, level, nature, and creation time. `SignalFeedbackNature` provides `Unspecified`, `Code`, `Operations`, `Security`, and `Content` categories.

Feedback methods include `LogInformation`, `LogVerbose`, `LogWarning`, `LogRetry`, and `LogCritical`. Use `LogMessage` to specify a level directly. Logging feedback raises the signal's `Level` to the highest level recorded.

| Feedback level | Value |
| --- | ---: |
| `Unspecified` | 0 |
| `SensitiveInformation` | 1 |
| `VerboseInformation` | 2 |
| `Information` | 4 |
| `Warning` | 8 |
| `Retry` | 16 |
| `Critical` | 32 |

By default, `Success` is true when `Level` is at or below `Retry`, and `Failure` is true when it is above `Retry`. A warning or retry therefore still counts as success; critical feedback counts as failure. These properties describe the feedback threshold and do not validate the result value. Use `CheckForLevelSuccess` or `CheckForLevelFailure` with an explicit threshold when your application needs different rules.

## Merge feedback

```csharp
using SignalGraph;

var first = Signal.Start();
first.LogInformation("First step completed.");

var second = Signal.Start();
second.LogWarning("Second step used cached data.");

var combined = Signal.Start();
combined.MergeSignal(first, second);
// combined.Entries.Count is 2; combined.Level is Warning.
```

`MergeSignal` appends feedback entries and recalculates the level. It does not merge typed result values or automatically remove duplicate entries.

## JSON serialization

```csharp
using Newtonsoft.Json;
using SignalGraph;

var original = Signal.Start<string>("Completed");
original.LogInformation("Saved successfully.");

string json = original.ToJson();

// Restore feedback as a non-generic Signal.
Signal feedback = Signal.FromJson(json);

// Preserve the typed result by deserializing to Signal<T>.
Signal<string> restored = JsonConvert.DeserializeObject<Signal<string>>(json);
```

Serialization uses Newtonsoft.Json. With the default settings, enum values are serialized as numbers; `LevelName` also provides the signal level as text. Feedback entry exceptions are not included in the serialized data contract.

## License and ownership

Licensed under the [MIT License](https://github.com/B-D-D-B/SignalGraph/blob/main/LICENSE).

BDDB LLC is the current copyright holder for the rights it owns in this project. Silicon Dream Artists SPC collaborates on the project.

## Project links

- [Source repository](https://github.com/B-D-D-B/SignalGraph)
- [Report an issue](https://github.com/B-D-D-B/SignalGraph/issues)
