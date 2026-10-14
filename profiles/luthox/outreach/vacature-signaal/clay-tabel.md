# Clay-tabel: kandidaten controleren en verrijken (facility management en vacature)

Volgt `outreach/PLAN.md`. Doel: van een lijst kandidaten alleen de bedrijven overhouden die we met een geloofwaardige reden kunnen bellen. Liever 10 goede leads per dag dan 30 matige.

Menunamen in Clay kunnen afwijken van wat hier staat. Klopt een naam niet, pas de naam aan en houd de logica. Credits en actions worden na de eerste 10 rijen geteld voordat we meer draaien.

## Principe

1. **Kandidaten komen van buiten Clay of uit de Clay-interface-zoekopdracht**, niet uit de Claude-koppeling. Die kan niet op land of vacature filteren. Bronnen: Clay-zoekopdracht in de interface (land Nederland, omvang 11-50, branche, geen non-profit), ledenlijsten van brancheorganisaties (bijvoorbeeld Schoonmakend Nederland), de bestaande FM-lijst na herfiltering, en voor vacatures de Apollo-schermzoekopdracht met branchefilter.
2. **Goedkoop filteren eerst, dure stappen alleen voor wie slaagt.**
3. **Bewijs of niets.** Elke AI-kolom geeft een bron-URL en een letterlijk citaat, of de tekst "onvoldoende bewijs, telefonisch verifiëren". Een gok is niet toegestaan.
4. **Eerst 10 rijen testen**, credits en minuten tellen, daarna pas meer.

## Fase 1: ICP-filter (gratis of bijna gratis)

| Kolom | Wat |
|---|---|
| `bedrijf`, `domein`, `bron`, `bron_term` | herkomst van de rij |
| `land_ok` | land is Nederland |
| `omvang` en `omvang_ok` | medewerkers tussen 11 en 50. Leeg = "handmatig checken" |
| `type_uit` | non-profit, vereniging, stichting, overheid |
| `naam_uit` | woorden als recruitment, uitzend, detachering, staffing, interim in naam of domein |
| `dubbel` | staat al in `profiles/luthox/leads/` (zonder bewuste herbenadering) |

Een rij die hier één keer faalt, krijgt `valt_af` met de reden en gaat niet verder.

## Fase 2: site en vacature lezen (AI-kolommen)

Eén kolom per vraag. Gebruik voor elke kolom deze slotregel in de prompt:

> Geef een antwoord, een bron-URL en één letterlijk citaat van de pagina. Staat het niet op de site of in de vacature, antwoord dan precies: "onvoldoende bewijs, telefonisch verifiëren". Vul niets aan met aannames.

| Kolom | Vraag aan de AI |
|---|---|
| `wat_doen_ze` | Wat verkoopt dit bedrijf aan wie? Kies: schoonmaak, beveiliging, technisch beheer/onderhoud, groenvoorziening, catering, receptie, anders (benoem). |
| `meerdere_locaties` | Werkt dit bedrijf voor meerdere klanten of op meerdere locaties tegelijk? Noem wat de site zegt. |
| `vacature` | Staat er een open vacature voor administratie, planning, operations, procesverbetering, digitalisering of automatisering? Titel, URL, plaatsingsdatum als zichtbaar. |
| `al_ver` | Zegt de site dat het bedrijf al investeert in AI/automatisering of een eigen ontwikkelteam heeft? Dan wordt het invalshoek C (samenwerking), geen teardown. |
| `rechtsvorm_concern` | Is dit een eenmanszaak of vof, of onderdeel van een groter concern? Waar blijkt dat uit? |

## Behoefte-check per segment (fase 2, test C en daarna)

Per bedrijf één AI-kolom `behoefte_check` met de rubric van het segment waarin het zit. Dezelfde slotregel: bron-URL, letterlijk citaat, of "onvoldoende bewijs, telefonisch verifiëren".
Uitkomst: **niveau A** (aanwijzing met citaat), **niveau B** (past in segment, geen aanwijzing), **valt af** (past niet of de site spreekt het tegen).

