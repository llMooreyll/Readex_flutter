# 文本渲染重构执行文档

## 1. 文档目的

本文档面向一个**没有任何上下文的新 AI**。目标是指导它把当前项目的阅读页文本渲染能力，从“只看起来像标题 + 普通文本”提升为“支持常见文章富文本样式”的完整实现。

本文档必须被当作**实施说明书**使用，而不是讨论提案。执行时应优先遵循本文档的步骤、验收标准和约束。

---

## 2. 当前项目状态

项目是一个 Flutter read-it-later 应用。当前正文链路大致是：

1. `reader_mode` 从网页中抽取正文 HTML。
2. `ArticleHtmlSanitizer` 对抽取结果做白名单清洗。
3. 清洗后的 HTML 存入数据库。
4. `ReaderPage` 使用 `flutter_widget_from_html_core` 的 `HtmlWidget` 直接渲染。

相关文件：

- `lib/features/articles/data/import/reader_mode_extractor.dart`
- `lib/features/articles/data/import/article_html_sanitizer.dart`
- `lib/features/articles/data/import/default_article_importer.dart`
- `lib/features/articles/presentation/pages/reader_page.dart`

### 当前可观察问题

目前阅读页“看上去只支持最基本的多级标题和普通文本”，常见富文本能力表现不完整，主要体现在：

- 引用块样式弱或不稳定。
- 粗体、斜体、下划线、删除线、上下标等行内语义不够完整。
- 图片可能无法正确显示、对齐、留白或展示图注。
- `figure/figcaption` 的结构语义没有被显式保留和美化。
- 代码块、预格式文本、表格、列表等在视觉上没有专门处理。
- 某些站点的懒加载图片、`srcset`、`data-*` 图片属性、相对链接等在清洗后可能丢失。

### 根因

当前问题不是单点 bug，而是链路设计偏保守：

- 清洗层只保留了有限标签，且大量属性会被清空。
- 渲染层仅使用默认 `HtmlWidget`，没有针对文章阅读体验做专门主题和组件扩展。
- 没有为真实文章富文本建立完整的 fixtures 和回归测试。

---

## 3. 最终目标

最终目标不是“渲染所有 HTML”，而是实现**面向文章阅读场景的常见富文本支持**，兼顾安全性、可读性和维护性。

### 必须支持的能力

#### 3.1 基础语义

- 标题：`h1` 到 `h6`
- 正文段落：`p`
- 行内强调：`strong`、`em`、`b`、`i`
- 删除和修饰：`del`、`s`、`u`
- 上下标：`sup`、`sub`
- 代码：`code`、`pre`
- 分隔：`br`、`hr`

#### 3.2 文章结构

- 引用块：`blockquote`
- 列表：`ul`、`ol`、`li`
- 图片容器：`figure`
- 图片说明：`figcaption`
- 图片：`img`
- 链接：`a`
- 表格：`table`、`thead`、`tbody`、`tfoot`、`tr`、`th`、`td`

#### 3.3 图片相关

- 支持普通 `src`
- 支持懒加载属性，例如 `data-src`、`data-original`、`data-lazy-src`、`data-srcset`
- 支持 `srcset` 选取可用图片
- 支持 `alt`
- 支持安全的远程 HTTPS 图片
- 支持图注和图片块排版

#### 3.4 安全和兼容

- 保留安全的文章语义，不保留可执行脚本和危险资源。
- 仅允许安全链接，禁止 `javascript:`、`file:`、非 HTTPS 外链等。
- 保留相对链接并正确转成绝对链接。
- 保证数据库仍然只存清洗后的内容，不存原始整页 HTML。

---

## 4. 约束条件

必须遵守以下约束：

1. 继续使用 Flutter 和现有项目架构，不要重写成 WebView 方案。
2. 继续使用 `reader_mode` 负责正文抽取。
3. 继续使用 `flutter_widget_from_html_core` 作为 HTML 到 Widget 的基础渲染器。
4. 不要把网页原始 HTML 直接渲染给用户。
5. 不要引入不必要的浏览器依赖或原生桥接，除非后续验证证明当前包能力不足。
6. 保持现有数据库结构和保存流程尽量稳定，优先通过清洗层和渲染层增强实现。

---

## 5. 推荐的最终方案

推荐采用“两层增强”的做法：

### 第 1 层：增强 HTML 清洗器

让清洗后的 HTML 尽量保留文章阅读所需的语义和布局线索。

### 第 2 层：增强阅读页渲染

为 `HtmlWidget` 补充文章专用样式和必要的自定义组件，让富文本真正呈现为可读内容。

