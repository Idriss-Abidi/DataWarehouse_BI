WITH dim_dossieranalyse AS (
    SELECT 
        df."idDossierAnalyse", 
        df."numeroDossierAnalyse", 
        sda.abreviation, 
        df."dateCreation", 
        df."dateDerniereModification", 
        df."idBonAnalyse", 
        df."idDevis", 
        df."idEtudiant", 
        df."numeroDemandeFicheAnalyse", 
        df."idLaboratoire", 
        df."suivieParUser",
        df."idFacturation", 
        f."DTYPE", 
        f."dateCreation" as "dateDerniereModification_facture",
        f.numero, 
        f."numeroQuittance"
    FROM 
        {{ ref('src_dossieranalyse') }} df
    LEFT JOIN 
        {{ ref('src_facturation') }} f ON f."idFacturation" = df."idFacturation"
    LEFT JOIN 
        {{ ref('src_statutdossieranalyse') }} sda ON sda."idStatutDossierAnalyse" = df."idStatutDossierAnalyse"
)
SELECT * FROM dim_dossieranalyse
