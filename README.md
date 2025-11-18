# 🛠️ Rendszertelepítési Alapbeállítások Script (Debian 13)

Egy egyszerű **Bash script** a frissen telepített **Debian 13** rendszer kezdeti beállításainak automatizálására és biztonságossá tételére.

---

## 📜 Jellemzők

Ez a script a következő alapvető rendszerkonfigurációs feladatokat végzi el:

* **Hosztnév beállítása:** Bekéri a felhasználótól a kívánt hosztnevet, és beállítja azt.
* **Rendszer frissítése:** Elvégzi az `apt update` és `apt upgrade -y` parancsokat a rendszer naprakészen tartásához.
* **Új felhasználó létrehozása:** Létrehoz egy megadott nevű felhasználót, automatikusan generált, erős jelszóval.
* **Sudo jogosultság:** Hozzáadja az új felhasználót a `sudo` csoporthoz.
* **Biztonsági beállítás:** **Letiltja** a közvetlen SSH-s **root bejelentkezést** (`PermitRootLogin no`) a biztonság növelése érdekében.
* **SSH újraindítása:** Újraindítja az SSH szolgáltatást a változások érvénybe léptetéséhez.

---

## 🚀 Használat

### Előfeltételek

A script futtatásához **root jogosultság** szükséges.

### Futtatás

1.  Mentsd el a scriptet (pl. `alapbeallitas.sh` néven).
2.  Tedd futtathatóvá a fájlt:
    ```bash
    chmod +x alapbeallitas.sh
    ```
3.  Futtasd a scriptet root jogosultsággal:
    ```bash
    sudo ./alapbeallitas.sh
    ```

### Interakció

A script a futás során a következő adatokat fogja kérdezni tőled:

1.  **A kívánt hosztnév:**
    > `Add meg a kívánt hosztnevet:`
2.  **Az új felhasználó neve:**
    > `Adj meg egy új felhasználó nevet:`

A futtatás végén a script kiírja az újonnan létrehozott felhasználó nevét és a hozzá generált **jelszót**. **Ezt a jelszót mindenképpen mentsd el!**

---

## ⚠️ Fontos biztonsági figyelmeztetés

A script futása után a konzolra kiíródik a generált jelszó. **Ez az egyetlen alkalom, amikor a jelszó megjelenik.** Azonnal mentsd el biztonságos helyre, mivel a script nem tárolja azt!

A jelszó generálás menete:
* Hossza: **22 karakter**
* Tartalmaz: Kisbetűk, nagybetűk, számok és speciális karakterek.

---

## ⚙️ A script műveletei dióhéjban

1.  Root ellenőrzés
2.  Hosztnév beállítása (`hostnamectl set-hostname`)
3.  Rendszer frissítése (`apt update && apt upgrade -y`)
4.  Jelszó generálása (`openssl rand` és `tr -dc`)
5.  Felhasználó és jelszó beállítása (`useradd`, `chpasswd`)
6.  Sudo jogosultság adása (`usermod -aG sudo`)
7.  `PermitRootLogin no` beállítása az `/etc/ssh/sshd_config` fájlban
8.  SSH szolgáltatás újraindítása (`systemctl restart ssh/sshd`)
9.  Összefoglaló kiírása a felhasználói adatokkal.

---

## 👤 Készítette

* **Készítette:** Doky
* **Dátum:** 2025.10.19
