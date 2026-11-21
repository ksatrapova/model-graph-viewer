# Glossary

**Use these terms verbatim**: in code, commits, docs and conversation. A synonym creates a second concept beside the first, and the next person greps for the wrong word.

| Term | Meaning | In code / data | Don't say |
|---|---|---|---|
| Model | The source neural network file (OpenVINO IR `.xml` + `.bin`). Never modified | path | network, net |
| Graph | The framework-independent intermediate representation built from a Model | `Graph` | IR (clashes with OpenVINO IR), DAG |
| Node | One operation in the Graph. Has a unique `id` separate from its `name` | `Node` | op, vertex, layer |
| Edge | A connection from one Node's output Port to another Node's input Port, with optional shape and dtype | `Edge` | link, connection |
| Port | Indexed input or output slot of a Node (`in 0`, `out 1`) | `src_port`, `dst_port` | pin, slot |
| Loader | Turns a Model file of one format into a Graph | `ModelLoader` | parser, reader |
| Pass | One configurable transformation applied to a Graph | `GraphPass` | transform, step, filter |
| Pipeline | An ordered list of Passes applied to a Graph | `Pipeline` | chain |
| Renderer | Turns a Graph into an SVG file | `GraphvizRenderer` | drawer, exporter |
| Visualization metadata | Per-Node display hints set by Passes and read by the Renderer (e.g. border colour) | `node.viz` | style, decoration |
| Shared Constant | A Constant Node consumed by more than one Node; marked `(shared: <id>)` when hidden | | reused weight |
