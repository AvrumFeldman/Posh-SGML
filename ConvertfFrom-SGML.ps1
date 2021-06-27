[cmdletbinding()]
param(
    $Data
)
$Hash = [ordered]@{}
for ($OpenIndex = 0; $OpenIndex -lt $Data.Length; $OpenIndex = ($ClosingIndex+1)) {
    $Row = $Data[$OpenIndex]

    if (($Row -notmatch "\/") -and ($Row -match "<")) {

        $RowTagless = $Row -replace "<|>",""

        # Needed as transactions are using the same open/close tags and they are overwriting the previous transaction is hash table 
        if ($Hash.keys -contains $RowTagless) {
            $ToArray = $Hash[$RowTagless]
            $Hash[$RowTagless] = [System.Collections.ArrayList]@()
            [void]$Hash[$RowTagless].Add($ToArray)
            $NeedsArray = $true
        }

        # Start searching from current row in file
        $ClosingIndex = $OpenIndex


        foreach ($crow in $Data[$OpenIndex..($Data.Length -1)]) {
            Write-Debug "$crow = </$RowTagless>"
            if ($crow -match "<\/$RowTagless>") {
                $ClosingTagExist = $true
                $CurrentData = & $PSCommandPath -data $Data[($OpenIndex+1)..($ClosingIndex-1)]
                if ($NeedsArray -ne $true) {
                    $Hash[$RowTagless] = $CurrentData
                } elseif ($NeedsArray) {
                    [void]$Hash[$RowTagless].Add($CurrentData)
                }
                break
            } else {
                $ClosingTagExist = $false
            }
            $ClosingIndex++
        }
        if ($ClosingTagExist -ne $true) {
            $ClosingIndex = $OpenIndex
            $SingleRow = [regex]::matches($Row,"<(\S+)>(.+)")
            $Hash[($SingleRow.groups)[1].value] = ($SingleRow.groups)[2].value
            Write-Debug $Hash
        }
    } else {
        $ClosingIndex = $OpenIndex
    }
}
[PSCustomObject]$Hash