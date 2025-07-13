.DEFAULT_GOAL:=help

BUILD_DIR:=build
CHART_NAME?=hoppscotch
CLUSTER_NAME?=helm-charts
TEST_E2E_DIR:=test/e2e
TEST_E2E_VALUES?=${TEST_E2E_DIR}/data/${CHART_NAME}-values.yaml

GREEN=\033[0;32m
YELLOW=\033[0;33m
RESET=\033[0m

.PHONY: clean
clean: ## Clean up temporary resources
	@echo "${GREEN}Cleaning up temporary resources...${RESET}"
	rm -rf ${BUILD_DIR}
	rm -rf .cr-release-packages

.PHONY: fmt
fmt: fmt-markdown fmt-shell fmt-yaml ## Check all files formatting

.PHONY: fmt-fix
fmt-fix: fmt-markdown-fix fmt-shell-fix fmt-yaml-fix ## Fix all files formatting

.PHONY: fmt-markdown
fmt-markdown: ## Check Markdown files formatting
	@echo "${GREEN}Checking Markdown files formatting...${RESET}"
	prettier -c **/*.md

.PHONY: fmt-markdown-fix
fmt-markdown-fix: ## Fix Markdown files formatting
	@echo "${GREEN}Fixing Markdown files formatting...${RESET}"
	prettier -w **/*.md

.PHONY: fmt-shell
fmt-shell: ## Check shell scripts formatting
	@echo "${GREEN}Checking shell scripts formatting...${RESET}"
	shfmt -l -d .

.PHONY: fmt-shell-fix
fmt-shell-fix: ## Fix shell scripts formatting
	@echo "${GREEN}Fixing shell scripts formatting...${RESET}"
	shfmt -l -w .

.PHONY: fmt-yaml
fmt-yaml: ## Check YAML files formatting
	@echo "${GREEN}Checking YAML files formatting...${RESET}"
	prettier -c **/*.yaml

.PHONY: fmt-yaml-fix
fmt-yaml-fix: ## Fix YAML files formatting
	@echo "${GREEN}Fixing YAML files formatting...${RESET}"
	prettier -w **/*.yaml

.PHONY: helm-docs
helm-docs: ## Generate Helm docs
	@echo "${GREEN}Generating Helm docs...${RESET}"
	helm-docs --sort-values-order=file
	$(MAKE) fmt-markdown-fix

.PHONY: helm-install
helm-install: kind-create-cluster ## Install chart
	@echo "${GREEN}Installing ${CHART_NAME} chart...${RESET}"
	helm install ${CHART_NAME} charts/${CHART_NAME} -n ${CHART_NAME} --values ${TEST_E2E_VALUES} --create-namespace --wait

.PHONY: helm-template
helm-template: clean ## Render chart templates
	@echo "${GREEN}Rendering ${CHART_NAME} chart templates...${RESET}"
	@mkdir -p ${BUILD_DIR}
	helm template ${CHART_NAME} charts/${CHART_NAME} > "${BUILD_DIR}/${CHART_NAME}.yaml"

.PHONY: helm-uninstall
helm-uninstall: ## Uninstall chart
	@echo "${GREEN}Uninstalling ${CHART_NAME} chart...${RESET}"
	@if ! helm list -n ${CHART_NAME} | grep -q ${CHART_NAME}; then \
		echo "${YELLOW}Warning:${RESET} Chart ${CHART_NAME} is not installed"; \
		exit 0; \
	else \
		helm uninstall ${CHART_NAME} -n ${CHART_NAME}; \
	fi

.PHONY: helm-upgrade
helm-upgrade: ## Upgrade chart
	@echo "${GREEN}Upgrading ${CHART_NAME} chart...${RESET}"
	helm upgrade ${CHART_NAME} charts/${CHART_NAME} -n ${CHART_NAME} --values ${TEST_E2E_VALUES} --wait

.PHONY: help
help: ## Show this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: install-deps
install-deps: ## Install dependencies
	@echo "${GREEN}Installing dependencies...${RESET}"
	@if [ "$$(uname)" = "Darwin" ]; then \
		$(MAKE) install-deps-macos; \
	else \
		echo "Error: unsupported operating system: $$(uname)" 1>&2; \
		exit 1; \
	fi

.PHONY: install-deps-macos
install-deps-macos: ## Install dependencies for MacOS
	@echo "${GREEN}Installing dependencies for MacOS...${RESET}"
	@if ! command -v brew &> /dev/null; then \
		echo "Error: Homebrew is not installed" 1>&2; \
		exit 1; \
	fi
	brew update
	brew install chart-releaser
	brew install chart-testing
	brew install docker
	brew install helm
	brew install norwoodj/tap/helm-docs
	brew install kind
	brew install kubectl
	brew install markdownlint-cli
	brew install prettier
	brew install shellcheck
	brew install shfmt
	brew install yamllint
	@if ! helm plugin list | grep -q 'unittest'; then \
		helm plugin install https://github.com/helm-unittest/helm-unittest; \
	else \
		echo "${YELLOW}Warning:${RESET} helm-unittest plugin is already installed"; \
	fi

.PHONY: kind-create-cluster
kind-create-cluster: ## Create a Kind cluster
	@echo "${GREEN}Creating Kind cluster...${RESET}"
	@if kind get clusters | grep -q "${CLUSTER_NAME}"; then \
		echo "${YELLOW}Warning:${RESET} Kind cluster ${CLUSTER_NAME} already exists"; \
	else \
		kind create cluster --name ${CLUSTER_NAME} --config ${TEST_E2E_DIR}/kind.yaml; \
		kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml; \
		echo "${GREEN}Waiting for cluster to be ready...${RESET}"; \
		sleep 5; \
		kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=60s; \
	fi

.PHONY: kind-delete-cluster
kind-delete-cluster: ## Delete the kind cluster
	@echo "${GREEN}Deleting ${CLUSTER_NAME} kind cluster...${RESET}"
	@if kind get clusters | grep -q "${CLUSTER_NAME}"; then \
		kind delete cluster --name ${CLUSTER_NAME}; \
	else \
		echo "${YELLOW}Warning:${RESET} Kind cluster ${CLUSTER_NAME} does not exist"; \
	fi

.PHONY: lint
lint: lint-helm lint-markdown lint-shell lint-yaml ## Run all linters

.PHONY: lint-helm
lint-helm: ## Lint Helm charts
	@echo "${GREEN}Linting Helm charts...${RESET}"
	ct lint --config ct.yaml --lint-conf lintconf.yaml --all

.PHONY: lint-markdown
lint-markdown: ## Lint Markdown files
	@echo "${GREEN}Linting Markdown files...${RESET}"
	markdownlint '**/*.md'

.PHONY: lint-shell
lint-shell: ## Lint shell scripts
	@echo "${GREEN}Linting shell scripts...${RESET}"
	find . -type f -name "*.sh" | xargs shellcheck

.PHONY: lint-yaml
lint-yaml: ## Lint YAML files
	@echo "${GREEN}Linting YAML files...${RESET}"
	yamllint .

.PHONY: package
package: clean ## Package Helm charts
	@echo "${GREEN}Packaging Helm charts...${RESET}"
	cr package charts/${CHART_NAME}

.PHONY: pre-commit
pre-commit: fmt lint test-unit ## Run pre-commit hooks

.PHONY: test-e2e
test-e2e: ## Run end-to-end tests
	@echo "${GREEN}Running end-to-end tests for ${CHART_NAME} chart...${RESET}"
	${TEST_E2E_DIR}/test-e2e.sh --charts=charts/${CHART_NAME} --debug --helm-extra-args="--values=${TEST_E2E_VALUES}"

.PHONY: test-unit
test-unit: ## Run unit tests
	@echo "${GREEN}Running unit tests...${RESET}"
	helm unittest charts/*

.PHONY: test
test: test-unit test-e2e ## Run all tests
