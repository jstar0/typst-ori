#import "@preview/rich-counters:0.2.2": rich-counter
#import "@preview/showybox:2.0.4": showybox

/// 一个简单的仿照 elegantbook 的定理框。
#let make-frames(
  identifier,
  head,
  inherited-levels: 0,
  inherited-from: heading,
  border-color: orange.darken(0%),
  title-color: orange.darken(0%),
  body-color: orange.lighten(95%),
  numbering: "1.1",
  symbol: sym.suit.heart.stroked,
) = {
  /// Counter for the frame.
  let frame-counter = rich-counter(
    identifier: identifier,
    inherited_levels: inherited-levels,
    inherited_from: inherited-from,
  )
  /// Style for the frame.
  let frame-box(title: "", body) = showybox(
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
    title: title,
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
      frame-box(
        title: [#head-i18n #context (frame-counter.display)(numbering)#{ if title != "" [ (#title)] }],
        body,
      )
    },
  )
  /// Reference to the frame.
  let show-frame(body) = {
    show ref: it => {
      let el = it.element
      if el != none and el.func() == figure and el.kind == identifier {
        if it.supplement == auto { head-i18n } else { it.supplement }
        " "
        context {
          // We need to add 1 to the counter value.
          let counter-value = (frame-counter.at)(el.location())
          counter-value = counter-value.slice(0, -1) + (counter-value.at(-1) + 1,)
          std.numbering(el.numbering, ..counter-value)
        }
      } else {
        it
      }
    }
    body
  }
  return (frame-counter, frame-box, frame, show-frame)
}


/// 创建对应的定理框。
#let (theorem-counter, theorem-box, theorem, show-theorem) = make-frames(
  "theorem",
  (en: "Theorem", zh: "定理"),
  inherited-levels: 2,
)

#let (lemma-counter, lemma-box, lemma, show-lemma) = make-frames(
  "lemma",
  (en: "Lemma", zh: "引理"),
  inherited-from: theorem-counter,
)

#let (corollary-counter, corollary-box, corollary, show-corollary) = make-frames(
  "corollary",
  (en: "Corollary", zh: "推论"),
  inherited-from: theorem-counter,
)

#let (axiom-counter, axiom-box, axiom, show-axiom) = make-frames(
  "axiom",
  (en: "Axiom", zh: "公理"),
  inherited-levels: 2,
)

#let (postulate-counter, postulate-box, postulate, show-postulate) = make-frames(
  "postulate",
  (en: "Postulate", zh: "假设"),
  inherited-levels: 2,
)

#let (definition-counter, definition-box, definition, show-definition) = make-frames(
  "definition",
  (en: "Definition", zh: "定义"),
  inherited-levels: 2,
  border-color: green.darken(20%),
  title-color: green.darken(20%),
  body-color: green.lighten(95%),
  symbol: sym.suit.club.filled,
)

#let (proposition-counter, proposition-box, proposition, show-proposition) = make-frames(
  "proposition",
  (en: "Proposition", zh: "命题"),
  inherited-levels: 2,
  border-color: blue.darken(30%),
  title-color: blue.darken(30%),
  body-color: blue.lighten(95%),
  symbol: sym.suit.spade.filled,
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

