SELECT
    s.patient_id,
    s.overall_satisfaction,
    s.timeliness_score,
    p.age_group,
    p.region,
    p.socioeconomic_band
FROM patient_experience_surveys s
JOIN patients_demographics p
ON s.patient_id = p.patient_id;

-- Satisfaction by Demographic
SELECT
    age_group,
    AVG(overall_satisfaction) AS avg_satisfaction
FROM patient_experience_surveys s
JOIN patients_demographics p
ON s.patient_id = p.patient_id
GROUP BY age_group
ORDER BY avg_satisfaction DESC;

-- Funnel Analysis
SELECT
    funnel_step,
    COUNT(DISTINCT patient_id) AS patients_reached
FROM patient_service_funnel
GROUP BY funnel_step
ORDER BY MIN(step_sequence);

-- Survey Completion Rate
SELECT
    COUNT(DISTINCT CASE 
        WHEN funnel_step = 'Survey Completed' 
        THEN patient_id END
    ) * 1.0 /
    COUNT(DISTINCT CASE 
        WHEN funnel_step = 'Survey Invitation Sent'
        THEN patient_id END
    ) AS survey_completion_rate
FROM patient_service_funnel;

-- CTE

WITH funnel_stage AS (
  SELECT
    p.age_group,
    f.funnel_step,
    COUNT(DISTINCT f.patient_id) AS patients
  FROM patient_service_funnel f
  JOIN patients_demographics p
    ON f.patient_id = p.patient_id
  GROUP BY p.age_group, f.funnel_step
)
SELECT * FROM funnel_stage;

