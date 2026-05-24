(: ═══════════════════════════════════════════════════════════════
   Fichier : updates.xq
   Projet  : Club Info_Tech — XQuery Update Facility
   Moteur  : BaseX (supporte XQuery Update)
   ⚠ Exécuter chaque opération séparément dans BaseX
     (les instructions update ne peuvent pas être mélangées
      avec des expressions de retour dans la même requête)
   ═══════════════════════════════════════════════════════════════ :)


(: ─────────────────────────────────────────
   OPÉRATION 1 — INSERTION  (1.5 pt)
   Ajouter un nouveau membre dans la catégorie C2 (Développement Web)
   Identifiant M012 (ne conflicte pas avec les IDs existants)
   ───────────────────────────────────────── :)

(: ★ Avant insertion : vérifier les membres existants
   for $m in doc("club.xml")//membre return $m/@id/string()
:)

insert node
  <membre id="M012" categorieRef="C2">
    <nom>Mansouri</nom>
    <prenom>Khalil</prenom>
    <email>k.mansouri@club.dz</email>
  </membre>
into doc("club.xml")//membres

(: ★ Après insertion : vérifier que M012 est bien ajouté
   doc("club.xml")//membre[@id="M012"]
:)


(: ─────────────────────────────────────────
   OPÉRATION 2 — MODIFICATION  (1.5 pt)
   Modifier le coefficient du concours CO2
   Avant : coefficient="1.2"   →   Après : coefficient="2.0"
   ───────────────────────────────────────── :)

(: ★ Avant modification : afficher l'état du concours CO2
   doc("club.xml")//concours[@id="CO2"]/@coefficient/string()
:)

replace value of node
  doc("club.xml")//concours[@id="CO2"]/@coefficient
with "2.0"

(: ★ Après modification : vérifier la nouvelle valeur
   doc("club.xml")//concours[@id="CO2"]/@coefficient/string()
   → doit retourner "2.0"
:)


(: ─────────────────────────────────────────
   OPÉRATION 3 — SUPPRESSION  (1 pt)
   Supprimer le participant M003 du concours CO1
   Le concours CO1 doit subsister avec ses autres participants (M001, M002)
   ───────────────────────────────────────── :)

(: ★ Avant suppression : afficher les participants de CO1
   for $p in doc("club.xml")//concours[@id="CO1"]//participant
   return $p/@membreRef/string()
:)

delete node
  doc("club.xml")//concours[@id="CO1"]
    //participant[@membreRef="M003"]

(: ★ Après suppression : vérifier que CO1 subsiste sans M003
   for $p in doc("club.xml")//concours[@id="CO1"]//participant
   return $p/@membreRef/string()
   → doit retourner M001 et M002 uniquement
:)
