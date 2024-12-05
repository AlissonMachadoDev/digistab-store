#!/bin/bash
set -e
source /opt/digistab_store/scripts/check_db.sh

echo "Fetching secrets from AWS Parameter Store..."
DB_URL=$(aws ssm get-parameter --name "/digistab_store/prod/database_url" --with-decryption --query Parameter.Value --output text)
KEY_BASE=$(aws ssm get-parameter --name "/digistab_store/prod/secret_key_base" --with-decryption --query Parameter.Value --output text)
AWS_BUCKET_NAME=$(aws ssm get-parameter --name "/digistab_store/prod/aws_bucket_name" --with-decryption --query Parameter.Value --output text)
AWS_REGION=$(aws ssm get-parameter --name "/digistab_store/prod/aws_region" --with-decryption --query Parameter.Value --output text)
AWS_ACCESS_KEY_ID=$(aws ssm get-parameter --name "/digistab_store/prod/aws_access_key_id" --with-decryption --query Parameter.Value --output text)
AWS_SECRET_ACCESS_KEY=$(aws ssm get-parameter --name "/digistab_store/prod/aws_secret_access_key" --with-decryption --query Parameter.Value --output text)


echo "Setting up directory permissions..."
sudo mkdir -p /opt/digistab_store/_build/prod/rel/digistab_store/tmp
sudo chown -R ubuntu:ubuntu /opt/digistab_store/_build/prod/rel/digistab_store/tmp
sudo chmod -R 755 /opt/digistab_store/_build/prod/rel/digistab_store/tmp

echo "Creating systemd service file..."
sudo tee /etc/systemd/system/digistab_store.service > /dev/null << EOL
[Unit]
Description=Digistab Store Phoenix Application
After=network.target postgresql.service

[Service]
Type=simple
User=ubuntu
Group=ubuntu
WorkingDirectory=/opt/digistab_store

# Application environment variables
Environment=PORT=4010
Environment=MIX_ENV=prod
Environment=PHX_HOST=digistab-store.alissonmachado.dev
Environment=PHX_SERVER=true
Environment=POOL_SIZE=10
Environment=RELEASE_NAME=digistab_store
Environment=DATABASE_URL=${DB_URL}
Environment=SECRET_KEY_BASE=${KEY_BASE}
Environment=AWS_BUCKET_NAME=${AWS_BUCKET_NAME}
Environment=AWS_REGION=${AWS_REGION}
Environment=AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
Environment=AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}

ExecStart=/opt/digistab_store/_build/prod/rel/digistab_store/bin/digistab_store start
ExecStop=/opt/digistab_store/_build/prod/rel/digistab_store/bin/digistab_store stop
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOL

echo "Setting proper permissions..."
sudo chmod 644 /etc/systemd/system/digistab_store.service

echo "Downloading RDS certificate if needed..."
if [ ! -f "/etc/ssl/certs/rds-ca-global.pem" ]; then
    sudo curl -o /etc/ssl/certs/rds-ca-global.pem https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem
    sudo chmod 644 /etc/ssl/certs/rds-ca-global.pem
fi

echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Give some time for RDS to be fully available
echo "Waiting for RDS to be ready..."
sleep 4

if ! check_database_connection "$DB_URL"; then
    echo "Cannot proceed with deployment - database is not accessible"
    exit 1
fi

echo "Creating database if needed and running migrations..."
DATABASE_URL="${DB_URL}" SECRET_KEY_BASE="${KEY_BASE}" /opt/digistab_store/_build/prod/rel/digistab_store/bin/digistab_store eval "DigistabStore.Release.migrate"

echo "Enabling and starting digistab_store service..."
sudo systemctl enable digistab_store
sudo systemctl restart digistab_store

echo "Waiting for service to start..."
sleep 5

echo "Checking service status..."
sudo systemctl status digistab_store