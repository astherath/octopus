# Log function for cleaner output
log() {
    echo "[INFO] $1"
}

error() {
    echo "[ERROR] $1"
    exit 1
}

# Step 1: Wait for 30 seconds
log "Waiting for 30 seconds..."
sleep 30

# Step 2: Check the health of the systemctl sms_dal service
log "Checking the health of the sms_dal service..."

SERVICE_STATUS=$(systemctl is-active sms_dal)

if [ "$SERVICE_STATUS" != "active" ]; then
    error "sms_dal service is not running. Status: $SERVICE_STATUS"
else
    log "sms_dal service is running. Status: $SERVICE_STATUS"
fi

# Step 3: Wait for another 30 seconds before checking the health of the endpoint
log "Waiting for another 30 seconds before checking the endpoint health..."
sleep 30

# Step 4: Check the health of the 0.0.0.0:5050 endpoint
log "Checking the health of the endpoint at 0.0.0.0:5050..."

HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://0.0.0.0:5050/)

if [ "$HTTP_RESPONSE" != "200" ]; then
    error "Health check failed! Received HTTP status: $HTTP_RESPONSE"
else
    log "Health check passed. Received HTTP 200 from the endpoint."
fi

# Step 5: Success
log "Both systemctl and endpoint checks passed successfully."
exit 0
