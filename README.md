# model-graph-viewer

Python library and CLI that loads a neural network model (OpenVINO IR), converts it to a framework-independent graph, applies a configurable sequence of transformation passes, and renders the result to SVG with Graphviz.

```
Model Loading → Graph Construction → Graph Transformation → Graph Rendering
```

> Status: work in progress. The sections below will be filled in as the components land.

Developed with the help of Claude Code (setup in `.claude/`). I wrote or reviewed and understand all; design decisions are in `docs/architecture/adr/`.

## Getting started

Requirements:

- Python 3.10 or newer
- [uv](https://docs.astral.sh/uv/) for dependencies and the virtual environment
- [Graphviz](https://graphviz.org/download/) installed as a system program. The Python `graphviz` package only calls the `dot` binary, so `dot` must be on `PATH`:
  - Windows: `winget install Graphviz.Graphviz`, then add `C:\Program Files\Graphviz\bin` to `PATH` if the installer did not, and open a new terminal
  - macOS: `brew install graphviz`
  - Debian/Ubuntu: `sudo apt install graphviz`

  Check with `dot -V`.

Install and run the tests:

```bash
git clone https://github.com/ksatrapova/model-graph-viewer.git
cd model-graph-viewer
uv sync
uv run pytest
```

If `dot` is missing, the Graphviz smoke test fails and says how to install it.

To check rendering with the example provided with the assignment (writes `simple_graph.svg` to the current directory):

```bash
uv run python reference/starter_code.py
```

## Usage
### CLI
_TBD_
### Python API
_TBD_

## Architecture
_TBD_ (decisions in `docs/architecture/adr/`)

## Extensibility
### Adding a transformation pass
_TBD_
### Adding a model format
_TBD_

## Testing
_TBD_

## Performance
_TBD_

## Known limitations
_TBD_
