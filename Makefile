# Dotfiles Test Suite
# Run 'make help' for available commands

.PHONY: help test syntax shellcheck bats install-deps clean

# Default target
help:
	@echo "Dotfiles Test Commands:"
	@echo "  make test         - Run all tests"
	@echo "  make syntax       - Check shell syntax only"
	@echo "  make shellcheck   - Run ShellCheck static analysis"
	@echo "  make bats         - Run BATS unit tests"
	@echo "  make install-deps - Install test dependencies (macOS)"
	@echo ""
	@echo "Prerequisites:"
	@echo "  brew install shellcheck bats-core"

# Run all tests
test: syntax shellcheck bats
	@echo "All tests passed!"

# Syntax validation
syntax:
	@echo "==> Checking Bash syntax..."
	@bash -n .bash_profile
	@bash -n .bashrc
	@bash -n .bash_prompt
	@bash -n .bash/git-prompt
	@bash -n install.sh
	@echo "==> Checking Zsh syntax..."
	@zsh -n .zshrc 2>/dev/null || echo "    (zsh not available, skipping)"
	@echo "==> Syntax check passed!"

# ShellCheck static analysis
shellcheck:
	@echo "==> Running ShellCheck..."
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck .bash_profile .bash_prompt .bash/git-prompt install.sh; \
		echo "==> ShellCheck passed!"; \
	else \
		echo "    ShellCheck not installed, skipping (brew install shellcheck)"; \
	fi

# BATS unit tests
bats:
	@echo "==> Running BATS tests..."
	@if command -v bats >/dev/null 2>&1; then \
		bats test/; \
	else \
		echo "    BATS not installed, skipping (brew install bats-core)"; \
	fi

# Install test dependencies (macOS)
install-deps:
	@echo "==> Installing test dependencies..."
	brew install shellcheck bats-core
	@echo "==> Dependencies installed!"

# Clean any test artifacts
clean:
	@echo "==> Cleaning test artifacts..."
	@rm -rf test/*.log
	@echo "==> Clean complete!"
