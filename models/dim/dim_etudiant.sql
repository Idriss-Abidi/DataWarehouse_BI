WITH dim_etudiant AS (
    SELECT 
        etd."idEtudiant", 
        etd.cin, 
        etd.cne, 
        concat(etd.prenom, ' ', etd.nom) AS nom_complet, 
        etd."idDiplome", 
        dp.abreviation AS diplome, 
        eu."idEtablissementUniversitaire", 
        eu.nom AS EtablissementUniversitaire
    FROM 
        {{ source('SC_App1', 'etudiant') }} etd
    LEFT JOIN 
        {{ source('SC_App1', 'diplome') }} dp ON dp."idDiplome" = etd."idDiplome"
    LEFT JOIN 
        {{ source('SC_App1', 'etablissementuniversitaire') }} eu ON eu."idEtablissementUniversitaire" = etd."idEtablissementUniversitaire"
)
SELECT * FROM dim_etudiant
