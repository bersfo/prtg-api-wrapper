<###
# This script removes PRTG sensors of a specific type from a device subtree.
#
# Prerequisites: prtg-functions.ps1 #>
. "<path>\prtg-functions.ps1"
#
# required Parameters:
$objid = $args[0] # device or device-group ID
$sensorTypeRaw = $args[1] # type of the sensors you'd like to remove
<#
# You can list all sensors of a device and ouput the xml to console by calling this script without the sensorTypeRaw parameter.
# The xml output includes a field <type_raw>, which is the field being used to filter the sensors. if you don't know the value for your sensor type, look there.
# Examples for $sensorTypeRaw: ping, snmpdiskfree, sntp, ssl, sslcertificate
#
###>


# Request list of matching sensors from API
$sensorList = list-sensors $objid $sensorTypeRaw

# Make user verify result of API request
WriteXmlToScreen($sensorList)
Write-Host "`nPlease verify the result of your API request above."
$uinput = Read-Host -Prompt 'Are you sure that the sensors listed above should be removed? (yes/no)'

# Remove sensors or abort
if ($uinput -eq 'yes') {
    foreach ($sensor in $SensorList.sensors.Item){
        $apiResponse = remove-sensor $sensor.objid
        $logline = "Removed sensor '" + $sensor.sensor + "' from device '" + $sensor.device + "'"
        Write-Host $logline
    }
}
else {
    Write-Host "`nSensor removal aborted."
}
