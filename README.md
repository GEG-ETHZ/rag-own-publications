# RAG Own Publications

Upload GEG publications to the RAG bucket under DOI-based names, skipping duplicates.

> **Built on the GEG Python template.** This project entails [`uv`](https://docs.astral.sh/uv/) for dependencies and environments, [`ruff`](https://docs.astral.sh/ruff/) for linting and formatting, [`mypy`](https://mypy-lang.org/) for type checks, [`pre-commit`](https://pre-commit.com/) hooks, and a working GitLab CI pipeline. A new contributor only needs `uv sync` to be productive, and every GEG repo looks the same to reviewers. See [About](#about) for the exact generation command.
>
> **First time on a template-generated project?** Read the rest of this README end-to-end — it documents our conventions.

## Table of contents

- [Quick Start](#quick-start)
- [Getting Started](#getting-started)
- [Repository Setup](#repository-setup)
- [Project Structure](#project-structure)

- [Developers](#developers)

<a id="about"></a>
<details>
<summary><strong>About</strong></summary>

This project was generated from the [GEG Python template](https://gitlab.ethz.ch/geg/templates/python-template) by running:

```bash
uvx --from cookiecutter cookiecutter git@gitlab.ethz.ch:geg/templates/python-template.git
```
</details>

## Quick Start

```bash
cd rag-own-publications
just setup # 'just' is a modern command runner (like 'make' but works for both macOS/Linux AND Windows)
```

That is enough to install dependencies and git hooks so you can work locally.
More information: Don't have `just` → [Getting Started](#getting-started). GitLab remote and first push → [Repository Setup](#repository-setup).


<a id="getting-started"></a>
<details>
<summary><strong>Getting Started</strong></summary>

### 1. Install required tools

[**uv**](https://docs.astral.sh/uv/getting-started/installation/) — manages dependencies and your Python environment.

### 2. Install optional tools (recommended)

[**just**](https://just.systems/man/en/packages.html) — wraps the setup steps into a single `just setup` command. Without it, run the steps manually (see below).
- macOS: `brew install just`
- Linux: see [just installation docs](https://just.systems/man/en/packages.html)
- Windows: `winget install Casey.Just` or `scoop install just`

[**direnv**](https://direnv.net) *(macOS/Linux only)* — auto-activates your environment on `cd` so you never need to run `source .venv/bin/activate` manually. Without it, activate the environment yourself each session (`source .venv/bin/activate` / `.venv\Scripts\Activate.ps1`).
- Install via your package manager (`brew install direnv` / `sudo apt install direnv`)
- Add the shell hook to your rc file: `eval "$(direnv hook zsh)"` or `eval "$(direnv hook bash)"`
- See [direnv hook docs](https://direnv.net/docs/hook.html) for other shells

### 3. Run setup

**With just:**
```bash
just setup
```
Runs `uv sync`, approves `.envrc` if direnv is installed (macOS/Linux), and installs git hooks.

**Without just:**
```bash
uv sync
direnv allow .   # macOS/Linux with direnv only
uv run prek install --hook-type pre-commit --hook-type pre-push --hook-type post-checkout --overwrite
```

> **Windows note:** prek hooks run as shell scripts — [Git for Windows](https://git-scm.com/download/win) (which includes Git Bash) must be installed.

</details>

<a id="repository-setup"></a>
<details>
<summary><strong>Repository Setup</strong></summary>

**Note: One-time action. This section can be deleted after initial setup.**

If you just generated this project from the template, you need to connect it to a remote repository:
1. **Create the remote repository:** Create a new project in
   [GitLab](https://gitlab.ethz.ch/geg) (unless it is already known that the
   project will be released publicly via [GitHub](https://github.com/GEG-ETHZ/)).
   - **Uncheck "Initialize repository with a README"** — the repository must be
     empty so the local history can be pushed without conflicts.
   - *Note: If you run into permissions issues creating the repository, please
      contact the Software Team (e.g., Chad Baker, Anton Kulik).*
1. **Link your local repository:** Follow the [Syncing with Multiple Repos](https://gitlab.ethz.ch/geg/computing-guide/-/wikis/git#syncing-with-multiple-repos) guide to set up your git remotes.
   - *Example:* `git remote add origin git@gitlab.ethz.ch:geg/your-project.git`
1. **Push the initial commit immediately** — before making any deliberate commits.
   This verifies the generated baseline passes CI before you build on top of it.
   ```
   git push -u --no-verify origin main
   ```
   - `--no-verify` skips local pre-push hooks (mypy/pytest) for this push only — **do not use it again.**
   - **If branch protection blocks the push:** first request Owner role from an admin
     (e.g. Chad Baker or Anton Kulik) — this alone may resolve it. If it still blocks,
     temporarily unprotect main in GitLab → Your Project → Settings → Repository →
     Protected Branches, push, then re-enable protection.
1. **GitLab Runner:** The GEG group runner handles CI automatically — no per-project setup needed.
1. **GitLab project settings:** Configure merge rules and branch protection once as a Maintainer, via the GitLab UI (not scripted, to avoid granting agents API access to repository settings).

   **Settings → General → Merge requests:**

   | Setting | Value |
   |---|---|
   | Merge method | Merge commit |
   | Squash commits | Encourage |
   | ☑ Pipelines must succeed | checked |
   | ☑ Delete source branch | checked |

   **Settings → Repository → Protected branches:**

   | Branch | Allowed to merge | Allowed to push and force push |
   |---|---|---|
   | `main` | Maintainers | No one |
   | `develop` | Maintainers | Developers + Maintainers |

   See [Confluence/OPS: Code — GitLab project settings](https://unlimited.ethz.ch/spaces/GEG/pages/441418531/OPS+Code#OPS%3ACode-GitLabprojectsettings) for the full rationale.
1. **Auto-tagging token:** The CI pipeline tags branches on merge (`bak/<branch-name>`) — this needs a one-time token.
   Create a Project Access Token under **Settings → Access Tokens → Add new token**:
   - **Token name**: `GITLAB_PUSH_TOKEN`
   - **Description**: `allows gitlab runner to tag branches`
   - **Expiration date**: leave blank (no expiration)
   - **Role**: Developer
   - **Scope**: `write_repository`

   GitLab shows the token value only once — copy it immediately and add it as a CI/CD variable under **Settings → CI/CD → Variables**:
   - **Key**: `GITLAB_PUSH_TOKEN`
   - **Value**: paste the token here
   - **Visibility**: Masked
   - **Protect variable**: unchecked (protected variables are not injected into unprotected MR branches)

</details>

## Project Structure
Layout of the generated repo.
**Note: This section should be deleted when creating a specific project from this template.**
```text
└── rag-own-publications
    ├── README.md
    ├── pyproject.toml
    ├── .gitignore
    ├── .python-version
    ├── data/        # Raw and processed data files (ignored by git by default)
    ├── outputs/     # Generated figures, reports, and models
    ├── scripts/     # Standalone Python scripts for data processing and analysis
    ├── src/         # Installable Python package source code and project-specific utilities
    │   └── rag-own-publications
    │       └── __init__.py
    ├── tests/       # Unit and integration tests
    │   ├── __init__.py
    │   └── test_demo.py

    └── uv.lock
```

> **Note on Repository Type:** You generated a `standard` repository.
> This layout contains both a standardized data analysis environment (`data`, `outputs`, `scripts`, `tests`) and an installable Python library in `src/`.
> If you find you do not need the data science folders, you may safely delete them.

**Tip:** To regenerate this tree, run:
`tree -I '__pycache__|.venv|*.egg-info|.git'`
(If tree isn't installed run: `brew install tree`)



<a id="developers"></a>
<details>
<summary><strong>Developers</strong></summary>

### Branching Strategy
Explained [here](./CONTRIBUTING.md#branching-strategy).

### Running Checks
- **Tests:** `uv run pytest -v`
- **Linting:** `uv run ruff check .`
- **Formatting:** `uv run ruff format .` (use `--check` to verify without modifying)
- **Type checking:** `uv run mypy src/`
</details>
