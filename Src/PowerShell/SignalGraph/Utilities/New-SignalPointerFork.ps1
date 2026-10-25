function New-SignalPointerFork {
    <#
    .SYNOPSIS
    Creates a Signal with an independent pointer Graph and optionally reuses
    the source Graph's registered Signal instances.

    .DESCRIPTION
    This is a shallow fork. The returned Signal and Graph are new containers,
    but copied Grid members remain the same Signal references. Replacing Grid
    registrations is therefore isolated while mutating a reused Signal is not.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Signal]$SourceSignal,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [object]$ReversePointer,

        [Graph]$TargetGraph,

        [ValidateSet('PreserveTarget', 'OverwriteTarget', 'Error')]
        [string]$CollisionAction = 'PreserveTarget',

        [string[]]$ExcludeKeys = @(),

        [switch]$CopyJacket,

        [switch]$CopyResult
    )

    $opSignal = [Signal]::Start("New-SignalPointerFork:$Name", $ReversePointer) | Select-Object -Last 1

    try {
        # Read source properties directly so a Signal received from another
        # in-process runspace can be forked without invoking its session-bound
        # PowerShell class methods.
        $sourceGraph = $SourceSignal.Pointer
        if ($sourceGraph -isnot [Graph]) {
            $null = $opSignal.LogCritical("Source signal '$($SourceSignal.Name)' does not have a Graph pointer.")
            return $opSignal
        }

        if ($null -eq $TargetGraph) {
            $graphSignal = [Graph]::Start("Graph:$Name", $opSignal, $false) | Select-Object -Last 1
            if ($opSignal.MergeSignalAndVerifyFailure(@($graphSignal)) -or -not $graphSignal.HasResult()) {
                return $opSignal
            }

            $TargetGraph = $graphSignal.GetResult()
        }

        foreach ($key in @($sourceGraph.Grid.Keys)) {
            if ($ExcludeKeys -contains [string]$key) {
                continue
            }

            if ($TargetGraph.Grid.Contains($key)) {
                switch ($CollisionAction) {
                    'PreserveTarget' { continue }
                    'Error' {
                        $null = $opSignal.LogCritical("Target graph already contains '$key'.")
                        return $opSignal
                    }
                }
            }

            $registerSignal = $TargetGraph.RegisterSignal([string]$key, $sourceGraph.Grid[$key]) | Select-Object -Last 1
            if ($opSignal.MergeSignalAndVerifyFailure(@($registerSignal))) {
                return $opSignal
            }
        }

        $forkedSignal = [Signal]::Start($Name, $ReversePointer) | Select-Object -Last 1
        $null = $forkedSignal.SetPointer($TargetGraph)

        if ($CopyJacket -and $null -ne $SourceSignal.Jacket) {
            $null = $forkedSignal.SetJacket($SourceSignal.Jacket)
        }

        if ($CopyResult -and $null -ne $SourceSignal.Result) {
            $forkedSignal.SetResult($SourceSignal.Result)
        }

        $opSignal.SetResult($forkedSignal)
    }
    catch {
        $null = $opSignal.LogCritical("Failed to fork signal pointer: $($_.Exception.Message)", $null, $_)
    }

    return $opSignal
}
