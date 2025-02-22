#import "../lib.typ": *

#set heading(numbering: numbly("{1:一}、", default: "1.1  "))

#show: ori.with(
  title: "文档标题",
  author: "作者",
  subject: "Ori in Typst",
  semester: "2025 春",
  date: datetime.today(),
  // maketitle: true,
  // makeoutline: true,
  // theme: "dark",
  // media: "screen",
)

= 快速开始

要开始使用此模板，你需要

+ 安装必须的字体包，包括：
  - #link("https://github.com/IBM/plex")[*IBM Plex Sans, Mono*]
  - #link("https://github.com/notofonts/noto-cjk")[*Noto Serif CJK SC*]

+ 下载 `template.typ` 并在你的文档开头中使用
  ```typ
  #import "template.typ": *
  ``` 来导入模板；

+ 在文档开头设置参数，包括标题、作者、课程或主题、学期、时间；
  ```typ
  #show: ori.with(
    title: "文档标题",
    author: "张三",
    subject: "Ori in Typst",
    semester: "2025 春",
    date: datetime.today(),
  )
  ```

= 使用

== 特殊参数

- `size`：字体大小，默认为 `11pt`；
- `screen-size`：屏幕字体大小，默认为 `11pt`；
- `maketitle`：是否生成标题页，默认为 `false`；
- `makeoutline`：是否生成目录，默认为 `false`；
- `outline-depth`：目录的深度，默认为 `2`；
- `first-line-indent`：首行缩进，如果设置为 `auto`，则会开启自动缩进，缩进量为 `2em`；
- `media`：媒体类型，可选值为 `"screen"` 和 `"print"`，前者边距较小，适合屏幕显示；后者边距较大，适合打印。默认值为 `"print"`；
- `lang`：语言，默认为 `"zh"`；
- `region`：地区，默认为 `"cn"`。

== 三线表

基于 `tablem` 包，提供了简单好用的三线表功能，如@three-line-table。

```typ
#figure(
  three-line-table[
    | Substance             | Subcritical °C | Supercritical °C |
    | --------------------- | -------------- | ---------------- |
    | Hydrochloric Acid     | 12.0           | 92.1             |
    | Sodium Myreth Sulfate | 16.6           | 104              |
    | Potassium Hydroxide   | 24.7           | <                |
  ],
  caption: "三线表示例"
) <three-line-table>
```

#figure(
  three-line-table[
    | Substance             | Subcritical °C | Supercritical °C |
    | --------------------- | -------------- | ---------------- |
    | Hydrochloric Acid     | 12.0           | 92.1             |
    | Sodium Myreth Sulfate | 16.6           | 104              |
    | Potassium Hydroxide   | 24.7           | <                |
  ],
  caption: "三线表示例"
) <three-line-table>

== Markdown 渲染

基于 `cmarker` 包和 `mitex` 包，支持 Markdown 渲染，包括数学公式，如：

`````typ
#md(````markdown
  支持 **加粗**、*斜体*、~~删除线~~、[链接](https://typst.com)、LaTeX 数学公式 $\max_{x \in X} f(x)$ 等 Markdown 语法。
````)
`````

#rect(
  width: 100%,
  md(````markdown
    支持 **加粗**、*斜体*、~~删除线~~、[链接](https://typst.com)、LaTeX 数学公式 $\max_{x \in X} f(x)$ 等 Markdown 语法。
  ````)
)

== 定理环境

我们可以创建@theorem @lemma

#theorem(title: "Fubini 定理")[
  定理内容定理内容定理内容定理内容定理内容定理内容定理内容定理内容定理内容定理内容定理内容定理内容定理内容定理内容定理内容定理内容定理内容定理内容定理内容容容
] <theorem>

#lemma[
  引理内容。
] <lemma>

= 自定义

== 标题编号

可以使用 `numbly` 包设置标题编号样式：

```typ
#set heading(numbering: numbly("{1:一}、", default: "1.1  "))
```

参数中，`{*:1}` 的 `*` 代表标题的级别，`1` 代表标题的格式。`{1:一}、` 代表一级标题的格式为 `一、`，并且设置了默认格式 `1.1  `。

*注意*，本模板默认去除了标题 numbering 后的空格，所以在设置标题编号时请注意空格的使用。如 `"1.1  "` 的末尾有两个空格，这样在标题编号后会有两个空格。

== 字体

先在终端 / 命令行输入 ```bash typst fonts``` 查看当前可用的字体，以在文档开头加入 `font` 参数修改字体设置以及使用的字体：

```typ
#let font = (
  main: "IBM Plex Sans",
  mono: "IBM Plex Mono",
  cjk: "Noto Serif SC",
  emph-cjk: "KaiTi",
  math: "New Computer Modern Math",
  math-cjk: "Noto Serif SC",
)

#show: ori.with(
  // ... 保持原有的参数
  font: font,
)
```
