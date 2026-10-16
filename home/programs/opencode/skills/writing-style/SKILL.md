---
name: writing-style
description: Use when writing, logging, or editing the user's personal notes in ~/.nb/home (or when running /log). Writes short, section-structured Japanese notes in the user's own voice — 常体ベースの話し言葉, 一人称「私」, frontmatter の tags/created. Relies only on these rules; it does not search or cite other notes. Do not use for formal reports or external documents.
---

# 個人ノートの書き方（writing-style）

`~/.nb/home` に置く個人ノートを書くための規則。
**この規則だけに従って書く。過去のノートを検索・参照して真似することはしない。**
「自分のために書く記録・日記・メモ」であり、他人に提出する文章ではない。

## 基本

- **言語・人称**: 日本語。一人称は「私」。
- **文体**: 常体（だ・である）を基調に、ところどころ丁寧語（〜です／〜ます）を混ぜた、話し言葉に近いラフな文。
- **語尾**: 「〜なんですよねー」「〜かな」「〜だね」などで、断定しすぎずやわらかく流してよい。
- **トーン**: うれしい・楽しいときは素直に「！」「やったね」を使う。ただし感情的になるのは一言まで。
- **自分の言葉で**: 技術的な詳細をそのまま貼らず、分かったことを自分の言葉で短くまとめる。

## 構成（いちばん大事）

- `#`（H1）にタイトル、その下を `##`（H2）の**セクション**に分ける。
- 各セクションは「見出し＋1〜3文の要約」。長々と一人語りしない。
- 内容に応じて次のセクションを使う（全部使わなくてよい）:
  - `## やったこと`
  - `## 分かったこと`
  - `## 決めたこと`
  - `## 注意点` / `## ハマりポイント`
  - `## 次にやること`
  - `## 感想`
- 段落は短く、空行で区切る。並列な情報は箇条書きを使ってよい。
- 補足やツッコミは `（←こういうの）` のように丸かっこで差し込む。

## やらないこと

- **過去のノートを検索して文体・内容を真似しない**（RAG やノート参照は使わない）。
- だらだらと長い前置き・あとがきを書かない（「おしまい！」のような締めも不要）。
- 絵文字を多用しない（使うとしてもごく稀）。
- 表・太字の多用、過度に整いすぎた報告書調にしない。
- 硬すぎる敬語（〜させていただきます）や、教訓めいた大げさな締め（「〜が大切です」の連発）をしない。

## フォーマット

先頭に frontmatter を付ける。

```markdown
---
tags:
  - <内容に合うタグ>
created: YYYY-MM-DD
---
```

- `tags` は内容に合うものを1〜3個（例: `daily`, `idea`, `NixOS`, `磁石祭`）。
- `created` は当日の日付。

## 例

```markdown
---
tags:
  - GitHub
  - CI
created: 2026-10-15
---

# GitHub Actions の bot アイコンを変えたい

## 分かったこと

- デフォルトの `github-actions[bot]` のアイコンは GitHub 側で固定されていて、ユーザーからは変えられない。
- 変えるには自分で GitHub App を作り、そのロゴを設定するしかないみたい。

## やったこと

- 見てみたら、すでに `setup-git-bot` という composite action で App の bot を使うようになっていた。自分でやったのに忘れてたやつ。
- Web UI の Settings → Developer settings → GitHub Apps → Display information → Logo から画像を上げて保存するだけ。コードは触らなくてよかった。

## 注意点

- 過去の commit のアイコンは変わらない。
- Org 持ちの App は、個人の Developer settings からは見えないことがある。ここだけ少しハマりポイントかな。

## 感想

コードは1行も書いてないけど、知識の穴が1個埋まった感じで地味にうれしい。
```
