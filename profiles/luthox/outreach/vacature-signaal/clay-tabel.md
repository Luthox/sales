# Clay-tabel en Apollo-gebruik: vacature-signaal

Opzet voor de 14-daagse trials (Clay: 1K data credits, 5K actions; Apollo Professional). Menunamen in Clay en Apollo kunnen afwijken van wat hier staat: ik had geen toegang tot jullie accounts. Kloppen de namen niet, pas de naam aan en houd de logica.

## Principe

1. **Bron zo breed mogelijk, filteren in kolommen.** Eerder kwam het filteren op nul uit, omdat elk extra filter in de bron de lijst leegt. Dus in de bron alleen: functietitel-zoekwoord, Nederland, laatste 14 dagen. Omvang, sector en recruiter-check komen later als kolommen.
2. **Goedkope kolommen eerst, dure kolommen alleen voor rijen die slagen.** Contactverrijking en e-mailzoektocht zijn de duurste stappen. Die draaien pas na de score.
3. **Eerst 10 rijen testen** en de credits tellen die elke kolom kost. Daarna pas 200 rijen.

## Bron

Gebruik de vacature-bron van Clay (zoek in Sources naar job postings / jobs) of, als alternatief, het job-postings-filter in Apollo. Zoektermen, één run per term:

- AI specialist · AI engineer · AI automation
- automatiseringsspecialist · procesautomatisering · workflow automation
- procesoptimalisatie · process improvement · digitalisering
- Power Automate · Power Platform · Make · Zapier · n8n

Alleen: land Nederland, geplaatst in de laatste 14 dagen. Kolom `bron_term` noteert welke zoekterm de rij opleverde.

## Kolommen (in deze volgorde)

| # | Kolom | Wat | Kost |
|---|---|---|---|
| 1 | `bedrijf`, `domein`, `vacature_titel`, `vacature_url`, `geplaatst` | uit de bron | |
| 2 | `bron_term` | welke zoekterm | |
| 3 | `dubbel` | staat het bedrijf al in `profiles/luthox/leads/`? Zo ja, uitsluiten | goedkoop |
| 4 | `recruiter` | vlag bij woorden als "recruitment", "uitzend", "detachering", "talent", "staffing", "interim bureau" in naam of domein | goedkoop |
| 5 | `omvang` | medewerkers (Clay-bedrijfsdata) | data credit |
| 6 | `omvang_ok` | `omvang` tussen 10 en 250, of leeg (leeg = handmatig checken) | gratis formule |
| 7 | `branche` | bedrijfsbranche uit bedrijfsdata | gratis uit kolom 5 |
| 8 | `branche_uit` | vlag voor software/IT, consultancy, bureaus, overheid, zorg, onderwijs, banken | gratis formule |
| 9 | `contractvorm` | AI-kolom die uit de vacaturetekst haalt: tijdelijk / freelance / interim / vast / onbekend | actions |
| 10 | `pijn_citaat` | AI-kolom: letterlijk één zin uit de vacature over handmatig werk, losse systemen of "bouwen van nul". Leeg als er geen is. | actions |
| 11 | `score` | zie hieronder | gratis formule |
| 12 | `beslisser` | persoon zoeken, alleen voor rijen met `score` ≥ 5 | data credits |
| 13 | `email` | via Clay waterfall en Apollo, alleen voor rijen met `score` ≥ 5 | data credits |
| 14 | `rechtsvorm` | eenmanszaak of vof? Dan niet mailen, wel bellen | handmatig |
| 15 | `proces_idee` | AI-kolom: één regel, gelabeld als aanname, voor de teardown | actions |

## Score (0–10)

- +3 tijdelijk, freelance of interim · +1 vast
- +2 `pijn_citaat` aanwezig
- +2 omvang tussen 20 en 150
- +1 geplaatst in de laatste 7 dagen
- +1 beslisser gevonden
- Uitsluiten (score 0): `dubbel`, `recruiter`, `branche_uit`, `omvang` boven 250

Alleen rijen met score ≥ 5 gaan door naar de dure kolommen.

## Apollo (14-daagse trial) gebruiken voor

- **Contacten en e-mailadressen** voor rijen die Clay niet heeft gevuld.
- **Exports voor de trial afloopt**: bewaar alles wat je nodig hebt als CSV in dit project. Weg is weg na dag 14.
- Gebruik Apollo niet voor het vinden van vacatures als Clay dat al doet. Dan betaal je twee keer voor hetzelfde signaal.

## Schema voor de 14 dagen

| Dag | Doen |
|---|---|
| 1 | Tabel bouwen, 10 rijen testen, credits per kolom noteren |
| 2–3 | 200 rijen draaien, score bekijken, top 50 handmatig controleren |
| 4–10 | Dagelijks bijvullen tot het budget op is, teardowns schrijven |
| 10 | Beslissen: wat werkte, wat was het kostbaar, welk abonnement (indien) |
| 12–13 | Alles exporteren naar het project |

## Naar de mail

Voor Gmail-concepten leveren we deze kolommen als CSV: `voornaam`, `email`, `bedrijf`, `vacature_titel`, `contractvorm`, `proces_idee`. Dat zijn de velden uit de mail.

## Let op

- Mail alleen naar zakelijke adressen en alleen na controle van de rechtsvorm (eenmanszaak en vof tellen als natuurlijke personen). Twijfel je, bel dan. Laat een jurist dit nog bevestigen voor je opschaalt.
- Een lead zonder `pijn_citaat` en zonder tijdelijke contractvorm krijgt geen teardown. Dan is het signaal te zwak.
