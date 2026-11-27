---
name: commit
description: Commit pending dotfiles changes as separate, isolated commits per logical change.
disable-model-invocation: true
---

# Commit dotfiles changes

The working tree may hold several unrelated changes. Turn them into a series of
small commits, one logical change each. Never lump unrelated changes together.

## 1. Survey

```shell
git status --short --untracked-files=all
git diff            # unstaged
git diff --cached   # anything already staged
git log --oneline -15   # match the existing style
```

Untracked directories can be huge. Use plain `git status --short` first, and only expand
a directory when you need to judge it.

## 2. Triage untracked files

For each untracked path decide: **real config to track**, or **generated/runtime/cache
state** (history, sessions, caches, logs, backups, telemetry, plugin installs, `.bak`
files, editor swap/undo files, etc.).

- Real config → commit it as a new file in its package.
- Runtime state → add a pattern to that package's own `.gitignore`
  (`<package>/.gitignore`, with paths relative to the package root, mirroring `$HOME`, e.g.
  `.claude/cache/` in `claude/.gitignore`). Create the file if missing. Do not edit a
  root-level `.gitignore`, and never add to `.gitignore` something that's already tracked.
- Prefer a few broad patterns over one line per file, but don't ignore tracked config.
  Check what is already tracked with `git ls-files <package>` first.
- If it's unclear whether an untracked file is config or state, ask the user.
- **Never commit secrets** (keys, tokens, credentials) — ignore them, or leave them
  alone and flag them.
- Don't ignore anything that looks like intentional new work, even if it is untracked
  (e.g. a whole new package dir like `rex/`, or `sort.py`) — ask the user instead.

Verify each ignore change with `git status --short` (the paths should disappear) before
committing.

## 3. Group into commits

- One commit per Stow package (top-level dir, or `local/<env>/<os>/<package>`) at minimum.
- Within a package, split further if the diff contains unrelated changes. Use
  `git diff <file>` to inspect hunks, and stage selectively with
  `git add -p` alternatives that work non-interactively (e.g. build a patch and use
  `git apply --cached`), since interactive mode isn't supported.
- Ignore-file changes get their **own commit**, separate from feature changes in the same
  package: `claude: Ignore runtime state`.
- Order commits so ignore commits come first, then the rest.

## 4. Message convention

`<package>: <Sentence-case description>`

- `<package>` is the Stow package name: the directory directly under the stow dir
  (`zsh`, `claude`, `git`, `tmux`, `vim`...). For `local/<env>/<os>/<package>/...`, use
  just `<package>`.
- Description: imperative mood, sentence case, no trailing period, concise
  (`zsh: Add gh completion`, `htop: Update config for htop 3.4.1`).
- A change spanning files that aren't in a package (repo root, e.g. `AGENTS.md`,
  `README.md`) has no prefix: `Update AGENTS.md`. Changes in `stow/` use `stow:`.
- Describe the *why/what* from reading the diff - don't guess. If the intent isn't clear
  from the diff, ask.

## 5. Commit

For each group, stage only its files by explicit path (never `git add -A` / `git add .`),
confirm with `git diff --cached --stat`, then commit. End the message with the
attribution line(s) from the system context, if provided.

```shell
git add <paths>
git diff --cached --stat
git commit -m "<package>: <Description>"
```

Do not push. Finish with `git log --oneline -<n>` and `git status --short`, then report
what was committed and anything deliberately left uncommitted.
