# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
- Local development: the group `dev-central-committee` gives the central approval committee role
  (`CENTRAL_APPROVAL_COMMITTEE_GROUPS` in `development/development.env`); needs a backend with the committee role
- Local development: the UI names the committee "CCE Data Access Committee", as the action texts and emails do
  (`FRONTEND_VARIABLES_CENTRAL_APPROVAL_COMMITTEE_NAME`; needs a UI with the committee role)
- Messages of the new action "Request changes" (`REQUEST_CHANGES_IN_APPROVAL` in `production/action-messages.json`);
  `BACK_TO_REVIEW` removed with the action it belonged to
- Central approval committee on the servers: `CENTRAL_APPROVAL_COMMITTEE_GROUPS=/projects/cce/central-committee`
  (Keycloak group, serveros) and `FRONTEND_VARIABLES_CENTRAL_APPROVAL_COMMITTEE_NAME="CCE Data Access Committee"`;
  its own explanations in review (the CCE-Office reviews first) and in the central approval (evaluate: request changes
  or start the local approval). Needs a backend and UI with the committee role
- Emails to the CCE Data Access Committee: "request accepted" (`NEW_PROJECT_ACCEPTED`: awaits its evaluation, with the
  request details) and "back in review" (`PROJECT_BACK_TO_REVIEW`, also to the CCE-Office; one file for both roles, so
  that someone in both gets it once)
- Hot reload for local development (`development/development.env`, `SPRING_DEVTOOLS_*`): changes in
  `production/` restart the backend started from the IDE; needs a backend with `spring-boot-devtools`
- Release workflow: when a new version section of `CHANGELOG.md` reaches `main`, the tag `vX.Y.Z`, the GitHub
  release (notes = that section) and the version images are created automatically
- `DEPLOYMENT_ENVIRONMENT` (`PROD` by default, `TEST` on test servers; any other value stops the start):
  `setdefault <variable> <production default> [<test default>]` gives test servers their own defaults
- Bridgeheads per server: `production/generate_bridgeheads.sh` lists `id|human-readable|environments|group`; a server
  offers the bridgeheads of its `DEPLOYMENT_ENVIRONMENT` (README "Bridgeheads")
### Changed
- The applicant's "back in review" email shows the requested changes (the message of "Request changes") instead of
  "the CCE-Office will contact you"
- Keycloak groups of the bridgeheads (VerbIS realm, serveros `bridgehead-groups-dktk-cce`):
  `/projects/cce/bridgeheads/<group>/user` (bridgehead user, `BK_USER_GROUP_SUFFIX=/user`) and
  `/projects/cce/bridgeheads/<group>/admin` (bridgehead admin), instead of `/projects/cce/sites/<group>` and
  `/projects/cce/sites/<group>/admin`. Needs a backend that gives the admin role to an admin group not matching the user
  pattern (project-manager CHANGELOG, Fixed "Bridgehead admin groups ...").
  No dev groups: the test bridgehead cce-cruk-cc-dev uses the group of cce-cruk-cc
- Bridgeheads follow the Explorer (project-manager-ops `bridgeheads/cce.md`): cce-dkfz, cce-dkfz-nct and
  cce-cruk-cc-dev only on test servers (the Explorer does not query them), cce-cruk-cc only in production; production request.cce.dkfz.de runs
  `DEPLOYMENT_ENVIRONMENT=TEST` while the sites test it. Names of the Explorer: Cancer Research UK Cambridge Center
  (cce-cruk-cc-dev), Cancer Research UK Cambridge Center (Prod) (cce-cruk-cc)
- Feasibility table page size: 6 sites in production, 8 on test servers (`FRONTEND_VARIABLES_FEASIBILITY_PAGE_SIZE`)
- Contacts are exported only for the bridgeheads the server offers
- Explanation of "Accept request" in review: request changes in the project manager instead of contacting the
  applicant directly; the German texts translate the English again (also the one for an archived request)
