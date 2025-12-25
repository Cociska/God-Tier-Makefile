#!/bin/bash

# --- COULEURS ---
# Je reprends le violet (35) et le reset
C_PURPLE='\033[35m'
C_RESET='\033[0m'

# --- TEXTE ---
text="  Makefile by cociska"

# Calcul de la longueur
# 'echo' ajoute un saut de ligne, donc wc -c compte 1 de plus
# C'est pour ça qu'on utilise -lt (plus petit que) dans la boucle
len=$(echo "$text" | wc -c)
i=1

# Optionnel : Cache le curseur pour que l'animation soit plus propre
tput civis 

while [ $i -lt $len ]; do
   # On coupe le texte de 1 à i
   current_sub=$(echo "$text" | cut -c1-$i)
   
   # -n : pas de saut de ligne
   # -e : interprète le \r (retour chariot pour revenir au début de la ligne)
   echo -ne "\r${C_PURPLE}${current_sub}${C_RESET}"
   
   sleep 0.15
   i=$((i + 1))
done

# Réaffiche le curseur et fait le saut de ligne final
tput cnorm
echo ""