这个方案的好处是：

- 兼容现有数据库和导入流程。
- 风险比自研富文本引擎低得多。
- 可以逐步扩展，而不是一次性重写。

---

## 6. 需要修改的模块

### 6.1 清洗层

文件：

- `lib/features/articles/data/import/article_html_sanitizer.dart`

职责：

- 识别和保留阅读所需标签。
- 过滤危险标签和危险属性。
- 规范图片属性。
- 规范链接属性。
- 为图注、引用、列表、表格、代码块保留结构。

### 6.2 渲染层

文件：

- `lib/features/articles/presentation/pages/reader_page.dart`

职责：

- 使用文章专用的渲染配置。
- 为 `HtmlWidget` 提供自定义样式、图片处理、引用/表格/代码块样式。
- 保证暗色模式下可读。
- 保证长文排版稳定。

### 6.3 数据导入流程

文件：

- `lib/features/articles/data/import/default_article_importer.dart`
- `lib/features/articles/data/import/reader_mode_extractor.dart`

职责：

- 确保抽取后的 HTML 进入清洗器前不丢失可恢复语义。
- 保持对正文内容的判断逻辑合理。
- 如有必要，扩展对图片密集文章和短文/图文内容的判定策略。

### 6.4 测试

文件：

- `test/features/articles/data/import/article_html_sanitizer_test.dart`
- 新增阅读页 widget test / golden test
- 新增真实文章 fixtures

职责：

- 覆盖每一种目标样式。
- 验证清洗后的 HTML 不丢失关键语义。
- 验证渲染后视觉行为稳定。

---

## 7. 具体实施步骤

以下步骤建议按顺序执行。不要跳步。

### Step 1. 建立目标样式清单

先明确本项目“常见样式”到底要支持什么。

#### 需要覆盖的 HTML 语义

- `p`
- `strong`
- `em`
- `b`
- `i`
- `u`
- `s`
- `del`
- `sup`
- `sub`
- `blockquote`
- `code`
- `pre`
- `ul`
- `ol`
- `li`
- `img`
- `figure`
- `figcaption`
- `a`
- `table`
- `thead`
- `tbody`
- `tfoot`
- `tr`
- `th`
- `td`
- `hr`
- `br`
- `h1` to `h6`

#### 需要至少准备的真实 fixture 类型

1. 普通新闻/博客文章
2. 图文混排文章
3. 含引用块的文章
4. 含代码块的文章
5. 含表格的文章
6. 含脚注或注释跳转的文章
7. 含懒加载图片的文章
8. 含相对链接和绝对链接混合的文章
9. 含嵌套列表的文章
10. 含 figure / figcaption 的文章

### Step 2. 重构 sanitizer 的白名单策略

当前 sanitizer 的问题是“允许标签少 + 属性清空过度”。需要改成更细的规则。

#### 目标

- 保留文章语义。
- 丢弃危险执行能力。
- 让清洗后的 HTML 仍然足够表达排版。

#### 建议策略

1. 保留基础标签：
   - 段落、标题、列表、引用、代码、表格、图片、链接、图注、分隔线。

2. 允许部分行内语义标签：
   - `strong`、`em`、`b`、`i`、`u`、`s`、`del`、`sup`、`sub`、`code`

3. 对图片标签做专门处理：
   - 保留安全的 `src`
   - 支持 `data-src`、`data-original`、`data-lazy-src`、`data-srcset`
   - 从 `srcset` / `data-srcset` 中选择可用候选
   - 保留 `alt`
   - 可保留 `title`、`width`、`height`

4. 对链接标签做专门处理：
   - 只保留安全 HTTPS 链接
   - 将相对链接解析成绝对链接
   - 过滤 `javascript:`、`file:`、非 HTTPS

5. 对结构化内容保留必要属性：
   - `blockquote` 可保留 `cite`
   - `figure`、`figcaption` 保留结构本身
   - 表格保留基本结构和表头语义

6. 删除危险标签：
   - `script`
   - `style`
   - `iframe`
   - `object`
   - `embed`
   - `form`
   - `input`
   - `textarea`
   - `select`
   - `button`
   - `audio`
   - `video`
   - `link`
   - `meta`

#### 重要实现原则

- 不要对所有允许标签一律 `attributes.clear()`。
- 应该改成“按标签定义允许属性白名单”。
- 不在允许列表中的属性全部丢弃。
- 对不认识的标签，优先 `unwrap` 而不是整段删除，避免误杀正文文本。

#### 建议新增内部结构

