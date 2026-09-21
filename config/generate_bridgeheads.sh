#!/bin/bash

generate_bridgehead() {
    local id="$1"
    local human="$2"

    local upper_id
    upper_id=$(echo "$id" \
        | tr '[:lower:]' '[:upper:]' \
        | sed 's/-/MINUS/g')

    cat <<EOF
export BRIDGEHEADS_CONFIG_${upper_id}_EXPLORERID="lens-${id}"
export BRIDGEHEADS_CONFIG_${upper_id}_FILEDISPATCHERBEAMID="beam-file.${id}.${BROKER_ID}"
export BRIDGEHEADS_CONFIG_${upper_id}_FOCUSBEAMID="focus.${id}.${BROKER_ID}"
export BRIDGEHEADS_CONFIG_${upper_id}_HUMANREADABLE="${human}"
export BRIDGEHEADS_CONFIG_${upper_id}_AFFILIATION="${human}"
export BRIDGEHEADS_CONFIG_${upper_id}_TOKENMANAGERID="token-manager.${id}.${BROKER_ID}"

EOF
}

generate_bridgehead_contact_language() {
    local id="$1"
    local index="$2"
    local language="$3"
    local name="$4"
    local description="$5"
    local email_address="$6"

    local upper_id
    upper_id=$(echo "$id" \
        | tr '[:lower:]' '[:upper:]' \
        | sed 's/-/MINUS/g')
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

# List of sites: id|human-readable
while IFS='|' read -r id human; do
    generate_bridgehead "$id" "$human"
done <<EOF
cce-dkfz|DKFZ (Test)
cce-dkfz-nct|DKFZ/NCT
cce-master|DKFZ
cce-gr|GR
cce-vhio|VHIO
cce-cruk-cc-dev|CCC (Dev)
cce-cruk-cc|CCC
cce-ki|KI
cce-nki|NKI
EOF

# Contact data: bridgehead-id|contact-index|language|name|description|email-address
# Add one row for each translated contact variant. Put the email address on one
# row per contact (normally the first language row).
# TODO: fill in real contacts for the CCE bridgeheads above. Example (commented out):
# cce-dkfz|0|en|Dr. Jane Example|CCE bridgehead contact|jane.example@cce-dkfz.example.org
# cce-dkfz|0|de|Dr. Jane Example|CCE-Bridgehead-Kontakt|
while IFS='|' read -r id index language name description email_address; do
    [[ -z "$id" || "$id" == \#* ]] && continue
    generate_bridgehead_contact_language \
        "$id" "$index" "$language" "$name" "$description" "$email_address"
done <<EOF
EOF
