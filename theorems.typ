#import "@preview/rich-counters:0.2.2": rich-counter
#import "@preview/showybox:2.0.4": showybox
#import "@preview/octique:0.1.0": octique-inline

/// 一个简单的仿照 elegantbook 的 fancy 框。
#let fancy-box(
  border-color: orange.darken(0%),
  title-color: orange.darken(0%),
  body-color: orange.lighten(95%),
  symbol: sym.suit.heart.stroked,
  prefix: none,
  title: "",
  full-title: auto,
  body,
) = showybox(
  frame: (
    thickness: .5pt,
    radius: 3pt,
    inset: (x: 12pt, top: 7pt, bottom: 12pt),
    border-color: border-color,
    title-color: title-color,
    body-color: body-color,
    title-inset: (x: 10pt, y: 5pt),
  ),
  title-style: (
    boxed-style: (
      anchor: (x: left, y: horizon),
      radius: 0pt,
    ),
    color: white,
    weight: "semibold",
  ),
  breakable: true,
  title: {
    if full-title == auto {
      if prefix != none {
        [#prefix (#title)]
      } else {
        title
      }
    } else {
      full-title
    }
  },
  {
    body
    if symbol != none {
      place(
        right + bottom,
        dy: 8pt,
        dx: 9pt,
        text(size: 6pt, fill: border-color, symbol),
      )
    }
  },
)

/// 基于 rich-counter 实现的定理环境
#let make-frame(
  identifier,
  head,
  inherited-levels: 0,
  inherited-from: heading,
  numbering: "1.1",
  render: (prefix: none, title: "", full-title: "", body) => block[*#full-title*: #body],
) = {
  /// Counter for the frame.
  let frame-counter = rich-counter(
    identifier: identifier,
    inherited_levels: inherited-levels,
    inherited_from: inherited-from,
  )
  /// Style for the frame.
  let head-i18n = {
    if type(head) == dictionary {
      context head.at(text.lang, default: head.at("en"))
    } else {
      head
    }
  }
  /// Frame with the counter.
  let frame(title: "", body) = figure(
    kind: identifier,
    supplement: head-i18n,
    numbering: numbering,
    {
      context (frame-counter.step)()
      let prefix = [#head-i18n #context (frame-counter.display)(numbering)]
      render(
        prefix: prefix,
        title: title,
        full-title: [#prefix#{ if title != "" [ (#title)] }],
        body,
      )
    },
  )
  /// Show rule for the frame.
  let show-frame(body) = {
    show figure.where(kind: identifier): set align(left)
    show figure.where(kind: identifier): set block(breakable: true)
    show ref: it => {
      let el = it.element
      if el != none and el.func() == figure and el.kind == identifier {
        link(
          it.target,
          {
            if it.supplement == auto { head-i18n } else { it.supplement }
            " "
            context {
              // We need to add 1 to the counter value.
              let counter-value = (frame-counter.at)(el.location())
              counter-value = counter-value.slice(0, -1) + (counter-value.at(-1) + 1,)
              std.numbering(el.numbering, ..counter-value)
            }
          },
        )
      } else {
        it
      }
    }
    body
  }
  return (frame-counter, render, frame, show-frame)
}

/// 创建对应的定理框。
#let (theorem-counter, theorem-box, theorem, show-theorem) = make-frame(
  "theorem",
  (en: "Theorem", zh: "定理"),
  inherited-levels: 2,
  render: fancy-box,
)

#let (lemma-counter, lemma-box, lemma, show-lemma) = make-frame(
  "lemma",
  (en: "Lemma", zh: "引理"),
  inherited-from: theorem-counter,
  render: fancy-box,
)

#let (corollary-counter, corollary-box, corollary, show-corollary) = make-frame(
  "corollary",
  (en: "Corollary", zh: "推论"),
  inherited-from: theorem-counter,
  render: fancy-box,
)

#let (axiom-counter, axiom-box, axiom, show-axiom) = make-frame(
  "axiom",
  (en: "Axiom", zh: "公理"),
  inherited-levels: 2,
  render: fancy-box,
)

#let (postulate-counter, postulate-box, postulate, show-postulate) = make-frame(
  "postulate",
  (en: "Postulate", zh: "假设"),
  inherited-levels: 2,
  render: fancy-box,
)

#let (definition-counter, definition-box, definition, show-definition) = make-frame(
  "definition",
  (en: "Definition", zh: "定义"),
  inherited-levels: 2,
  render: fancy-box.with(
    border-color: green.darken(20%),
    title-color: green.darken(20%),
    body-color: green.lighten(95%),
    symbol: sym.suit.club.filled,
  ),
)

#let (proposition-counter, proposition-box, proposition, show-proposition) = make-frame(
  "proposition",
  (en: "Proposition", zh: "命题"),
  inherited-levels: 2,
  render: fancy-box.with(
    border-color: blue.darken(30%),
    title-color: blue.darken(30%),
    body-color: blue.lighten(95%),
    symbol: sym.suit.spade.filled,
  ),
)

/// 汇总 show rules。
#let show-theorems(body) = {
  show: show-theorem
  show: show-lemma
  show: show-corollary
  show: show-axiom
  show: show-postulate
  show: show-definition
  show: show-proposition
  body
}

/// 一些其他的有用的信息框。
#let emph-box(body) = {
  showybox(
    frame: (
      dash: "dashed",
      border-color: yellow.darken(30%),
      body-color: yellow.lighten(90%),
    ),
    sep: (dash: "dashed"),
    breakable: true,
    body,
  )
}

#let quote-box(body) = block(
  stroke: (left: 3pt + luma(200)),
  inset: (left: 1em, y: .75em),
  text(luma(100), body),
)

#let note-box(fill: rgb("#0969DA"), head: (en: "Note", zh: "注意"), octique-name: "info", body) = block(
  stroke: (left: 3pt + fill),
  inset: (left: 1em, top: .5em, bottom: .75em),
  {
    let head-i18n = {
      if type(head) == dictionary {
        context head.at(text.lang, default: head.at("en"))
      } else {
        head
      }
    }
    stack(
      spacing: 1.5em,
      text(
        fill: fill,
        weight: "semibold",
        octique-inline(
          height: 1.2em,
          width: 1.2em,
          color: fill,
          baseline: .2em,
          octique-name,
        )
          + h(.5em)
          + head-i18n,
      ),
      body,
    )
  },
)

#let tip-box = note-box.with(
  fill: rgb("#1A7F37"),
  head: (en: "Tip", zh: "提示"),
  octique-name: "light-bulb",
)

#let important-box = note-box.with(
  fill: rgb("#8250DF"),
  head: (en: "Important", zh: "重要"),
  octique-name: "report",
)

#let warning-box = note-box.with(
  fill: rgb("#9A6700"),
  head: (en: "Warning", zh: "警告"),
  octique-name: "alert",
)

#let caution-box = note-box.with(
  fill: rgb("#CF222E"),
  head: (en: "Caution", zh: "小心"),
  octique-name: "stop",
)
