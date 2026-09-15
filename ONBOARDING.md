# Sales Team Skills — One-Time Setup

This gets you the team's shared sales tools set up in Claude Code. You only
do this once, ever, on each computer you use. After this, everything stays
up to date on its own — you'll never need to run anything again.

Takes about 5 minutes if everything's already in place, and a bit longer the
first time if your Mac needs one extra download (explained below — totally
normal, not a mistake on your part).

---

## Step 1 — Check if you already have Git

Open the Terminal inside Claude Code (or a regular Terminal window) and run:

```bash
git --version
```

**If it prints something like `git version 2.43.0`** → great, skip straight
to Step 2.

**If instead you see a message about "command line developer tools" and/or
a popup appears asking to install something** → don't click Install on that
popup. It's real, but it downloads a 14GB Apple package you don't actually
need just for this. Do this instead:

1. If that popup is still open, click **Cancel**.
2. Go to **[git-scm.com/download/mac](https://git-scm.com/download/mac)**
   and download the Git installer (a normal, small ~200MB `.pkg` file).
3. Open it and click through like any normal Mac install (Continue, Continue,
   Install).
4. Run `git --version` again to confirm — it should now print a version
   number.

Either way, once `git --version` shows a real version, move to Step 2.

---

## Step 2 — Run the one-time setup command

Copy-paste this whole line into the same Terminal and press Enter:

```bash
git clone https://github.com/YHavshush/sales.git ~/sales && bash ~/sales/install.sh
```

You'll see a list of lines like `linked sales-prospect` scroll by — that's
it doing its job. If your Mac already had some of these tools installed
under different names, it backs those up safely first (nothing is ever
deleted) before switching you over to the shared team versions.

---

## Step 3 — You're done

That's it. From now on:

- **You never need to run any of this again.** Whenever anyone on the team
  fixes a tool or updates the target-customer criteria, you get it
  automatically the next time you use any sales skill in Claude Code — it
  quietly checks for updates on its own, every time.
- **You'll only ever see this setup again if a brand-new tool gets added**
  to the shared kit later — we'll let you know if and when that happens.

If anything about Step 2 doesn't work or looks different from what's
described here, stop and send whatever error message you see rather than
guessing — it's much faster to fix from the actual error than from a
description of it.

---

## Not sure what any of this does?

In plain terms: there's one shared, online "master copy" of our sales tools
and our target-customer definition. This setup links your Claude Code to
that master copy instead of giving you a personal, disconnected copy —
so when it gets updated, yours updates too, without you doing anything.
