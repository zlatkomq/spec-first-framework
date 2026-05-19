# Figma Designer Guide — Spec-First Framework

**Who this is for:** Designers handing Figma files to a development team using the [Spec-First Framework](../README.md) with the [`figma-to-code` MCP server](https://github.com/zlatkomq/figma-mcp).

**Why it matters:** The Spec-First Framework's UIX step (step 2b in `/flow`) calls the `figma-to-code` MCP to extract design tokens, layout, and assets directly from your Figma files. The extraction is deterministic — it can only see what Figma exposes via its REST API. **How you build the file determines whether the agent ships pixel-accurate code or has to guess.** This document is the contract: follow these rules and the AI implementation will match the design.

**Compatible MCP server version:** `figma-to-code` **v2.0.0+** (`figma-to-code-mcp-os`).

**How to use this document:** Read it once before starting the first Figma file for a Spec-First project. Refer to the **"Quick checklist for every frame before handoff"** at the bottom before passing each design to the dev team.

---

## **Figma Design Rules for MCP Extraction**

### **NAMING**

**Do:**

- Prefix any icon, illustration, logo, or complex vector with `svg_ex_` — e.g. `svg_ex_arrow-right`, `svg_ex_hero-illustration`. The MCP will flag these for automatic SVG export and tell the AI not to hand-draw them (not mandatory \- only for strict output \- initially MCP will send icons as assets by default)  
- Name every frame and layer with the intended CSS class name. Names become class names in generated code — use `kebab-case` or `camelCase`, no special characters.  
- Keep names unique within the same parent frame. Duplicates confuse CSS class generation.

**Avoid:**

- Generic names like `Frame 47`, `Group 12`, `Rectangle 3`. These generate useless CSS class names.  
- Renaming component instances — the MCP reads the instance name, not the master component name.

---

### **LAYOUT — the single most important area**

**Do:**

- Use **Auto Layout** on every container that has children. This gives the MCP `layout`, `gap`, `padding`, `align-main`, `align-cross`, `sizing-h/v` — all the flex properties. Absolute-positioned frames lose all of this.  
- Set **sizing mode** (`Fixed` / `Fill` / `Hug`) explicitly on every frame and its children. Don't leave it unset.  
- Set **constraints** (`Left`, `Right`, `Scale`, `Stretch`, `Center`) on every element inside a fixed frame, especially for responsive containers.  
- Enable **Wrap** on auto-layout frames that should wrap to next line — this now maps to `flex-wrap: wrap`.  
- Use **min/max width and height** on auto-layout children that should constrain — these are captured.

**Avoid:**

- Mixing auto-layout and absolute positioning in the same frame for elements that belong to the same layout.  
- Deeply nesting frames beyond 10 levels — the MCP hard-stops at depth 12, geometry table at depth 6\.

---

### **FRAMES vs GROUPS**

**Do:**

- Use **Frames** for all layout containers — only frames have auto-layout, padding, constraints, clip content, overflow, and grid settings.  
- Use **Groups** only for purely visual grouping of shapes that have no layout meaning (e.g. grouping decoration vectors).

**Avoid:**

- Using Groups as layout containers. Groups have no padding, no auto-layout, no constraints — the MCP renders them as `<Group>` with only position/size.

---

### **COMPONENTS AND INSTANCES**

**Do:**

- Build all reusable UI elements as **Components** (buttons, inputs, cards, nav items, tags).  
- Use **Component Properties** (text, boolean, instance swap, variant) for overrides — these are captured as `props="{...}"` on the instance.  
- Keep top-level instances **large enough** (\> 128×128px) OR explicitly named with `svg_ex_` — otherwise the icon heuristic may treat them as SVG exports.  
- Keep component internal depth shallow — the MCP recurses **3 levels** into an instance. If a component has important layout at depth 4+, flatten it.

**Avoid:**

- Deeply nested instances (instance inside instance inside instance) — the MCP treats nested instances as leaves. The outer instance expands 3 levels; any instance found inside stays as a single tag.  
- Hiding important layout information inside instance internals beyond 3 levels.

---

### **TEXT**

**Do:**

- Use **one text node per style run**. If a sentence has a bold word and a normal word, use two separate `<Text>` nodes side by side in an auto-layout frame.  
- Apply **Figma Text Styles** for all typography. The MCP captures `fontFamily`, `fontSize`, `fontWeight`, `lineHeight`, `letterSpacing`, `textAlign`, `textDecoration`, `textCase` at node level.

**Avoid:**

- **Mixed styles within a single text node** (selecting half the text and making it bold). The MCP only reads the node-level style — per-character overrides from `styleOverrideTable` are completely invisible.

---

### **COLORS AND FILLS**

**Do:**

- Use **Figma Color Styles** or **Variables** — these end up in the `--color-N` token block. Use consistent values rather than one-off fills.  
- Gradients: position the **gradient handles** carefully — the MCP now reads the exact angle and stop positions. A linear gradient set to 45° will produce `linear-gradient(135deg, ...)` in the output.  
- Use **blend modes** freely on fills and layers — these are now captured as `blend="multiply"` etc. `NORMAL` and `PASS_THROUGH` are omitted as they are the default.

**Avoid:**

- Using **image fills** for things that should be CSS (flat color backgrounds, simple gradients). Image fills are flagged as PNG export assets, not reproduced in code.  
- Relying on the **spread** value of a shadow — only offset X/Y, blur radius, and color are captured. Spread is lost.

---

### **EFFECTS**

**Do:**

- Drop shadows and inner shadows are fully captured: offset X/Y, blur radius, color.  
- Layer blur and background blur are captured: `blur(Npx)`.

**Avoid:**

- Using **shadow spread** as a visual design element — it's not extracted.  
- Multiple overlapping effects for critical visual appearance — the MCP captures all of them, but downstream AI may not render complex multi-shadow stacks perfectly.

---

### **ICONS AND VECTOR ASSETS**

**Do:**

- Name every icon frame/component with `svg_ex_` prefix. This is explicit and works regardless of size.  
- Keep icons ≤ 128×128px and without any child `TEXT` nodes — the icon heuristic auto-detects these even without the prefix.  
- For illustrations, logos, complex shapes: always use `svg_ex_` prefix — never rely on the heuristic alone for critical assets.

**Avoid:**

- Placing important text inside an icon component — the heuristic checks for text children and skips icon-detection if text is present.  
- `VECTOR`, `BOOLEAN_OPERATION`, `STAR`, `REGULAR_POLYGON`, `LINE` nodes that should be visible in code — these are hard leaves, their internal path data is never exposed. Wrap them in a frame named `svg_ex_`.

---

### **GRID LAYOUTS**

**Do:**

- Set up **Layout Grids** (column, row, or base grid) on section/page-level frames. The MCP now captures: column count, gutter size, column width, offset, alignment.  
- Use consistent column grids across the design (e.g. 12-column, 16px gutter) — these map to CSS Grid or column layout rules for the AI.

---

### **OVERFLOW, SCROLL, AND STICKY**

**Do:**

- Set **"Clip content"** on any frame that should have `overflow: hidden`.  
- Set **"Overflow direction"** in the frame's scroll settings for scrollable containers (Horizontal / Vertical / Both).  
- Use **"Fix position when scrolling"** in prototype settings on nav bars, headers, FABs — this maps to `sticky="true"` in the output.

---

### **WHAT THE MCP WILL NEVER SEE — design around these**

| Figma feature | Status | Workaround |
| :---- | :---- | :---- |
| Mixed text styles (per-character bold/color) | Not extracted | Use separate Text nodes |
| Shadow spread radius | Not extracted | Avoid using it for precision |
| Stroke alignment (inside/outside/center) | Not extracted | Note in layer name if critical |
| Figma Variables / token bindings | Partial extracted | MCP extracts raw hex/values |
| Prototype interactions / animations | Not extracted | Separate spec doc |
| Boolean operation shapes | Hard leaf | Wrap in `svg_ex_` frame |
| Nodes deeper than depth 12 | Truncated | Flatten component internals |
| Instance internals deeper than 3 levels | Truncated | Flatten component tree |
| Nested instance internals (instance-in-instance) | Always leaf | Flatten or name with `svg_ex_` |

---

### **Quick checklist for every frame before handoff**

□ All layout containers use Auto Layout (not free placement)

□ Every element has sizing mode set (Fixed / Fill / Hug)

□ Constraints set on all elements in fixed frames

□ All icons / illustrations / logos prefixed with svg\_ex\_

□ No mixed text styles in single nodes — use separate text nodes

□ Scroll frames have overflow direction set

□ Sticky elements have "Fix position when scrolling" enabled

□ Clip content enabled on frames that clip overflow

□ Layer names are semantic (kebab-case, no "Frame 47")

□ Max nesting depth \< 10 levels from root frame

---

## Version

- **Guide v0.1** — 2026-05-05
- **Compatible MCP server:** `figma-to-code` v2.0.0+ ([github.com/zlatkomq/figma-mcp](https://github.com/zlatkomq/figma-mcp))
- **Compatible Spec-First Framework:** v1.2.0+ (cached Figma snapshot model)

If the MCP server bumps to a new major version, check this guide for updated rules before continuing.