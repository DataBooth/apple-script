on run argv
    if (count of argv) < 1 then
        display dialog "Usage: osascript find-physio-receipts.scpt <sender-email>"
        return
    end if

    set theSender to item 1 of argv
    set saveFolder to (POSIX path of (path to home folder)) & "apple-script/invoices/"
    set senderCount to 0
    set foundCount to 0

    -- Ensure save folder exists
    do shell script "mkdir -p " & quoted form of saveFolder

    tell application "Mail"
        repeat with aMailbox in mailboxes
            repeat with aMessage in (messages of aMailbox)
                if (sender of aMessage contains theSender) then
                    set senderCount to senderCount + 1
                    if (count mail attachment of aMessage) > 0 then
                        set msgDate to date sent of aMessage
                        set {year:y, month:m, day:d, hours:h, minutes:min} to msgDate
                        set formattedDate to (y as string) & "-" & (m as integer) & "-" & (d as string) & "_" & text -2 thru -1 of ("0" & h) & "-" & text -2 thru -1 of ("0" & min)
                        
                        repeat with anAttachment in mail attachments of aMessage
                            set attName to name of anAttachment
                            if attName starts with "invoice" and attName ends with ".pdf" then
                                set baseName to text 1 thru ((offset of ".pdf" in attName) - 1) of attName
                                set newName to baseName & "_" & formattedDate & ".pdf"
                                set savePath to saveFolder & newName
                                try
                                    save anAttachment in savePath
                                    set foundCount to foundCount + 1
                                on error errMsg
                                    display dialog "Error saving " & attName & ": " & errMsg
                                end try
                            end if
                        end repeat
                    end if
                end if
            end repeat
        end repeat
    end tell

    display dialog "Found " & senderCount & " emails from " & theSender & return & ¬
        "Saved " & foundCount & " invoice PDFs to " & saveFolder buttons {"OK"} default button "OK"
end run
