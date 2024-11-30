#!/bin/bash
set -e

echo "Fetching secrets from AWS Parameter Store..."
DB_URL=$(aws ssm get-parameter --name "/digistab_store/prod/database_url" --with-decryption --query Parameter.Value --output text)
KEY_BASE=$(aws ssm get-parameter --name "/digistab_store/prod/secret_key_base" --with-decryption --query Parameter.Value --output text)

echo "Creating systemd service file..."
sudo tee /etc/systemd/system/digistab_store.service > /dev/null << EOL
[Unit]
Description=Digistab Store Phoenix Application
After=network.target postgresql.service

[Service]
Type=forking
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

ExecStart=/opt/digistab_store/_build/prod/rel/digistab_store/bin/digistab_store daemon
ExecStop=/opt/digistab_store/_build/prod/rel/digistab_store/bin/digistab_store stop
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOL

echo "Setting proper permissions for service file..."
sudo chmod 644 /etc/systemd/system/digistab_store.service

echo "Downloading RDS certificate if needed..."
if [ ! -f "/etc/ssl/certs/rds-ca-global.pem" ]; then
    sudo curl -o /etc/ssl/certs/rds-ca-global.pem https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem
    sudo chmod 644 /etc/ssl/certs/rds-ca-global.pem
fi

echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Running database migrations..."
# Run migrations with environment variables scoped only to this command
DATABASE_URL="${DB_URL}" SECRET_KEY_BASE="${KEY_BASE}" /opt/digistab_store/_build/prod/rel/digistab_store/bin/digistab_store eval "DigistabStore.Release.migrate"

echo "Enabling and starting digistab_store service..."
sudo systemctl enable digistab_store
sudo systemctl restart digistab_store

echo "Waiting for service to start..."
sleep 5

echo "Checking service status..."
sudo systemctl status digistab_store