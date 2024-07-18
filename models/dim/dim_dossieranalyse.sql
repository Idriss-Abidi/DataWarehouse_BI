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
        {{ source('SC_App1', 'dossieranalyse') }} df
    LEFT JOIN 
        {{ source('SC_App1', 'facturation') }} f ON f."idFacturation" = df."idFacturation"
    LEFT JOIN 
        {{ source('SC_App1', 'statutdossieranalyse') }} sda ON sda."idStatutDossierAnalyse" = df."idStatutDossierAnalyse"
)
SELECT * FROM dim_dossieranalyse
