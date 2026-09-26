// <copyright file="SignalFeedbackEntryComparer.cs" company="BDDB LLC">
//     Copyright (c) Silicon Dream Artists. Current copyright holder: BDDB LLC.
// </copyright>

namespace SignalGraph
{
    using System.Collections.Generic;

    public class SignalFeedbackEntryComparer : IEqualityComparer<SignalFeedbackEntry>
    {
        public bool Equals(SignalFeedbackEntry g1, SignalFeedbackEntry g2)
        {
            return g1.CreatedDate == g2.CreatedDate && g1.Message == g2.Message && g1.Nature == g2.Nature;
        }

        public int GetHashCode(SignalFeedbackEntry g)
        {
            return (g.CreatedDate.ToString() + g.Message + g.Nature.ToString()).GetHashCode();
        }
    }
}
