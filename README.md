# amdgpu-pro-gpu-fan-control
Bash shell script to control fan speed of GPU using AMDGPU-PRO driver

AUTOMATICALLY SET YOUR FAN SPEED BASED ON THE SCRIPT CONFIGURATION
------------------------------------------------------------------

Currently requires Superuser permissions 
$USER ALL=(ALL) NOPASSWD:ALL


By default, the fan will operate:

Temp          Fan
---------------------------------
< 40degC      Off
40-65degC     40-100% (scales)
65degC        100%

