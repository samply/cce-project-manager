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
export BRIDGEHEADS_CONFIG_${upper_id}_FILEDISPATCHERBEAMID="beam-file.${id}.broker.ccp-it.dktk.dkfz.de"
export BRIDGEHEADS_CONFIG_${upper_id}_FOCUSBEAMID="focus.${id}.broker.ccp-it.dktk.dkfz.de"
export BRIDGEHEADS_CONFIG_${upper_id}_HUMANREADABLE="${human}"
export BRIDGEHEADS_CONFIG_${upper_id}_AFFILIATION="${human}"
export BRIDGEHEADS_CONFIG_${upper_id}_TOKENMANAGERID="token-manager.${id}.broker.ccp-it.dktk.dkfz.de"

EOF
}

# List of sites: id|human-readable
while IFS='|' read -r id human; do
    generate_bridgehead "$id" "$human"
done <<EOF
cce-dkfz|DKFZ
cce-gr|GR
cce-vhio|VHIO
cce-cruk-cc-dev|CCE (Dev)
cce-ki|KI
cce-nki|NKI
EOF