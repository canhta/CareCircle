-- TimescaleDB Optimization for CareCircle Health Data
-- This script sets up hypertables and optimizations for time-series health data

-- Enable TimescaleDB extension (should already be enabled)
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- Drop existing primary key constraints to allow hypertable creation
ALTER TABLE health_metrics DROP CONSTRAINT IF EXISTS health_metrics_pkey;

-- Create composite primary keys that include the time column
ALTER TABLE health_metrics ADD CONSTRAINT health_metrics_pkey PRIMARY KEY (id, timestamp);

-- Create hypertable for health_metrics (time-series optimization)
-- This converts the regular table to a hypertable partitioned by timestamp
SELECT create_hypertable('health_metrics', 'timestamp',
    chunk_time_interval => INTERVAL '1 day',
    if_not_exists => TRUE
);

-- Create indexes for efficient querying (using proper column names with quotes)
-- Index for user-specific metric queries
CREATE INDEX IF NOT EXISTS idx_health_metrics_user_type_time
ON health_metrics ("userId", "metricType", timestamp DESC);

-- Index for device-specific queries
CREATE INDEX IF NOT EXISTS idx_health_metrics_device_time
ON health_metrics ("deviceId", timestamp DESC)
WHERE "deviceId" IS NOT NULL;

-- Index for validation status queries
CREATE INDEX IF NOT EXISTS idx_health_metrics_validation_status
ON health_metrics ("userId", "validationStatus", timestamp DESC);

-- Index for data source queries
CREATE INDEX IF NOT EXISTS idx_health_metrics_source_time
ON health_metrics ("userId", source, timestamp DESC);

-- Composite index for analytics queries
CREATE INDEX IF NOT EXISTS idx_health_metrics_analytics
ON health_metrics ("userId", "metricType", "validationStatus", timestamp DESC)
WHERE "validationStatus" = 'VALIDATED';

-- Index for health insights
CREATE INDEX IF NOT EXISTS idx_health_insights_user_type_time
ON health_insights ("userId", "insightType", "createdAt" DESC);

-- Index for unread insights
CREATE INDEX IF NOT EXISTS idx_health_insights_unread
ON health_insights ("userId", "isRead", "createdAt" DESC)
WHERE "isRead" = FALSE;

-- Create continuous aggregates for common analytics queries
-- Daily averages for each metric type per user
CREATE MATERIALIZED VIEW IF NOT EXISTS health_metrics_daily_avg
WITH (timescaledb.continuous) AS
SELECT
    "userId",
    "metricType",
    time_bucket('1 day', timestamp) AS day,
    AVG(value) AS avg_value,
    MIN(value) AS min_value,
    MAX(value) AS max_value,
    COUNT(*) AS reading_count,
    STDDEV(value) AS std_deviation
FROM health_metrics
WHERE "validationStatus" = 'VALIDATED'
GROUP BY "userId", "metricType", day;

-- Weekly aggregates for trend analysis
CREATE MATERIALIZED VIEW IF NOT EXISTS health_metrics_weekly_avg
WITH (timescaledb.continuous) AS
SELECT
    "userId",
    "metricType",
    time_bucket('1 week', timestamp) AS week,
    AVG(value) AS avg_value,
    MIN(value) AS min_value,
    MAX(value) AS max_value,
    COUNT(*) AS reading_count,
    STDDEV(value) AS std_deviation
FROM health_metrics
WHERE "validationStatus" = 'VALIDATED'
GROUP BY "userId", "metricType", week;

-- Monthly aggregates for long-term analysis
CREATE MATERIALIZED VIEW IF NOT EXISTS health_metrics_monthly_avg
WITH (timescaledb.continuous) AS
SELECT
    "userId",
    "metricType",
    time_bucket('1 month', timestamp) AS month,
    AVG(value) AS avg_value,
    MIN(value) AS min_value,
    MAX(value) AS max_value,
    COUNT(*) AS reading_count,
    STDDEV(value) AS std_deviation
FROM health_metrics
WHERE "validationStatus" = 'VALIDATED'
GROUP BY "userId", "metricType", month;

