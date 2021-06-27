[cmdletbinding()]
param(
    $data,
    [parameter(DontShow)]
    $Depth = 0
)
if ($Depth -eq 0) {
    "OFXHEADER:100`nDATA:OFXSGML`nVERSION:102`nSECURITY:NONE`nENCODING:USASCII`nCHARSET:1252`nCOMPRESSION:NONE`nOLDFILEUID:NONE`nNEWFILEUID:NONE"
}
$data.psobject.Members | ForEach-Object {
    if ($_.membertype -eq "noteproperty" -and $_.TypeNameOfValue -ne "System.String") {
        $cur = $_
        $_.value | ForEach-Object {
            "<$($cur.name)>"
            & $PSCommandPath -data $_ -depth 1
            "</$($cur.name)>"
        }
    } elseif ($_.membertype -eq "noteproperty" -and $_.TypeNameOfValue -eq "System.String") {
        "<$($_.name)>$($_.value)"
    }
}