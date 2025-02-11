#!/usr/bin/env sh

# Dir related logic
YEAR=$(date '+%Y')

DOCUMENTS_DIR=${XDG_DOCUMENTS_DIR:-"$HOME/documents"}
DIARY_DIR="$DOCUMENTS_DIR/diary"

mkdir -p "$DOCUMENTS_DIR"
mkdir -p "$DIARY_DIR"
mkdir -p "$DIARY_DIR/$YEAR"
mkdir -p "$DIARY_DIR/$YEAR/media"

# Setting up important variables
DATE=$(date '+%Y-%m-%d')

ENTRY_COUNT=$(find "$DIARY_DIR" -type f -name "*.md" | wc -l)

echo "You're writing again??? :00"
echo "What's the title for this entry?: "
read -r TITLE

# Create and open the file
FILEPATH="$DIARY_DIR/$YEAR/Entry $ENTRY_COUNT: $TITLE.md"
echo -e "# Entry $ENTRY_COUNT: $TITLE\n\n[WRITE HERE DUMBASS]\n\n- Name <3 ($DATE)" > "$FILEPATH"
nvim +3 "$FILEPATH"
