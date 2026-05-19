# pipeline-demo

The starter project for [`@jahbini/pipeline`](https://github.com/jahbini/pipeline).
Clone, install, run — and in under a minute you'll see the shipped
test pipeline execute end-to-end and print a friendly hand-off
message telling you where to go next.

This repo is intentionally small. It exists to answer the question
*"I just heard about @jahbini/pipeline, what do I actually do?"*

## What you get

A `package.json` with three things in it:

- A `dependencies` block that pulls the runner from GitHub.
- A `scripts` block that wires the four lifecycle commands you'll
  use (`setup`, `pipeline`, `ui`, `clean`).
- Nothing else. No source code, no recipes, no overrides — those
  all come from the runner package or get scaffolded on first run.

## Prerequisites

- **Node 20+** — the runner uses CoffeeScript and node:sqlite.
- **Python 3.10+** — only if you'll exercise the MLX surface. The
  test pipeline's `step7_python` spawns Python; if you skip the
  `setup:py` step below it'll fail there.
- **macOS with Apple Silicon** — MLX is Apple-Silicon-only. The
  rest of the runner is platform-agnostic.

## First run, in two commands

```sh
git clone https://github.com/jahbini/pipeline-demo my-project
cd my-project
./run-first.sh
```

`run-first.sh` does the three things below for you. The whole thing
takes well under a minute on a fresh clone; the slow part is the
one-time MLX pip install. The very last thing you see will be the
`step9_handoff` welcome message — "now it's your opportunity" —
with concrete suggestions for what to edit next.

If you'd rather see each step, the script is just three lines:

```sh
npm install       # pulls @jahbini/pipeline from GitHub
npm run setup     # drops override.yaml, creates .venv with MLX
npm run demo      # runs the 9-step test pipeline
```

## What each script does

| script              | what it does                                                                       |
|---------------------|------------------------------------------------------------------------------------|
| `npm run setup`     | `setup:override` + `setup:py` — one-shot bootstrap                                 |
| `npm run setup:override` | Copies `override.test.yaml` from the runner package into `override.yaml`      |
| `npm run setup:py`  | Creates `.venv/` and installs MLX (mlx, mlx-lm, mlx-metal at pinned versions)      |
| `npm run demo`      | Runs the pipeline named in `override.yaml` (defaults to `test`)                    |
| `npm run pipeline`  | Same as `demo` — both invoke the runner. Use whichever name feels right.           |
| `npm run ui`        | Starts the local UI HTTP server on `http://127.0.0.1:4311` (override via `UI_PORT`) |
| `npm run ui:reset`  | Restores `ui/` and `ui_server.coffee` from the installed package's defaults         |
| `npm run clean`     | Wipes every runtime artifact — back to a fresh clone state                         |

## The UI is yours to hack

The starter ships with the **entire UI stack** at the project root,
not buried in `node_modules/`:

```
your-project/
  ui/index.html        ← static frontend (HTML, CSS, JS) — edit freely
  ui_server.coffee     ← HTTP server (recipe dropdown, state polling,
                         spawn runner) — edit freely too
```

Both are first-class project files. Modify them however you want —
add panels, change the protocol, swap the layout, rip out features.
Updates to `@jahbini/pipeline` in `node_modules/` don't touch these
files. If you ever want to start over from the package's current
defaults, `npm run ui:reset` overwrites them.

To launch:

```sh
npm run ui     # then open http://127.0.0.1:4311
```

The script sets `EXEC` to `./node_modules/@jahbini/pipeline` so the
server still finds the shipped recipes, meta devices, and runner.
Your `ui_server.coffee` is in charge of the user experience; the
installed package is in charge of the engine.

## Making it yours

This starter is the floor, not the ceiling. After `npm run demo`
prints the hand-off message, edit `override.yaml`:

```yaml
pipeline: test            # ← change this to one of the recipes
                          #    shipped under config/ in the runner
step1_setup:
  greeting: "hi"
  value: 100
```

The runner ships several recipes you can switch to:

- `pipeline: test` — what you just ran (9 steps, every mechanism)
- `pipeline: prompt_ite` — iterative prompt generation
- `pipeline: diary_ite` — diary generation A/B with/without LoRA
- `pipeline: lora_ite` — iterative LoRA adapter training
- `pipeline: oracle_ite` — KAG extraction from raw stories
- `pipeline: diary_translate_ite` — adapter-based translation

The `_ite` recipes are starting-point templates — several reference
supporting scripts (`scripts/story/*`) that aren't in the runner
package, so you'll need to supply or stub them. See the runner's
README for details: <https://github.com/jahbini/pipeline>.

To write your own recipe, drop `config/<myname>.yaml` in this
directory and set `pipeline: myname` in `override.yaml`. To override
or extend a step, drop `scripts/<name>.coffee` in this directory.
Both directories merge with the runner's shipped versions; project
files win on filename collision.

## Resetting

```sh
npm run clean    # removes .venv, override, state, runtime artifacts
npm run setup    # back to a fresh first-run
npm run demo
```

## Where to go next

- Read [the runner's README](https://github.com/jahbini/pipeline)
  for the engine's architecture, the meta-device system, and the
  contract API.
- Read [`node_modules/@jahbini/pipeline/pipeline_runner.coffee`](https://github.com/jahbini/pipeline/blob/main/pipeline_runner.coffee)
  in Backbone/Underscore Docco style — every section has prose
  explaining why the code looks the way it does.
- Edit `override.yaml` and re-run `npm run demo` as your scratchpad.

## License

ISC.
