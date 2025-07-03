#!/bin/bash
set -e

# Create additional databases if needed
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Create development database (already exists as POSTGRES_DB)
    -- CREATE DATABASE carecircle_dev;
    
    -- Create test database
    CREATE DATABASE carecircle_test;
    
    -- Create admin portal database
    CREATE DATABASE carecircle_admin_dev;
    
    -- Grant privileges
    GRANT ALL PRIVILEGES ON DATABASE carecircle_dev TO postgres;
    GRANT ALL PRIVILEGES ON DATABASE carecircle_test TO postgres;
    GRANT ALL PRIVILEGES ON DATABASE carecircle_admin_dev TO postgres;
    
    -- Create extensions
    \c carecircle_dev;
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    CREATE EXTENSION IF NOT EXISTS "pgcrypto";
    
    \c carecircle_test;
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    CREATE EXTENSION IF NOT EXISTS "pgcrypto";
    
    \c carecircle_admin_dev;
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    CREATE EXTENSION IF NOT EXISTS "pgcrypto";
EOSQL

echo "Additional databases and extensions created successfully!"
