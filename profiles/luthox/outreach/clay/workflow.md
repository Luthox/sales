# Clay-workflow: handmatig of modern? (per bedrijf)

Status 2026-10-15: gebouwd en gedraaid als concept in Clay ("Clay – Klinieken behoefte-check", `wf_0tmwmztvgPhUu4EDB7h`, niet gepubliceerd). 74 klinieken twee keer doorgelopen. Dit bestand is de specificatie en het kostenlog.

## Nodes (in volgorde)
1. **CSV upload** (trigger): name, website, phone, address, rating, reviews, maps_url. Één run per rij.
2. **Scrape website**: homepage-tekst, links en e-mailadressen (0,1 credit).
3. **Kies subpagina's** (code, gratis): kiest uit de homepage-links maximaal twee extra pagina's op dezelfde site (contact, afspraak, consult, offerte, tarief, vestiging, werkwijze e.d.; sociale media, privacy en blog worden overgeslagen) en verzamelt boek- en toollinks (Salonized, Treatwell, Calendly, WhatsApp, enz.). Geen pagina gevonden: de homepage wordt nog eens gebruikt.
4. **Scrape pagina 2** en **Scrape pagina 3** (elk 0,1 credit).
5. **Behoefte-check klinieken** (AI, gpt-5.4-nano): leest de drie pagina's en de boeklinks. Antwoordt eerst de hoofdvraag (`proces_type`: handmatig, gemengd, modern, onbekend, met `boekingstool`, `reden`, signalen met citaat en URL), daarna de zes kenmerken K1-K6 en `contra`, `al_ver`, `online_boeken`, `rechtsvorm`.
6. **Tel kenmerken en voorstel** (code, gratis): telt K1-K6 en kiest het eerste bruikbare e-mailadres. Het veld `voorstel` (bel / controleer handmatig / valt af) komt uit de oude regel en wordt **niet meer gebruikt**. De beslisregel staat in `rubrics.md` en werkt op `proces_type`.

Aanpassen in Clay-assistent of CLI: de zoekinstellingen van de Google Maps-bron zijn alleen in de Clay-app te zien en te wijzigen (de CLI kan ze niet lezen).

Aan de zijkant staat een handmatige trigger met de Google Maps-bron "Find companies by location and keyword" (haar transplantatie, 15 km rond Amsterdam, limiet 10). Die is nog niet verbonden met de scrape-stappen: de bron zet de resultaten in een Clay-datalijst die de CLI niet kan lezen. Eén testrun kostte 10 credits voor 10 bedrijven. Niet starten zonder reden.

## Invoer en herhaling
- Google Maps-lijsten komen uit een Clay-tabel (in de app aangemaakt). Ik exporteer ze naar een CSV, haal duplicaten op domein weg, sla bedrijven over die al in `gezien.csv` of `profiles/luthox/leads/` staan, upload de CSV en start de run.
- Na elke batch worden de bedrijven aan `gezien.csv` toegevoegd.
- De trial-limiet van 100 runs per workflow bleek niet te gelden: er zijn meer dan 150 runs gedraaid zonder blokkade.

## Wat er niet in zit
- Geen contactverrijking. Het e-mailadres komt van de site (gratis, bij ongeveer twee van de drie klinieken). Een betaalde e-mailstap is er (nog) niet.
- Geen `waarom_nu_*` of briefing in Clay: die schrijft Claude in de repo voor de kandidaten die je goedkeurt.
- Geen publicatie: runs gebruiken de conceptversie.

## Bekende beperkingen
- De AI leest alleen de gescrapete tekst en links. Een boekingswidget die niet in de tekst of links staat, zien we niet. "Handmatig" betekent dus "geen systeem zichtbaar".
- Een klein model (gpt-5.4-nano) geeft licht wisselende antwoorden bij dezelfde site. Controleer elke kandidaat voor je belt.
- Een scrape kan falen of een timeout geven (6 uit de eerste run, 1 uit de tweede). Die staan in de batchbestanden.

## Prompt
De actuele prompt staat in de AI-node in Clay (open de workflow). Samengevat: gebruik alleen de aangeleverde tekst; per onderdeel `gevonden`, `citaat` (woordelijk) en `url`; niet te beoordelen is precies "onvoldoende bewijs, telefonisch verifiëren"; een knop "Boek nu" telt alleen als modern als de links of tekst een echte boekingstool laten zien. Voor andere niches: vervang K1-K6 door de rij uit `rubrics.md`.

## Kostenlog
Saldo vóór de eerste test (2026-10-14): 1313.9 data credits, 4924 action executions. Tussen de test en de eerste batch ging er 66 af door de Google Maps-bron in de tabel.

| Datum | Niche | Rijen | Credits voor | Credits na | Per rij | Opmerking |
|---|---|---|---|---|---|---|
| 2026-10-14 | klinieken | 3 | 1247.9 | 1244.6 | 1.1 | Eerste test, alleen homepage |
| 2026-10-14 | Maps-bron | 10 | 1244.6 | 1234.6 | 1.0 | Eén testrun van de bron, nog niet gekoppeld |
| 2026-10-14 | klinieken | 3 | 1234.6 | 1230.7 | 1.3 | Test met extra pagina's |
| 2026-10-14 | klinieken | 77 | 1230.7 | 1138.2 | 1.2 | Eerste batch met extra pagina's (71 geslaagd, 6 gefaald). Oude regel "bel" |
| 2026-10-15 | klinieken | 5 | 1138.0 | 1131.5 | 1.3 | Test van de vraag handmatig/modern |
| 2026-10-15 | klinieken | 69 | 1131.5 | 1043.0 | 1.3 | Tweede run met de nieuwe vraag (68 geslaagd, 1 gefaald). Resultaat: `batches/2026-10-15-haartransplantatie-klinieken-proces.yaml` |

Totaal voor 74 klinieken twee keer door de workflow ongeveer 190 credits. Geen top-up of abonnement zonder jouw besluit. Clay-trial loopt naar verwachting tot ca. 27 oktober; exporteer daarvóór alles wat je wilt bewaren (alles staat al in `batches/`).