如果现有 sanitizer 过于复杂，建议拆成几个私有方法：

- `_sanitizeElement`
- `_sanitizeAttributes`
- `_sanitizeImageAttributes`
- `_sanitizeLinkAttributes`
- `_sanitizeTableAttributes`
- `_sanitizeInlineAttributes`
- `_unwrap`

### Step 3. 为图片处理建立明确策略

图片是这次重构的重点之一。

#### 图片处理要求

1. 支持标准 `src`
2. 支持懒加载图片属性
3. 支持从 `srcset` 选择合适候选
4. 只保留 HTTPS 图片
5. 过滤明显占位图
6. 保留 `alt`
7. 尽量保留 `width/height` 以稳定布局

#### 建议规则

- 如果 `src` 是占位图，尝试从 `data-original`、`data-src`、`srcset` 中找真实图片。
- 如果图片只有 `srcset`，选择最合适的安全候选。
- 如果图片最终没有可用 URL，就移除该图片元素，而不要留下坏图标或者无意义占位。

### Step 4. 为阅读页建立文章专用渲染配置

文件：`lib/features/articles/presentation/pages/reader_page.dart`

#### 当前问题

当前只传了：

- `baseUrl`
- `onTapUrl`
- `renderMode: RenderMode.column`
- 一个统一的 `textStyle`

这不够支撑文章阅读页的视觉质量。

#### 目标

构建一个“文章阅读专用的 `HtmlWidget` 配置”。

#### 建议加入的能力

1. 统一正文基础样式
   - 字号
   - 行高
   - 字重
   - 颜色
   - 段落间距

2. 引用块样式
   - 左侧引用线
   - 背景弱化
   - 内边距
   - 更小的字号或更柔和的颜色

3. 代码块样式
   - `pre` 使用横向滚动
   - `code` 使用等宽字体
   - 背景和边框区分
   - 保留换行

4. 图片样式
   - 图片最大宽度自适应
   - 图片上下留白
   - 图片点击打开原图或外部浏览器
   - 加载失败时有合理 fallback

5. 图注样式
   - `figcaption` 字号更小
   - 颜色更弱
   - 与图片分离但保持关联

6. 表格样式
   - 容器横向滚动
   - 单元格边框
   - 表头强调
   - 避免小屏被挤爆

7. 链接样式
   - 清晰但不喧宾夺主
   - 站外链接可提示或统一用系统浏览器打开

8. 列表样式
   - 保持缩进
   - 嵌套列表可读

#### 需要重点使用的扩展点

应优先调查和使用 `flutter_widget_from_html_core` 的：

- `customStylesBuilder`
- `customWidgetBuilder`
- `onTapImage`
- `onTapUrl`
- 必要时自定义 `WidgetFactory`

#### 设计原则

- 渲染层只负责表现，不负责再做安全过滤。
- 安全性主要在 sanitizer 完成。
- 渲染层只补视觉行为和交互。

### Step 5. 处理脚注和图片说明

如果遇到 `sup` 脚注、`a href="#fn..."` 的锚点、`figure/figcaption` 图注，应尽量保留结构。

#### 目标

- 脚注编号不要消失。
- 图注不要被合并进正文导致信息丢失。
- 锚点跳转如果可实现就保留。

#### 最低可接受方案

如果完整脚注跳转实现成本过高，至少保证：

- 脚注编号和脚注文本仍可见。
- 图注作为独立文本显示在图片下方。

### Step 6. 调整正文可读性判定

当前可读性判断会使用 `text.length < 40` 一类阈值。

#### 问题

这类判定对图文混排、脚注较多、短文但信息密集的内容可能过于严格。

#### 处理建议

- 不要只用纯文本长度判断。
- 应结合：
  - 标题是否存在
  - 主体 HTML 是否保留
  - 段落数量
  - 图片/图注/表格等结构
- 若文章主要靠图片表达内容，要避免误判为不可读。

### Step 7. 补齐测试

这是本次改动最重要的一部分之一。

#### 7.1 sanitizer 单测

需要覆盖：

- `strong` / `em` / `b` / `i`
- `blockquote`
- `img` + `alt`
- 懒加载图片属性
- `srcset`
- `figure` / `figcaption`
- `table`
- `code` / `pre`
- 安全链接
- 危险链接
- 危险标签移除

#### 7.2 阅读页 widget test

至少验证：

- 标题显示正常
- 引用块有单独样式
- 图片可以显示
- 图注可见
- 链接可点击
- 代码块不挤压布局
- 表格能布局完整

