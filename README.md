# CalibrationLicorAG_Rillig
Calibration updates for the injection of CO2 to the Licor Machine of AG Rillig

The objective of this repository is to better organize and share the information on the calibration curves for the injection of CO2 to the Licor machine of AG Rillig.

You can use the script "CalibrationProtokol.R" as a template when creating new calibration. This script contains: 
1. The logic behind the calibration, 
2. The code for the first calibration done (from data collected by Max and Carlos on August 2017) and;
3. A "guideline code" to make new calibrations

When you do a new calibration, please update it in "CalibrationProtokol.R file (if you do not have github send it to Carlos) so that everyone has access to the most updated calibrations done for different volumes of air.

The update should contain:

1. The data used for the new calibration (with a name that is indicative of who made the calibration, for what volume of air and month/year when the calibration was done).
2. The fitting values of the calibration (that is, the slope and the intercept of the fitted line of observed peaks~known CO2 values)
3. A plot to check visualize the fitted line

In this way we can paste those values here. As follows:

Calibration conversion factor for 5ml = ((your sample value)*38.25) - 265.57  [Calibration done on August 2017 by Max and Carlos]

Thanks!!
