# --
# PRTG worker script - example for using PRTG API Wrapper functions
# --

# --
# include PRTG API Wrapper functions from prtg-functions.ps1
# -
. "<path-to>\prtg-functions.ps1"
# --


# list all (max 50k) Ping sensors from device tree
$sensorList = list-sensors 0 "Ping"
WriteXmlToScreen($sensorList)
