on run argv
    set sampleList to {}
    set sampleLimit to 10
    set inboxesFound to 0

    tell application "Mail"
        set debugInfo to ""
        set allMailboxes to mailboxes
        repeat with mbox in allMailboxes
            set mboxName to name of mbox as string
            if mboxName as lowercase is equal to "inbox" then
                set inboxesFound to inboxesFound + 1
                set debugInfo to debugInfo & "Top-level Inbox: " & mboxName & return
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
            end if
        end repeat
    end tell

    set outputText to "=== Inboxes found: " & inboxesFound & " ===" & return & debugInfo & return & "=== Sample Messages ===" & return & (sampleList as string)
    display dialog outputText buttons {"OK"} default button "OK"
end run
