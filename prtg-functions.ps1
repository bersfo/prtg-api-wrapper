<# --
# PRTG API Wrapper
# -
# WriteXmlToScreen         [xml]$xml                          --- helper function to check the result of an API call on screen
# -
# list-devices             [int]$treeObject                   --- returns [xml]$deviceList
#
# clone-device             [int]$masterDeviceID 
#                          [string]$newDeviceName 
#                          [string]$newDeviceHostname 
#                          [int]$newDeviceGroupID             --- clones a device
#
# resume-device            [int]$deviceID                     --- resumes all sensors of a device
# -
# list-sensors             [int]$treeObject 
#                          [string]$sensorType                --- returns [xml]$SensorTable
#
# rename-sensor            [int]$objid 
#                          [string]$newSensorName             --- renames sensor with $objid to $newSensorName
#
# set-sensor-priority      [int]$objid 
#                          [string]$newSensorPriority         --- sets the priority of a sensor
#
# remove-sensor            [int]$objid                        --- removes a sensor
#
# pause-sensor             [int]$sensorID                     --- pauses a sensor
# ...
# -- #>

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


# general function to write xml to screen
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

# device related functions
function list-devices {

[cmdletbinding()]
Param (
    [int]$treeObject
)

Process {
    $getTableCall = 'https://' + $apihost + '/api/table.xml?content=devices&columns=objid,device,host,group,probe&id=' + $treeObject + '&count=50000' + '&username=' + $username + '&passhash=' + $passhash
    [xml]$deviceTable = Invoke-RestMethod -Uri $getTableCall

    return [xml]$deviceTable
}}

function clone-device {

[cmdletbinding()]
Param (
    [int]$masterDeviceID,
    [string]$newDeviceName,
    [string]$newDeviceHostname,
    [int]$newDeviceGroupID
)

Process {
    $apiCall = 'https://' + $apihost + '/api/duplicateobject.htm?id=' + $masterDeviceID + '&name=' + $newDeviceName + '&host=' + $newDeviceHostname + '&targetid=' + $newDeviceGroupID + '&username=' + $username + '&passhash=' + $passhash
    $apiResponse = Invoke-RestMethod -Uri $apiCall

    return $apiResponse
}}

function resume-device {

[cmdletbinding()]
Param (
    [int]$deviceID
)

Process {
    $apiCall = 'https://' + $apihost + '/api/pause.htm?id=' + $deviceID + '&action=1' + '&username=' + $username + '&passhash=' + $passhash
    [xml]$apiResponse = Invoke-RestMethod -Uri $apiCall
}}

#sensor related functions
function list-sensors {

[cmdletbinding()]
Param (
    [int]$treeObject, 
    [string]$sensorTypeRaw
)

Process {
    
    if (!$sensorTypeRaw) {
        $getTableCall = 'https://' + $apihost + '/api/table.xml?content=sensors&columns=objid,sensor,type,device,priority,status&id=' + $treeObject + '&count=50000' + '&username=' + $username + '&passhash=' + $passhash
    }
    else {
        $getTableCall = 'https://' + $apihost + '/api/table.xml?content=sensors&columns=objid,sensor,type,device,priority,status&filter_type=' + $sensorTypeRaw + '&id=' + $treeObject + '&count=50000' + '&username=' + $username + '&passhash=' + $passhash
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

function set-sensor-priority {

[cmdletbinding()]
Param (
    
    [int]$objid, 
    [string]$newSensorPriority
)

Process {

    $POSTnewName = 'https://' + $apihost + '/api/setpriority.htm?id=' + $objid + '&prio=' + $newSensorPriority + '&username=' + $username + '&passhash=' + $passhash
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

function pause-sensor {

[cmdletbinding()]
Param (
    [int]$sensorID
)

Process {
    $apiCall = 'https://' + $apihost + '/api/pause.htm?id=' + $sensorID + '&action=0' + '&username=' + $username + '&passhash=' + $passhash
    [xml]$apiResponse = Invoke-RestMethod -Uri $apiCall
}}
