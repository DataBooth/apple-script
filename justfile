
default:
    @just --list

# Link all scripts in the repo's mail/com.apple.mail folder to the Mail scripts folder
link-mail-scripts:
	#! /bin/bash
	mkdir -p "$HOME/Library/Application Scripts/com.apple.mail"
	for script in ./mail/com.apple.mail/*.scpt; do
		abs_script="$(cd "$(dirname "$script")"; pwd)/$(basename "$script")"
		dest="$HOME/Library/Application Scripts/com.apple.mail/$(basename "$script")"
		ln -sf "$abs_script" "$dest"
		if [ -L "$dest" ]; then
			target="$(readlink "$dest")"
			echo "Linked $(basename "$script") -> $target"
		else
			echo "Failed to link $(basename "$script")"
		fi
	done



# Run the find-physio-receipts.scpt AppleScript
run-find-physio-receipts sender:
	osascript ./mail/com.apple.mail/find-physio-receipts.scpt "{{sender}}"

