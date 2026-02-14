# umwelt-terraform

Terraform infrastructure-as-code project for deploying the Umwelt application on DigitalOcean.

## Overview

This project provisions and manages the complete infrastructure for the Umwelt application, including compute resources, networking, storage, and DNS configuration on DigitalOcean.

## Architecture Components

| Component | Description |
|-----------|-------------|
| **VPC** | Virtual Private Cloud (10.0.0.0/16) in nyc3 region |
| **Load Balancer Droplet** | Routes traffic to main server (s-2vcpu-4gb) |
| **Main Server Droplet** | Primary application server (s-8vcpu-16gb) |
| **Database Droplet** | Database server (s-4vcpu-8gb) |
| **Monitoring Droplet** | Prometheus/metrics collection (s-1vcpu-2gb) |
| **SIT Droplet** | System Integration Testing environment (s-2vcpu-4gb) |
| **Backup Storage** | DigitalOcean Spaces for backups (100GB) |
| **Backend Storage** | Spaces bucket for application state |
| **Firewall** | Network security rules for all droplets |
| **DNS** | Domain configuration for umwelt.com |

## Project Structure

```
umwelt-terraform/
├── environments/
│   └── variables.yaml      # Environment-specific configuration
├── modules/                 # Reusable Terraform modules
│   ├── backend/
│   ├── backup-storage/
│   ├── DNS/
│   ├── droplet-database/
│   ├── droplet-loadbalancer/
│   ├── droplet-mainserver/
│   ├── droplet-monitoring/
│   ├── droplet-sit/
│   ├── firewall/
│   └── vpc/
├── resources/               # Resource instantiations using modules
│   ├── backend/
│   ├── backup-storage/
│   ├── DNS/
│   ├── droplet-database/
│   ├── droplet-loadbalancer/
│   ├── droplet-mainserver/
│   ├── droplet-monitoring/
│   ├── droplet-sit/
│   ├── firewall/
│   └── vpc/
├── Scripts/
│   └── runner.sh           # GitHub Actions self-hosted runner setup
└── README.md
```

## Prerequisites

- Terraform >= 1.0
- DigitalOcean account and API token
- SSH key pair registered with DigitalOcean

## Configuration

Update `environments/variables.yaml` with your values:

1. Replace all `TBA` placeholders with actual values:
   - `do_token`: Your DigitalOcean API token
   - `ssh_keys`: Your SSH key fingerprint
   - `private_key_path`: Path to your SSH private key
   - `access_key` / `secret_key`: Spaces credentials

2. Update `vpc_id` references after VPC creation

## Usage

Navigate to each resource directory and run:

```bash
cd resources/<resource-name>
terraform init
terraform plan
terraform apply
```

**Recommended deployment order:**
1. vpc
2. backend (for state storage)
3. firewall
4. droplet-database
5. droplet-mainserver
6. droplet-monitoring
7. droplet-sit
8. droplet-loadbalancer
9. backup-storage
10. DNS

## Network Configuration

- **VPC CIDR**: 10.0.0.0/16
- **Region**: nyc3
- **Private IPs**:
  - Main Server: 10.0.0.5
  - Database: 10.0.0.6
  - Load Balancer: 10.0.0.10

## Firewall Rules

- HTTP (80) and HTTPS (443): Open to all
- SSH (22): Open to all (restrict in production)
- Database ports (3306, 5432, 6379): Internal only (mainserver, monitoring)
- Application ports (3000, 9000, 9090, 9100): Internal only

## Scripts

### runner.sh
Sets up multiple GitHub Actions self-hosted runners for CI/CD pipelines. Configure the variables at the top of the script before running.