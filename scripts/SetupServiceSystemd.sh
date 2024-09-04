# Variables for customization
SERVICE_NAME="sms_dal"              # The name of your service
EXECUTABLE_PATH="/home/azureadmin/bin/sms_dal"  # Path to your executable
WORKING_DIR="/home/azureadmin/bin"   # Working directory for the service
USER="azureadmin"                        # User to run the service

# Step 1: Create systemd service file
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

echo "Creating systemd service file at ${SERVICE_FILE}..."

sudo tee ${SERVICE_FILE} > /dev/null <<EOL
[Unit]
Description=${SERVICE_NAME^} Service
After=network.target

[Service]
ExecStart=${EXECUTABLE_PATH}
Restart=always
User=${USER}
WorkingDirectory=${WORKING_DIR}
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=${SERVICE_NAME}
PIDFile=/var/run/${SERVICE_NAME}.pid

[Install]
WantedBy=multi-user.target
EOL

echo "Service file created."

# Step 2: Reload systemd daemon
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Step 3: Enable the service to start on boot
echo "Enabling ${SERVICE_NAME} service to start on boot..."
sudo systemctl enable ${SERVICE_NAME}

# Step 4: Start the service
echo "Starting ${SERVICE_NAME} service..."
sudo systemctl start ${SERVICE_NAME}

# Step 5: Check the status of the service
echo "Checking service status..."
sudo systemctl status ${SERVICE_NAME} --no-pager

echo "${SERVICE_NAME} service setup is complete."