- German action texts (`production/action-messages.json`) translate the English again: many explanations were
  shortened or shared one text for different situations (script download, site authorization, final phase,
  finishing, assigning users, results URL)
- Project manager admins and bridgehead admins come from the VerbIS Keycloak groups
  `/projects/cce/project-manager-admin` and `/projects/cce/sites/<bridgehead id>/admin` (`PM_ADMIN_GROUPS`,
  `BK_*_GROUP_*`); the old groups `cce-requester-admin` and `CCE_<site>[_Verwalter]` did not exist in Keycloak
- Researchers: everyone with the Explorer app `/apps/cce-federated-explorer` (`RESEARCHER_GROUPS`, was
  `/projects/cce/vdc`), also when the Explorer was granted by hand
- Groups are written as Keycloak shows them, with the leading slash: needs a backend that ignores it in every group
  setting (project-manager after 1.0.0, CHANGELOG "Group settings ... with or without the leading slash"); the next
  release of this configuration must build on such a backend release, not on 1.0.0

## [1.0.0] - 2026-10-16
### Added
- GitHub repository `samply/cce-project-manager` (moved from GitLab; secrets removed from the history)
- GitHub Actions build with the samply `docker-ci.yml`: images `samply/cce-project-manager:main` and `:develop` on
  Docker Hub; `develop` rebuilt every night
- Dependabot: pull request into `develop` for every new backend release
- README: introduction, branches and images, how a backend release reaches production, minimal docker compose
- LICENSE (Apache 2.0, as the other samply repositories)
### Changed
- `main` is built on a released backend (`samply/project-manager:1.0.0`), `develop` on `samply/project-manager:develop`
- New development database key in `development/development.env`
### Removed
- GitLab CI (`.gitlab-ci.yml`)

## [0.0.1 - 2026-09-10]
### Added
- CHANGELOG
- Dockerfile
- Public documents
- Templates
- Bridgehead configuration
- Gitlab CI
- Action Explanations Config
- Project manager admin new project message
- New project accepted messages
- New votum message
- '<support-info/>' and '<team-signature/>' email context variables
- Invitation to a project message
- Bridgehead admin technical approval message
- Notification of Bridgehead admin authorization or revocation messages
- Notification regarding Acceptance, rejection or changes request of script messages
- Notification regarding Acceptance, rejection or changes request of final results messages
- Notification regarding Acceptance, rejection or changes request of final analysis results messages
- Authentication Script messages
- Project finished message
- New publication message
- '<project-view-link/>' project view url with format
- Project view link in all templates
- More space between Dear ... and the rest of the message
- Reject project message
- Blocking message in rejection email templates
- Query saved (and executed) in Teiler messages
- Title and description in project configuration
- Error message if a query is sent with an error
- Send error email if error while sending a query to bridgehead
- Mention to Exporter App for Teiler executions of the query
- Result templates
- Create send credentials and find send credentials templates
- Messages of email templates related to the results
- Action Explanations regarding the results
- Email template for NEW_VOTUM_FOR_ALL_BRIDGEHEADS
- Research Environment Link
- DB_ENCRYPTION_ALGORITHM variable
- Coder configuration
- APP_ID and APP_SECRET variables to coder templates
- Authentik configuration
- Sample Form
- Clinical Data Form
- Samples form the template
- Logos in samples form the template
- DataType in a sample template
- Form template metadata for samples
- Project form fields for samples
- Group fields in samples from the template
- Form config
- Development Environment
- Configurable localized display formats without database or form-value persistence changes
- Localized DATE values in generated form PDFs
- Samples as service in configuration
- Project and Forms configuration
- Output format and template id in samples config
- Data and Samples configuration
- Cohort, Samples and Project configuration
- Generate bridgeheads
- Query forms
- Form attachments for new projects in emails
- Final report emails
- Assets
- Canonical form order
- Mailing blacklist file
- Applicant Declaration
- Cache config
- Merge action message proposals and add German translations
- Favicon as backend environment variable
- FRONTEND_VARIABLES_SUMMARY_SPACING (compact or airy summary)
- FRONTEND_VARIABLES_FEASIBILITY_TABLE_WIDTH (compact, medium or full feasibility table)
- FRONTEND_VARIABLES_FEASIBILITY_TABLE_ALIGNMENT (standard, left or right feasibility values)


