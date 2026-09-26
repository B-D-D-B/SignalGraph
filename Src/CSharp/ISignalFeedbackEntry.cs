// <copyright file="ISignalFeedbackEntry.cs" company="BDDB LLC">
//     Copyright (c) Silicon Dream Artists. Current copyright holder: BDDB LLC.
// </copyright>

namespace SignalGraph
{
    using System;

    public interface ISignalFeedbackEntry
    {
        string Message { get; set; }
        string MessageFull { get; set; }
        SignalFeedbackLevel Level { get; set; }
        SignalFeedbackNature Nature { get; set; }

        Exception Exception { get; set; }
    }
}
