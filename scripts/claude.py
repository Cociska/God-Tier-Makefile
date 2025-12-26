#!/usr/bin/env python3
import os
import sys
import json
import urllib.request
import urllib.error
from pathlib import Path

# --- CONFIG ---
MODEL = "claude-sonnet-4-5-20250929" # Modèle actuel
API_URL = "https://api.anthropic.com/v1/messages"
KEY_FILE = Path.home() / ".config/god-tier-makefile/anthropic.key"

# --- COULEURS ---
CYAN = "\033[36m"
GREEN = "\033[32m"
RED = "\033[31m"
YELLOW = "\033[33m"
RESET = "\033[0m"
BOLD = "\033[1m"

def get_api_key():
    # 1. Vérifie variable d'environnement
    api_key = os.getenv("ANTHROPIC_API_KEY")
    if api_key:
        return api_key

    # 2. Vérifie fichier de config
    if KEY_FILE.exists():
        try:
            return KEY_FILE.read_text().strip()
        except Exception:
            pass

    # 3. ECHEC : Renvoie vers make api
    print(f"{YELLOW}⚠️  Aucune clé API trouvée.{RESET}")
    print(f"{RED}Erreur : Claude a besoin d'une clé pour fonctionner.{RESET}")
    print(f"\n👉 Pour configurer votre accès, lancez : {BOLD}make api{RESET}")
    print(f"{CYAN}(Cela ouvrira le gestionnaire sécurisé de clés){RESET}")
    sys.exit(1)

def chat_with_claude(prompt):
    api_key = get_api_key()

    headers = {
        "x-api-key": api_key,
        "anthropic-version": "2023-06-01",
        "content-type": "application/json"
    }

    data = {
        "model": MODEL,
        "max_tokens": 1024,
        "messages": [{"role": "user", "content": prompt}]
    }

    try:
        print(f"{CYAN}>>> Claude is thinking...{RESET}")
        req = urllib.request.Request(API_URL, data=json.dumps(data).encode('utf-8'), headers=headers)
        
        with urllib.request.urlopen(req) as response:
            result = json.loads(response.read().decode('utf-8'))
            content = result['content'][0]['text']
            print(f"\n{GREEN}{BOLD}Claude:{RESET}")
            print(content)
            print(f"\n{CYAN}----------------------------------------{RESET}")

    except urllib.error.HTTPError as e:
        if e.code == 401:
             print(f"{RED}Erreur 401 : Clé API invalide ou expirée.{RESET}")
             print(f"👉 Lancez {BOLD}make api{RESET} pour la mettre à jour.")
        else:
             print(f"{RED}API Error: {e.code} - {e.reason}{RESET}")
             print(e.read().decode('utf-8'))
    except Exception as e:
        print(f"{RED}Error: {e}{RESET}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        prompt = " ".join(sys.argv[1:])
        chat_with_claude(prompt)
    else:
        print(f"{BOLD}🤖 Claude AI Terminal Client{RESET}")
        print("Type 'exit' or 'q' to quit.\n")
        # On teste la clé AVANT d'entrer dans la boucle pour éviter de taper un prompt pour rien
        get_api_key() 
        
        while True:
            try:
                user_input = input(f"{CYAN}You > {RESET}")
                if user_input.lower() in ['exit', 'quit', 'q']:
                    break
                if not user_input.strip():
                    continue
                chat_with_claude(user_input)
            except KeyboardInterrupt:
                print("\nBye!")
                break
