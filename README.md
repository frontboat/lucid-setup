# Lucid Agents "From Zero" Starter Pack

Going from 0 - 1

This is just a script that sets up projects the same way I do when starting to work on a new Lucid Agent. TLDR: Bun create hono@lateset + bun install lucid packages. no code or anything just template.

## Requirements

- [Bun](https://bun.sh) must be installed. Check the link to their docs to install, it's quick and easy.

## Usage

1. Open terminal using <kbd>⌘</kbd> + <kbd>Space</kbd>

2. Type "terminal" and press <kbd>Enter</kbd>

3. Create a folder to store your projects (you probably don't want these in your home folder):
   ```bash
   mkdir projects
   ```
   > You can replace `projects` with whatever you want to call it

4. Navigate to your new folder:
   ```bash
   cd projects
   ```
   > If you chose a different name for `projects` in the previous step, use that name instead

5. Copy one of these commands, paste it in terminal, and press <kbd>Enter</kbd>:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/frontboat/lucid-setup/main/install.sh | bash
   ```
   > Or with a custom project name (you can change the "my-app" to something different if you like. This command does the same thing as the above). Only one is needed
   ```bash
   curl -fsSL https://raw.githubusercontent.com/frontboat/lucid-setup/main/install.sh | bash -s my-app
   ```

6. After it completes, navigate to your new project:
   ```bash
   cd lucid-quickstart
   ```

That's all. No agents implemented yet. Think of where you are now as: *"Okay, we're set up to build an agent from here. Let's boot up Claude Code and add the lucid-agents-sdk skills."*

#### Extra - What just happened?

The `curl` command did 2 things:

1. Ran `bun create hono@latest lucid-quickstart --template bun --pm bun --install` — the official Bun + Hono quickstart template
2. Installed the latest Lucid Agents SDK packages with `bun add @lucid-agents/a2a @lucid-agents/analytics` etc.

#### What it installs

All Lucid Agents packages:

- `@lucid-agents/a2a` — Agent-to-agent communication
- `@lucid-agents/analytics` — Usage analytics
- `@lucid-agents/ap2` — AP2 protocol support
- `@lucid-agents/api-sdk` — API SDK
- `@lucid-agents/cli` — CLI tools
- `@lucid-agents/core` — Core functionality
- `@lucid-agents/express` — Express adapter for Express Servers
- `@lucid-agents/hono` — Hono adapter (what we are using here)
- `@lucid-agents/http` — HTTP utilities (All servers)
- `@lucid-agents/identity` — ERC-8004 identity
- `@lucid-agents/payments` — X402 payments
- `@lucid-agents/scheduler` — Task scheduling
- `@lucid-agents/tanstack` — TanStack adapter
- `@lucid-agents/types` — TypeScript types
- `@lucid-agents/wallet` — Wallet integration
