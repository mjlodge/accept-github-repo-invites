# accept-github-repo-invites
Invited to join lots of repos but don't want to accept by clicking each one? This script bulk accepts repo invites

# The problem

A company I was working with had over 100 repos on GitHub and invited me individually to each
one (using a script). So I needed a script to accept all of those invitations vs. clicking on
all of them one-by-one in the UI.

# Usage

In GitHub's UI go to Settings->Developer Settings. Create a "Classic" PAT for your account and
git it repo and admin privileges. Very important: do not create a fine-grained PAT, which
is scoped to a single repo -- it won't work for this script.

Copy the PAT and then paste it into the following command to run the script:

GITHUB_TOKEN="your-token-here" ./accept_repo_invitations.sh

The script will accept up to 100 invitations in a single run. If you have >100 invitations,
just run the script again and it will accept the next 100. Keep going until there are
no invitations left.
