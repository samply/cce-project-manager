#!/bin/bash

# Prints the BRIDGEHEADS_CONFIG_<ID>_* exports of the bridgeheads of this server (DEPLOYMENT_ENVIRONMENT: PROD or
# TEST, default PROD). Inventory and the reasons per bridgehead: project-manager-ops bridgeheads/cce.md.
deployment_environment=$(echo "${DEPLOYMENT_ENVIRONMENT:-PROD}" | tr '[:upper:]' '[:lower:]')

upper_id() {
    echo "$1" \
        | tr '[:lower:]' '[:upper:]' \
        | sed 's/-/MINUS/g'
}

generate_bridgehead() {
    local id="$1"
    local human="$2"
    local group="$3"

    local upper_id
    upper_id=$(upper_id "$id")

    cat <<EOF
export BRIDGEHEADS_CONFIG_${upper_id}_EXPLORERID="lens-${id}"
export BRIDGEHEADS_CONFIG_${upper_id}_FILEDISPATCHERBEAMID="beam-file.${id}.${BROKER_ID}"
export BRIDGEHEADS_CONFIG_${upper_id}_FOCUSBEAMID="focus.${id}.${BROKER_ID}"
export BRIDGEHEADS_CONFIG_${upper_id}_HUMANREADABLE="${human}"
export BRIDGEHEADS_CONFIG_${upper_id}_AFFILIATION="${human}"
export BRIDGEHEADS_CONFIG_${upper_id}_TOKENMANAGERID="token-manager.${id}.${BROKER_ID}"
EOF
    if [[ -n "$group" ]]; then
        echo "export BRIDGEHEADS_CONFIG_${upper_id}_GROUP=\"${group}\""
    fi
    echo
}

generate_bridgehead_contact_language() {
    local id="$1"
    local index="$2"
    local language="$3"
    local name="$4"
    local description="$5"
    local email_address="$6"

    local upper_id
    upper_id=$(upper_id "$id")
    local upper_language
    upper_language=$(echo "$language" | tr '[:lower:]' '[:upper:]')

cat <<EOF
export BRIDGEHEADS_CONFIG_${upper_id}_CONTACTS_${index}_NAME_${upper_language}="${name}"
export BRIDGEHEADS_CONFIG_${upper_id}_CONTACTS_${index}_DESCRIPTION_${upper_language}="${description}"
EOF

if [[ -n "$email_address" ]]; then
    cat <<EOF
export BRIDGEHEADS_CONFIG_${upper_id}_CONTACTS_${index}_EMAILADDRESS="${email_address}"

EOF
fi
}

# Bridgeheads: id|human-readable|environments|group
# - human-readable: the display name of the Explorer (without the flag).
# - environments: prod, test or prod,test (the servers that offer the bridgehead). The production server
#   explorer.cce.dkfz.de / request.cce.dkfz.de runs TEST while the sites test it.
# - group: the group of the identity provider (/projects/cce/bridgeheads/<group>/user, .../admin); empty = the id.
active_bridgeheads=" "
while IFS='|' read -r id human environments group; do
    [[ -z "$id" || "$id" == \#* ]] && continue
    [[ ",${environments}," == *",${deployment_environment},"* ]] || continue
    generate_bridgehead "$id" "$human" "$group"
    active_bridgeheads+="${id} "
done <<EOF
cce-dkfz|German Cancer Research Center (Test)|test|
cce-dkfz-nct|German Cancer Research Center / National Center for Tumor Diseases|test|
cce-master|German Cancer Research Center|prod,test|
cce-gr|Gustave Roussy|prod,test|
cce-vhio|Vall d'Hebron Institute of Oncology|prod,test|
cce-cruk-cc-dev|Cancer Research UK Cambridge Center|test|cce-cruk-cc
cce-cruk-cc|Cancer Research UK Cambridge Center (Prod)|prod|
cce-ki|Karolinska Institutet|prod,test|
cce-nki|Netherlands Cancer Institute|prod,test|
EOF

# Contact data: bridgehead-id|contact-index|language|name|description|email-address
# Add one row for each translated contact variant. Put the email address on one
# row per contact (normally the first language row). Rows of bridgeheads that this
# server does not offer are skipped (any variable of a bridgehead registers it).
# TODO: fill in real contacts for the CCE bridgeheads above. Example (commented out):
# cce-dkfz|0|en|Dr. Jane Example|CCE bridgehead contact|jane.example@cce-dkfz.example.org
# cce-dkfz|0|de|Dr. Jane Example|CCE-Bridgehead-Kontakt|
while IFS='|' read -r id index language name description email_address; do
    [[ -z "$id" || "$id" == \#* ]] && continue
    [[ "$active_bridgeheads" == *" ${id} "* ]] || continue
    generate_bridgehead_contact_language \
        "$id" "$index" "$language" "$name" "$description" "$email_address"
done <<EOF
EOF
