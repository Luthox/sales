# Sales-aanpak Luthox: stand van zaken en plan (bijgewerkt 2026-10-13)

Dit bestand is het geheugen van de sparringssessie. Lees dit eerst in een nieuwe chat. Details staan in `outreach/vacature-signaal/`.

## Waarom een andere aanpak
- 22 leadbatches over 11 segmenten met dezelfde generieke pitch ("plan een intakegesprek"), zonder reden om nú te reageren.
- Het vacature-signaal is het enige signaal met een reden om nu te bellen, maar de eerdere bronnen (LinkedIn-alertmails, Indeed handmatig) gaven weinig bruikbare leads (1-2 uit ongeveer 60).

## Beslissingen tot nu toe
- **Meer lagen, geen vervanging.** Omnichannel (LinkedIn, mail, bellen) op dezelfde lead, met signaal als aanleiding.
- **Eerst handmatig testen om te leren, daarna pas automatiseren.** Clay inzetten voor een stap die we al minstens 20 keer handmatig deden.
- **Geen extra abonnementen.** Instantly en Lemlist zijn geen optie. Mail eerst als concept in Gmail, handmatig verzenden. Tweede domein volgt later, mail op volume pas in week 3-4. Zie `vacature-signaal/opwarmen-en-dns.md`.
- **Doel:** eerste meetings binnen 4 weken (uiterlijk rond 10 november), minimaal live binnen een week. Verwachting 3-6 meetings is een aanname, geen meting.
- **Meetlat:** na ongeveer 150 contacten minstens 5 reacties en 2 gesprekken, anders eerst het aanbod aanpassen.

## Sporen (tracks)
1. **Facility management** (bewezen, goede gesprekken): segment `segments/facility-management.yaml`, 42 bedrijven in `leads/2026-09-22-facility-management.yaml`. Open: uitzoeken wat de goede gesprekken gemeen hadden en daar op zoeken.
2. **Vacature-signaal** (testen): bedrijven met een AI-, automatiserings- of procesoptimalisatievacature, bij voorkeur tijdelijk/freelance, 11-50 medewerkers.
3. **Lokale bedrijven** (goodwill, leren, eerste cases): bestaand script en lijst, maximaal 20-30% van de belblokken.
4. **Warme CRM-leads** (eerst oppakken): bijvoorbeeld BeheerGoed, waar de vervolgmail te laat was.

## Twee invalshoeken per lead
- **Teardown + pilot**: voor bedrijven die het probleem plausibel nog hebben. Eén pagina, losstaand van bestaande software (niet voortbouwen op Twinq, Syntess, enzovoort). Template: `vacature-signaal/teardown-template.md`. **Eerst hun site lezen**: zeggen ze al voorop te lopen met automatisering, dan geen teardown.
- **Samenwerking, geen pitch**: voor bedrijven die al ver zijn (voorbeeld iQOUNT). Zie `vacature-signaal/voorbeeld-iqount-bellen.md`.

## Tools en accounts (stand 13 oktober)
- **Clay:** 14 dagen trial (1K data credits, 5K actions), gekoppeld in Claude. Via de koppeling: bedrijven zoeken op branche/omvang/regio, vacatures en contacten per bedrijf. Niet: zoeken op vacatures, en geen tabel bouwen.
- **Apollo:** 14 dagen trial Professional (80 contactcredits, 160 telefoonnummers, 5000 AI-credits, 0 exportcredits). Via de koppeling is bedrijvenzoeken geblokkeerd (plan), dus zoeken gebeurt in het scherm van Apollo; resultaten plakken in de chat. Credits laat uitgeven: alleen contacten voor de beste leads.
- Trials lopen ongeveer tot 27 oktober. Test in Clay uiterlijk rond 20 oktober.

## Wat we geleerd hebben
- Het vacaturefilter in Apollo alleen geeft vooral AI/IT-bedrijven, bureaus en industriële automatisering (PLC/robotica). Branchefilter en de AI-kolom zijn nodig. Zie `vacature-signaal/logboek.md` (1 passende lead uit 25 gecontroleerde namen).
- Een teardown mag nooit een probleem aannemen dat de site tegenspreekt (les iQOUNT).
- De mail aan een tussenpersoon (Ronald bij BeheerGoed) moet expliciet vragen om doorsturen naar de directie.
- Alleen feiten uit gesprek, site of vacature. Tijdwinst als aanname met rekensom. Geen klanten of resultaten noemen die er niet zijn: Luthox is startend.

## Open vragen
- Wat hadden de goede facility-management-gesprekken gemeen? (namen en zinnen uit het CRM)
- Pilotprijs en de claim "in twee weken waarmaken".
- Eigen IP bij SiteGround of Google Workspace voor het tweede domein (controle van het IP van klantdomeinen).
- Wie belt, hoeveel uur per dag.

## Bestanden
- `vacature-signaal/teardown-template.md`, `mail-en-opvolging.md`, `linkedin.md`
- `vacature-signaal/clay-tabel.md` (kolommen en scoreformule), `opwarmen-en-dns.md`
- `vacature-signaal/logboek.md` (zoekbatches, leads en acties, lessen): houd dit bij
- Voorbeelden: `voorbeeld-iqount-*.md`, `voorbeeld-beheergoed.md`, `onepager-beheergoed.html/.pdf`
- `leads/2026-10-13-vacature-signaal-apollo-1.yaml`

## Een nieuwe chat starten
Plak: "Lees profiles/luthox/outreach/PLAN.md en vacature-signaal/logboek.md. We beslissen de globale strategie opnieuw: begin met een korte samenvatting van de stand en stel me de belangrijkste keuzes voor."
