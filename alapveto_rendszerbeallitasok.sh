#!/bin/bash
# ------------------------------------------------------------
# Rendszertelepítési Alapbeállítások Script (Debian/Ubuntu)
#
# A script Debian és Ubuntu rendszeren is működik!
#
# Ez a script az alábbi teendőket végzi el:
#
# - Hosztnevet állít be (Megkérdezi mi legyen az)
# - Rendszert frissít (apt update és apt upgrade -y)
# - Létrehoz egy megadott felhasználónevet sudo jogosultsággal
# - Letiltja a közvetlen root bejelentkezést (biztonságból)
# - Újraindítja az SSH szolgáltatást
#
# Dátum: 2025.10.19
# Készítette: Doky
# ------------------------------------------------------------

# Ellenőrizzük, hogy rootként fut-e a script
if [ "$EUID" -ne 0 ]; then
    echo "Kérlek, futtasd a scriptet rootként (sudo)." 
    exit 1
fi

# 1. Hosztnév bekérése és beállítása
read -p "Add meg a kívánt hosztnevet: " NEW_HOSTNAME
sudo hostnamectl set-hostname "$NEW_HOSTNAME"
echo "✅ Hosztnév beállítva: $NEW_HOSTNAME"

# 2. Rendszer frissítése
echo "Rendszer frissítése folyamatban..."
sudo apt update && sudo apt upgrade -y
echo "✅ Rendszer frissítve."

# 3. Felhasználó létrehozása
read -p "Adj meg egy új felhasználó nevet: " NEW_USER

# Jelszó generálása: 22 karakter, kisbetű, nagybetű, szám, speciális karakter
PASSWORD=$(openssl rand -base64 33 | tr -dc 'A-Za-z0-9@#$%^&*()_+=' | head -c 22)

# Felhasználó létrehozása
sudo useradd -m -s /bin/bash "$NEW_USER"
echo "$NEW_USER:$PASSWORD" | sudo chpasswd

# Sudo jogosultság hozzáadása
sudo usermod -aG sudo "$NEW_USER"
echo "✅ Felhasználó létrehozva és sudo jogosultsággal ellátva."

# 4. SSH root login letiltása
sudo sed -i 's/^PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config

# 4b. SSH szolgáltatás újraindítása (Debian és Ubuntu kompatibilis)
if systemctl restart ssh 2>/dev/null; then
    echo "✅ SSH szolgáltatás újraindítva (ssh)."
elif systemctl restart sshd 2>/dev/null; then
    echo "✅ SSH szolgáltatás újraindítva (sshd)."
else
    echo "Hiba: SSH szolgáltatás újraindítása nem sikerült."
fi

# 5. Minden kész, adatok kiírása
echo ""
echo "---------------------------------------------------------"
echo "ℹ️ A felhasználó létrehozva: $NEW_USER"
echo "ℹ️ A generált jelszó: $PASSWORD"
echo ""
echo "🎉 Mindennel elkészültünk:"
echo ""
echo "✅ Hosztnév beállítva"
echo "✅ Rendszer frissítve"
echo "✅ Felhasználó létrehozva és sudo jogosultsággal ellátva"
echo "✅ Letiltva a közvetlen root bejelentkezés (biztonságból)"
echo "✅ SSH szolgáltatás újraindítva"
echo "---------------------------------------------------------"