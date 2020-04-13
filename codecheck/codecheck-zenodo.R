## Attempt to use zen4R api to handle zenodo.
## [2020-04-10 Fri]
## Code taken from Daniel's Hopfield reproduction.

require(zen4R)
require(yaml)
yaml_file = "../codecheck.yml"
codecheck_yaml = read_yaml( yaml_file) 

## The following line ma work only for SJE
my_token = system("pass show codechecker-token", intern=TRUE)

zenodo <- ZenodoManager$new(
   token = my_token,
   logger = "INFO"
)

##myrec <- zenodo$createEmptyRecord()


## 10.5281/zenodo.3746024

# get draft (manually created)
deposit_draft <- zenodo$getDepositionByConceptDOI("10.5281/zenodo.3746024")

# add metadata
deposit_draft$setPublicationType("report")
deposit_draft$setCommunities(communities = c("codecheck"))
deposit_draft$setTitle(paste("CODECHECK certificate", codecheck_yaml$certificate))
# sje -- yes, we should do this, for now I just added my orcid.
# could also add codechecker as author
# deposit_draft$addContributor(), but need to split firstname/lastname, handle optiona ORCID etc.
deposit_draft$setLanguage(language = "eng")
deposit_draft$setLanguage(language = "eng")
deposit_draft$setDescription(paste("CODECHECK certificate for paper:", codecheck_yaml$paper$title))
deposit_draft$setKeywords(keywords = c("CODECHECK"))
deposit_draft$setNotes(notes = c("See file LICENSE for license of the contained code. The report document codecheck.pdf is published under CC-BY 4.0 International."))
deposit_draft$setAccessRight(accessRight = "open")
deposit_draft$setLicense(licenseId = "other-open")
deposit_draft$addRelatedIdentifier(relation = "isSupplementTo", identifier = codecheck_yaml$repository)
deposit_draft$addRelatedIdentifier(relation = "isSupplementTo", identifier = codecheck_yaml$paper$reference)


deposit_draft <- zenodo$depositRecord(deposit_draft)

## Upload the file itself when ready.
zenodo$uploadFile("codecheck.pdf", deposit_draft$id)


## Created an zenodo token with permission to do everything using:
## https://zenodo.org/account/settings/applications/tokens/new/
## and then stored in my password manager, using
## pass insert codechecker-token
## this can then be retrieved using:
## pass show codechecker-token




