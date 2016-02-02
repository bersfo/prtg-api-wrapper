# PRTG API Wrapper for Powershell

The Powershell scripts in this repository provide a wrapper for the [PRTG API](http://prtg.paessler.com/api.htm?username=demo&password=demodemo).

So far the following functions are included:

function: list-sensors --- returns [xml]$SensorTable

parameter 1: $treeObject --- ID of the tree-object which childs you'd like to enumerate

parameter 2: $sensorType --- String that describes the Sensor type that you are looking for (i.e. 'Ping')

rename-sensor

paremeter 1: $objid --- ID of the sensor that you would like to rename

parameter 2: $newSensorName --- The new name for the sensor

## How to use it
To use it simply make the functions available through:

`. "<path-to>\prtg-functions.ps1"`

## Example
[worker.ps1](https://github.com/bersfo/prtg-api-wrapper/blob/master/worker.ps1) shows how to do that as an example.
