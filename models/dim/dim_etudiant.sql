WITH dim_etudiant AS (
    SELECT 
        etd."idEtudiant" as etdId, 
        etd.cin, 
        etd.cne, 
        concat(etd.prenom, ' ', etd.nom) AS nom_complet, 
        etd."idDiplome", 
        dp.abreviation AS diplome, 
        eu."idEtablissementUniversitaire", 
        eu.nom AS EtablissementUniversitaire
    FROM 
        {{ ref('src_etudiant') }} etd
    LEFT JOIN 
        {{ ref('src_diplome') }} dp ON dp."idDiplome" = etd."idDiplome"
    LEFT JOIN 
        {{ ref('src_etablissementuniversitaire') }} eu ON eu."idEtablissementUniversitaire" = etd."idEtablissementUniversitaire"
)
SELECT * FROM dim_etudiant
