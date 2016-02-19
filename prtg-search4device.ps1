###
# This script checks whether a device exists in the device tree.
# If a matching device is found, it prints it's URL to console.
#
# Prerequisites: prtg-functions.ps1
. "<path-to>\prtg-functions.ps1"
#
# required Parameters:
$searchString = "*" +  $args[0] + "*"
#
###

# set success-factor
$success = $false

# Request list of devices from API
$deviceList = list-devices 0

foreach ($device in $deviceList.devices.Item){
    if ($device.device -Like $searchString) {
        $deviceURL = "https://netmon.ad1.sfwater.org/device.htm?id=" + $device.objid
        Write-Host $deviceURL
        $success = $true
    }
}

if ($success) {
    $logMessage = $searchString + " was not found in device tree :-("
    Write $logMessage
}