#### 7.3 golden test

建议分别做：

- 亮色模式
- 暗色模式

至少要覆盖：

- 普通文章
- 图文文章
- 引用 + 代码文章
- 表格文章

#### 7.4 fixture 文档

在 `test/fixtures/` 下放固定 HTML，用于回归测试。

建议文件：

- `simple_article.html`
- `image_article.html`
- `blockquote_article.html`
- `code_article.html`
- `table_article.html`
- `footnote_article.html`
- `mixed_rich_article.html`

### Step 8. 回归验证

完成代码后必须检查以下内容：

1. 阅读页能显示标题、正文、引用、图片、图注、表格。
2. 富文本样式在暗色模式下仍清晰。
3. 安全链接不被错误打开。
4. 危险 HTML 不会进入渲染链路。
5. 长文章页面不发生严重卡顿或布局溢出。
6. 旧文章仍能打开，不出现崩溃。

---

## 8. 文件级改动建议

### 8.1 `article_html_sanitizer.dart`

建议修改内容：

- 把允许标签扩展到完整的文章语义集合。
- 取消“一刀切清空属性”。
- 引入按标签分组的属性白名单。
- 加强图片 URL 的候选解析。
- 加强安全 URL 过滤。
- 保留图注、表格和脚注结构。

### 8.2 `reader_page.dart`

建议修改内容：

- 将 `HtmlWidget` 配置抽出成局部函数或专门的渲染辅助类。
- 增加 `customStylesBuilder`。
- 增加 `customWidgetBuilder`。
- 对图片、引用、代码块、表格、图注做专门样式。
- 需要时单独处理 `onTapImage`。

### 8.3 测试文件

建议新增或扩展：

- `test/features/articles/data/import/article_html_sanitizer_test.dart`
- `test/features/articles/presentation/pages/reader_page_test.dart`
- `test/fixtures/*.html`

---

## 9. 验收标准

以下条件必须全部满足，才能认为改动完成。

### 功能验收

- 引用块能以引用样式显示。
- 粗体、斜体、下划线、删除线、上下标能显示。
- 图片能正常显示，且支持至少一种常见懒加载形式。
- 图注能显示并和图片关联。
- 代码块和预格式文本能保持可读。
- 列表和嵌套列表不乱。
- 表格在小屏幕上不崩布局。
- 链接可点击，且安全限制有效。

### 安全验收

- `script`、`iframe`、`style` 等危险标签不会渲染。
- `javascript:`、`file:` 等危险链接不会被允许。
- 清洗后内容仍然只存安全 HTML。

### 稳定性验收

- 页面不因为某类文章崩溃。
- 长文章不出现明显布局溢出。
- 暗色模式与亮色模式都可读。

### 测试验收

- sanitizer 单测覆盖目标语义。
- 阅读页 widget test 通过。
- 至少一组 golden 测试通过。
- 真实 fixture 测试通过。

---

## 10. 推荐实施顺序

如果要严格按风险控制推进，建议顺序如下：

1. 先改测试 fixtures。
2. 再改 sanitizer。
3. 再改阅读页渲染。
4. 再补 widget / golden 测试。
5. 最后做回归修正。

不要先大改 UI 再回头补 sanitizer，否则会出现“界面做了，但输入内容已经被抹掉”的问题。

---

## 11. 重要实现提醒

1. 不要尝试自研完整 HTML/CSS 引擎。
2. 不要直接切到 WebView 作为默认阅读方案。
3. 不要依赖原始站点 CSS。
4. 不要把所有属性都保留，安全属性白名单必须明确。
5. 不要只做视觉，不补测试。
6. 不要忽略旧文章兼容性。

---

## 12. 推荐的完成定义

当且仅当以下内容全部完成时，可以认为本次重构成功：

- 清洗器保住了常见文章语义。
- 渲染页对常见富文本有明确的文章样式。
- 图片、图注、引用、代码块、表格都可用。
- 安全性不退化。
- 测试覆盖了关键样式和回归路径。

---

## 13. 给接手 AI 的执行提示

如果你是接手这份任务的新 AI，请按以下方式推进：

1. 先读 `reader_page.dart` 和 `article_html_sanitizer.dart`。
2. 明确目前是“清洗层过度裁剪”而不是“渲染器完全失效”。
3. 先增强 sanitizer，再增强阅读页。
4. 每改一个能力点都加一个对应测试。
5. 最终输出时同时说明：
   - 改了什么
   - 为什么这样改
   - 哪些样式支持了
   - 哪些仍然不支持
   - 还剩什么风险

