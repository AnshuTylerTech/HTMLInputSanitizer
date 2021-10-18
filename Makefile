default: help
## This help screen.
help:
	@printf "Available targets:\n\n"
	@awk '/^[a-zA-Z\-\_0-9%:\\]+/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = $$1; \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			gsub("\\\\", "", helpCommand); \
			gsub(":+$$", "", helpCommand); \
			printf "  \x1b[32;01m%-35s\x1b[0m %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort -u
	@printf "\n"

deps::
	@which pre-commit >/dev/null || (echo "Missing pre-commit framework: https://pre-commit.com/#install"; exit 1)

## init-all, then execute all pre-commit checks against all git tracked files.
precommit: deps tf/init-all
	@pre-commit run -a

## Initialize all Terraform directories in project.
tf/init-all:
	@[ "${INIT}" = false ] || ./scripts/init-all.sh

# Remove all `.terraform` directories in project, including root-module, sub-modules and example directories). This is most useful when testing/validationg against multiple versions of Terraform.
## Remove all `.terraform` directories in project.
tf/clean:
	@./scripts/clean.sh

## Run TF Validate for all modules and examples
tf/validate-all: deps tf/init-all
	@pre-commit run -a terraform_validate

## Run Terraform Format for all *.tf files.
tf/fmt-all: deps
	@pre-commit run -a terraform_fmt

## Generate Terraform Docs for all modules and examples with existing README.md files
tf/docs-all: deps
	@pre-commit run -a terraform_docs

## Execute tflint against all modules and examples
tf/lint-all: deps tf/init-all
	@pre-commit run -a terraform_tflint

## Execute tfsec against all modules and examples
tf/sec-all: deps
	@pre-commit run -a terraform_tfsec

## Update context.tf file.
gh/update-context:
	@./scripts/update-context.sh