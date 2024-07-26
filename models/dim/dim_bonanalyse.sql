WITH dim_bonanalyse AS (
    SELECT DISTINCT
        b."idBonAnalyse", 
        b."dateCreation", 
        b."dateStatut", 
        b."isActuel", 
        b."active",
        b."montantInitial", 
        b."numeroBA", 
        b."idProfesseur",
        concat(me."prenom", ' ', me."nom") AS professeur,
        me."cin",
        eu."idEtablissementUniversitaire",
        eu."nom" AS etablissement_universitaire,
        dfac."idFaculteEcole",
        concat(fac."nom", ' - ', eu."nom") AS faculteecole_nom,
        sba."abreviation" as statut,
        scdba."abreviation" as statut_confirmation, 
        us."userName" as suiviePar,
        -- dba."idDetailsBonAnalyse",
        dlu."idLaboratoire",
        dlu.laboratoire,
        dlu."idUniteMesure" as idUniteMesure_lab,
        dlu.unitemesure,
        dtu."idTypeAnalyse",
        dtu."prestation" AS typeAnalyse,
        dtu."idUniteMesure" as idUniteMesure_type,
        dtu."abreviation" AS typeAnalyse_unitemesure,
        dba."valeur"
    FROM 
        {{ ref('src_bonanalyse') }} b
    INNER JOIN 
        {{ ref('src_membreexterne') }} me ON b."idProfesseur" = me."idMembreExterne"
    INNER JOIN 
        {{ ref('src_detailfaculteecoleprofesseur') }} dfac ON me."idMembreExterne" = dfac."idProfesseur"
    INNER JOIN 
        {{ ref('src_faculteecole') }} fac ON dfac."idFaculteEcole" = fac."idFaculteEcole"
    INNER JOIN 
        {{ ref('src_etablissementuniversitaire') }} eu ON fac."idEtablissementUniversitaire" = eu."idEtablissementUniversitaire"
    INNER JOIN 
        {{ ref('src_statutconfirmationdemandebonanalyse') }} scdba ON scdba."idStatutConfirmationDemandeBonAnalyse" = b."idStatutConfirmationDemandeBonAnalyse"
    INNER JOIN 
        {{ ref('src_statutbonanalyse') }} sba ON sba."idStatutBonAnalyse" = b."idStatutBonAnalyse"
    LEFT JOIN 
        {{ ref('src_users') }} us ON us."idUser" = b."suivieParUser"
    LEFT JOIN 
        {{ ref('src_detailsbonanalyse') }} dba ON dba."idBonAnalyse" = b."idBonAnalyse"
    left join 
    {{ref('dim_detail_labo_unitemesure')}} dlu on dlu."idDetailLaboratoireUniteMesure" = dba."idDetailLaboratoireUniteMesure"
    left join 
    {{ref('dim_detail_typeanalyse_unitemesure')}} dtu on dtu."idDetailTypeAnalyseUniteMesure" = dba."idDetailTypeAnalyseUniteMesure"
    WHERE 
        b."idProfesseur" IS NOT NULL 
        AND dfac."idFaculteEcole" IS NOT NULL
)
SELECT * FROM dim_bonanalyse
