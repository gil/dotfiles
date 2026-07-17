---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints
disable-model-invocation: true
---

# Executing Plans

## Overview

Plans live in `docs/plans/YYYY-MM-DD-<feature-name>/`, one file per step. Each step file is written so it can run in a clean session with no prior context, as long as you read the overview first.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

## The Process

### Step 1: Load Context

1. Read `step-000-overview.md` in the plan directory. It has the goal, architecture, global constraints, the step list, and the leftovers protocol.
2. Pick your step: the one the user named, or the first unchecked entry in the overview's Steps list. Respect the ordering the overview declares.
3. If `step-999-leftovers.md` exists, read it. If an entry blocks or overlaps your step, raise it with your human partner before starting.
4. Read your step file fully.
5. Review it critically. If you have questions or concerns, raise them before starting. If not, create todos for the step's actions and proceed.

If the user asks you to run several steps in one session, run them one at a time, each with its own wrap-up.

### Step 2: Execute the Step

For each action in the step file:

1. Mark as in_progress
2. Follow it exactly (the plan has bite-sized actions)
3. Run verifications as specified
4. Check it off in the step file and mark it completed

### Step 3: Wrap Up

1. Check the step off in the Steps list of `step-000-overview.md` so the next session sees accurate progress.
2. Only if something could not be finished: record it in `step-999-leftovers.md` (see below).
3. Report what was done, what was verified, and anything you deferred.

## Leftovers: Last Resort, Not a Parking Lot

Finish your step completely. That is the whole point of the format. Deferring work to `step-999-leftovers.md` is for things that genuinely cannot happen in this session: a missing credential, a bug in a dependency, a discovery that invalidates part of the plan. Hard, tedious, or long work does not qualify. Before deferring anything, ask yourself whether you're blocked or avoiding.

When you truly must defer, write it down completely, following the Leftovers Protocol in the overview: what remains, why it was deferred, which files and tests are involved, and how to tell when it's resolved. Write for a future session with none of your context. The entry is the only thing standing between that work and being forgotten. If it's not done and not in leftovers, it's lost.

Never end a session with undone work that exists only in your head or your final message.

## When to Stop and Ask for Help

**STOP executing immediately when:**

- Hit a blocker (missing dependency, test fails, instruction unclear)
- The step has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Load Context (Step 1) when:**

- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Remember

- Read the overview before the step file, every session
- Review the step critically first
- Follow actions exactly, don't skip verifications
- Keep the overview's Steps list current
- Deferred work goes in `step-999-leftovers.md`, always written down, never assumed remembered
- Stop when blocked, don't guess
- Never start implementation on main/master branch without explicit user consent
