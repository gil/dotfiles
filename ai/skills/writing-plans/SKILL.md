---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
disable-model-invocation: true
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each step, code, testing, docs they might need to check, how to test it. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

## Plan Layout

A plan is a directory, not a single file. Save to `docs/plans/YYYY-MM-DD-<feature-name>/`:

```
docs/plans/2026-07-17-user-auth/
├── step-000-overview.md          shared context every step needs
├── step-001-<description>.md     one self-contained unit of work
├── step-002-<description>.md
└── ...
```

- (User preferences for plan location override this default)

Each step file is designed to be executed in its own clean agentic session, with no memory of the brainstorming, the spec discussion, or the other steps. The executing agent reads exactly two things: `step-000-overview.md` and its own step file. Write every step for that reader. If a step needs a fact, put the fact in the step file or in the overview. "As discussed above" or "see the previous step" are broken references in this format.

`step-999-leftovers.md` is reserved. Never create it at planning time. It only comes into existence if execution has to postpone work (the executing-plans skill owns that). Never number a real step 999.

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans, one per subsystem. Each plan should produce working, testable software on its own.

## File Structure

Before defining steps, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure. But if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the step decomposition. Each step should produce self-contained changes that make sense independently.

## Step Right-Sizing

Each step runs in its own clean session. That drives sizing in both directions.

**Too small wastes sessions.** A step is not a single test cycle. Every session pays a fixed cost: reading the overview, the step file, and the relevant code. If two chunks of work share that context, splitting them means paying that cost twice for nothing. Group work that shares a working set (same files, same component, same concepts) into one step. A step typically bundles several test-and-commit cycles around one cohesive deliverable; the bite-sized actions inside it carry the individual cycles.

**Too large pollutes the session.** When a step mixes unrelated concerns, context from one becomes noise for the other, and a long session risks running out of room before wrap-up. Split at the point where the working set changes: if the executor would put down one group of files and pick up a different one, that's a step boundary.

**Cohesion test:** can you title the step honestly without "and" joining unrelated things? "Token issuing and refresh" is one working set, one step. "Token issuing and settings page" is two steps.

When drawing boundaries, fold setup, configuration, scaffolding, and documentation into the step whose deliverable needs them. Each step ends with an independently testable deliverable that a reviewer could accept or reject on its own.

## Bite-Sized Action Granularity

Within a step, each checkboxed action is one thing (2-5 minutes):

- "Write the failing test" - action
- "Run it to make sure it fails" - action
- "Implement the minimal code to make the test pass" - action
- "Run the tests and make sure they pass" - action
- "Commit" - action

## Overview File

**Every plan MUST have a `step-000-overview.md` following this template:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** You are executing one step of this plan in a clean
> session with no prior context. Read this overview fully, then read your
> assigned step file. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

**Spec:** [path to the design doc this plan implements, if one exists]

## Global Constraints

[The spec's project-wide requirements, such as version floors, dependency
limits, naming and copy rules, platform requirements. One line each, with
exact values copied verbatim from the spec. Every step's requirements
implicitly include this section.]

## Steps

- [ ] `step-001-<description>.md`: [one-line deliverable]
- [ ] `step-002-<description>.md`: [one-line deliverable]

[State ordering: which steps depend on which, and which could run in any
order. Executors check a step off here when it's done, so this list is also
the plan's progress tracker across sessions.]

## Leftovers Protocol

Finishing your step completely is the goal. `step-999-leftovers.md` is a
last resort for work that genuinely cannot happen in your session (a missing
credential, an upstream bug, a discovery that changes scope). It is not a
place to park work that is hard, boring, or long.

If you must defer something, append an entry to `step-999-leftovers.md` in
this directory (create the file if it doesn't exist):

### [step file] - [short title]

- **What:** the undone work, specific enough to act on without your
  session's context
- **Why deferred:** the concrete blocker
- **Where:** files and tests involved
- **Done when:** how to verify it's resolved

Write down everything you defer. If it's not done and not in leftovers,
it's lost.
```

## Step File Structure

````markdown
# Step N: [Component Name]

> Read `step-000-overview.md` in this directory before starting. It has the
> goal, architecture, global constraints, and leftovers protocol that apply
> to every step. This file assumes you have read it.

**Depends on:** [step files whose deliverables this step uses, or "none"]

**Files:**

- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Interfaces:**

- Consumes: [what this step uses from earlier steps, with exact signatures
  repeated here. The implementer cannot see the other step files; this
  block is how they learn the names and types neighboring steps use.]
- Produces: [what later steps rely on, with exact function names, parameter
  and return types]

- [ ] **Action 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Action 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Action 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Action 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Action 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```

## Wrap-Up

- [ ] Check this step off in the Steps list of `step-000-overview.md`
- [ ] Only if something could not be finished: record it in
      `step-999-leftovers.md` per the overview's Leftovers Protocol
````

## No Placeholders

Every action must contain the actual content an engineer needs. These are **plan failures**, never write them:

- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to step N" (repeat the code; the executor sees only their own step file and the overview)
- Actions that describe what to do without showing how (code blocks required for code changes)
- References to types, functions, or methods not defined in the same step file or the overview

## Remember

- Exact file paths always
- Complete code in every action; if an action changes code, show the code
- Exact commands with expected output
- DRY, YAGNI, TDD, frequent commits

## Self-Review

After writing the complete plan, look at the spec with fresh eyes and check the plan against it. This is a checklist you run yourself, not a subagent dispatch.

**1. Spec coverage:** skim each section or requirement in the spec. Can you point to a step that implements it? List any gaps.

**2. Placeholder scan:** search your plan for the red flags in the "No Placeholders" section above. Fix them.

**3. Type consistency:** do the types, method signatures, and property names used in later steps match what earlier steps define? A function called `clearLayers()` in step 3 but `clearFullLayers()` in step 7 is a bug.

**4. Clean-session check:** for each step file, could an agent holding only that file plus the overview execute it? Any reference to a decision, name, or detail that lives only in another step file (or only in this conversation) is a bug. Copy the needed detail into the step or the overview.

If you find issues, fix them inline. No need to re-review, just fix and move on. If you find a spec requirement with no step, add the step.

## Execution Handoff

You MUST STOP after saving the plan, don't run any other skill or start with the implementation.
