//------------------------------------------------------------------------------
// <copyright file="ISignal{T}.cs" company="BDDB LLC">
//     Copyright (c) Silicon Dream Artists. Current copyright holder: BDDB LLC.
// </copyright>
//------------------------------------------------------------------------------

namespace SignalGraph
{
    public interface ISignal<T> : ISignal
    {
        T Result { get; set; }
        bool HasValue { get; }
    }
}
