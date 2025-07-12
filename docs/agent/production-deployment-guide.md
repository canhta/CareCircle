# CareCircle AI Agent Production Deployment Guide

## Overview

This guide provides comprehensive instructions for deploying CareCircle's multi-agent AI system to production environments with Kubernetes orchestration, HIPAA compliance, and enterprise-grade monitoring.

## Prerequisites

- Kubernetes cluster (v1.28+) with RBAC enabled
- Helm 3.12+ for package management
- Docker registry access (private registry recommended)
- SSL certificates for HTTPS endpoints
- Healthcare compliance certifications

## 1. Kubernetes Cluster Setup

### 1.1 Namespace and RBAC Configuration

**k8s/namespace.yaml**
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: carecircle-ai
  labels:
    name: carecircle-ai
    compliance: hipaa
    environment: production
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: carecircle-ai-service-account
  namespace: carecircle-ai
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: carecircle-ai
  name: carecircle-ai-role
rules:
- apiGroups: [""]
  resources: ["pods", "services", "configmaps", "secrets"]
  verbs: ["get", "list", "watch", "create", "update", "patch"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets"]
  verbs: ["get", "list", "watch", "create", "update", "patch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: carecircle-ai-role-binding
  namespace: carecircle-ai
subjects:
- kind: ServiceAccount
  name: carecircle-ai-service-account
  namespace: carecircle-ai
roleRef:
  kind: Role
  name: carecircle-ai-role
  apiGroup: rbac.authorization.k8s.io
```

### 1.2 Secrets Management

**k8s/secrets.yaml**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: carecircle-ai-secrets
  namespace: carecircle-ai
type: Opaque
data:
  openai-api-key: <base64-encoded-key>
  langchain-api-key: <base64-encoded-key>
  redis-password: <base64-encoded-password>
  database-url: <base64-encoded-url>
  phi-encryption-key: <base64-encoded-key>
  jwt-secret: <base64-encoded-secret>
---
apiVersion: v1
kind: Secret
metadata:
  name: carecircle-tls-secret
  namespace: carecircle-ai
type: kubernetes.io/tls
data:
  tls.crt: <base64-encoded-certificate>
  tls.key: <base64-encoded-private-key>
```

## 2. Application Deployments

### 2.1 Agent Orchestrator Deployment

**k8s/agent-orchestrator-deployment.yaml**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: agent-orchestrator
  namespace: carecircle-ai
  labels:
    app: agent-orchestrator
    tier: backend
    compliance: hipaa
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: agent-orchestrator
  template:
    metadata:
      labels:
        app: agent-orchestrator
        tier: backend
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "9090"
        prometheus.io/path: "/metrics"
    spec:
      serviceAccountName: carecircle-ai-service-account
      securityContext:
        runAsNonRoot: true
        runAsUser: 1001
        fsGroup: 1001
      containers:
      - name: agent-orchestrator
        image: carecircle/agent-orchestrator:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 3001
          name: http
        - containerPort: 9090
          name: metrics
        env:
        - name: NODE_ENV
          value: "production"
        - name: PORT
          value: "3001"
        - name: OPENAI_API_KEY
          valueFrom:
            secretKeyRef:
              name: carecircle-ai-secrets
              key: openai-api-key
        - name: LANGCHAIN_API_KEY
          valueFrom:
            secretKeyRef:
              name: carecircle-ai-secrets
              key: langchain-api-key
        - name: REDIS_URL
          value: "redis://redis-service:6379"
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: carecircle-ai-secrets
              key: database-url
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1000m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3001
          initialDelaySeconds: 60
          periodSeconds: 30
          timeoutSeconds: 10
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /ready
            port: 3001
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
        securityContext:
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true
          capabilities:
            drop:
            - ALL
        volumeMounts:
        - name: tmp-volume
          mountPath: /tmp
        - name: cache-volume
          mountPath: /app/cache
      volumes:
      - name: tmp-volume
        emptyDir: {}
      - name: cache-volume
        emptyDir: {}
      nodeSelector:
        kubernetes.io/arch: amd64
      tolerations:
      - key: "healthcare-workload"
        operator: "Equal"
        value: "true"
        effect: "NoSchedule"
---
apiVersion: v1
kind: Service
metadata:
  name: agent-orchestrator-service
  namespace: carecircle-ai
  labels:
    app: agent-orchestrator
spec:
  selector:
    app: agent-orchestrator
  ports:
  - name: http
    port: 80
    targetPort: 3001
    protocol: TCP
  - name: metrics
    port: 9090
    targetPort: 9090
    protocol: TCP
  type: ClusterIP
```

### 2.2 Healthcare Agents Deployment

**k8s/healthcare-agents-deployment.yaml**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: healthcare-agents
  namespace: carecircle-ai
  labels:
    app: healthcare-agents
    tier: backend
    compliance: hipaa
spec:
  replicas: 2
  selector:
    matchLabels:
      app: healthcare-agents
  template:
    metadata:
      labels:
        app: healthcare-agents
        tier: backend
    spec:
      serviceAccountName: carecircle-ai-service-account
      securityContext:
        runAsNonRoot: true
        runAsUser: 1001
        fsGroup: 1001
      containers:
      - name: healthcare-agents
        image: carecircle/healthcare-agents:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 3002
          name: http
        env:
        - name: NODE_ENV
          value: "production"
        - name: OPENAI_API_KEY
          valueFrom:
            secretKeyRef:
              name: carecircle-ai-secrets
              key: openai-api-key
        - name: REDIS_URL
          value: "redis://redis-service:6379"
        - name: PHI_ENCRYPTION_KEY
          valueFrom:
            secretKeyRef:
              name: carecircle-ai-secrets
              key: phi-encryption-key
        resources:
          requests:
            memory: "1.5Gi"
            cpu: "750m"
          limits:
            memory: "3Gi"
            cpu: "1500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3002
          initialDelaySeconds: 60
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /ready
            port: 3002
          initialDelaySeconds: 30
          periodSeconds: 10
        securityContext:
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true
          capabilities:
            drop:
            - ALL
        volumeMounts:
        - name: phi-secrets
          mountPath: /app/secrets
          readOnly: true
      volumes:
      - name: phi-secrets
        secret:
          secretName: carecircle-ai-secrets
          defaultMode: 0400
---
apiVersion: v1
kind: Service
metadata:
  name: healthcare-agents-service
  namespace: carecircle-ai
spec:
  selector:
    app: healthcare-agents
  ports:
  - port: 80
    targetPort: 3002
  type: ClusterIP
```

### 2.3 Redis Deployment

**k8s/redis-deployment.yaml**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
  namespace: carecircle-ai
  labels:
    app: redis
    tier: cache
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
        tier: cache
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 999
        fsGroup: 999
      containers:
      - name: redis
        image: redis:7-alpine
        command:
        - redis-server
        - --appendonly
        - "yes"
        - --requirepass
        - $(REDIS_PASSWORD)
        ports:
        - containerPort: 6379
          name: redis
        env:
        - name: REDIS_PASSWORD
          valueFrom:
            secretKeyRef:
              name: carecircle-ai-secrets
              key: redis-password
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          exec:
            command:
            - redis-cli
            - ping
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          exec:
            command:
            - redis-cli
            - ping
          initialDelaySeconds: 5
          periodSeconds: 5
        volumeMounts:
        - name: redis-data
          mountPath: /data
      volumes:
      - name: redis-data
        persistentVolumeClaim:
          claimName: redis-pvc
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: redis-pvc
  namespace: carecircle-ai
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: fast-ssd
---
apiVersion: v1
kind: Service
metadata:
  name: redis-service
  namespace: carecircle-ai
spec:
  selector:
    app: redis
  ports:
  - port: 6379
    targetPort: 6379
  type: ClusterIP
```

## 3. Ingress and Load Balancing

### 3.1 Ingress Configuration

**k8s/ingress.yaml**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: carecircle-ai-ingress
  namespace: carecircle-ai
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/rate-limit: "100"
    nginx.ingress.kubernetes.io/rate-limit-window: "1m"
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-origin: "https://carecircle.app"
    nginx.ingress.kubernetes.io/proxy-body-size: "10m"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "300"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "300"
spec:
  tls:
  - hosts:
    - ai-api.carecircle.app
    secretName: carecircle-tls-secret
  rules:
  - host: ai-api.carecircle.app
    http:
      paths:
      - path: /orchestrator
        pathType: Prefix
        backend:
          service:
            name: agent-orchestrator-service
            port:
              number: 80
      - path: /agents
        pathType: Prefix
        backend:
          service:
            name: healthcare-agents-service
            port:
              number: 80
```

## 4. Monitoring and Observability

### 4.1 Prometheus Configuration

**k8s/monitoring.yaml**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: carecircle-ai
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
      evaluation_interval: 15s
    
    rule_files:
      - "healthcare_alerts.yml"
    
    scrape_configs:
    - job_name: 'carecircle-ai-agents'
      kubernetes_sd_configs:
      - role: pod
        namespaces:
          names:
          - carecircle-ai
      relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)
      - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
        action: replace
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
        target_label: __address__
    
    alerting:
      alertmanagers:
      - static_configs:
        - targets:
          - alertmanager:9093
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: healthcare-alerts
  namespace: carecircle-ai
data:
  healthcare_alerts.yml: |
    groups:
    - name: healthcare_ai_alerts
      rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.1
        for: 5m
        labels:
          severity: critical
          compliance: hipaa
        annotations:
          summary: "High error rate detected in AI agents"
          description: "Error rate is {{ $value }} for {{ $labels.instance }}"
      
      - alert: PHIExposureRisk
        expr: phi_detection_count > 10
        for: 1m
        labels:
          severity: critical
          compliance: hipaa
        annotations:
          summary: "Potential PHI exposure detected"
          description: "High PHI detection count: {{ $value }}"
      
      - alert: EmergencyResponseDelay
        expr: emergency_response_time > 30
        for: 0s
        labels:
          severity: critical
          compliance: patient_safety
        annotations:
          summary: "Emergency response time exceeded"
          description: "Emergency response took {{ $value }} seconds"
```

## 5. Deployment Commands

### 5.1 Initial Deployment
```bash
# 1. Create namespace and RBAC
kubectl apply -f k8s/namespace.yaml

# 2. Create secrets (update with actual values)
kubectl apply -f k8s/secrets.yaml

# 3. Deploy Redis
kubectl apply -f k8s/redis-deployment.yaml

# 4. Deploy AI agents
kubectl apply -f k8s/agent-orchestrator-deployment.yaml
kubectl apply -f k8s/healthcare-agents-deployment.yaml

# 5. Configure ingress
kubectl apply -f k8s/ingress.yaml

# 6. Set up monitoring
kubectl apply -f k8s/monitoring.yaml

# 7. Verify deployment
kubectl get pods -n carecircle-ai
kubectl get services -n carecircle-ai
kubectl get ingress -n carecircle-ai
```

### 5.2 Health Checks
```bash
# Check pod status
kubectl get pods -n carecircle-ai -w

# Check logs
kubectl logs -f deployment/agent-orchestrator -n carecircle-ai

# Test endpoints
curl -k https://ai-api.carecircle.app/orchestrator/health
curl -k https://ai-api.carecircle.app/agents/health

# Monitor metrics
kubectl port-forward svc/agent-orchestrator-service 9090:9090 -n carecircle-ai
```

This production deployment guide ensures CareCircle's AI agent system is deployed with enterprise-grade reliability, security, and compliance monitoring.
