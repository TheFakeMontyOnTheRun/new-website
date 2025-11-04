# POSIX-compliant Makefile for a Markdown → HTML static site
# Generates index.html and RSS feed sorted by modification time (ISO dates)

SRC_DIR := src
INDEX_MD := $(SRC_DIR)/index.md
BUILD_DIR := build
MARKDOWN := markdown
SITE_URL := https://example.neocities.org   # ← change this
SITE_TITLE := "My Neocities Site"
SITE_DESCRIPTION := "A personal site built with Markdown and Make"

MD_FILES := $(wildcard $(SRC_DIR)/*.md)
HTML_FILES := $(patsubst $(SRC_DIR)/%.md,$(BUILD_DIR)/%.html,$(MD_FILES))
ZIP_FILE := site.zip

all: $(HTML_FILES) $(BUILD_DIR)/index.html $(BUILD_DIR)/feed.xml

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Convert Markdown → HTML
$(BUILD_DIR)/%.html: $(SRC_DIR)/%.md | $(BUILD_DIR)
	$(MARKDOWN) $< > $@

# POSIX: Get ISO date from file using ls -lT or find
define get_iso_date
sh -c 'find "$1" -prune -printf "%TY-%Tm-%TdT%TH:%TM:%TSZ\n" 2>/dev/null || \
  ls -lT "$1" 2>/dev/null | awk "{print \$$6\"-\"\$$7\"-\"\$$8\"T00:00:00Z\"}"' dummy "$1"
endef

# Generate index.html (strict POSIX)
$(BUILD_DIR)/index.html: $(HTML_FILES) $(INDEX_MD)
	@echo "Generating index.html (links + ISO dates + updates)..."
	@{ \
		echo "<!DOCTYPE html>"; \
		echo "<html lang='en'>"; \
		echo "<head><meta charset='UTF-8'><title>$(SITE_TITLE)</title>"; \
		echo "<meta name='viewport' content='width=device-width, initial-scale=1'>"; \
		echo "<link rel='alternate' type='application/rss+xml' href='feed.xml' title='RSS Feed'>"; \
		echo "<style>body{font-family:sans-serif;max-width:700px;margin:2em auto;line-height:1.6;}li{margin-bottom:.4em;}time,span{color:#666;font-size:.9em;}</style>"; \
		echo "</head><body>"; \
		if [ -f $(INDEX_MD) ]; then \
			$(MARKDOWN) $(INDEX_MD); \
		fi; \
		echo "<h2>Articles</h2><ul>"; \
		find $(SRC_DIR) -name '*.md' ! -name 'index.md' -type f -exec sh -c '\
			for f; do \
				base="$${f##*/}"; \
				html="build/$${base%.md}.html"; \
				title="$$(head -n 1 $$f | sed "s/^# *//")"; \
				[ -z "$$title" ] && title="$${base%.md}"; \
				ctime=""; mtime=""; \
				if stat -f "%SB" -t "%Y-%m-%dT%H:%M:%SZ" "$$f" >/dev/null 2>&1; then \
					ctime="$$(stat -f "%SB" -t "%Y-%m-%dT%H:%M:%SZ" "$$f")"; \
					mtime="$$(stat -f "%Sm" -t "%Y-%m-%dT%H:%M:%SZ" "$$f")"; \
				elif stat -c "%w" "$$f" >/dev/null 2>&1; then \
					ctime="$$(stat -c "%w" "$$f" | sed "s/\.[0-9]*//")Z"; \
					mtime="$$(stat -c "%y" "$$f" | sed "s/\.[0-9]*//")Z"; \
				else \
					ctime="$$(date -u +%Y-%m-%dT%H:%M:%SZ -r $$f 2>/dev/null || echo "")"; \
					mtime="$$ctime"; \
				fi; \
				[ -z "$$ctime" ] && ctime="$$mtime"; \
				echo "$$mtime|$$ctime|$$html|$$title"; \
			done \
		' sh {} + | sort -r | \
		while IFS="|" read -r mtime ctime html title; do \
			echo "<li><a href=\"$${html##*/}\">$$title</a> — <time datetime=\"$$ctime\">$$ctime</time>"; \
			if [ "$$mtime" != "$$ctime" ]; then \
				echo " <span>(Updated $$mtime)</span>"; \
			fi; \
			echo "</li>"; \
		done; \
		echo "</ul></body></html>"; \
	} > $(BUILD_DIR)/index.html



# Generate RSS feed (strict POSIX)
$(BUILD_DIR)/feed.xml: $(HTML_FILES)
	@echo "Generating RSS feed (with updated dates)..."
	@{ \
		echo '<?xml version="1.0" encoding="UTF-8"?>'; \
		echo '<rss version="2.0">'; \
		echo '<channel>'; \
		echo "  <title>$(SITE_TITLE)</title>"; \
		echo "  <link>$(SITE_URL)</link>"; \
		echo "  <description>$(SITE_DESCRIPTION)</description>"; \
		echo "  <lastBuildDate>$$(date -u +%Y-%m-%dT%H:%M:%SZ)</lastBuildDate>"; \
		find $(SRC_DIR) -name '*.md' ! -name 'index.md' -type f -exec sh -c '\
			for f; do \
				base="$${f##*/}"; \
				html="$${base%.md}.html"; \
				title="$$(head -n 1 $$f | sed "s/^# *//")"; \
				[ -z "$$title" ] && title="$${base%.md}"; \
				if stat -f "%Sm" -t "%Y-%m-%dT%H:%M:%SZ" "$$f" >/dev/null 2>&1; then \
					mtime="$$(stat -f "%Sm" -t "%Y-%m-%dT%H:%M:%SZ" "$$f")"; \
				elif stat -c "%y" "$$f" >/dev/null 2>&1; then \
					mtime="$$(stat -c "%y" "$$f" | sed "s/\.[0-9]*//")Z"; \
				else \
					mtime="$$(date -u +%Y-%m-%dT%H:%M:%SZ -r $$f 2>/dev/null || echo "")"; \
				fi; \
				echo "$$mtime|$$html|$$title"; \
			done \
		' sh {} + | sort -r | \
		while IFS="|" read -r iso html title; do \
			echo "  <item>"; \
			echo "    <title>$$title</title>"; \
			echo "    <link>$(SITE_URL)/$$html</link>"; \
			echo "    <guid>$(SITE_URL)/$$html</guid>"; \
			echo "    <pubDate>$$iso</pubDate>"; \
			echo "  </item>"; \
		done; \
		echo '</channel></rss>'; \
	} > $(BUILD_DIR)/feed.xml



package: all
	rm -f $(ZIP_FILE)
	zip -r $(ZIP_FILE) $(BUILD_DIR) assets css js images 2>/dev/null || zip -r $(ZIP_FILE) $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR) $(ZIP_FILE)

.PHONY: all clean package
