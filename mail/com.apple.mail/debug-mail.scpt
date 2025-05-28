on run argv
    set sampleList to {}
    set sampleLimit to 10
    set inboxesFound to 0
    set debugInfo to ""
    set inboxMailboxes to {}

    tell application "Mail"
        -- Flatten all mailboxes into a list
        set allMailboxes to my flattenMailboxes(mailboxes)
        -- Find all mailboxes named "Inbox" (case-insensitive)
        repeat with mbox in allMailboxes
            set mboxName to name of mbox as string
            if mboxName as lowercase is equal to "inbox" then
                set end of inboxMailboxes to mbox
            end if
        end repeat

        set inboxesFound to count of inboxMailboxes
        repeat with mbox in inboxMailboxes
            set mboxName to name of mbox as string
            set debugInfo to debugInfo & "Inbox: " & mboxName & return
            set msgCount to count of messages of mbox
            set debugInfo to debugInfo & "  Messages: " & msgCount & return
            repeat with aMessage in (messages of mbox)
                set senderString to ""
                set subjectString to ""
                try
                    set senderString to sender of aMessage
                end try
                try
                    set subjectString to subject of aMessage
                end try
                set sampleEntry to "Sender: " & senderString & return & "Subject: " & subjectString
                if sampleEntry is not in sampleList then
                    set end of sampleList to sampleEntry
                end if
                if (count of sampleList) ≥ sampleLimit then exit repeat
            end repeat
            if (count of sampleList) ≥ sampleLimit then exit repeat
        end repeat
    end tell

    set outputText to "=== Inboxes found: " & inboxesFound & " ===" & return & debugInfo & return & "=== Sample Messages ===" & return & (sampleList as string)
    display dialog outputText buttons {"OK"} default button "OK"
end run

-- Helper to flatten mailbox hierarchy
on flattenMailboxes(mailboxList)
    set flatList to {}
    repeat with mbox in mailboxList
        set end of flatList to mbox
        tell application "Mail"
            set subMailboxes to mailboxes of mbox
            if (count of subMailboxes) > 0 then
                set flatList to flatList & my flattenMailboxes(subMailboxes)
            end if
        end tell
    end repeat
    return flatList
end flattenMailboxes
