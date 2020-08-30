# Notes



## Flashing ESP12 (no CH340 - USB interface), using FTDI

Brochage ESP12:

RESET : pull up 2,2kohm -> V+
CH_PD : pull up 2,2kohm -> V+
GPIO15 : GND



Vitesse de connection :

115000 bauds -> peut être perdu en terme de configuration, utiliser 9600 bauds, fonctionne tout le temps !!! 


	AT+GMR
	
	AT version:0.23.0.0(Apr 24 2015 21:11:01)
	SDK version:1.0.1
	Ai-Thinker Technology Co. Ltd.
	Apr 27 2015 13:55:14
	
	OK

## Flash firmware node MCU

utilisation du logiciel de flash avec les paramètres par défaut

procedure :


- il est important que la broche GPOI0 (noté GPOI6) soit à 0, avec un redémarrage de l'esp
- démarrage de l'esp (alimentation)
- choix du fichier dans le logiciel de firmware
- changement de la taille flash (1mb)
- Appuyez sur flash
- Enlever la broche GPIO0 (en l'air)
- redémarrer l'esp

le courant norminal doit être de 60 ma





## NodeMCU

On peut utiliser alors esplorer pour programmer, envoyer les fichiers
	

	PORT OPEN 9600
	
	Communication with MCU...
	Got answer! AutoDetect firmware...
	Communication with MCU established.
	NodeMCU firmware detected.
	=node.heap()
	23152
	> =node.heap()
	23152
	> =node.heap()
	23152
	> =node.heap()
	23152



