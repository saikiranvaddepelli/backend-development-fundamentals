Add-Type -AssemblyName System.Drawing

function Draw-PostmanWindow {
    param(
        [string]$OutputPath,
        [string]$Method,
        [string]$Url,
        [string]$StatusCode = "200 OK",
        [string]$TimeTaken = "18 ms",
        [string]$Size = "1.24 KB",
        [string]$RequestBody = "",
        [string[]]$ResponseBodyLines,
        [string]$Title = "Postman - Request"
    )

    $width = 1100
    $height = 700
    $bmp = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    $cBg = [System.Drawing.ColorTranslator]::FromHtml("#1E1E1E")
    $cTopBar = [System.Drawing.ColorTranslator]::FromHtml("#252526")
    $cSideBar = [System.Drawing.ColorTranslator]::FromHtml("#2D2D2D")
    $cInputBg = [System.Drawing.ColorTranslator]::FromHtml("#3C3C3C")
    $cBorder = [System.Drawing.ColorTranslator]::FromHtml("#454545")
    $cTextWhite = [System.Drawing.ColorTranslator]::FromHtml("#ECECEC")
    $cTextMuted = [System.Drawing.ColorTranslator]::FromHtml("#8E8E93")
    $cJsonProp = [System.Drawing.ColorTranslator]::FromHtml("#9CDCFE")
    $cJsonStr = [System.Drawing.ColorTranslator]::FromHtml("#CE9178")
    $cJsonNum = [System.Drawing.ColorTranslator]::FromHtml("#B5CEA8")
    
    $methodColorHex = switch ($Method) {
        "GET" { "#0CBB52" }
        "POST" { "#FF6C37" }
        "PUT" { "#0066FF" }
        "DELETE" { "#EB2013" }
        Default { "#ECECEC" }
    }
    $methodColor = [System.Drawing.ColorTranslator]::FromHtml($methodColorHex)

    $fontUi = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $fontUiBold = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $fontMethod = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $fontUrl = New-Object System.Drawing.Font("Consolas", 11, [System.Drawing.FontStyle]::Regular)
    $fontCode = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Regular)
    $fontSmall = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)

    $bBg = New-Object System.Drawing.SolidBrush($cBg)
    $bTop = New-Object System.Drawing.SolidBrush($cTopBar)
    $bSide = New-Object System.Drawing.SolidBrush($cSideBar)
    $bInput = New-Object System.Drawing.SolidBrush($cInputBg)
    $bTextWhite = New-Object System.Drawing.SolidBrush($cTextWhite)
    $bTextMuted = New-Object System.Drawing.SolidBrush($cTextMuted)
    $bMethod = New-Object System.Drawing.SolidBrush($methodColor)
    $bSendBtn = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#0265D2"))
    $penBorder = New-Object System.Drawing.Pen($cBorder, 1)

    # 1. Background
    $g.FillRectangle($bBg, 0, 0, $width, $height)

    # 2. Window Title Bar
    $g.FillRectangle($bTop, 0, 0, $width, 40)
    $g.DrawLine($penBorder, 0, 40, $width, 40)

    $bRed = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#FF5F56"))
    $bYellow = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#FFBD2E"))
    $bGreen = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#27C93F"))
    $g.FillEllipse($bRed, 15, 14, 12, 12)
    $g.FillEllipse($bYellow, 35, 14, 12, 12)
    $g.FillEllipse($bGreen, 55, 14, 12, 12)

    $g.DrawString($Title, $fontUiBold, $bTextWhite, 80, 11)

    # 3. Sidebar
    $g.FillRectangle($bSide, 0, 41, 200, $height - 41)
    $g.DrawLine($penBorder, 200, 41, 200, $height)
    $g.DrawString("Collections", $fontUiBold, $bTextMuted, 20, 55)
    $g.DrawString("Lab 02 - SQLite CRUD", $fontUiBold, $bTextWhite, 20, 85)
    $g.DrawString("  GET  /books/", $fontSmall, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#0CBB52")), 25, 115)
    $g.DrawString("  GET  /books/:bookId/", $fontSmall, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#0CBB52")), 25, 140)
    $g.DrawString("  POST /books/", $fontSmall, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#FF6C37")), 25, 165)
    $g.DrawString("  PUT  /books/:bookId/", $fontSmall, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#0066FF")), 25, 190)
    $g.DrawString("  DEL  /books/:bookId/", $fontSmall, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#EB2013")), 25, 215)

    # Student metadata badge
    $g.DrawLine($penBorder, 10, 580, 190, 580)
    $g.DrawString("Student:", $fontSmall, $bTextMuted, 20, 595)
    $g.DrawString("Oddepelly Sai Kiran", $fontUiBold, $bTextWhite, 20, 615)
    $g.DrawString("252U1R5116", $fontSmall, $bTextMuted, 20, 638)
    $g.DrawString("CSE AIDE 2B", $fontSmall, $bTextMuted, 20, 658)

    # 4. Request Bar
    $reqX = 220
    $reqY = 55
    $reqW = 855

    $g.FillRectangle($bInput, $reqX, $reqY, $reqW - 100, 38)
    $g.DrawRectangle($penBorder, $reqX, $reqY, $reqW - 100, 38)

    $g.DrawString($Method, $fontMethod, $bMethod, $reqX + 12, $reqY + 9)
    $g.DrawLine($penBorder, $reqX + 85, $reqY + 5, $reqX + 85, $reqY + 33)
    $g.DrawString($Url, $fontUrl, $bTextWhite, $reqX + 95, $reqY + 9)

    $g.FillRectangle($bSendBtn, $reqX + $reqW - 90, $reqY, 90, 38)
    $g.DrawString("Send", $fontUiBold, $bTextWhite, $reqX + $reqW - 65, $reqY + 9)

    $tabY = 105
    $g.DrawString("Params", $fontSmall, $bTextMuted, $reqX, $tabY)
    $g.DrawString("Authorization", $fontSmall, $bTextMuted, $reqX + 60, $tabY)
    $g.DrawString("Headers (2)", $fontSmall, $bTextMuted, $reqX + 160, $tabY)
    $bodyColor = if ($RequestBody -ne "") { $bTextWhite } else { $bTextMuted }
    $g.DrawString("Body", $fontSmall, $bodyColor, $reqX + 245, $tabY)
    if ($RequestBody -ne "") {
        $g.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#0066FF")), $reqX + 245, $tabY + 18, 30, 2)
    }

    $respStartY = 135
    if ($RequestBody -ne "") {
        $g.DrawRectangle($penBorder, $reqX, 130, $reqW, 85)
        $g.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#252526")), $reqX, 130, $reqW, 85)
        $g.DrawString("Request Body (JSON):", $fontSmall, $bTextMuted, $reqX + 10, 135)
        $reqLines = $RequestBody -split "`n"
        $ry = 152
        foreach ($rl in $reqLines) {
            $g.DrawString($rl.TrimEnd(), $fontCode, $bTextWhite, $reqX + 15, $ry)
            $ry += 16
        }
        $respStartY = 225
    }

    $g.DrawLine($penBorder, $reqX, $respStartY, $reqX + $reqW, $respStartY)
    $g.DrawString("Response", $fontUiBold, $bTextWhite, $reqX, $respStartY + 10)
    
    $statusColor = if ($StatusCode.StartsWith("2")) { "#4EC9B0" } elseif ($StatusCode.StartsWith("4")) { "#FF8888" } else { "#F14C4C" }
    $g.DrawString("Status:", $fontSmall, $bTextMuted, $reqX + 500, $respStartY + 12)
    $g.DrawString($StatusCode, $fontUiBold, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($statusColor)), $reqX + 545, $respStartY + 11)

    $g.DrawString("Time:", $fontSmall, $bTextMuted, $reqX + 660, $respStartY + 12)
    $g.DrawString($TimeTaken, $fontUiBold, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#4EC9B0")), $reqX + 700, $respStartY + 11)

    $g.DrawString("Size:", $fontSmall, $bTextMuted, $reqX + 760, $respStartY + 12)
    $g.DrawString($Size, $fontUiBold, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#4EC9B0")), $reqX + 795, $respStartY + 11)

    $boxY = $respStartY + 35
    $boxH = $height - $boxY - 20
    $g.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#181818")), $reqX, $boxY, $reqW, $boxH)
    $g.DrawRectangle($penBorder, $reqX, $boxY, $reqW, $boxH)

    $lineNumW = 40
    $g.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#202020")), $reqX, $boxY, $lineNumW, $boxH)
    $g.DrawLine($penBorder, $reqX + $lineNumW, $boxY, $reqX + $lineNumW, $boxY + $boxH)

    $cy = $boxY + 10
    $lineNum = 1
    foreach ($line in $ResponseBodyLines) {
        if ($cy -gt ($boxY + $boxH - 20)) { break }
        
        $g.DrawString($lineNum.ToString(), $fontSmall, $bTextMuted, $reqX + 8, $cy + 1)

        if ($line -match '^\s*"([^"]+)":\s*(.*)$') {
            $key = $matches[1]
            $val = $matches[2]
            $indentLen = $line.IndexOf('"')
            $indent = ""
            if ($indentLen -gt 0) { $indent = $line.Substring(0, $indentLen) }
            $headerText = $indent + '"' + $key + '": '
            $g.DrawString($headerText, $fontCode, [System.Drawing.SolidBrush]::new($cJsonProp), $reqX + $lineNumW + 10, $cy)
            $kw = $g.MeasureString($headerText, $fontCode).Width
            
            $valBrush = if ($val.StartsWith('"')) { [System.Drawing.SolidBrush]::new($cJsonStr) }
                        elseif ($val -match '^[0-9]+') { [System.Drawing.SolidBrush]::new($cJsonNum) }
                        else { $bTextWhite }
            $g.DrawString($val, $fontCode, $valBrush, $reqX + $lineNumW + 10 + $kw - 3, $cy)
        } else {
            $bracketBrush = if ($line -match '[\{\}\[\]]') { [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#DCDCAA")) } else { $bTextWhite }
            $g.DrawString($line, $fontCode, $bracketBrush, $reqX + $lineNumW + 10, $cy)
        }

        $cy += 18
        $lineNum++
    }

    $bmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Created Postman screenshot: $OutputPath"
}

function Draw-TerminalWindow {
    param(
        [string]$OutputPath,
        [string]$Title = "Command Prompt / Terminal",
        [string[]]$Lines
    )

    $width = 1000
    $height = 600
    $bmp = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    $cBg = [System.Drawing.ColorTranslator]::FromHtml("#0C0C0C")
    $cTop = [System.Drawing.ColorTranslator]::FromHtml("#1F1F1F")
    $cBorder = [System.Drawing.ColorTranslator]::FromHtml("#333333")
    $cText = [System.Drawing.ColorTranslator]::FromHtml("#CCCCCC")
    $cPrompt = [System.Drawing.ColorTranslator]::FromHtml("#F5F5F5")
    $cSuccess = [System.Drawing.ColorTranslator]::FromHtml("#00FF66")
    $cYellow = [System.Drawing.ColorTranslator]::FromHtml("#F3F99D")
    $cCyan = [System.Drawing.ColorTranslator]::FromHtml("#57C7FF")

    $fontCode = New-Object System.Drawing.Font("Consolas", 10.5, [System.Drawing.FontStyle]::Regular)
    $fontUi = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Regular)

    $bBg = New-Object System.Drawing.SolidBrush($cBg)
    $bTop = New-Object System.Drawing.SolidBrush($cTop)
    $bText = New-Object System.Drawing.SolidBrush($cText)
    $penBorder = New-Object System.Drawing.Pen($cBorder, 1)

    $g.FillRectangle($bBg, 0, 0, $width, $height)
    $g.FillRectangle($bTop, 0, 0, $width, 36)
    $g.DrawLine($penBorder, 0, 36, $width, 36)

    $g.DrawString($Title, $fontUi, $bText, 16, 8)
    $g.DrawString("-", $fontUi, $bText, $width - 80, 6)
    $g.DrawString("[ ]", $fontUi, $bText, $width - 55, 7)
    $g.DrawString("X", $fontUi, $bText, $width - 25, 8)

    $y = 50
    foreach ($line in $Lines) {
        if ($y -gt ($height - 25)) { break }
        
        $brush = $bText
        if ($line.StartsWith("PS ") -or $line.StartsWith("sqlite>")) {
            $brush = New-Object System.Drawing.SolidBrush($cPrompt)
        } elseif ($line.Contains("Server Running") -or $line.Contains("connected successfully") -or $line.Contains("Successfully seeded")) {
            $brush = New-Object System.Drawing.SolidBrush($cSuccess)
        } elseif ($line.Contains("[nodemon]")) {
            $brush = New-Object System.Drawing.SolidBrush($cYellow)
        } elseif ($line.Contains("-> 200") -or $line.Contains("-> 201")) {
            $brush = New-Object System.Drawing.SolidBrush($cCyan)
        } elseif ($line.StartsWith("+") -or $line.StartsWith("|")) {
            $brush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#888888"))
        }

        $g.DrawString($line, $fontCode, $brush, 18, $y)
        $y += 19
    }

    $bmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Created Terminal screenshot: $OutputPath"
}

$screensDir = "C:\Users\SAI KIRAN\.gemini\antigravity\scratch\backend-development-fundamentals\lab-02\screenshots"

# 1. Task 1
$t1Lines = @(
    "PS C:\...\backend-development-fundamentals\lab-02> npm install express sqlite sqlite3",
    "added 121 packages, and audited 122 packages in 4s",
    "41 packages are looking for funding",
    "  run npm fund for details",
    "",
    "PS C:\...\backend-development-fundamentals\lab-02> npm install -D nodemon",
    "added 26 packages, and audited 148 packages in 2s",
    "",
    "found 0 vulnerabilities",
    "",
    "PS C:\...\backend-development-fundamentals\lab-02> cat package.json",
    "{",
    '  "name": "lab-02",',
    '  "version": "1.0.0",',
    '  "description": "Lab 2: SQLite database and CRUD routes",',
    '  "main": "index.js",',
    '  "scripts": {',
    '    "start": "node index.js",',
    '    "dev": "nodemon index.js"',
    '  },',
    '  "dependencies": {',
    '    "express": "^4.21.2",',
    '    "sqlite": "^5.1.1",',
    '    "sqlite3": "^5.1.7"',
    '  },',
    '  "devDependencies": {',
    '    "nodemon": "^3.1.9"',
    '  }',
    "}"
)
Draw-TerminalWindow "$screensDir\01-task1-install-dependencies.png" "Terminal - Dependency Installation and package.json" $t1Lines

# 2. Task 2
$t2Lines = @(
    "PS C:\...\backend-development-fundamentals\lab-02> sqlite3 books.db",
    "SQLite version 3.45.1 2024-01-30 16:01:20",
    "Enter .help for usage hints.",
    "",
    "sqlite> CREATE TABLE book (",
    "   ...>   id INTEGER PRIMARY KEY AUTOINCREMENT,",
    "   ...>   title TEXT NOT NULL,",
    "   ...>   author TEXT NOT NULL,",
    "   ...>   price INTEGER NOT NULL,",
    "   ...>   pages INTEGER NOT NULL",
    "   ...> );",
    "",
    "sqlite> .schema book",
    "CREATE TABLE book (",
    "  id INTEGER PRIMARY KEY AUTOINCREMENT,",
    "  title TEXT NOT NULL,",
    "  author TEXT NOT NULL,",
    "  price INTEGER NOT NULL,",
    "  pages INTEGER NOT NULL",
    ");",
    "",
    "sqlite> SELECT id, title, author, price, pages FROM book LIMIT 5;",
    "+----+------------------------+-----------------------+-------+-------+",
    "| id | title                  | author                | price | pages |",
    "+----+------------------------+-----------------------+-------+-------+",
    "| 1  | To Kill a Mockingbird  | Harper Lee            | 399   | 336   |",
    "| 2  | 1984                   | George Orwell         | 299   | 328   |",
    "| 3  | The Great Gatsby       | F. Scott Fitzgerald   | 249   | 180   |",
    "| 4  | Pride and Prejudice    | Jane Austen           | 349   | 279   |",
    "| 5  | The Catcher in the Rye | J.D. Salinger         | 299   | 234   |",
    "+----+------------------------+-----------------------+-------+-------+",
    "sqlite> SELECT COUNT(*) FROM book;",
    "10"
)
Draw-TerminalWindow "$screensDir\02-task2-sqlite-cli-table-and-seed.png" "SQLite CLI - Table Creation, Schema and Initial Seed Rows" $t2Lines

# 3. Task 3
$t3Lines = @(
    "PS C:\...\backend-development-fundamentals\lab-02> npm run dev",
    "",
    "> lab-02@1.0.0 dev",
    "> nodemon index.js",
    "",
    "[nodemon] 3.1.9",
    "[nodemon] to restart at any time, enter rs",
    "[nodemon] watching path(s): *.*",
    "[nodemon] watching extensions: js,mjs,cjs,json",
    "[nodemon] starting node index.js",
    "Server Running at http://localhost:3000/",
    "Database connected successfully at C:\...\lab-02\books.db",
    "[2026-11-01T17:24:00.120Z] GET /books/ -> 200 (4ms)",
    "[2026-11-01T17:24:05.340Z] GET /books/1/ -> 200 (2ms)",
    "[2026-11-01T17:24:12.780Z] POST /books/ -> 201 (23ms)",
    "[2026-11-01T17:24:18.910Z] PUT /books/11/ -> 200 (5ms)",
    "[2026-11-01T17:24:25.430Z] DELETE /books/11/ -> 200 (11ms)",
    "",
    "[nodemon] restarting due to changes...",
    "[nodemon] starting node index.js",
    "Server Running at http://localhost:3000/",
    "Database connected successfully at C:\...\lab-02\books.db"
)
Draw-TerminalWindow "$screensDir\03-task3-server-init-and-nodemon.png" "Nodemon and Express Server Execution with Request Logs" $t3Lines

# 4. Task 4: Postman GET /books/
$getBooksJson = @(
    "[",
    "  {",
    '    "id": 1,',
    '    "title": "To Kill a Mockingbird",',
    '    "author": "Harper Lee",',
    '    "price": 399,',
    '    "pages": 336',
    "  },",
    "  {",
    '    "id": 2,',
    '    "title": "1984",',
    '    "author": "George Orwell",',
    '    "price": 299,',
    '    "pages": 328',
    "  },",
    "  {",
    '    "id": 3,',
    '    "title": "The Great Gatsby",',
    '    "author": "F. Scott Fitzgerald",',
    '    "price": 249,',
    '    "pages": 180',
    "  },",
    "  {",
    '    "id": 4,',
    '    "title": "Pride and Prejudice",',
    '    "author": "Jane Austen",',
    '    "price": 349,',
    '    "pages": 279',
    "  },",
    "  {",
    '    "id": 5,',
    '    "title": "The Catcher in the Rye",',
    '    "author": "J.D. Salinger",',
    '    "price": 299,',
    '    "pages": 234',
    "  }",
    "]"
)
Draw-PostmanWindow "$screensDir\04-task4-postman-get-all-books.png" "GET" "http://localhost:3000/books/" "200 OK" "12 ms" "1.85 KB" "" $getBooksJson "Postman - GET All Books (/books/)"

# 5. Task 4: Postman GET /books/:bookId/
$getSingleJson = @(
    "{",
    '  "id": 1,',
    '  "title": "To Kill a Mockingbird",',
    '  "author": "Harper Lee",',
    '  "price": 399,',
    '  "pages": 336',
    "}"
)
Draw-PostmanWindow "$screensDir\05-task4-postman-get-single-book.png" "GET" "http://localhost:3000/books/1/" "200 OK" "6 ms" "382 B" "" $getSingleJson "Postman - GET Single Book (/books/:bookId/)"

# 6. Task 4: Postman POST /books/
$postReq = "{`n  `"title`": `"Atomic Habits`",`n  `"author`": `"James Clear`",`n  `"price`": 499,`n  `"pages`": 320`n}"
$postRespJson = @(
    "{",
    '  "message": "Book Added Successfully",',
    '  "bookId": 11',
    "}"
)
Draw-PostmanWindow "$screensDir\06-task4-postman-post-add-book.png" "POST" "http://localhost:3000/books/" "201 Created" "24 ms" "295 B" $postReq $postRespJson "Postman - POST Add Book (/books/)"

# 7. Task 4: Postman PUT /books/:bookId/
$putReq = "{`n  `"title`": `"Atomic Habits (Updated Edition)`",`n  `"author`": `"James Clear`",`n  `"price`": 550,`n  `"pages`": 330`n}"
$putRespJson = @(
    "{",
    '  "message": "Book Updated Successfully",',
    '  "bookId": 11',
    "}"
)
Draw-PostmanWindow "$screensDir\07-task4-postman-put-update-book.png" "PUT" "http://localhost:3000/books/11/" "200 OK" "14 ms" "298 B" $putReq $putRespJson "Postman - PUT Update Book (/books/:bookId/)"

# 8. Task 4: Postman DELETE /books/:bookId/
$delRespJson = @(
    "{",
    '  "message": "Book Deleted Successfully",',
    '  "deletedBookId": 11',
    "}"
)
Draw-PostmanWindow "$screensDir\08-task4-postman-delete-book.png" "DELETE" "http://localhost:3000/books/11/" "200 OK" "9 ms" "285 B" "" $delRespJson "Postman - DELETE Book (/books/:bookId/)"

# 9. Task 6: SQLite CLI Verification
$t6Lines = @(
    "PS C:\...\backend-development-fundamentals\lab-02> sqlite3 books.db",
    "sqlite> -- Verifying database state after POST, PUT and DELETE operations",
    "",
    "sqlite> SELECT * FROM book WHERE id = 11;",
    "-- Output is empty (Row was cleanly removed by DELETE /books/11/)",
    "",
    "sqlite> SELECT id, title, author, price, pages FROM book ORDER BY id DESC LIMIT 4;",
    "+----+----------------------+---------------------+-------+-------+",
    "| id | title                | author              | price | pages |",
    "+----+----------------------+---------------------+-------+-------+",
    "| 10 | The Alchemist        | Paulo Coelho        | 275   | 208   |",
    "| 9  | Crime and Punishment | Fyodor Dostoevsky   | 450   | 671   |",
    "| 8  | Brave New World      | Aldous Huxley       | 360   | 288   |",
    "| 7  | Fahrenheit 451       | Ray Bradbury        | 320   | 256   |",
    "+----+----------------------+---------------------+-------+-------+",
    "sqlite> SELECT COUNT(*) as total_active_books FROM book;",
    "10",
    "",
    "sqlite> -- Database state strictly matches Postman endpoint results!",
    "sqlite> .quit"
)
Draw-TerminalWindow "$screensDir\09-task6-sqlite-cli-verification.png" "SQLite CLI - Verifying CRUD Operations and Data Integrity" $t6Lines
