-- Enable TimescaleDB extension
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- Create additional extensions for healthcare data
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create schemas for different bounded contexts
CREATE SCHEMA IF NOT EXISTS identity_access;
CREATE SCHEMA IF NOT EXISTS care_group;
CREATE SCHEMA IF NOT EXISTS health_data;
CREATE SCHEMA IF NOT EXISTS medication;
CREATE SCHEMA IF NOT EXISTS notification;
CREATE SCHEMA IF NOT EXISTS ai_assistant;