### Changed
- Replace Minus in bridgeheads
- Variable JWT_GROUPS_CLAIM
- <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
- Action Priorities
- Configurations as files
- Rename mail server property
- Messages in italic
- Action explanation for start final stage for project type export
- Accept project bridgehead only if the query-state is finished
- OpenId Client: project-manager-api
- Rename creator to applicant
- Upload script explanation only for DEVELOP and PILOT users
- Exporter cron expression every 30 seconds
- Rename project state CREATED and ACCEPTED as REVIEW and APPROVAL
- Docker VerbIS User for Gitlab CI
- Localized display-format configuration
- FRONTEND_VARIABLES_FEASIBILITY_PAGE_SIZE = 9 (the number of sites): the feasibility table without pagination
- ENABLE_RESEARCH_ENVIRONMENT (was ENABLE_CODER) and ENABLE_DATASHIELD (was ENABLE_TOKEN_MANAGER); ENABLE_APP_REGISTER removed (app register is part of the research environment)
- Development: ENABLE_EXPORTER, ENABLE_FEASIBILITY and ENABLE_EMAILS = test (test implementations without Beam and SMTP; EMAILS_TEST_LOG=summary); README section "Optional modules"
- Removed the research environment and DataSHIELD configuration (both disabled here): CODER_*, APP_REGISTER_*, TOKEN_MANAGER_URL, MANAGE_TOKENS_CRON_EXPRESSION, production/coder/*.json and the block of dummy values for disabled modules. A working version for demo-project-manager: master-project-manager, commit 17579fd (branch feat/optional-modules, 2026-10-08, new variable names; with the old names ENABLE_CODER/ENABLE_TOKEN_MANAGER also on main, d738236)
- Removed variables the backend does not read: CODER_MEMBER_ID (only a placeholder inside CODER_CREATE_PATH), CODER_TEMPLATE_VERSION_ID, ENABLE_RSTUDIO_GROUP_MANAGER
- Optional modules are opt-in in the backend (unset = disabled): only the enabled modules are set; ENABLE_FEASIBILITY=true added to production (was enabled through the former default), ENABLE_RESEARCH_ENVIRONMENT=false and ENABLE_DATASHIELD=false removed
- Project state APPROVAL renamed CENTRAL_APPROVAL (action messages); needs the backend with the same rename
- ENABLE_LOCAL_APPROVAL=true (production and development): local approval of each site after the central approval
- Development: example approval contacts per site (BRIDGEHEADS_CONFIG_<SITE>_APPROVALCONTACTS_<n>_NAME_EN|DE, _DESCRIPTION_EN|DE, _EMAILADDRESS); production: to be added per site
- Email templates of the local approval (EN): LOCAL_APPROVAL_STARTED (approval contacts with the form, creator, bridgehead admins), NEW_LOCAL_APPROVAL, NEW_LOCAL_APPROVAL_FINAL (bridgehead admin: export now), PROJECT_BACK_TO_REVIEW (creator)
- Action messages of the local approval: START_LOCAL_APPROVAL_STAGE, START_FINAL_STAGE in LOCAL_APPROVAL, BACK_TO_REVIEW, UPLOAD_LOCAL_APPROVAL
- README: FRONTEND_VARIABLES_LOCAL_APPROVAL_REQUIRED (local approval mandatory, UI only)
- FRONTEND_VARIABLES_LOCAL_APPROVAL_REQUIRED="false" in production (frontend-environment.sh) and development: the local approval is not mandatory for now

### Fixed
- Avoid splitting fields in samples from the template
- PDF alignment
- PDF: texts with HTML (links, formatting) shown as in the frontend

### Removed
- Application Form
- Only a sample option
