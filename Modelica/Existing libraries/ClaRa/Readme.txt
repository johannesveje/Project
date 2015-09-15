//___________________________________________________________________________//
//         ClaRa 1.0.0 - Simulation of Clausius-Rankine Cycles               //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013-2015, DYNCAP research team.                              //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

Thank you for choosing the ClaRa library for your simulation purposes!
Please read the following steps for a successful usage.



Installation:
******************************

1. Copy the unzipped library files to your preferred folder

2. Execute batch files:
	- Execute (as system administrator!)
	- %path of the directory where ClaRa is located on your computer%\ClaRaDelay\update.bat
	- %path of the directory where ClaRa is located on your computer%\TILMedia 1.0.0 ClaRa\update.bat
	- This will copy some external libraries to your system which are necessary for using a ClaRa internal implementation of signal delay and for using external media data from TIL Media.

3. Set environmental variable in windows (optional!)

	In Windows add an Environment Variable with the following properties:
	Variable name:	ModelicaPath
	Variable value:	path of the directory where ClaRa library files are located
	
	How to do this on Windows 7:

	click "Start" 
	- right click on "Computer" 
	- choose "Properties" option
	- in the "System" window click on "Advanced system settings" 
	- in the "System Properties" window select the "Advanced" tab and click on "Environmental Variables"
	- now create a  new variable "ModelicaPath" either in "System variables" (this makes your definition accessible for all users) or in "User variables for %your user name%" (this makes your definition only accessible for you and programs executed by yourself)
	- give the variable as value the path of the directory where ClaRa is located on your computer
	- click "OK" button 
	- click "OK" button in "Environmental Variables"
	- click "OK" button in "System Properties Window"
	- close "System" window

	
Known Issues:
******************************
	- the library in the current status does not work with 64 Bit compilation (for some models)


Contact:	
******************************
	info@clara.com