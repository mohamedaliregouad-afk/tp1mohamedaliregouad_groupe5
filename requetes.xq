(: ═══════════════════════════════════════════════════════════════
   Fichier : requetes.xq
   Projet  : Club Info_Tech — Gestion XML avec XQuery
   Tester  : BaseX GUI  ou  Oxygen XML Editor
   Source  : doc("club.xml") — charger le fichier dans BaseX d'abord
   ═══════════════════════════════════════════════════════════════ :)

(: ─────────────────────────────────────────
   Q1 — Liste complète des membres  (1 pt)
   Affiche : id, nom complet, email, libellé catégorie
   ───────────────────────────────────────── :)
<membres>
{
  for $m in doc("club.xml")//membre
  (: Jointure : récupérer la catégorie via categorieRef :)
  let $cat := doc("club.xml")//categorie[@id = $m/@categorieRef]
  return
    <membre id="{$m/@id}">
      <nomComplet>{$m/prenom/text()} {$m/nom/text()}</nomComplet>
      <email>{$m/email/text()}</email>
      <categorie>{$cat/@libelle/string()}</categorie>
    </membre>
}
</membres>

,

(: ─────────────────────────────────────────
   Q2 — Liste des concours triés par date  (1 pt)
   Affiche : titre, date, coefficient, libellé catégorie
   ───────────────────────────────────────── :)
<listeConcours>
{
  for $c in doc("club.xml")//concours[@id]
  (: Jointure : récupérer le libellé de la catégorie :)
  let $cat := doc("club.xml")//categorie[@id = $c/@categorieRef]
  (: Tri par date croissante :)
  order by xs:date($c/@date)
  return
    <concours id="{$c/@id}">
      <titre>{$c/titre/text()}</titre>
      <date>{$c/@date/string()}</date>
      <coefficient>{$c/@coefficient/string()}</coefficient>
      <categorie>{$cat/@libelle/string()}</categorie>
    </concours>
}
</listeConcours>

,

(: ─────────────────────────────────────────
   Q3 — Calcul des scores de chaque participant  (2 pts)
   Formule : score = (complexite + tempsExecution) × coefficient
   Affiche : titre concours, nom participant, complexite, tempsExec, score arrondi 2 décimales
   ───────────────────────────────────────── :)
<resultatsConcours>
{
  for $c in doc("club.xml")//concours[@id]
  return
    <concours titre="{$c/titre/text()}">
    {
      for $p in $c//participant
      (: Récupérer le membre correspondant via membreRef :)
      let $m     := doc("club.xml")//membre[@id = $p/@membreRef]
      (: Récupérer les valeurs numériques :)
      let $comp  := xs:integer($p/complexite)
      let $temps := xs:integer($p/tempsExecution)
      let $coef  := xs:decimal($c/@coefficient)
      (: Calcul du score :)
      let $score := ($comp + $temps) * $coef
      return
        <participant>
          <nom>{$m/prenom/text()} {$m/nom/text()}</nom>
          <complexite>{$comp}</complexite>
          <tempsExecution>{$temps}</tempsExecution>
          <score>{format-number($score, "0.00")}</score>
        </participant>
    }
    </concours>
}
</resultatsConcours>

,

(: ─────────────────────────────────────────
   Q4 — Vainqueur de chaque concours  (2 pts)
   Participant avec le score maximum.
   En cas d'égalité : afficher tous les ex-aequo.
   ───────────────────────────────────────── :)
<vainqueurs>
{
  for $c in doc("club.xml")//concours[@id]
  (: Calculer tous les scores pour ce concours :)
  let $coef  := xs:decimal($c/@coefficient)
  let $scores :=
    for $p in $c//participant
    return ($coef * (xs:integer($p/complexite) + xs:integer($p/tempsExecution)))
  (: Obtenir le score maximum :)
  let $maxScore := max($scores)
  return
    <concours titre="{$c/titre/text()}">
    {
      (: Filtrer les participants ayant le score maximum (ex-aequo inclus) :)
      for $p in $c//participant
      let $m     := doc("club.xml")//membre[@id = $p/@membreRef]
      let $score := $coef * (xs:integer($p/complexite) + xs:integer($p/tempsExecution))
      where $score = $maxScore
      return
        <vainqueur>
          <nom>{$m/nom/text()}</nom>
          <prenom>{$m/prenom/text()}</prenom>
          <score>{format-number($score, "0.00")}</score>
        </vainqueur>
    }
    </concours>
}
</vainqueurs>

,

(: ─────────────────────────────────────────
   Q5 — Membres d'une catégorie (triés)  (2 pts)
   Paramétrer $categorie avec le libellé souhaité.
   Tri alphabétique : par nom, puis par prénom.
   ───────────────────────────────────────── :)
(: ★ Changer la valeur de $categorie pour filtrer une autre spécialité :)
let $categorie := "Intelligence Artificielle"
let $catNode   := doc("club.xml")//categorie[@libelle = $categorie]
return
<membresDeLaCategorie libelle="{$categorie}">
{
  for $m in doc("club.xml")//membre[@categorieRef = $catNode/@id]
  (: Tri alphabétique par nom, puis prénom :)
  order by $m/nom, $m/prenom
  return
    <membre id="{$m/@id}">
      <nom>{$m/nom/text()}</nom>
      <prenom>{$m/prenom/text()}</prenom>
      <email>{$m/email/text()}</email>
    </membre>
}
</membresDeLaCategorie>
