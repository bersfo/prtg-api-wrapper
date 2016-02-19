# PRTG API Wrapper for Powershell

The Powershell scripts in this repository provide a wrapper for the [PRTG API](http://prtg.paessler.com/api.htm?username=demo&password=demodemo).

So far the following functions are included:

**function: list-devices** --- returns [xml]$deviceTable

parameter 1: $treeObject --- ID of the tree-object, which childs you'd like to enumerate

**function: clone-device** --- clones a device

parameter 1: $masterDeviceID --- ID of the device you want to create a clone from

parameter 2: $newDeviceName --- Name of the new device

parameter 3: $newDeviceHostname --- Hostname/IP of the new device

parameter 4: $newDeviceGroupID --- Group in which you'd like the new device to be created in

**function: list-sensors** --- returns [xml]$SensorTable

parameter 1: $treeObject --- ID of the tree-object which childs you'd like to enumerate

parameter 2: $sensorType --- String that describes the Sensor type that you are looking for (i.e. 'Ping')

**function: rename-sensor**

paremeter 1: $objid --- ID of the sensor that you would like to rename

parameter 2: $newSensorName --- The new name for the sensor

**function: remove-sensor**

paremeter 1: $objid --- ID of the sensor that you would like to remove

## How to use it
To use it simply make the functions available through:

`. "<path-to>\prtg-functions.ps1"`

## Example
[worker.ps1](https://github.com/bersfo/prtg-api-wrapper/blob/master/worker.ps1) shows how to do that as an example.
