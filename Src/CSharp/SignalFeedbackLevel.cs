// <copyright file="SignalFeedbackLevel.cs" company="BDDB LLC">
//     Copyright (c) Silicon Dream Artists. Current copyright holder: BDDB LLC.
// </copyright>

namespace SignalGraph
{
    public enum SignalFeedbackLevel
    {
        Unspecified = 0,

        SensitiveInformation = 1,

        VerboseInformation = 2,

        Information = 4,

        Warning = 8,

        Retry = 16,

        Critical = 32,
    }
}
