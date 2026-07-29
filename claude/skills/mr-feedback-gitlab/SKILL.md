---
name: mr-feedback-gitlab
description: This skill fixes feedback on a branch by fetching MR comments from GitLab and addressing them.
---

# MR Feedback Skill

Start by using `glab mr view --comments -P 1000` to get all MR feedback comments
from the current branch.

When addressing feedback:

1. Look at all comments before starting, sometimes one comment supersedes
   another one.
