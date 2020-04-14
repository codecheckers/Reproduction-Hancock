## Attempt to use zen4R api to handle zenodo.
## [2020-04-10 Fri]
## Code taken from Daniel's Hopfield reproduction.

require(zen4R)
require(yaml)
yaml_file = "../codecheck.yml"
codecheck_yaml = read_yaml( yaml_file) 

## The following line may work only for SJE
my_token = system("pass show codechecker-token", intern=TRUE)

zenodo <- ZenodoManager$new(
   ##url = "http://sandbox.zenodo.org/api",
   token = my_token)


## Codechecker may have already created a draft report, but if not let's
## do it now. 
this_doi = codecheck_yaml$report
if (length(this_doi)==0) {
  ## run this only once.  perhaps after creating it, stick the doi in the yml file?
  myrec <- zenodo$createEmptyRecord()
  ## capture the DOI and store it in the yml file, as we don't want to create a new one.
  this_doi = myrec$metadata$prereserve_doi$doi
  print(this_doi)
}



## 10.5281/zenodo.3746024

# get draft (manually created)
deposit_draft <- zenodo$getDepositionByConceptDOI(this_doi)

# add metadata
deposit_draft$setPublicationType("report")
deposit_draft$setCommunities(communities = c("codecheck"))
deposit_draft$setTitle(paste("CODECHECK certificate", codecheck_yaml$certificate))
# sje -- yes, we should do this, for now I just added my orcid.
# could also add codechecker as author
# deposit_draft$addContributor(), but need to split firstname/lastname, handle optiona ORCID etc.
deposit_draft$setLanguage(language = "eng")


## for uploading the creators, addCreator() will simply add another, potentially duplicate entry,
## so we should remove all creators before providing just the one we want.
deposit_draft$metadata$creators = NULL
num_creators = length(codecheck_yaml$codechecker)
for (i in 1:num_creators) {
  deposit_draft$addCreator(
                  firstname = codecheck_yaml$codechecker[[i]]$firstname,
                  lastname  = codecheck_yaml$codechecker[[i]]$lastname,
                  orcid     = codecheck_yaml$codechecker[[i]]$ORCID)
}

description_text = paste("CODECHECK certificate for paper:", codecheck_yaml$paper$title)
repo_url = gsub("[<>]", "", codecheck_yaml$repository)
description_text = paste(description_text, sprintf('<p><p>Repository: <a href="%s">%s</a>', repo_url, repo_url))
deposit_draft$setDescription(description_text)
deposit_draft$setKeywords(keywords = c("CODECHECK"))
deposit_draft$setNotes(notes = c("See file LICENSE for license of the contained code. The report document codecheck.pdf is published under CC-BY 4.0 International."))
deposit_draft$setAccessRight(accessRight = "open")
deposit_draft$setLicense(licenseId = "other-open")
deposit_draft$addRelatedIdentifier(relation = "isSupplementTo", identifier = codecheck_yaml$repository)
deposit_draft$addRelatedIdentifier(relation = "isSupplementTo", identifier = codecheck_yaml$paper$reference)


deposit_draft <- zenodo$depositRecord(deposit_draft)

## Upload the file itself when ready.
zenodo$uploadFile("codecheck.pdf", deposit_draft$id)


## now go to zenodo and check the record.

## Created an zenodo token with permission to do everything using:
## https://zenodo.org/account/settings/applications/tokens/new/
## and then stored in my password manager, using
## pass insert codechecker-token
## this can then be retrieved using:
## pass show codechecker-token




