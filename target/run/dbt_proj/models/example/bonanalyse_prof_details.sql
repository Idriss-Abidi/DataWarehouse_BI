
  
    

  create  table "res"."public"."bonanalyse_prof_details__dbt_tmp"
  
  
    as
  
  (
    WITH bonanalyse_data AS (
              SELECT DISTINCT
                  b."idBonAnalyse", 
                  b."dateCreation", 
                  b."dateStatut", 
                  b."isActuel", 
                  b."montantInitial", 
                  b."numeroBA", 
                  eu.nom AS etablissement_universitaire_nom,
                  concat(me.prenom, ' ', me.nom) AS professeur,
                  me.cin,
                  concat(fac.nom, ' - ', eu.nom) AS faculteecole_nom
              FROM 
                  "res"."SC_App1"."bonanalyse" b
              INNER JOIN 
                  "res"."SC_App1"."membreexterne" me ON b."idProfesseur" = me."idMembreExterne"
              INNER JOIN 
                  "res"."SC_App1"."detailfaculteecoleprofesseur" dfac ON me."idMembreExterne" = dfac."idProfesseur"
              INNER JOIN 
                  "res"."SC_App1"."faculteecole" fac ON dfac."idFaculteEcole" = fac."idFaculteEcole"
              INNER JOIN 
                  "res"."SC_App1"."etablissementuniversitaire" eu ON fac."idEtablissementUniversitaire" = eu."idEtablissementUniversitaire"
              WHERE 
                  b."idProfesseur" IS NOT NULL 
                  AND dfac."idFaculteEcole" IS NOT NULL
          )
          SELECT * FROM bonanalyse_data
  );
  