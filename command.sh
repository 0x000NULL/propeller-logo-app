#!/usr/bin/env bash
#
# Task 1 - Collaborate Using GitHub with Propeller
#
# Every Git and GitHub CLI command used to scaffold the app, publish it, make the
# logo change on a branch, and land it through a reviewed pull request.
#
# REPO_URL https://github.com/0x000NULL/propeller-logo-app
#
# Prerequisites: Node.js and npm, Git, and GitHub CLI authenticated via `gh auth login`.

set -euo pipefail


# ---------------------------------------------------------------------------
# 1. Create the React application with create-react-app
# ---------------------------------------------------------------------------
npx create-react-app@latest propeller-logo-app
cd propeller-logo-app


# ---------------------------------------------------------------------------
# 2. Commit the code and create the GitHub repository with GitHub CLI
#
# create-react-app already runs `git init` and makes the first commit, so the
# init and commit below are no-ops on a fresh scaffold. They are included
# because the repository would need them if the app came from anywhere else.
# -b master sets the initial branch name, since the PR target is master.
# ---------------------------------------------------------------------------
git init -b master
git add .
git commit -m "Initial commit: create-react-app scaffold"

# --source=. links the new remote repo to this working copy and --push sends
# the existing history straight up, so no separate `git remote add` is needed.
gh repo create propeller-logo-app --public --source=. --remote=origin --push


# ---------------------------------------------------------------------------
# 3. Switch to the update_logo branch
# ---------------------------------------------------------------------------
git checkout -b update_logo


# ---------------------------------------------------------------------------
# 4 & 5. Replace the logo and the link in src/App.js
#
# Edited by hand rather than scripted, so the change is reviewable in the PR:
#
#   - Removed the `import logo from './logo.svg'` bundled asset and pointed the
#     <img> at the Propeller Aero footer logo:
#     https://cdn-ikponof.nitrocdn.com/vGqfYAGlOLDkYkJqZhYIYKEsibdbZnkc/assets/images/optimized/rev-f684a87/www.propelleraero.com/wp-content/uploads/2023/05/footer-logo.svg
#
#   - Changed the anchor href from https://reactjs.org to
#     https://www.propelleraero.com/dirtmate/ and updated its label and the
#     image alt text to match.
# ---------------------------------------------------------------------------
git --no-pager diff --stat


# ---------------------------------------------------------------------------
# 6. Commit, then push the code
# ---------------------------------------------------------------------------
git add src/App.js
git commit -m "Replace React logo with Propeller Aero logo and link to DirtMate"
git push -u origin update_logo


# ---------------------------------------------------------------------------
# 7. Create the PR from update_logo to master with GitHub CLI
# ---------------------------------------------------------------------------
gh pr create \
  --base master \
  --head update_logo \
  --title "Update logo and link to Propeller Aero DirtMate" \
  --body "Replaces the default React logo with the Propeller Aero footer logo and points the call-to-action link at the DirtMate product page."


# ---------------------------------------------------------------------------
# 8. Merge the PR with GitHub CLI
#
# In a real team another engineer reviews and approves first. GitHub does not
# allow approving your own pull request, so the approval step is skipped here
# as the task notes. --delete-branch tidies up the merged branch.
# ---------------------------------------------------------------------------
gh pr merge 1 --merge --delete-branch


# ---------------------------------------------------------------------------
# Verify the result
# ---------------------------------------------------------------------------
gh pr view 1 --json number,state,mergedAt,url
git checkout master
git pull
git --no-pager log --oneline -5
