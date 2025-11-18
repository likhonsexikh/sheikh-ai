# Sheikh AI Deployment Guide

This guide covers various deployment options for Sheikh AI.

## Table of Contents
- [GitHub Packages Setup](#github-packages-setup)
- [Creating Releases](#creating-releases)
- [Deployment Options](#deployment-options)
- [Environment Configuration](#environment-configuration)

## GitHub Packages Setup

### 1. Enable GitHub Container Registry

GitHub Container Registry (GHCR) is automatically enabled for your repository. The workflow will push Docker images to:
- `ghcr.io/likhonsexikh/sheikh-ai-frontend`
- `ghcr.io/likhonsexikh/sheikh-ai-backend`
- `ghcr.io/likhonsexikh/sheikh-ai-sandbox`

### 2. Trigger Package Build

Images are automatically built when you:
- Push to `main` branch
- Create a new tag (e.g., `v1.0.0`)
- Manually trigger the workflow

### 3. Use Published Packages

Update your `docker-compose.yml` to use GHCR images:

```yaml
services:
  frontend:
    image: ghcr.io/likhonsexikh/sheikh-ai-frontend:latest
  backend:
    image: ghcr.io/likhonsexikh/sheikh-ai-backend:latest
  sandbox:
    image: ghcr.io/likhonsexikh/sheikh-ai-sandbox:latest
```

## Creating Releases

### Method 1: Using Git Tags (Recommended)

```bash
# Create and push a version tag
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

This will automatically:
- Build and push Docker images with version tags
- Create a GitHub release
- Generate release notes

### Method 2: Using GitHub Web Interface

1. Go to your repository: https://github.com/likhonsexikh/sheikh-ai
2. Click "Releases" on the right sidebar
3. Click "Create a new release"
4. Fill in:
   - **Tag**: `v1.0.0` (create new tag)
   - **Title**: `Sheikh AI v1.0.0`
   - **Description**: Use template from `.github/RELEASE_TEMPLATE.md`
5. Click "Publish release"

### Method 3: Using GitHub CLI

```bash
# Install GitHub CLI (gh)
gh release create v1.0.0 \
  --title "Sheikh AI v1.0.0" \
  --notes-file CHANGELOG.md
```

## Deployment Options

### Option 1: Docker Compose (Simplest)

**Local/Single Server Deployment**

```bash
# Clone repository
git clone https://github.com/likhonsexikh/sheikh-ai.git
cd sheikh-ai

# Configure environment
cp .env.example .env
nano .env  # Edit configuration

# Start services
docker-compose up -d

# Check status
docker-compose ps
```

**Access**:
- Frontend: http://localhost
- Backend API: http://localhost/api
- API Docs: http://localhost/docs

### Option 2: Kubernetes

**For Production Scale**

```bash
# Create namespace
kubectl create namespace sheikh-ai

# Create secrets
kubectl create secret generic sheikh-ai-secrets \
  --from-env-file=.env \
  -n sheikh-ai

# Apply manifests (create these based on docker-compose)
kubectl apply -f k8s/

# Check deployment
kubectl get pods -n sheikh-ai
```

### Option 3: Cloud Platforms

#### **AWS ECS/Fargate**
```bash
# Use Docker images from GHCR
# Configure ECS task definitions
# Set up load balancer
# Configure RDS for MongoDB (or use MongoDB Atlas)
```

#### **Google Cloud Run**
```bash
# Deploy each component
gcloud run deploy sheikh-ai-frontend \
  --image ghcr.io/likhonsexikh/sheikh-ai-frontend:latest \
  --platform managed

gcloud run deploy sheikh-ai-backend \
  --image ghcr.io/likhonsexikh/sheikh-ai-backend:latest \
  --platform managed
```

#### **Azure Container Instances**
```bash
az container create \
  --resource-group sheikh-ai \
  --name sheikh-ai-backend \
  --image ghcr.io/likhonsexikh/sheikh-ai-backend:latest
```

#### **DigitalOcean App Platform**
1. Connect your GitHub repository
2. Select docker-compose.yml
3. Configure environment variables
4. Deploy

### Option 4: VPS Deployment

**For Ubuntu/Debian servers**

```bash
# SSH to your server
ssh user@your-server.com

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Clone and deploy
git clone https://github.com/likhonsexikh/sheikh-ai.git
cd sheikh-ai
cp .env.example .env
nano .env  # Configure

# Start with docker-compose
docker-compose up -d

# Set up Nginx reverse proxy (optional)
sudo apt install nginx
# Configure Nginx to proxy to localhost:3000 and :8000
```

## Environment Configuration

### Required Environment Variables

```env
# API Configuration
LLM_API_KEY=your_api_key_here
LLM_BASE_URL=https://api.provider.com

# MongoDB
MONGODB_HOST=mongodb
MONGODB_PORT=27017
MONGODB_DATABASE=sheikh_ai
MONGODB_USERNAME=admin
MONGODB_PASSWORD=secure_password

# Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=secure_password

# Security
SECRET_KEY=generate_random_key_here
JWT_SECRET=generate_random_jwt_secret

# Frontend
VITE_API_BASE_URL=https://your-domain.com/api
```

### Generate Secure Keys

```bash
# Generate SECRET_KEY
openssl rand -hex 32

# Generate JWT_SECRET
openssl rand -base64 32
```

## Monitoring and Maintenance

### Health Checks

```bash
# Check frontend health
curl http://localhost/health

# Check backend health
curl http://localhost/api/health

# View logs
docker-compose logs -f backend
docker-compose logs -f frontend
```

### Backup MongoDB

```bash
# Backup
docker-compose exec mongodb mongodump \
  --out /backup/$(date +%Y%m%d)

# Restore
docker-compose exec mongodb mongorestore \
  /backup/20250119
```

### Update to Latest Version

```bash
# Pull latest images
docker-compose pull

# Restart services
docker-compose up -d

# Remove old images
docker image prune -f
```

## Troubleshooting

### Common Issues

1. **Port conflicts**: Change ports in docker-compose.yml
2. **MongoDB connection**: Check MONGODB_HOST and credentials
3. **CORS errors**: Verify VITE_API_BASE_URL
4. **Memory issues**: Increase Docker memory limits

### Logs

```bash
# View all logs
docker-compose logs

# Follow specific service
docker-compose logs -f backend

# Last 100 lines
docker-compose logs --tail=100
```

## Security Checklist

- [ ] Change all default passwords
- [ ] Generate unique SECRET_KEY and JWT_SECRET
- [ ] Enable HTTPS (use Let's Encrypt)
- [ ] Configure firewall (UFW/iptables)
- [ ] Set up regular backups
- [ ] Enable MongoDB authentication
- [ ] Use strong Redis password
- [ ] Keep Docker images updated
- [ ] Monitor logs for suspicious activity
- [ ] Use environment variables (never commit secrets)

## Support

- **Documentation**: https://docs.sheikhAI.com
- **Issues**: https://github.com/likhonsexikh/sheikh-ai/issues
- **Discussions**: https://github.com/likhonsexikh/sheikh-ai/discussions

---

For more details, see [README.md](README.md) and [QUICK_START.md](QUICK_START.md).
