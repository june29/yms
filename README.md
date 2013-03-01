# YMS

Just for [mktakuya/YMS](https://github.com/mktakuya/YMS "mktakuya/YMS · GitHub")

## 背景

[mktakuya/YMS](https://github.com/mktakuya/YMS "mktakuya/YMS · GitHub") のコードレビューのお願いを受けて、色々と思うところはあったけれど、コード1行1行にコメントしていくよりは「こういう設計はどうかな？」を示したかったので、つくった。

## 概要

### 基本的な使い方

```
$ ruby main.rb -c path/to/config.yml
```

### config ファイル

`configs` ディレクトリの下に、変更をチェックしたいページごとに config ファイルを YAML で書いて置く。新しくページを足すときは、初回起動時に `--init` オプションをつけて動かす。そうすると `cache` ディレクトリの下に、その時点での対象ページの HTML をファイルに保存する。以降は、そのファイルを比較対象とする。もし対象ページに変更があったら config ファイルの `notifications` の設定に従って通知する。

### 様子

コンソール上で動かしているところ [yms | Flickr - Movie Sharing!](http://www.flickr.com/photos/june29/8518438406/ "yms | Flickr - Photo Sharing!")
