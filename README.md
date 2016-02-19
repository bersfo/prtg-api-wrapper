# PRTG API Wrapper for Powershell

The Powershell scripts in this repository provide a wrapper for the [PRTG API](http://prtg.paessler.com/api.htm?username=demo&password=demodemo).

So far the following functions are included:

## Device Functions

**list-devices** --- returns [xml]$deviceTable

parameter 1: $treeObject --- ID of the tree-object, which childs you'd like to enumerate

**clone-device** --- clones a device

parameter 1: $masterDeviceID --- ID of the device you want to create a clone from

parameter 2: $newDeviceName --- Name of the new device

parameter 3: $newDeviceHostname --- Hostname/IP of the new device

parameter 4: $newDeviceGroupID --- Group in which you'd like the new device to be created in

**resume-device** --- resumes (un-pause) all sensors of a device

parameter 1: $deviceID --- ID of the device you'd like to resume

## Sensor Functions

**list-sensors** --- returns [xml]$SensorTable

parameter 1: $treeObject --- ID of the tree-object which childs you'd like to enumerate

parameter 2: $sensorType --- String that describes the Sensor type that you are looking for (i.e. 'Ping')

**rename-sensor**

paremeter 1: $objid --- ID of the sensor that you would like to rename

parameter 2: $newSensorName --- The new name for the sensor

**set-sensor-priority**

paremeter 1: $objid --- ID of the sensor that you would like to change the priority of

parameter 2: $newSensorPriority --- The new priority for the sensor

**remove-sensor**

paremeter 1: $objid --- ID of the sensor that you would like to remove

**pause-sensor**

paremeter 1: $sensorID --- ID of the sensor that you would like to pause

## How to use it
To use it simply make the functions available through:

`. "<path-to>\prtg-functions.ps1"`

## Example
[worker.ps1](https://github.com/bersfo/prtg-api-wrapper/blob/master/worker.ps1) shows how to do that as an example.
