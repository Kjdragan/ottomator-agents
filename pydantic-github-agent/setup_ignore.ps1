# This is a script to that I created with ChatGPT so that I could track .gitignore files and folders locally but not push them to GitHub.  It uses a GitHub hook script to do so. Check this out for future uses

# Set variables for the folder and file to ignore
$LOCAL_FOLDER = "_knowledge"
$LOCAL_FILE = ".env"
$GITIGNORE_FILE = ".gitignore"
$PRE_PUSH_HOOK = ".git\hooks\pre-push"

# Step 1: Add the folder and file to .gitignore if not already present
Write-Host "Adding $LOCAL_FOLDER and $LOCAL_FILE to .gitignore..."

if (-not (Select-String -Pattern "^$LOCAL_FOLDER" -Path $GITIGNORE_FILE)) {
    Add-Content -Path $GITIGNORE_FILE -Value "$LOCAL_FOLDER/"
    Write-Host "Added $LOCAL_FOLDER to $GITIGNORE_FILE."
} else {
    Write-Host "$LOCAL_FOLDER is already in $GITIGNORE_FILE."
}

if (-not (Select-String -Pattern "^$LOCAL_FILE" -Path $GITIGNORE_FILE)) {
    Add-Content -Path $GITIGNORE_FILE -Value "$LOCAL_FILE"
    Write-Host "Added $LOCAL_FILE to $GITIGNORE_FILE."
} else {
    Write-Host "$LOCAL_FILE is already in $GITIGNORE_FILE."
}

# Step 2: Force add the folder and file locally
Write-Host "Force adding $LOCAL_FOLDER and $LOCAL_FILE for local tracking..."
git add -f $LOCAL_FOLDER, $LOCAL_FILE
git commit -m "Add $LOCAL_FOLDER and $LOCAL_FILE for local use only" | Out-Null

# Step 3: Create the pre-push hook to block them from being pushed
Write-Host "Creating pre-push hook to block $LOCAL_FOLDER and $LOCAL_FILE from being pushed..."

$prePushScript = @"
#!/bin/bash
# Block $LOCAL_FOLDER and $LOCAL_FILE from being pushed
if git diff --cached --name-only | Select-String -Pattern "^($LOCAL_FOLDER/|$LOCAL_FILE)"; then
    echo 'Error: $LOCAL_FOLDER or $LOCAL_FILE is staged for push. Please unstage it to proceed.'
    exit 1
fi
"@

# Write the pre-push script to the appropriate hook location
$prePushScript | Set-Content -Path $PRE_PUSH_HOOK -Force

# Make the pre-push hook executable
chmod +x $PRE_PUSH_HOOK
Write-Host "Pre-push hook created successfully."

Write-Host "Setup complete. $LOCAL_FOLDER and $LOCAL_FILE are tracked locally but won't be pushed to GitHub."
