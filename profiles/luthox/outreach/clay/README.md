# Kanaal: Clay (niche-segmenten met zichtbaar handmatig proces)

Aangemaakt 2026-10-14. Dit is een apart kanaal naast `vacature-signaal/`. Het heeft een eigen leadformaat (zie `batches/_template.yaml`) en raakt `leads/*.yaml` niet aan. Het volgt `outreach/PLAN.md` (sectie 5 en 6, Clay-test C). Bij tegenspraak wint het plan.

## Wat dit kanaal doet
Per niche-segment een lijst bedrijven (Google Maps of Clay-zoekopdracht) door één Clay-workflow halen. De workflow leest de website (homepage plus twee extra pagina's) en beantwoordt de hoofdvraag: **werkt dit bedrijf handmatig, gemengd of modern?** Elk antwoord heeft letterlijke citaten en een bron-URL. Handmatig en gemengd zijn de kandidaten om te bellen.

## Wat een kenmerk wel en niet bewijst
- Een site zegt nooit "wij hebben automatisering nodig". Een kenmerk toont alleen dat een handmatige stap **bestaat** (bijvoorbeeld "stuur uw foto's via WhatsApp, wij nemen contact op").
- Het bewijst niet dat de stap pijn doet. Dat bevestigt alleen het gesprek. Dus: kenmerk = **feit**, wat het kan betekenen = **hypothese**, wat we vragen = **vraag**.
- Er zijn geen niveaus (A/B). Alleen `proces_type` (handmatig, gemengd, modern, onbekend) met bewijs. "Handmatig" betekent: geen boekingstool of portaal zichtbaar op de gelezen pagina's. Een systeem dat niet op de site staat blijft onzichtbaar; het gesprek bevestigt.

## Regels
1. **Citaat of niets.** Elk kenmerk heeft een letterlijk citaat en een URL, of precies: "onvoldoende bewijs, telefonisch verifiëren". Geen gokken.
2. **Alleen de kandidaten (handmatig en gemengd) krijgen handmatige controle:** bron openen, citaat controleren, omvang (11-50) en rechtsvorm nakijken. Dat is geen controle van alle rijen.
3. **Rechtsvorm** (eenmanszaak/vof) alleen vóór mailen controleren. Bellen mag altijd. Concern: bij kandidaten even kijken.
4. **Eerst 3 rijen, dan 20.** Credits vóór en na tellen. Pas meer draaien na het cijfer per rij. Zie `workflow.md`.
5. **Geen claims** over klanten, resultaten, tijdwinst of levertijd. Luthox is startend.
6. **Dubbelen:** vergelijk met `profiles/luthox/leads/` vóór het bellen.

## Bestanden
| Bestand | Inhoud |
|---|---|
| `rubrics.md` | Hoofdvraag (handmatig of modern), kenmerken per niche en de beslisregel |
| `gezien.csv` | Elk bedrijf dat al is gecontroleerd, tegen herhaling |
| `workflow.md` | Wat de Clay-workflow doet, invoer, uitvoer en kostenlog |
| `logboek.md` | Per batch: onderzocht, kandidaten, minuten, credits, gesprekken |
| `batches/_template.yaml` | Leadformaat van dit kanaal |
| `batches/<datum>-<niche>.yaml` | Eén bestand per niche en run |

## Eerste start
Niche: haartransplantatie en cosmetische klinieken (Clay-tabel "Haartransplantatie", 86 bedrijven). Eerste resultaten: `batches/2026-10-15-haartransplantatie-klinieken-proces.yaml` (73 klinieken: 44 handmatig, 11 gemengd, 15 modern, 3 onbekend). Script: `../../scripts/klinieken-call-script.md`. Daarna warmtepomp/zonnepaneel-installateurs en relocation/immigratie.
