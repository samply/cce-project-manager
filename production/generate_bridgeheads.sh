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

# Sites: site|human-readable|production bridgehead|test bridgehead
# - site: the site in Keycloak (/projects/cce/sites/<site>/...), shared by the site's bridgeheads.
# - human-readable: the display name of the Explorer (without the flag).
# - production / test bridgehead: the SITE_ID of the site's bridgehead on the broker of that environment (empty =
#   none); its Explorer collection id is lens-<bridgehead id>. A server offers the bridgeheads of its
#   DEPLOYMENT_ENVIRONMENT (PROD or TEST).
# A site with two bridgeheads in the same environment has one line per bridgehead.
# A server reaches only its own broker: PROD = broker.cce.dkfz.de, TEST = test-no-real-data.broker.samply.de. Until the
# migration every site runs on the test broker under its test id and request.cce.dkfz.de runs TEST; at the migration
# the bridgeheads move to the production broker under their production id and the server switches to PROD.
declare -A site_bridgeheads=()
while IFS='|' read -r site human production test; do
    [[ -z "$site" || "$site" == \#* ]] && continue
    if [[ "$deployment_environment" == "test" ]]; then id="$test"; else id="$production"; fi
    [[ -z "$id" ]] && continue
    # The group defaults to the bridgehead id; set it only when they differ.
    group=""
    [[ "$id" != "$site" ]] && group="$site"
    generate_bridgehead "$id" "$human" "$group"
    site_bridgeheads[$site]+="$id "
done <<EOF
dkfz-master|German Cancer Research Center|dkfz-master|cce-master
gustave-roussy|Gustave Roussy|gustave-roussy|cce-gr
karolinska|Karolinska Institutet|karolinska|cce-ki
nki|Netherlands Cancer Institute|nki|cce-nki
vhio|Vall d'Hebron Institute of Oncology|vhio|cce-vhio
cruk-cc|Cancer Research UK Cambridge Center|cruk-cc|cce-cruk-cc-dev
EOF

# Contact data: site|contact-index|language|name|description|email-address
# One row for each translated contact variant; the email address on one row per contact (normally the first
# language row). A contact goes to every bridgehead of its site that this server offers.
while IFS='|' read -r site index language name description email_address; do
    [[ -z "$site" || "$site" == \#* ]] && continue
    for id in ${site_bridgeheads[$site]:-}; do
        generate_bridgehead_contact_language \
            "$id" "$index" "$language" "$name" "$description" "$email_address"
    done
done <<EOF
# TODO: fill in real contacts for the CCE sites above. Example (commented out):
# dkfz-master|0|en|Dr. Jane Example|CCE bridgehead contact|jane.example@dkfz.example.org
# dkfz-master|0|de|Dr. Jane Example|CCE-Bridgehead-Kontakt|
EOF
