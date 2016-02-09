# --
# PRTG API Wrapper
# -
# WriteXmlToScreen [xml]$xml --- helper function to check the result of an API call on screen
# -
# list-sensors [int]$treeObject [string]$sensorType --- returns [xml]$SensorTable
# rename-sensor [int]$objid [string]$newSensorName --- renames sensor with $objid to $newSensorName
# ...
# --

# --
# PRTG connection parameters:
# -
$apihost = '192.168.1.1'
$username = 'prtgadmin'
$passhash = '12345678'
# --

# Prepare Powershell to deal with HTTPS errors
# [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
   
    public class IDontCarePolicy : ICertificatePolicy {
        public IDontCarePolicy() {}
        public bool CheckValidationResult(
            ServicePoint sPoint, X509Certificate cert,
            WebRequest wRequest, int certProb) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = new-object IDontCarePolicy


function WriteXmlToScreen {

[cmdletbinding()]
Param (
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True)]

    [xml]$xml
)

Process {

    $StringWriter = New-Object System.IO.StringWriter
    $XmlWriter = New-Object System.Xml.XmlTextWriter $StringWriter
    $XmlWriter.Formatting = "indented"
    $xml.WriteTo($XmlWriter)
    $XmlWriter.Flush()
    $StringWriter.Flush()
    Write-Output $StringWriter.ToString()
}}


function list-sensors {

[cmdletbinding()]
Param (
    [int]$treeObject, 
    [string]$sensorType
)

Process {
    
    if ($sensorType -eq $null) {
        $getTableCall = 'https://' + $apihost + '/api/table.xml?content=sensors&columns=objid,sensor,type,device&id=' + $treeObject + '&username=' + $username + '&passhash=' + $passhash
    }
    else {
        $getTableCall = 'https://' + $apihost + '/api/table.xml?content=sensors&columns=objid,sensor,type,device&filter_type=' + $sensorType + '&id=' + $treeObject + '&username=' + $username + '&passhash=' + $passhash
    }
    [xml]$SensorTable = Invoke-RestMethod -Uri $getTableCall

    return [xml]$SensorTable
}}


function rename-sensor {

[cmdletbinding()]
Param (
    
    [int]$objid, 
    [string]$newSensorName
)

Process {

    $POSTnewName = 'https://' + $apihost + '/api/rename.htm?id=' + $objid + '&value=' + $newSensorName + '&username=' + $username + '&passhash=' + $passhash
    Invoke-RestMethod -Uri $POSTnewName
}}

function remove-sensor {

[cmdletbinding()]
Param (
    
    [int]$objid
)

Process {
    $POSTremoveSensor = 'https://' + $apihost + '/api/deleteobject.htm?id=' + $objid + '&approve=1' + '&username=' + $username + '&passhash=' + $passhash
    Invoke-RestMethod -Uri $POSTremoveSensor
}}
