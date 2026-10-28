# comfyui

**One capability bit from GBT V8, packaged standalone.** No. 22 of 341,
`creation` domain (Creation).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> ComfyUI（秋叶整合版）全控（主人令 2026-09-27「这个必须也是一个不漏的双向绑定，才能实现无限制审查生产」）：**966 个节点**（每把一把键）+ 11 个 API 端点 + 14 个启动开关 + 模型清单（checkpoints/loras/controlnet）；**节点消失=断连**（要解释或补）。出网硬钉（SSRF 防线）：只许本机 http + 主机白名单(127.0.0.1/localhost/::1) + 端口 8188 + 路径前缀白名单 + **拒重定向**；读类直连、提交/释放过 filesystem_write 门。op=status/nodes/models/submit/queue/history/free/interrupt/surface/verify

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-comfyui.git
cd gbt-comfyui
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_comfyui info                  # capability card
python -m gbt_comfyui spec --json           # machine-readable contract
python -m gbt_comfyui check --payload '{}'
python -m gbt_comfyui run   --payload '{}'
```

Real `info` output from this machine:

```text
comfyui  (creation)  v1.0.0
----------------------------------------
ComfyUI（秋叶整合版）全控（主人令 2026-09-27「这个必须也是一个不漏的双向绑定，才能实现无限制审查生产」）：**966 个节点**（每把一把键）+ 11 个 API 端点 + 14 个启动开关 + 模型清单（checkpoints/loras/controlnet）；**节点消失=断连**（要解释或补）。出网硬钉（SSRF 防线）：只许本机 http + 主机白名单(127.0.0.1/localhost/::1) + 端口 8188 + 路径前缀白名单 + **拒重定向**；读类直连、提交/释放过 filesystem_write 门。op=status/nodes/models/submit/queue/history/free/interrupt/surface/verify

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : checkpoints, loras, controlnet
```

Wire a real implementation:

```python
from gbt_comfyui import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（3 个）**：`checkpoints`、`loras`、`controlnet`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.11s
```

## Provenance

| field | value |
|---|---|
| capability | `comfyui` |
| domain | `creation` |
| handler | `comfyui` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [creation/comfyui](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/creation/comfyui.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
