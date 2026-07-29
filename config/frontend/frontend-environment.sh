#!/bin/sh

export FRONTEND_PROJECT_CONFIG_PATH="/app/frontend/frontend-project-configs.json"
# export FRONTEND_BASEURL="http://project-manager-ui:8099" #################################### <= Please configure me
export FRONTEND_SITES_PROJECTMINUSDASHBOARD="/"
export FRONTEND_SITES_PROJECTMINUSVIEW="/project-view"
export ASSETS_DIRECTORY="/app/frontend/assets"

export FRONTEND_VARIABLES_LOGO_URL="${BACKEND_BASEURL}/assets/cce-logo.svg"
export FRONTEND_VARIABLES_PROJECT_URL="https://www.cancercoreeurope.eu/"
export FRONTEND_VARIABLES_LOGO_TEXT="cce"
export FRONTEND_VARIABLES_LOGO_CSS="${BACKEND_BASEURL}/assets/logo.css"
