within ClaRa;
package Components "Containing general description of pumps, heat exchangers,..."
//___________________________________________________________________________//
// Package of the ClaRa library, version: 1.0.0                          //
// Models of the ClaRa library are tested under DYMOLA v2013 FD01.           //
// It is planned to support alternative Simulators like SimulationX in the   //
// future                                                                    //
//___________________________________________________________________________//
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013-2015, DYNCAP research team.                                   //
//___________________________________________________________________________//
// This Modelica package is free software and the use is completely at your  //
// own risk; it can be redistributed and/or modified under the terms of the  //
// Modelica License 2. For license conditions (including the disclaimer of   //
// warranty) see Modelica.UsersGuide.ModelicaLicense2 or visit               //
// http://www.modelica.org/licenses/ModelicaLicense2                         //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//


  extends ClaRa.Basics.Icons.PackageIcons.Components100;


annotation (Documentation(info="<html>
<p><h2>AP 2.2 Modellierung der Einzelkomponenten f&uuml;r den konventionellen Kraftwerksprozess - Wasser-Dampfkreislauf</h2></p>
<p>Die verschiedenen Kraftwerkskomponenten f&uuml;r den Wasser-Dampfkreislauf des Kraftwerks sind f&uuml;r die Bearbeitung verschiedener Aufgabenstellungen in unterschiedlichem Detaillie-rungsgrad umzusetzen. Dabei stellen stark vereinfachte Modelle auf der Basis von gemes-senen oder von den Auslegungsdaten abgeleiteten Kennlinien eine robuste und Ressourcen schonende Basis dar. F&uuml;r vertiefende Untersuchungen werden Modelle auf der Grundlage der thermodynamischen Erhaltungsgleichungen erstellt. Durch den modularen Aufbau der Modellbibliothek sind die Modelle untereinander austauschbar.</p>
<p>Von besonderem Interesse f&uuml;r die detaillierte Modellierung des Wasser-Dampfkreislaufs sind der Dampferzeuger, die rekuperativen Vorw&auml;rmer und der Kondensator.</p>
<p>In diesem Arbeitspaket kann auf die mehrj&auml;hrige Erfahrung von Herrn Gottelt (XRG) im Be-reich der dynamischen Modellierung von Wasser-Dampfkreisl&auml;ufen konventioneller Dampf-kraftwerke zur&uuml;ckgegriffen werden (siehe Abschnitt 3.3). Weitere Vorarbeiten wurden bereits in einer Kooperation zwischen dem IET und XRG aus dem Jahre 2009 geleistet. Die verein-fachte Modellierung der Hauptkomponenten des Dampfkraftwerks kann sich auf die Richtli-nie VDI/VDE 3508 st&uuml;tzen. Die thermodynamischen Detailmodelle nehmen die Modelica-Bibliotheken Modelica.Fluid und ThermoPower, in denen eine Reihe von Grundmodellen definiert sind, als Ausgangsbasis.</h2></p>
<p><br/><h2>AP 2.3 Modellierung der Einzelkomponenten f&uuml;r den konventionellen Kraft-werksprozess - Verbrennungs- und Rauchgasseite -</p>
<p>Das Hauptaugenmerk bei der Modellierung der Rauchgasseite des Kraftwerks liegt in der korrekten Einbindung der Stoffdaten f&uuml;r die Betrachtung der Rauchgase von kohlebefeuerten Dampfkraftwerken. TLK konnte in den letzten Jahren bereits Erfahrungen in der Berechnung von Stoffdaten sammeln. Die Stoffdaten-Bibliothek TILMedia, die in Zusammenarbeit mit dem Institut f&uuml;r Thermodynamik der Technischen Universit&auml;t Braunschweig entwickelt wur-de, umfasst neben der Einbindung verbreiteter Bibliotheken auch verschiedenste eigene Berechnungsmethoden f&uuml;r Stoffdaten.</p>
<p>Die Hauptkomponenten der Rauchgasseite stellen der Dampferzeuger, die Kohlem&uuml;hlen sowie die Rauchgasreinigungskomponenten (DeNOx, E-Filter und REA) dar. Die Modellie-rung des Dampferzeugers wird - wie im AP 2.2 - von XRG &uuml;bernommen. Bei der Modellie-rung der Rauchgasreinigungskomponenten kann auf die Erfahrungen von TT und TLK im Umgang mit W&auml;rme- und Stofftransportsystemen zur&uuml;ckgegriffen werden.</p>
<p><br/><h2>AP 2.4 Modellierung der Einzelkomponenten f&uuml;r den Oxyfuel-Prozess</h2></p>
<p>Die Einzelkomponenten f&uuml;r den Oxyfuel-Prozess k&ouml;nnen neben der Feuerung in die Model-lierung der Luftzerlegungsanlage und die CO2-Aufreinigung aufgeteilt werden. Der Oxyfuel-Prozess nutzt mit Sauerstoff angereichertes Rauchgas als Verbrennungsgas in der Brennkammer. Wenn keine ausreichenden Sauerstoffspeicher zur Verf&uuml;gung stehen, bestimmt die Luftzerlegung mit der erforderlichen Luftvorw&auml;rmung die Dynamik bei der Leis-tungsanpassung des Kraftwerks. Bei der Modellierung der Hochdruck- und der Niederdruck-rektifikationskolonne kann auf die Erfahrungen von TT im Umgang mit der Modellierung von Absorptions- und Desorptionskolonnen zur&uuml;ckgegriffen werden [16]. Des Weiteren liegt ein besonderes Augenmerk auf der Modellierung des Hauptverdichters der Luftzerlegungsanla-ge. Der Hauptverdichter und alle &uuml;brigen Komponenten des Oxyfuel-Prozesses sowie die zus&auml;tzlichen Komponenten der Luftzerlegungskolonnen werden von TLK modelliert. Die Er-kenntnisse aus der Modellierung des Hauptverdichters der Luftzerlegungsanlage werden im weiteren Verlauf des Projekts f&uuml;r die Modellierung des CO2-Verdichters verwendet. Die Modellierung der CO2-Aufreinigung wird ebenfalls von TLK &uuml;bernommen. Auch hier kann auf die theoretischen und experimentellen Erfahrungen aus dem Verbundvorhaben ADECOS zur&uuml;ckgegriffen werden.</p>
<p><br/><h2>AP 2.5 Modellierung der Einzelkomponenten f&uuml;r die Post-Combustion CO2-Abtrennung</h2></p>
<p>Bei der Modellierung der CO2-Abscheidetechnologien ist, neben der Anwendung von Grundmodellen, die auch im konventionellen Kraftwerksmodell Verwendung finden, die Mo-dellierung der Absorptions- und Desorptionskolonnen sowie die korrekte Einbindung der Stoffwerte das zentrale Arbeitspaket. Die Abbildung des Stofftransports in den Kolonnen erfolgt &uuml;ber die in der Literatur &uuml;bliche Annahme eines Gleichgewichts-Ansatzes. In einem weiteren Schritt wird die Verwendung eines Rate-Based-Ansatzes untersucht. Hierf&uuml;r sind neben einem geeigneten Aktivit&auml;tsmodell (eNRTL, modified UNIQUAC) auch geeignete Stoff- und W&auml;rme&uuml;bergangsmodelle zu implementieren. </p>
<p>Bei der Modellierung von Absorptions- und Desorptionsprozessen ist es zudem sinnvoll, den mit Blick auf Projektziele angemessenen Detaillierungsgrad als Modell umzusetzen. So wirkt sich z. B. die genaue Abbildung der chemischen Reaktion in der Fl&uuml;ssigphase negativ auf die Rechenzeit aus. Das Ziel ist es, ein m&ouml;glichst vollst&auml;ndiges Modell zu entwickeln und daraus reduzierte Modelle abzuleiten, die bei einer ausreichenden Genauigkeit eine erheb-lich h&ouml;here Rechengeschwindigkeit aufweisen. Solche reduzierten Modelle sind daher f&uuml;r die Anwendung in Gesamt-Kraftwerkssimulationen besonders geeignet.</p>
<p>Dieses AP wird auf Grund der zahlreichen Erfahrungen auf dem Gebiet der dynamischen Modellierung von CO2-Rauchgasw&auml;schen [16] von TT &uuml;bernommen.</p>
</html>"));
end Components;
