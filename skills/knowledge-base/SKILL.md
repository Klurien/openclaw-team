---
name: knowledge-base
description: "Obsidian-like modular knowledge base with bidirectional links, graph view, tag system, and semantic recall. All notes are plain Markdown."
metadata:
  {
    "openclaw":
      {
        "emoji": "🧠",
        "requires": { "bins": ["node"] },
      },
  }
---

# Knowledge Base

Manage a persistent knowledge base of linked Markdown notes. The vault lives at `~/.openclaw/vault/`.

## Structure

```
~/.openclaw/vault/
├── index.md              # Main entry point with graph of all topics
├── projects/             # Project-specific knowledge
│   ├── project-name.md
│   └── decisions/
├── concepts/             # General concepts and patterns
├── people/               # People and contacts
├── learnings/            # Lessons learned, gotchas
├── daily/                # Daily notes (YYYY-MM-DD.md)
└── .tags/                # Auto-generated tag indices
```

## Note Format

Every note uses bidirectional links with `[[Wiki Links]]`:

```markdown
---
tags: [architecture, decision]
created: 2026-07-02
---

# Title

Key content here.

## Related
- [[Related Note]] — why this matters
- [[Another Note]] — context

## References
- Source: URL
```

## Commands

### Create a note
```bash
mkdir -p ~/.openclaw/vault/projects
cat > ~/.openclaw/vault/projects/feature-x.md << 'EOF'
---
tags: [project, feature-x]
created: $(date +%Y-%m-%d)
---
# Feature X

## Overview
Description here.

## Decisions
- [[ADR-001]] — Why we chose this approach

## Related
- [[Concept Y]]
EOF
```

### Search notes
```bash
grep -r "search term" ~/.openclaw/vault/ --include="*.md" -l
```

### Show tag index
```bash
grep -rh "^tags:" ~/.openclaw/vault/ --include="*.md" | sort | uniq -c | sort -rn
```

### Find linked notes (backlinks)
```bash
grep -rl "\[\[Note Name\]\]" ~/.openclaw/vault/ --include="*.md"
```

### Generate graph data
```bash
node -e "
const fs = require('fs'), path = require('path');
const vault = '${HOME}/.openclaw/vault';
const files = fs.readdirSync(vault, {recursive: true}).filter(f => f.endsWith('.md'));
const nodes = [], links = [];
for (const f of files) {
  const content = fs.readFileSync(path.join(vault, f), 'utf-8');
  const name = path.basename(f, '.md');
  nodes.push({id: name, file: f});
  const matches = content.match(/\[\[([^\]]+)\]\]/g) || [];
  for (const m of matches) {
    links.push({source: name, target: m.slice(2, -2)});
  }
}
fs.writeFileSync('/tmp/graph.json', JSON.stringify({nodes, links}, null, 2));
console.log('Graph: ' + nodes.length + ' nodes, ' + links.length + ' links');
"
```

### Daily note
```bash
NOTE=~/.openclaw/vault/daily/$(date +%Y-%m-%d).md
if [ ! -f \"\$NOTE\" ]; then
  cat > \"\$NOTE\" << EOF
---
tags: [daily]
created: $(date +%Y-%m-%d)
---
# $(date +%Y-%m-%d)

## Today
- 

## Notes
- 

## Links
EOF
fi
echo "Daily note: \$NOTE"
```

## Recall Queries

### Semantic search (find related by tags)
```bash
grep -rl "tags:.*\[\[query\]\]" ~/.openclaw/vault/ --include="*.md" | head -10
```

### Recent changes
```bash
find ~/.openclaw/vault/ -name "*.md" -newer /tmp/.kb-mark -printf '%T+ %p\n' | sort -r | head -10
touch /tmp/.kb-mark
```

### Decision history
```bash
grep -rl "tags:.*\[\[decision\]\]" ~/.openclaw/vault/ --include="*.md" | while read f; do
  echo "=== $(basename \$f .md) ==="
  head -3 "\$f"
done
```
