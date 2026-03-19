---
name: buildmate:version
description: Show current Buildmate version and installation info.
tools: Read, Bash
---

# /buildmate:version - Show Version

Display current Buildmate version and installation details.

## Usage

```
/buildmate:version
```

## Output

```
📦 Buildmate Version Info

Version: 1.25.1
Installation: Global (Claude Code)
Location: ~/.claude/buildmate-core/

Components:
- Commands: 29
- Agents: 7
- Runtime: Claude Code

Update check:
/buildmate:update --check
```

## Steps

<step name="read_version">
```bash
# Read version from package.json
cat ~/.claude/buildmate-core/package.json 2>/dev/null | jq -r '"Buildmate v\(.version)"' || echo "Buildmate (version unknown)"

# Count commands
ls ~/.claude/commands/buildmate/*.md 2>/dev/null | wc -l

# Count agents
ls ~/.claude/agents/buildmate-*.md 2>/dev/null | wc -l
```
</step>

<step name="display_info">
```
📦 Buildmate

Version: [version]
Location: ~/.claude/buildmate-core/

Components:
- Commands: [count]
- Agents: [count]

Check for updates: /buildmate:update --check
```
</step>
