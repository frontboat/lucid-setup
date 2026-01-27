# Lucid Agents Install Script

A quick-start installer for creating Bun + Hono projects with [Lucid Agents](https://github.com/daydreamsai/lucid-agents) packages pre-configured.

## Usage

```bash
curl -fsSL https://raw.githubusercontent.com/frontboat/lucid-setup/main/install.sh | bash
```

Or with a custom project name:

```bash
curl -fsSL https://raw.githubusercontent.com/frontboat/lucid-setup/main/install.sh | bash -s my-app
```

## Requirements

- [Bun](https://bun.sh) must be installed

## What it does

1. Creates a new Bun + Hono project using `bun create hono@latest`
2. Installs all Lucid Agents packages:
   - `@lucid-agents/a2a` - Agent-to-agent communication
   - `@lucid-agents/analytics` - Usage analytics
   - `@lucid-agents/ap2` - AP2 protocol support
   - `@lucid-agents/api-sdk` - API SDK
   - `@lucid-agents/cli` - CLI tools
   - `@lucid-agents/core` - Core functionality
   - `@lucid-agents/express` - Express adapter
   - `@lucid-agents/hono` - Hono adapter
   - `@lucid-agents/http` - HTTP utilities
   - `@lucid-agents/identity` - ERC-8004 identity
   - `@lucid-agents/payments` - X402 payments
   - `@lucid-agents/scheduler` - Task scheduling
   - `@lucid-agents/tanstack` - TanStack adapter
   - `@lucid-agents/types` - TypeScript types
   - `@lucid-agents/wallet` - Wallet integration

## Safety features

- Validates project name (alphanumeric, hyphens, underscores only)
- Checks if directory already exists before creating
- Cleans up partial installations on failure or interruption (Ctrl+C)
- Terminates child processes on exit
- Shows error output when commands fail
