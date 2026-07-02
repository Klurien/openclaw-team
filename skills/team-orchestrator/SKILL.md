---
name: team-orchestrator
description: "Orchestrate a software engineering team of AI agents: planner, coder, reviewer, tester, documenter. Each agent has specialized tools and works in parallel."
metadata:
  {
    "openclaw":
      {
        "emoji": "👥",
        "requires": { "bins": ["opencode", "gh", "git", "node"] },
      },
  }
---

# Team Orchestrator

You are the team lead. Break down work into subtasks and delegate to specialized agents. Each agent works in its own workspace with full tool access.

## Team Roles

| Role | Agent | Tools |
|------|-------|-------|
| **Planner** | opencode | Architecture design, task breakdown, spec writing |
| **Coder** | opencode | Implementation, refactoring, testing |
| **Reviewer** | opencode | Code review, linting, security audit |
| **Documenter** | opencode | README, API docs, inline comments |
| **Data Analyst** | Python/node | Charts, stats, data viz |

## Workflow

### 1. Planning Phase
```bash
# Create project workspace
WORKSPACE=$(mktemp -d)
mkdir -p "$WORKSPACE"/{src,tests,docs,plans}

# Write the plan
opencode run --workdir "$WORKSPACE" --prompt "Create a detailed implementation plan in plans/PLAN.md covering: architecture, file structure, data flow, API design, testing strategy"
```

### 2. Delegation Phase
For each subtask, launch a background agent:
```bash
opencode run --workdir "$WORKSPACE" --background --pty --session-id "coder-1" \
  --prompt "Implement the feature described in plans/PLAN.md section 3. Write tests in tests/. Run tests after implementation."
```

### 3. Review Phase
```bash
# Auto-review all changes
opencode run --workdir "$WORKSPACE" --session-id "reviewer-1" \
  --prompt "Review all uncommitted changes in src/ and tests/. Check for: bugs, edge cases, security issues, code style. Use 'opencode run' for deep analysis of any file."
```

### 4. Integration
```bash
# Merge reviewed changes
git -C "$WORKSPACE" add -A && git -C "$WORKSPACE" commit -m "feat: implemented planned feature"
gh pr create --repo owner/repo --title "feat: feature name" --body-file "$WORKSPACE/plans/PLAN.md"
```

## GitHub Integration

Always start by cloning or forking the target repo:
```bash
gh repo clone owner/repo "$WORKSPACE/repo"
git -C "$WORKSPACE/repo" checkout -b feat/feature-name
```

After implementation:
```bash
cd "$WORKSPACE/repo"
git add -A && git commit -m "feat: description"
gh pr create --fill --web
gh pr view --json title,body,additions,deletions,files
```

## Knowledge Base Integration

Store project context and decisions:
```bash
# Create knowledge entry
mkdir -p "$WORKSPACE/.knowledge"
cat > "$WORKSPACE/.knowledge/architecture.md" << 'EOF'
# Architecture Decision Record
## Date: $(date +%Y-%m-%d)
## Decision: ...
## Rationale: ...
EOF

# Link related notes
echo "See also: plans/PLAN.md, src/core/module.ts" >> "$WORKSPACE/.knowledge/architecture.md"
```

## Progress Tracking

After each phase, update status:
```bash
echo "## Status: $(date)" >> "$WORKSPACE/STATUS.md"
echo "- Phase: [current phase]" >> "$WORKSPACE/STATUS.md"
echo "- Completed: [task list]" >> "$WORKSPACE/STATUS.md"
echo "- Blockers: [if any]" >> "$WORKSPACE/STATUS.md"
```

## Token Saving

- Use **opencode** with `--small-model` for simple tasks (linting, formatting, docs)
- Use **opencode** default model for complex implementation
- Cache results with: `opencode run --cache --prompt "..."`  
- Summarize long outputs before feeding to next agent
- Use `diff` output instead of full file content when reviewing changes

## Data Visualization

Generate charts using Node.js scripts:
```bash
cat > /tmp/chart.mjs << 'SCRIPT'
import { createCanvas } from 'canvas';
const canvas = createCanvas(800, 400);
const ctx = canvas.getContext('2d');
// Draw chart...
canvas.createPNGStream().pipe(require('fs').createWriteStream('/tmp/chart.png'));
SCRIPT
node /tmp/chart.mjs
```

Or use Python:
```bash
python3 -c "
import matplotlib.pyplot as plt
plt.plot([1,2,3], [4,5,6])
plt.savefig('/tmp/chart.png')
"
```

For quick tables, use markdown:
```markdown
| Metric | Value |
|--------|-------|
| Files changed | 12 |
| Tests added | 45 |
| Coverage | 92% |
```

## Hard Rules

1. Always use `--background` for long-running agents
2. Always capture agent output for review
3. Never run agents on the openclaw state directory
4. Use isolated temp directories for each task
5. Clean up temp directories after completion
6. Report progress to the user after each phase
7. If an agent fails, diagnose and retry before escalating
8. Keep the user informed with status summaries
