# Log function for cleaner output
log() {
    echo "[INFO] $1"
}

error() {
    echo "[ERROR] $1"
    exit 1
}

ServiceName="sms_dal"

# stop service
log "Stopping the service..."
sudo systemctl stop "${ServiceName}"
if [ $? -eq 0 ]; then
    log "Service stopped successfully."
else
    error "Failed to stop the service!"
fi

# Assign the extracted path to a variable (assuming $OctopusParameters is an environment variable or a command output)
log "Fetching the extracted path from Octopus variables..."
ExePath=$(get_octopusvariable "Octopus.Action.Package[sms_dal].ExtractedPath")
if [ -z "$ExePath" ]; then
    error "Failed to retrieve the extracted path!"
else
    log "Extracted path retrieved: $ExePath"
fi

# Set the executable name
ExeName="sms_dal"
log "Executable name set to: $ExeName"

# Append '-linux' to the path
LinuxExePath="${ExePath}/${ExeName}"
log "Full path to the executable: $LinuxExePath"

# Set output path
OutPath="/home/azureadmin/bin"
log "Output directory set to: $OutPath"

# Create output directory if it doesn't exist
log "Creating output directory if it doesn't exist..."
mkdir -p "${OutPath}"
if [ $? -eq 0 ]; then
    log "Output directory created successfully (or already exists)."
else
    error "Failed to create output directory!"
fi

# clear output directory
log "Clearing output directory... at $OutPath"
rm -rf "${OutPath:?}"/*
if [ $? -eq 0 ]; then
    log "Output directory cleared successfully."
else
    error "Failed to clear output directory!"
fi

# Change directory to the output path
log "Changing directory to output path: $OutPath"
cd "${OutPath}" || error "Failed to change directory to $OutPath!"

# Copy the executable to the output directory
log "Copying the executable to the output directory..."
cp "${LinuxExePath}" .
if [ $? -eq 0 ]; then
    log "Executable copied successfully."
else
    error "Failed to copy the executable!"
fi

# Set the executable permissions and chown
log "Setting executable permissions and ownership..."
chmod +x "${ExeName}"
chown azureadmin:azureadmin "${ExeName}"
if [ $? -eq 0 ]; then
    log "Permissions and ownership set successfully."
else
    error "Failed to set permissions and ownership!"
fi

# log the current path and dir contents
log "Current path: $(pwd)"
log "Directory contents: $(ls -la)"

# Restart the service
log "Restarting the service..."
sudo systemctl start "${ServiceName}"
if [ $? -eq 0 ]; then
    log "Service restarted successfully."
else
    error "Failed to restart the service!"
fi

# done
log "Service setup is complete."