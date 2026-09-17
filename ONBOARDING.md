# Sales Team Skills — One-Time Setup

This gets you the team's shared sales tools set up in Claude Code. You only
do this once, ever, on each computer you use. After this, everything stays
up to date on its own — you'll never need to run anything again.

You don't need to know what any of the words below mean, or open a Terminal
yourself, or click through any installers. Just tell Claude Code to do it.

---

## Step 1 — Open Claude Code and paste this message

```
Please set up the shared sales team skills for me:
1. Check if git is installed. If it isn't, install it yourself (prefer
   `brew install git`, or the small git-scm.com installer — not Apple's
   Xcode Command Line Tools, which is a ~14GB download we don't need here).
2. Run: git clone https://github.com/Luthox/sales.git ~/sales
3. Run: bash ~/sales/install.sh
```

## Step 2 — Approve whatever it asks

Claude Code may ask permission before running a command or installing
something — just approve those when they come up. That's normal, and it's
the only thing you need to do.

## Step 3 — You're done

That's it. From now on:

- **You never need to do this again.** Whenever anyone on the team fixes a
  tool or updates the target-customer criteria, you get it automatically
  the next time you use any sales skill in Claude Code — it quietly checks
  for updates on its own, every time.
- **You'll only see this again if a brand-new tool gets added** to the
  shared kit later — we'll let you know if and when that happens.

If Claude Code reports an error at any point, just paste that error back to
whoever's helping you set this up, rather than trying to guess a fix — it's
much faster to solve from the actual message than from a description of it.

---

## Not sure what any of this does?

In plain terms: there's one shared, online "master copy" of our sales tools
and our target-customer definition. This setup links your Claude Code to
that master copy instead of giving you a personal, disconnected copy —
so when it gets updated, yours updates too, without you doing anything.
