#!/bin/bash
# Load Balancer Docker Setup with SSL

apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install certbot for SSL
apt-get install -y certbot python3-certbot-nginx

# Create nginx directory
mkdir -p /opt/loadbalancer/{config,ssl,logs,letsencrypt}

# Nginx configuration with SSL
cat > /opt/loadbalancer/config/nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    upstream backend {
        server ${main_server_private_ip}:4000;
    }

    # HTTP server for Let's Encrypt challenge and redirect to HTTPS
    server {
        listen 80;
        server_name ${domain_name} www.${domain_name} api.${domain_name};
        
        # Let's Encrypt challenge location
        location /.well-known/acme-challenge/ {
            root /var/www/certbot;
        }
        
        # Redirect all other traffic to HTTPS
        location / {
            return 301 https://$host$request_uri;
        }
    }

    # HTTPS server
    server {
        listen 443 ssl;
        server_name ${domain_name} www.${domain_name} api.${domain_name};

        ssl_certificate /etc/nginx/ssl/live/${domain_name}/fullchain.pem;
        ssl_certificate_key /etc/nginx/ssl/live/${domain_name}/privkey.pem;
        
        # SSL configuration
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384;
        ssl_prefer_server_ciphers off;

        location / {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
EOF

# Create directory for Let's Encrypt challenges
mkdir -p /var/www/certbot

# Docker Compose for Load Balancer
cat > /opt/loadbalancer/docker-compose.yml << 'EOF'
version: '3.8'
services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./config/nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
      - ./logs:/var/log/nginx
      - /var/www/certbot:/var/www/certbot
    networks:
      - lbnet
    restart: unless-stopped

networks:
  lbnet:
    driver: bridge
EOF

# Start Docker services
systemctl enable docker
systemctl start docker

# Start nginx temporarily for SSL certificate
cd /opt/loadbalancer && docker-compose up -d

# Wait for nginx to start and DNS to propagate
sleep 30

# Obtain SSL certificate from Let's Encrypt
certbot certonly --webroot -w /var/www/certbot -d ${domain_name} -d www.${domain_name} -d api.${domain_name} --email admin@${domain_name} --agree-tos --non-interactive

# Create SSL certificate directory structure
mkdir -p /opt/loadbalancer/ssl/live/${domain_name}
ln -sf /etc/letsencrypt/live/${domain_name}/fullchain.pem /opt/loadbalancer/ssl/live/${domain_name}/
ln -sf /etc/letsencrypt/live/${domain_name}/privkey.pem /opt/loadbalancer/ssl/live/${domain_name}/

# Restart nginx with SSL configuration
cd /opt/loadbalancer && docker-compose restart

# Set up automatic certificate renewal
echo "0 12 * * * /usr/bin/certbot renew --quiet && cd /opt/loadbalancer && docker-compose restart nginx" | crontab -