| Segment | Zoek op de site naar |
|---|---|
| Haartransplantatie en cosmetische klinieken | Gratis adviesgesprek of intakeformulier met foto-upload, WhatsApp-contact, offerte of prijsindicatie op aanvraag, meerdere vestigingen, advertenties of landingspagina's |
| Tandarts met implantologie of orthodontie | Consult of intake aanvragen, offerte of behandelplan, meerdere locaties of behandelaars |
| Medisch-esthetisch en laser | Online afspraak of aanvraagformulier, behandeltrajecten (meerdere afspraken), nazorg |
| Dieren- en paardenklinieken | Aanvraag per telefoon of mail, offerte of kostenindicatie, oproepsysteem |
| Warmtepomp, zonnepanelen, airco | Offerte of opname aanvragen, adviesgesprek, meerdere monteurs of installatieteams, projecten per week |
| Maatwerk keuken, interieur, zwembad | Showroomafspraak of offerte aanvragen, opname bij de klant, projecten met meerdere stappen |
| Jacht (bouw, makelaar, onderhoud) | Offerte voor onderhoud of renovatie, werf met meerdere projecten tegelijk |
| Klassieke en exclusieve auto's | Aanvraag, inruil, restauratieprojecten per auto |
| Relocation, expat, immigratie | Intakeformulier, documentenlijst, trajecten met deadlines, meerdere klanten tegelijk |
| Boutique advocaat of notaris | Intake, dossiers per cliënt, kantoor met meerdere behandelaars |
| Facility management | Meerdere klanten of locaties, planning per locatie, relevante vacature |
| Aannemers, groothandel, installateur, administratiekantoor, vastgoedbeheer, maakindustrie | Zie de segmentbestanden in `segments/` voor het probleem en de openingsvraag |

Is het bedrijf zelf al ver (site noemt AI-tools, eigen ontwikkelaar, geavanceerd klantportaal)? Dan `al_ver` en invalshoek C (samenwerking).

## Briefing per lead (belbriefje)

Voor niveau A, na `waarom_nu`, één AI-kolom `briefing`. Maximaal 6 regels, in deze volgorde:
1. Wat doet het bedrijf, in één zin.
2. **Haakje (feit):** het citaat uit `behoefte_check` met bron.
3. **Hypothese:** wat dit kan betekenen, gemarkeerd als aanname.
4. **Openingsvraag:** uit het segmentbestand of de rubric.
5. **Twee vervolgvragen** over proces, tools en tijd.
6. **Let op:** onzekerheid (omvang onbekend, rechtsvorm, medische gegevens, al ver).

De briefing bevat geen prijs, levertijd, klantnaam of resultaat.

## Fase 3: beslissing

Een formule geeft een voorstel, jij beslist.

- **bel:** `wat_doen_ze` past, plus `meerdere_locaties` of een relevante `vacature` met bron, geen concern, geen eenmanszaak.
- **controleer handmatig:** één van de vragen heeft "onvoldoende bewijs".
- **valt af:** past niet, of de site spreekt de hypothese tegen.

Elk bedrijf met "bel" wordt nog handmatig bekeken: de bron openen en het citaat controleren.

## Waarom nu? (AI-kolom, na fase 3)

Alleen voor "bel". Drie aparte kolommen:

- `waarom_nu_feit`: één zin uit de uitkomsten van fase 2, met bron. Is er geen citaat, dan is er geen lead.
- `waarom_nu_hypothese`: wat dit kan betekenen, expliciet gemarkeerd als aanname.
- `waarom_nu_vraag`: de vraag voor in het gesprek, in gewone taal.

## Fase 4: contact (alleen voor "bel")

`beslisser`, `email`, `telefoon`. Dit is de duurste stap. Probeer Clay eerst. Apollo (80 contactcredits) alleen voor wat Clay mist.

## Meten per batch

Noteer in `outreach/vacature-signaal/logboek.md`: onderzocht, valt af in fase 1, valt af in fase 2-3, bel, **minuten totaal**, credits en actions verbruikt, wat Clay vond dat handwerk gemist zou hebben, en later gesprekken en intakes.

## Voor de mail of het bellen

Lever per "bel"-rij: `bedrijf`, `voornaam`, `telefoon`, `email`, `waarom_nu_feit`, `waarom_nu_hypothese`, `waarom_nu_vraag`, `al_ver`. Dat zijn de velden uit `mail-en-opvolging.md` en `scripts/`.

## Let op

- Mail alleen naar zakelijke adressen en alleen na controle van de rechtsvorm (eenmanszaak en vof tellen als natuurlijke personen). Twijfel je, bel dan. Laat een jurist dit bevestigen voor je opschaalt.
- Exporteer alles wat je nodig hebt vóór de trial afloopt (ongeveer 27 oktober).
