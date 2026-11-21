"""Checks that the Graphviz toolchain works before any real rendering code depends on it."""

from pathlib import Path
from xml.etree import ElementTree

import graphviz
import pytest

INSTALL_HINT = (
    "The Graphviz 'dot' binary was not found on PATH. The Python 'graphviz' package is only "
    "a wrapper around it. Install Graphviz (Windows: 'winget install Graphviz.Graphviz', "
    "macOS: 'brew install graphviz', Debian/Ubuntu: 'apt install graphviz'), make sure its "
    "bin directory is on PATH, then open a new terminal."
)

SVG_NS = "{http://www.w3.org/2000/svg}"


def test_renders_two_node_graph_to_valid_svg(tmp_path: Path) -> None:
    graph = graphviz.Digraph(format="svg")
    graph.node("a", label="Input", id="node_a")
    graph.node("b", label="Output", id="node_b")
    graph.edge("a", "b")

    try:
        svg_path = Path(graph.render(tmp_path / "smoke", cleanup=True))
    except graphviz.ExecutableNotFound:
        svg_path = None
    if svg_path is None:  # failing outside the except block keeps the chained errors out of the report
        pytest.fail(INSTALL_HINT, pytrace=False)

    root = ElementTree.parse(svg_path).getroot()  # raises if the SVG is not well-formed XML
    assert root.tag == f"{SVG_NS}svg"

    group_ids = {g.get("id") for g in root.iter(f"{SVG_NS}g")}
    assert {"node_a", "node_b"} <= group_ids
