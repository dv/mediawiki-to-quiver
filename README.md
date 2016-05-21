# mediawiki-to-quiver
Simple scripts to convert your MediaWiki to Quiver app format

# usage

## Install Pandoc

On Mac:
```
brew install pandoc
```

Or check http://pandoc.org/installing.html

## Bundle

```
bundle
```

## Run

```
ruby export_to_quiver.rb https://website-of-your-mediawiki.com/some-subdir/maybe
```

## With auth
```
USER=david PASSWORD=helloworld ruby export_to_quiver.rb
```

# Thanks to
* https://github.com/prurph/markdown-to-quiver
