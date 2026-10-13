# Tweede domein: DNS-stappen en opwarm-routine (14 dagen)

Voor koude mail vanaf een tweede domein, gehost bij SiteGround (of Google Workspace; de DNS-stappen zijn dezelfde). Menunamen in SiteGround, de registrar en Gmail kunnen afwijken. Pas ze aan op wat je ziet.

Regels, altijd:
- Nooit koude mail vanaf luthox.com.
- Zakelijke adressen, een duidelijke afmeldregel in elke mail, afzendernaam is een echt persoon.
- Platte tekst. In de eerste twee weken geen links en geen afbeeldingen.

## A. Domein en postvak (dag 0)

- [ ] Domein gekozen en gekocht (variant van luthox.com, zonder woorden als "mail" of "sales")
- [ ] Domein staat bij SiteGround als aparte site of alias, of bij je registrar met DNS naar SiteGround
- [ ] Postvak aangemaakt op het nieuwe domein met een echte naam (voornaam@nieuwdomein)
- [ ] Website van het nieuwe domein stuurt door naar luthox.com
- [ ] Je kunt in en uit het postvak loggen via webmail én IMAP/SMTP

## B. DNS-records (dag 1, ongeveer een uur)

Controleer of de DNS van het domein echt bij SiteGround staat. Zo niet, zet daar de records, bij de partij die de nameservers beheert.

- [ ] **SPF:** TXT-record op de root (`@`). SiteGround zet dit meestal automatisch zodra het domein bij hen staat (Site Tools, Email, Authentication). Controleer dat er maar één SPF-record bestaat.
- [ ] **DKIM:** in dezelfde pagina inschakelen. Het record verschijnt in de DNS-zone.
- [ ] **DMARC:** TXT-record op `_dmarc.nieuwdomein`, voorlopig zacht:

```
v=DMARC1; p=none; rua=mailto:dmarc@nieuwdomein
```

- [ ] **Test:** stuur een mail naar het adres dat mail-tester.com je geeft. Streef naar 9 of 10 van de 10.
- [ ] **Test op echte inboxen:** stuur een mail naar eigen Gmail- en Outlook-adressen. Landt hij in de inbox of in spam?
- [ ] Controleer de records daarna nog eens met een DNS-checker (zoek op "MX toolbox")

Na twee weken zonder problemen kan DMARC strenger (`p=quarantine`). Geen haast.

## C. Opwarmen (dag 1–14)

Het idee: het domein bouwt reputatie op door een paar echte mails per dag met antwoorden erop, op een geleidelijk stijgend volume.

| Dag | Verstuurd per dag | Aan wie | Opmerkingen |
|---|---|---|---|
| 1 | 3 | Mensen die je kent en die terugschrijven (collega's, vrienden, bestaande contacten) | Vraag ze echt te antwoorden |
| 2–3 | 5 | Idem | Antwoord zelf ook op hun antwoorden |
| 4–5 | 8 | Idem, mix van adressen (Gmail, Outlook, bedrijf) | Als iets in spam belandt: markeer "geen spam" en antwoord |
| 6–7 | 10 | Idem | |
| 8–10 | 12 | Eerste echte leads (maximaal 5), de rest warme contacten | Eerste teardown-mails starten |
| 11–14 | 15–20 | Leads plus warme contacten | |
| 15+ | tot 20–30 | Alleen leads | |

Ritme: mails verspreid over de dag, niet allemaal tegelijk. Niet in het weekend.

## D. Stoppen of terugschroeven als

- Meer dan 2–3% van de mails komt terug als onbezorgbaar.
- Een testmail naar je eigen Gmail of Outlook landt in spam.
- Je krijgt een klacht of iemand markeert een mail als spam.

Dan: pauzeren, de oorzaak zoeken (inhoud, volume, DNS) en pas weer door met half volume.

## E. Een punt om te beslissen

De teardown gaat als PDF mee in de eerste mail. Bijlagen van een nieuw domein hebben een grotere kans op spam. Overweeg in de eerste twee weken eerst zonder bijlage te sturen ("zal ik de uitwerking sturen?") en de PDF pas na een reactie te sturen. Test beide varianten op je eigen inboxen voor je beslist.

## F. Controle van de hostingvoorwaarden

Lees de gebruiksvoorwaarden van SiteGround over ongevraagde of bulkmail en de uitgaande mail-limieten voor jullie pakket. Bij 20–30 persoonlijke mails per dag is het waarschijnlijk geen probleem, maar controleer het.
