.DEFAULT_GOAL:=help

BUILD_DIR:=build
CHART_NAME?=hoppscotch
CLUSTER_NAME?=helm-charts
TEST_E2E_DIR:=test/e2e

GREEN=\033[0;32m
YELLOW=\033[0;33m
RESET=\033[0m

.PHONY: clean
clean: ## Clean up temporary resources
	@echo "${GREEN}Cleaning up temporary resources...${RESET}"
	rm -rf ${BUILD_DIR}
	rm -rf .cr-release-packages

.PHONY: helm-docs
helm-docs: ## Generate Helm docs
	@echo "${GREEN}Generating Helm docs...${RESET}"
	helm-docs --sort-values-order=file

.PHONY: helm-install
helm-install: kind-create-cluster ## Install chart
	@echo "${GREEN}Installing chart ${CHART_NAME}...${RESET}"
	helm install ${CHART_NAME} charts/${CHART_NAME} -n ${CHART_NAME} --create-namespace --wait --debug

.PHONY: helm-upgrade
helm-upgrade: ## Upgrade chart
	@echo "${GREEN}Upgrading chart ${CHART_NAME}...${RESET}"
	helm upgrade ${CHART_NAME} charts/${CHART_NAME} -n ${CHART_NAME} --wait --debug


.PHONY: helm-template
helm-template: clean ## Render Helm templates
	@echo "${GREEN}Rendering Helm templates...${RESET}"
	@mkdir -p ${BUILD_DIR}
	@for chart in charts/*/; do \
		if [ -d "$${chart}" ]; then \
			chart_name=$$(basename "$${chart}"); \
			helm dependency build "$${chart}"; \
			helm template "$${chart_name}" "$${chart}" > "${BUILD_DIR}/$${chart_name}.yaml"; \
		fi; \
	done

.PHONY: helm-uninstall
helm-uninstall: ## Uninstall chart
	@echo "${GREEN}Uninstalling chart ${CHART_NAME}...${RESET}"
	@if ! helm list -n ${CHART_NAME} | grep -q ${CHART_NAME}; then \
		echo "${YELLOW}Warning:${RESET} Chart ${CHART_NAME} is not installed"; \
		exit 0; \
	else \
		helm uninstall ${CHART_NAME} -n ${CHART_NAME}; \
	fi

.PHONY: helm-upgrade
helm-upgrade: ## Upgrade chart
	@echo "${GREEN}Upgrading chart ${CHART_NAME}...${RESET}"
	helm upgrade ${CHART_NAME} charts/${CHART_NAME} -n ${CHART_NAME} --wait --debug

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
	brew install shellcheck
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
	fi

.PHONY: kind-delete-cluster
kind-delete-cluster: ## Delete the Kind cluster
	@echo "${GREEN}Deleting Kind cluster...${RESET}"
	@if kind get clusters | grep -q "${CLUSTER_NAME}"; then \
		kind delete cluster --name ${CLUSTER_NAME}; \
	else \
		echo "${YELLOW}Warning:${RESET} Kind cluster ${CLUSTER_NAME} does not exist"; \
	fi

.PHONY: lint
lint: lint-charts lint-markdown lint-shell lint-yaml ## Run all linters

.PHONY: lint-charts
lint-charts: ## Lint charts
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
package: clean ## Package charts
	@echo "${GREEN}Packaging Helm charts...${RESET}"
	cr package charts/*

.PHONY: pre-commit
pre-commit: helm-docs lint test-unit ## Run pre-commit hooks

.PHONY: test-e2e
test-e2e: ## Run end-to-end tests
	@echo "${GREEN}Running end-to-end tests...${RESET}"
	${TEST_E2E_DIR}/test-e2e.sh --all --debug

.PHONY: test-unit
test-unit: ## Run unit tests
	@echo "${GREEN}Running unit tests...${RESET}"
	helm unittest charts/*

.PHONY: test
test: test-unit test-e2e ## Run all tests
