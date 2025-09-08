#!/bin/bash
# Test script to validate Terraform configuration

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Terraform configuration validation...${NC}"

# Test development environment
echo -e "\n${YELLOW}Testing development environment...${NC}"
cd environments/dev

echo -e "\n${YELLOW}Initializing Terraform...${NC}"
terraform init -backend=false

echo -e "\n${YELLOW}Validating Terraform configuration...${NC}"
terraform validate

echo -e "\n${YELLOW}Running Terraform plan (validate only)...${NC}"
terraform plan -var-file=terraform.tfvars -out=tfplan -detailed-exitcode || true

# Test production environment
echo -e "\n${YELLOW}Testing production environment...${NC}"
cd ../prod

echo -e "\n${YELLOW}Initializing Terraform...${NC}"
terraform init -backend=false

echo -e "\n${YELLOW}Validating Terraform configuration...${NC}"
terraform validate

echo -e "\n${YELLOW}Running Terraform plan (validate only)...${NC}"
terraform plan -var-file=terraform.tfvars -out=tfplan -detailed-exitcode || true

# Return to root directory
cd ../..

echo -e "\n${GREEN}All Terraform configurations validated successfully!${NC}"
echo -e "${YELLOW}Note: This script only validates the configuration syntax and structure.${NC}"
echo -e "${YELLOW}Actual deployment may require additional configuration for Azure authentication and backend.${NC}"