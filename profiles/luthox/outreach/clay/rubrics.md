# Rubrics: proces per niche en beslisregel

Hypothesen tot gesprekken ze bevestigen (zie `outreach/PLAN.md` sectie 5). Elk kenmerk = `gevonden` (true/false), `citaat` (letterlijk) en `url`. Niet te beoordelen: `gevonden: false` en citaat "onvoldoende bewijs, telefonisch verifiëren".

## Hoofdvraag: handmatig of modern? (sinds 2026-10-15)
Per bedrijf beantwoordt de AI eerst: werkt dit bedrijf met een **handmatig** proces (mail, telefoon, WhatsApp, formulier waarna iemand terugbelt, offerte op aanvraag) of met een **modern**, geautomatiseerd systeem (echte boekingstool, online betalen of aanbetaling, klantportaal of login, offertecalculator, chatbot, upload met automatische bevestiging)?

| `proces_type` | Betekenis |
|---|---|
| `handmatig` | Handmatige signalen, geen zichtbare boekingstool of portaal |
| `gemengd` | Zowel online plannen als handmatige stappen (terugbellen, formulier, foto's sturen) |
| `modern` | Echte boekingstool of portaal en geen handmatige signalen |
| `onbekend` | De gelezen pagina's laten er niets over zien (bijvoorbeeld een lege site) |

Bijbehorende velden: `boekingstool` (naam van de tool, bijvoorbeeld Salonized, Treatwell), `reden` (één zin), `handmatig` en `modern` (signalen met citaat en pagina-URL). Een knop "Boek nu" telt alleen als modern als de links of tekst een echte tool laten zien. Gelezen pagina's: homepage plus maximaal twee extra pagina's (contact, afspraak, offerte, werkwijze e.d.) plus de boek- en toollinks van de homepage.

## Vaste velden (alle niches)
| Veld | Betekenis |
|---|---|
| `contra` | De site toont al een volledig klantportaal, automatische offerte of geautomatiseerde intake. Dan valt het bedrijf af. |
| `al_ver` | De site noemt eigen AI, automatisering of een ontwikkelteam. Dan invalshoek C (samenwerking), geen teardown. |
| `online_boeken` | Online zelf een afspraak kunnen boeken. Telt niet mee in `aantal_kenmerken`; wel een signaal voor `proces_type`. |
| `rechtsvorm_zichtbaar` | BV, VOF of eenmanszaak in de tekst. Vaak "onvoldoende bewijs". Alleen vóór mailen echt controleren. |

## Zes procesenkenmerken (K1-K6), per niche ingevuld
Het aantal gevonden K1-K6 is `aantal_kenmerken`. Dit is extra bewijs, geen beslisregel meer: K1 (aanvraag via formulier/telefoon/mail) vindt de AI bij vrijwel elke kliniek (65 van 74 in de eerste run).

| Niche | K1 | K2 | K3 | K4 | K5 | K6 |
|---|---|---|---|---|---|---|
| **Haartransplantatie / cosmetische klinieken** | Aanvraag via formulier, WhatsApp, mail of telefoon | Foto's of documenten insturen | Offerte of prijs op aanvraag | "Wij nemen contact op" | Meerdere vestigingen | Traject: adviesgesprek, behandeling, nazorg/controle |
| **Tandarts implantologie / orthodontie** | Consult of intake aanvragen | Röntgen/foto's insturen | Offerte of behandelplan op aanvraag | Terugbelverzoek | Meerdere locaties of behandelaars | Meerstaps behandeltraject |
| **Medisch-esthetisch / laser** | Afspraak of aanvraag via formulier | Intakevragenlijst | Behandelplan of prijs op aanvraag | Bevestiging na handmatig contact | Meerdere locaties | Behandeltraject of herhaalbehandelingen, nazorg |
| **Dieren- en paardenklinieken** | Aanvraag per telefoon of mail | Dossier of verwijsbrief insturen | Kostenindicatie of offerte | Terugbelverzoek | Meerdere locaties of dierenartsen | Oproep of controle |
| **Warmtepomp, zonnepanelen, airco** | Offerte of adviesaanvraag via formulier | Foto's van meterkast/dak/woning insturen | Offerte of opname op aanvraag | "Wij nemen contact op" | Meerdere monteurs of installatieteams | Opname, offerte, installatie als aparte stappen |
| **Maatwerk keuken, interieur, zwembad** | Showroomafspraak of offerte aanvragen | Tekeningen of foto's insturen | Offerte op aanvraag | Opname bij de klant | Meerdere projecten tegelijk zichtbaar | Meerstaps project (ontwerp, opname, plaatsing) |
| **Jacht (bouw, makelaar, onderhoud)** | Aanvraag onderhoud of renovatie | Specificaties of foto's insturen | Offerte op aanvraag | Contact door werf of makelaar | Meerdere projecten op de werf | Seizoensplanning, onderhoudscyclus |
| **Klassieke en exclusieve auto's** | Aanvraag of inruil per formulier | Foto's en documenten per auto | Taxatie of offerte op aanvraag | Terugbelverzoek | Meerdere restauratieprojecten | Dossier per auto |
| **Relocation / expat / immigratie** | Intakeformulier | Documentenlijst of upload | Offerte op aanvraag | Persoonlijk contact na aanvraag | Meerdere klanten of kantoren | Traject met deadlines |
| **Boutique advocaat / notaris** | Intake per formulier of mail | Documenten insturen | Offerte of tarief op aanvraag | Terugbelverzoek | Meerdere behandelaars | Dossier per cliënt |
| **Facility management** | Aanvraag of offerte per formulier | Locatiegegevens insturen | Offerte op aanvraag | Opvolging door een medewerker | Meerdere klanten of locaties | Planning per locatie |

Is het segment niet hierboven te vinden, voeg een rij toe met dezelfde zes vragen, en noteer de datum.

## Beslisregel (voorstel, jij beslist)
Filters vóór de AI-stap (kosteloos): Nederland, geen duplicaat in `profiles/luthox/leads/` of `gezien.csv`, geen recruitment/uitzend/detachering in naam of domein.

- **Bellen (kandidaat):** `proces_type` is `handmatig` of `gemengd`.
- **Later of laag:** `modern` (al een goed systeem, zwakste lead) en `onbekend` (eerst de site handmatig bekijken).
- **Valt af:** past niet in het segment, of `contra` is true.

Binnen de kandidaten helpen `aantal_kenmerken`, foto's insturen, offerte op aanvraag en meerdere locaties bij de volgorde. De eerste run (2026-10-14) gebruikte de regel "twee kenmerken is bel" en gaf 52 van 74 als bel. Dat was te ruim: bijna elke kliniek heeft een contactformulier en een eerste consult.

Elke kandidaat wordt daarna door jou gecontroleerd: bron openen, citaat lezen, omvang 11-50, rechtsvorm. Pas daarna heeft de lead `waarom_nu_*` en een briefing.

## Controle vóór mailen (niet in Clay)
Rechtsvorm op KvK of in de footer nakijken. Eenmanszaak en vof niet mailen, wel bellen. Laat een jurist de regels bevestigen vóór opschalen.

## Zoekcriteria per niche (Clay-bedrijvenzoekopdracht)
Aangemaakt 2026-10-14. Veldnamen en enumwaarden komen uit `clay searches query-mode reference`. De zoekopdracht staat niet vast: pas aan na de eerste resultaten. Een `contains` zoekt hele woorden, geen deelwoorden, dus noteer varianten.

**Voor alle niches:** hoofdkantoor in Nederland, `company_size` = "11-50", `company_type` niet Non Profit / Government Agency / Educational, geen recruitment/uitzend/detachering/staffing, niet al in `profiles/luthox/leads/` (controle buiten Clay, vóór de workflow). Per niche 30-50 resultaten ophalen, 20-30 naar de workflow. De eerste test is 10.

| Niche | Industry (Clay-enum) | Beschrijving bevat | Niet |
|---|---|---|---|
| Haartransplantatie / cosmetische klinieken | Medical Practices, Hospitals and Health Care | haartransplantatie, hair transplant, cosmetische, cosmetic, plastische chirurgie, huidtherapie, medisch-esthetisch | ziekenhuizen, UMC, grote ketens |
| Warmtepomp / zonnepanelen / airco | (nog te bepalen uit de enumlijst) | warmtepomp, zonnepanelen, airco, installatie | energiebedrijven, webshops, groothandels |
| Relocation / immigratie | (nog te bepalen uit de enumlijst) | relocation, expat, immigratie, visum, residence permit | grote advieskantoren |

Dekking van Clay's bedrijvendatabase voor kleine lokale bedrijven is onbewezen. Blijkt het dun, dan blijft Google Maps (alleen in de Clay-app) de aanvullende bron.
