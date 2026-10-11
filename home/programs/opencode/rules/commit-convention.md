# Commit Message Convention

Follow [Conventional Commits](https://www.conventionalcommits.org/).

Format: `<type>[optional scope]: <description>`

## Types

- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `build` - Build system, dependencies, Nix flake
- `chore` - Maintenance tasks
- `ci` - CI/CD configuration
- `refactor` - Code restructuring without behavior change
- `test` - Adding or updating tests
- `perf` - Performance improvements
- `style` - Code style (formatting, semicolons, etc.)
- `revert` - Reverting a previous commit

## Scope

Scope is optional. When used, pick the most relevant area of the repo, e.g.:

- `nix` - flake inputs, `flake.nix` / `flake.lock`
- `home` - Home Manager configuration under `home/`
- `modules` - NixOS modules under `modules/`
- `pkgs` - custom packages under `pkgs/`
- `configs` - raw dotfiles / config files under `configs/`
- `secrets` - sops / secret management
- `opencode` - opencode agents, skills, and rules
- `git` - git configuration
- `ci` - GitHub Actions workflows
- a WM / program name (`niri`, `noctalia`, `nixvim`) or a host name
  (`desktop`, `surface`, `wsl`, `freesia`, `zephyr`) for host-specific changes

## Description

- Use the imperative mood in English (e.g. `add`, `fix`, `update`, not `added`).
- Do not capitalize the first letter.
- Do not end with a period.

## PR Titles

PR titles **must** follow the same convention. This repo squash-merges, so the PR
title becomes the commit subject.

## Bad Examples

```
update code                      # missing type and scope
fix(nix): Fix bug.               # don't capitalize, don't end with period
Core: CLI + GitHub provider      # PR title not following convention
```
