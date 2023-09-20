default:
	@echo "==> Type make <thing> to run tasks"
	@echo
	@echo "Thing is one of:"
	@echo "docs fmt fmtcheck tfclean tools"

docs:
	@echo "==> Updating documentation..."
	find . | egrep "\.md" | grep -v README.md | sort | while read f; do terrafmt fmt $$f; done

fmt:
	@echo "==> Fixing Terraform code with terraform fmt..."
	terraform fmt -recursive
	@echo "==> Fixing embedded Terraform with terrafmt..."
	find . | egrep "\.md|\.tf" | grep -v README.md | sort | while read f; do terrafmt fmt $$f; done

fmtcheck:
	@echo "==> Checking source code with gofmt..."
	@sh "$(CURDIR)/scripts/gofmtcheck.sh"
	@echo "==> Checking source code with terraform fmt..."
	terraform fmt -check -recursive

tfclean:
	@echo "==> Cleaning terraform files..."
	find . -type d -name '.terraform' | xargs rm -vrf
	find . -type f -name 'tfplan' | xargs rm -vf
	find . -type f -name 'terraform.tfstate*' | xargs rm -vf
	find . -type f -name '.terraform.lock.hcl' | xargs rm -vf

tools:
	go install github.com/katbyte/terrafmt@latest

# Makefile targets are files, but we aren't using it like this,
# so have to declare PHONY targets
.PHONY: docs fmt fmtcheck tfclean tools
