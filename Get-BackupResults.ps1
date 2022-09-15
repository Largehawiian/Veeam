function Write-ReportOut {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline, Mandatory = $True)][array]$InputObject
    )
    begin {
        $Sessions = Get-VBRBackupSession
        $SessionsIndex = $Sessions | Group-Object JobID -AsHashTable -AsString
        class Veeam {
            [String]$JobName
            [String]$State
            [String]$StartTime
            [String]$EndTime
            [String]$Result
            hidden[Array]$Sessions

            Veeam () {}

            Veeam ($JobName, $State, $StartTime, $EndTime, $Result) {
                $this.JobName = $JobName
                $this.State = $State
                $this.StartTime = $StartTime
                $this.Endtime = $EndTime
                $this.Result = $Result
            }

            static [Veeam]Report ($JobName, $Sessions) {
                return [Veeam]::new($JobName, $Sessions.State, $Sessions.StartTime, $Sessions.EndTime, $Sessions.Result)
            }
        }
    }
    process {
        For ($i = 0; $i -lt $SessionsIndex[$InputObject.Id.guid].count; $i++) {
            [Veeam]::Report($InputObject.Name, $SessionsIndex[$InputObject.Id.guid][$i])
        }
        
    }
}
