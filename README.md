## NASM TESTING
* [nasm_linux_with_gui](https://github.com/SitrakaResearchAndPOC/nasm/blob/main/nasm_linux.md)
* [nasm_linux_without_gui](https://github.com/SitrakaResearchAndPOC/nasm/blob/main/nasm_linux_without_gui.md)
* [nasm_windows_with_gui](https://github.com/SitrakaResearchAndPOC/nasm/blob/main/nasm_windows.md)

## BONNE PRATIQUE
* BIEN CHOISIR GCC 32bit, [gcc32](https://drive.usercontent.google.com/download?id=1fmtYdRcNcMQi0bh15xn2HPM0G1j5NTaL&export=download&authuser=0)
* LES ETIQUETTES EN LINUX C'EST SANS TIRET ET EN WINDOWS C'EST AVEC UN TIRET
* TOUJOURS ALIGNES LES NIVEAUX DE CODE
* AJOUTER EXTERN NOM_FONCTION DANS LE CODE QUAND C'EST FONCTION EXTERNE
* GLOBAL METTRE TOUJOURS A _START SI ON VEUT PAS AJOUTET L'OPTION DU CHARGEUR DE PROGRAMME OU POINT D'ENTREE ( UTILISE -Wl,-e,_start_main si le point d'entrée n'est pas specifé)
* LORS DE LA CREATION DE L'ETHIQUETTE, AJOUTER DEUX POINTS A LA FIN
* SI VOUS TRAVAILLER DANS LE REPERTOIRE C, DESACTIVER LES ANTIVIRUS
