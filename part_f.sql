WITH imei_history AS (
    SELECT 
        imei_a AS imei,
        msisdn,
        device_brand,
        device_model,
        activation_date AS imei_eff_dt,
        LEAD(activation_date) OVER (PARTITION BY imei_a ORDER BY activation_date) AS next_activation_date,
        LEAD(deletion_date) OVER (PARTITION BY imei_a ORDER BY activation_date) AS next_deletion_date,
        LEAD(msisdn) OVER (PARTITION BY imei_a ORDER BY activation_date) AS next_msisdn,
        deletion_date
    FROM sandbox_activations
    WHERE device_brand IS NOT NULL AND device_model IS NOT NULL
    ORDER BY imei_a, activation_date
),
processed_history AS (
    SELECT 
        imei,
        msisdn,
        device_brand,
        device_model,
        imei_eff_dt,
        CASE
            WHEN next_msisdn IS NOT NULL THEN next_activation_date
            WHEN deletion_date IS NOT NULL AND deletion_date <> '1970-01-01' THEN deletion_date
            ELSE NULL
        END AS imei_end_dt
    FROM imei_history
)
SELECT 
    imei,
    msisdn,
    device_brand,
    device_model,
    imei_eff_dt,
    imei_end_dt
FROM processed_history
ORDER BY imei, imei_eff_dt;
