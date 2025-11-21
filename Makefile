default:
	@echo "==> Type make <thing> to run tasks"
	@echo
	@echo "Thing is one of:"
	@echo "fmt fmtcheck tfclean"

fmt:
	@echo "==> Fixing Terraform code with terraform fmt..."
	terraform fmt -recursive

fmtcheck:
	@echo "==> Checking source code with terraform fmt..."
	terraform fmt -check -recursive

tfclean:
	@echo "==> Cleaning terraform files..."
	find . -type d -name '.terraform' | xargs rm -vrf
	find . -type f -name 'tfplan' | xargs rm -vf
	find . -type f -name 'terraform.tfstate*' | xargs rm -vf
	find . -type f -name '.terraform.lock.hcl' | xargs rm -vf

# Makefile targets are files, but we aren't using it like this,
# so have to declare PHONY targets
.PHONY: fmt fmtcheck tfclean
