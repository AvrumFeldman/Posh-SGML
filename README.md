# Posh-SGML
2 scripts to convert from and to SGML

## SGML
From my research QBO and QFX files are regular OFX files based on SGML. SGML is very similar to XML, just the properties don't have closing tags. This created a challenge for me when I was trying to manipulate such a file. I couldn't fine online anything so I went ahead and created my own converters from/to SGML.

## Info
* The script `ConvertFrom-SGML` takes an SGML formated file and converts it to a PowerShell object (uses only pscustomobject type).
* The script `ConvertTo-SGML` takes an object and converts it to SGML formatting.

## Notes
* I only tested the `ConvertTo-SGML` with an object I created using `ConvertFrom-SGML`.
* The `ConvertTo-SGML` just outputs the SGML to pipeline, it is be the responsibility  of the wrapper script/executer to output to file.
* If using `Out-File` to save the SGML file, make sure to use `-encoding ascii` to export the SGML in the correct encoding, as it seems it needs to be ascii (based on headers in exisintg files), I didn't test if it's indeed a requirement.