-- Set up refresh policies for continuous aggregates
-- Refresh daily aggregates every hour
SELECT add_continuous_aggregate_policy('health_metrics_daily_avg',
    start_offset => INTERVAL '3 days',
    end_offset => INTERVAL '1 hour',
    schedule_interval => INTERVAL '1 hour',
    if_not_exists => TRUE
);

-- Refresh weekly aggregates every 6 hours
SELECT add_continuous_aggregate_policy('health_metrics_weekly_avg',
    start_offset => INTERVAL '3 weeks',
    end_offset => INTERVAL '6 hours',
    schedule_interval => INTERVAL '6 hours',
    if_not_exists => TRUE
);

-- Refresh monthly aggregates daily
SELECT add_continuous_aggregate_policy('health_metrics_monthly_avg',
    start_offset => INTERVAL '3 months',
    end_offset => INTERVAL '1 day',
    schedule_interval => INTERVAL '1 day',
    if_not_exists => TRUE
);

-- Set up data retention policies
-- Keep raw health metrics for 2 years
SELECT add_retention_policy('health_metrics', INTERVAL '2 years', if_not_exists => TRUE);

-- Keep health insights for 1 year
SELECT add_retention_policy('health_insights', INTERVAL '1 year', if_not_exists => TRUE);

-- Create functions for common health data queries
-- Function to get latest metric value for a user and metric type
CREATE OR REPLACE FUNCTION get_latest_metric_value(
    p_user_id TEXT,
    p_metric_type TEXT
) RETURNS TABLE (
    value DOUBLE PRECISION,
    unit TEXT,
    metric_timestamp TIMESTAMP,
    source TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        hm.value,
        hm.unit,
        hm.timestamp,
        hm.source::TEXT
    FROM health_metrics hm
    WHERE hm."userId" = p_user_id
        AND hm."metricType"::TEXT = p_metric_type
        AND hm."validationStatus" = 'VALIDATED'
    ORDER BY hm.timestamp DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- Function to detect anomalies using statistical analysis
CREATE OR REPLACE FUNCTION detect_metric_anomalies(
    p_user_id TEXT,
    p_metric_type TEXT,
    p_days INTEGER DEFAULT 30,
    p_std_threshold DOUBLE PRECISION DEFAULT 2.0
) RETURNS TABLE (
    metric_timestamp TIMESTAMP,
    value DOUBLE PRECISION,
    z_score DOUBLE PRECISION,
    is_anomaly BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    WITH metric_stats AS (
        SELECT
            AVG(value) as mean_value,
            STDDEV(value) as std_value
        FROM health_metrics
        WHERE "userId" = p_user_id
            AND "metricType"::TEXT = p_metric_type
            AND "validationStatus" = 'VALIDATED'
            AND timestamp >= NOW() - INTERVAL '1 day' * p_days
    ),
    metric_data AS (
        SELECT
            hm.timestamp,
            hm.value,
            (hm.value - ms.mean_value) / NULLIF(ms.std_value, 0) as z_score
        FROM health_metrics hm
        CROSS JOIN metric_stats ms
        WHERE hm."userId" = p_user_id
            AND hm."metricType"::TEXT = p_metric_type
            AND hm."validationStatus" = 'VALIDATED'
            AND hm.timestamp >= NOW() - INTERVAL '1 day' * p_days
    )
    SELECT
        md.timestamp,
        md.value,
        md.z_score,
        ABS(md.z_score) > p_std_threshold as is_anomaly
    FROM metric_data md
    ORDER BY md.timestamp DESC;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate health trend
CREATE OR REPLACE FUNCTION calculate_metric_trend(
    p_user_id TEXT,
    p_metric_type TEXT,
    p_days INTEGER DEFAULT 30
) RETURNS TABLE (
    trend_direction TEXT,
    trend_strength DOUBLE PRECISION,
    correlation_coefficient DOUBLE PRECISION
) AS $$
BEGIN
    RETURN QUERY
    WITH trend_data AS (
        SELECT 
            EXTRACT(EPOCH FROM timestamp) as x,
            value as y
        FROM health_metrics
        WHERE "userId" = p_user_id
            AND "metricType"::TEXT = p_metric_type
            AND "validationStatus" = 'VALIDATED'
            AND timestamp >= NOW() - INTERVAL '1 day' * p_days
        ORDER BY timestamp
    ),
    trend_calc AS (
        SELECT 
            COUNT(*) as n,
            SUM(x) as sum_x,
            SUM(y) as sum_y,
            SUM(x * y) as sum_xy,
            SUM(x * x) as sum_x2,
            SUM(y * y) as sum_y2
        FROM trend_data
    )
    SELECT 
        CASE 
            WHEN tc.n < 2 THEN 'insufficient_data'
            WHEN (tc.n * tc.sum_xy - tc.sum_x * tc.sum_y) > 0 THEN 'increasing'
            WHEN (tc.n * tc.sum_xy - tc.sum_x * tc.sum_y) < 0 THEN 'decreasing'
            ELSE 'stable'
        END as trend_direction,
        CASE 
            WHEN tc.n < 2 THEN 0
            ELSE ABS(tc.n * tc.sum_xy - tc.sum_x * tc.sum_y) / 
                 SQRT((tc.n * tc.sum_x2 - tc.sum_x * tc.sum_x) * (tc.n * tc.sum_y2 - tc.sum_y * tc.sum_y))
        END as trend_strength,
        CASE 
            WHEN tc.n < 2 THEN 0
            ELSE (tc.n * tc.sum_xy - tc.sum_x * tc.sum_y) / 
                 SQRT((tc.n * tc.sum_x2 - tc.sum_x * tc.sum_x) * (tc.n * tc.sum_y2 - tc.sum_y * tc.sum_y))
        END as correlation_coefficient
    FROM trend_calc tc;
END;
$$ LANGUAGE plpgsql;

-- Grant necessary permissions
GRANT SELECT ON health_metrics_daily_avg TO carecircle_user;
GRANT SELECT ON health_metrics_weekly_avg TO carecircle_user;
GRANT SELECT ON health_metrics_monthly_avg TO carecircle_user;
GRANT EXECUTE ON FUNCTION get_latest_metric_value(TEXT, TEXT) TO carecircle_user;
GRANT EXECUTE ON FUNCTION detect_metric_anomalies(TEXT, TEXT, INTEGER, DOUBLE PRECISION) TO carecircle_user;
GRANT EXECUTE ON FUNCTION calculate_metric_trend(TEXT, TEXT, INTEGER) TO carecircle_user;

-- Create view for health dashboard queries
CREATE OR REPLACE VIEW health_dashboard_summary AS
SELECT
    hm."userId",
    hm."metricType",
    COUNT(*) as total_readings,
    AVG(hm.value) as avg_value,
    MIN(hm.value) as min_value,
    MAX(hm.value) as max_value,
    STDDEV(hm.value) as std_deviation,
    MAX(hm.timestamp) as last_reading,
    COUNT(CASE WHEN hm.timestamp >= NOW() - INTERVAL '7 days' THEN 1 END) as readings_last_7_days,
    COUNT(CASE WHEN hm.timestamp >= NOW() - INTERVAL '30 days' THEN 1 END) as readings_last_30_days
FROM health_metrics hm
WHERE hm."validationStatus" = 'VALIDATED'
GROUP BY hm."userId", hm."metricType";

GRANT SELECT ON health_dashboard_summary TO carecircle_user;

-- Add comments for documentation
COMMENT ON TABLE health_metrics IS 'Time-series health metrics data optimized with TimescaleDB hypertables';
COMMENT ON MATERIALIZED VIEW health_metrics_daily_avg IS 'Daily aggregated health metrics for trend analysis';
COMMENT ON MATERIALIZED VIEW health_metrics_weekly_avg IS 'Weekly aggregated health metrics for trend analysis';
COMMENT ON MATERIALIZED VIEW health_metrics_monthly_avg IS 'Monthly aggregated health metrics for long-term analysis';
COMMENT ON FUNCTION get_latest_metric_value(TEXT, TEXT) IS 'Get the most recent valid metric value for a user and metric type';
COMMENT ON FUNCTION detect_metric_anomalies(TEXT, TEXT, INTEGER, DOUBLE PRECISION) IS 'Detect statistical anomalies in health metrics using z-score analysis';
COMMENT ON FUNCTION calculate_metric_trend(TEXT, TEXT, INTEGER) IS 'Calculate trend direction and strength using linear regression';
COMMENT ON VIEW health_dashboard_summary IS 'Summary statistics for health dashboard display';
