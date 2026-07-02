# Open Design — AI Design System Platform

Integrates with Open Design (http://127.0.0.1:7456), a design system platform
with 149+ brand design systems (Apple, Stripe, OpenAI, xAI, Spotify, etc.)
and 12 craft rules for design quality.

## API

Base URL: `http://127.0.0.1:7456/api`
Auth: `Authorization: Bearer OD_API_TOKEN`

## Available Tools

### List design systems
`GET /api/design-systems` → List all 149 design systems with metadata

Use to find the right design system for a task. Each entry has:
- `id` (e.g. "stripe", "apple", "openai", "x-ai")
- `title` (human readable name)
- `category` (e.g. "E-Commerce", "AI & ML", "Themed & Unique")
- `summary` (short description)
- `swatches` (brand color palette)
- `surface` (web, mobile, etc.)

### Get design system details
`GET /api/design-systems/:id` → Full design system spec including:
- `body` — full DESIGN.md documentation (colors, typography, spacing, components)
- `designSystem` — structured design tokens
- `swatches` — color palette

Use to get the full design language before generating an artifact.

### List craft rules
`GET /api/craft` → List 12 craft rules:
- accessibility-baseline, animation-discipline, anti-ai-slop
- color, form-validation, laws-of-ux, rtl-and-bidi
- state-coverage, typography (3 variants)

### List prompt templates
`GET /api/prompt-templates` → Available prompt templates

### List plugins
`GET /api/plugins` → Available plugins (design systems, examples, atoms)

## Workflow

1. **Pick a design system**: List them, pick one matching the brand vibe
2. **Study the design language**: Get the DESIGN.md body for colors/tokens
3. **Review craft rules**: Get accessibility, typography, color rules
4. **Generate the artifact**: Use the design system tokens + craft rules to create HTML/CSS that matches the brand

## Best Practices

- Always fetch the design system body to get exact color hexes, font stacks, spacing units
- Apply craft rules: accessibility baseline + color + typography at minimum
- Use swatches for the primary/secondary/accent color palette
- Stay faithful to the design system's component vocabulary
- Never use lorem ipsum — use real content
- When generating HTML, embed styles in `<style>` tags for portability
