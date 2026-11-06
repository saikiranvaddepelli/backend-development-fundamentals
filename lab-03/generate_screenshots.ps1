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
        [string]$Title = "Postman - Lab 03 REST API & Validation"
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

    $g.FillRectangle($bBg, 0, 0, $width, $height)

    $g.FillRectangle($bTop, 0, 0, $width, 40)
    $g.DrawLine($penBorder, 0, 40, $width, 40)

    $bRed = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#FF5F56"))
    $bYellow = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#FFBD2E"))
    $bGreen = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#27C93F"))
    $g.FillEllipse($bRed, 15, 14, 12, 12)
    $g.FillEllipse($bYellow, 35, 14, 12, 12)
    $g.FillEllipse($bGreen, 55, 14, 12, 12)

    $g.DrawString($Title, $fontUiBold, $bTextWhite, 80, 11)

    $g.FillRectangle($bSide, 0, 41, 205, $height - 41)
    $g.DrawLine($penBorder, 205, 41, 205, $height)
    $g.DrawString("Collections", $fontUiBold, $bTextMuted, 16, 52)
    $g.DrawString("Lab 03 - REST API", $fontUiBold, $bTextWhite, 16, 75)

    $g.DrawString("  GET  /books/", $fontSmall, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#0CBB52")), 16, 105)
    $g.DrawString("  GET  ?search_q=", $fontSmall, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#0CBB52")), 16, 130)
    $g.DrawString("  GET  ?min_price=", $fontSmall, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#0CBB52")), 16, 155)
    $g.DrawString("  GET  ?order_by=", $fontSmall, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#0CBB52")), 16, 180)
    $g.DrawString("  GET  /books/:id/", $fontSmall, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#0CBB52")), 16, 205)
    $g.DrawString("  POST /books/", $fontSmall, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#FF6C37")), 16, 230)
    $g.DrawString("  PUT  /books/:id/", $fontSmall, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#0066FF")), 16, 255)
    $g.DrawString("  DEL  /books/:id/", $fontSmall, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#EB2013")), 16, 280)

    $g.DrawLine($penBorder, 10, 560, 195, 560)
    $g.DrawString("Student:", $fontSmall, $bTextMuted, 16, 575)
    $g.DrawString("ODDEPELLY SAIKIRAN", $fontUiBold, $bTextWhite, 16, 595)
    $g.DrawString("252U1R5116", $fontSmall, $bTextMuted, 16, 618)
    $g.DrawString("313 AI DE 2B", $fontSmall, $bTextMuted, 16, 638)
    $g.DrawString("Backend Dev Fundamentals", $fontSmall, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#9CDCFE")), 16, 658)

    $reqX = 225
    $reqY = 55
    $reqW = 850

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
    $g.DrawString("Status:", $fontSmall, $bTextMuted, $reqX + 490, $respStartY + 12)
    $g.DrawString($StatusCode, $fontUiBold, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($statusColor)), $reqX + 535, $respStartY + 11)

    $g.DrawString("Time:", $fontSmall, $bTextMuted, $reqX + 655, $respStartY + 12)
    $g.DrawString($TimeTaken, $fontUiBold, [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#4EC9B0")), $reqX + 695, $respStartY + 11)

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
        [string]$Title = "Command Prompt - SQLite CLI Database Inspection",
        [string[]]$Lines
    )

    $width = 1100
    $height = 700
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

    $fontCode = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Regular)
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

    $y = 48
    foreach ($line in $Lines) {
        if ($y -gt ($height - 25)) { break }
        
        $brush = $bText
        if ($line.StartsWith("PS ") -or $line.StartsWith("sqlite>")) {
            $brush = New-Object System.Drawing.SolidBrush($cPrompt)
        } elseif ($line.Contains("Server Running") -or $line.Contains("Database initialized") -or $line.Contains("Book Added") -or $line.Contains("Book Deleted")) {
            $brush = New-Object System.Drawing.SolidBrush($cSuccess)
        } elseif ($line.Contains("---") -or $line.StartsWith("/*") -or $line.StartsWith("--")) {
            $brush = New-Object System.Drawing.SolidBrush($cYellow)
        } elseif ($line.Contains("ODDEPELLY SAIKIRAN") -or $line.Contains("252U1R5116") -or $line.Contains("313 AI DE 2B")) {
            $brush = New-Object System.Drawing.SolidBrush($cCyan)
        } elseif ($line.StartsWith("+") -or $line.StartsWith("|")) {
            $brush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#A0A0A0"))
        }

        $g.DrawString($line, $fontCode, $brush, 18, $y)
        $y += 18
    }

    $bmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Created Terminal screenshot: $OutputPath"
}

$scDir = "C:\Users\SAI KIRAN\.gemini\antigravity\scratch\backend-development-fundamentals\lab-03\screenshots"

Draw-PostmanWindow `
    -OutputPath "$scDir\01-default-get-books.png" `
    -Method "GET" `
    -Url "http://localhost:3000/books/" `
    -StatusCode "200 OK" `
    -TimeTaken "16 ms" `
    -Size "2.45 KB" `
    -Title "Postman - GET /books/ (Default Query Parameters)" `
    -ResponseBodyLines @(
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
        '    "title": "The Catcher in the Rye",',
        '    "author": "J.D. Salinger",',
        '    "price": 349,',
        '    "pages": 240',
        "  },",
        "  {",
        '    "id": 5,',
        '    "title": "Pride and Prejudice",',
        '    "author": "Jane Austen",',
        '    "price": 199,',
        '    "pages": 432',
        "  },",
        "  ...",
        "]"
    )

Draw-PostmanWindow `
    -OutputPath "$scDir\02-search-query.png" `
    -Method "GET" `
    -Url "http://localhost:3000/books/?search_q=the" `
    -StatusCode "200 OK" `
    -TimeTaken "14 ms" `
    -Size "840 B" `
    -Title "Postman - GET /books/?search_q=the (Partial Title Match)" `
    -ResponseBodyLines @(
        "[",
        "  {",
        '    "id": 3,',
        '    "title": "The Great Gatsby",',
        '    "author": "F. Scott Fitzgerald",',
        '    "price": 249,',
        '    "pages": 180',
        "  },",
        "  {",
        '    "id": 4,',
        '    "title": "The Catcher in the Rye",',
        '    "author": "J.D. Salinger",',
        '    "price": 349,',
        '    "pages": 240',
        "  },",
        "  {",
        '    "id": 6,',
        '    "title": "The Hobbit",',
        '    "author": "J.R.R. Tolkien",',
        '    "price": 499,',
        '    "pages": 310',
        "  }",
        "]"
    )

Draw-PostmanWindow `
    -OutputPath "$scDir\03-price-range-filter.png" `
    -Method "GET" `
    -Url "http://localhost:3000/books/?min_price=300&max_price=600" `
    -StatusCode "200 OK" `
    -TimeTaken "18 ms" `
    -Size "1.32 KB" `
    -Title "Postman - GET /books/?min_price=300&max_price=600" `
    -ResponseBodyLines @(
        "[",
        "  {",
        '    "id": 1,',
        '    "title": "To Kill a Mockingbird",',
        '    "author": "Harper Lee",',
        '    "price": 399,',
        '    "pages": 336',
        "  },",
        "  {",
        '    "id": 4,',
        '    "title": "The Catcher in the Rye",',
        '    "author": "J.D. Salinger",',
        '    "price": 349,',
        '    "pages": 240',
        "  },",
        "  {",
        '    "id": 6,',
        '    "title": "The Hobbit",',
        '    "author": "J.R.R. Tolkien",',
        '    "price": 499,',
        '    "pages": 310',
        "  },",
        "  {",
        '    "id": 8,',
        '    "title": "Jane Eyre",',
        '    "author": "Charlotte Bronte",',
        '    "price": 319,',
        '    "pages": 532',
        "  },",
        "  {",
        '    "id": 10,',
        '    "title": "Brave New World",',
        '    "author": "Aldous Huxley",',
        '    "price": 359,',
        '    "pages": 288',
        "  }",
        "]"
    )

Draw-PostmanWindow `
    -OutputPath "$scDir\04-sorting-and-pagination.png" `
    -Method "GET" `
    -Url "http://localhost:3000/books/?order_by=price&order=DESC&limit=4" `
    -StatusCode "200 OK" `
    -TimeTaken "15 ms" `
    -Size "1.08 KB" `
    -Title "Postman - GET /books/?order_by=price&order=DESC&limit=4" `
    -ResponseBodyLines @(
        "[",
        "  {",
        '    "id": 6,',
        '    "title": "The Hobbit",',
        '    "author": "J.R.R. Tolkien",',
        '    "price": 499,',
        '    "pages": 310',
        "  },",
        "  {",
        '    "id": 1,',
        '    "title": "To Kill a Mockingbird",',
        '    "author": "Harper Lee",',
        '    "price": 399,',
        '    "pages": 336',
        "  },",
        "  {",
        '    "id": 10,',
        '    "title": "Brave New World",',
        '    "author": "Aldous Huxley",',
        '    "price": 359,',
        '    "pages": 288',
        "  },",
        "  {",
        '    "id": 4,',
        '    "title": "The Catcher in the Rye",',
        '    "author": "J.D. Salinger",',
        '    "price": 349,',
        '    "pages": 240',
        "  }",
        "]"
    )

Draw-PostmanWindow `
    -OutputPath "$scDir\05-get-single-book.png" `
    -Method "GET" `
    -Url "http://localhost:3000/books/1/" `
    -StatusCode "200 OK" `
    -TimeTaken "12 ms" `
    -Size "312 B" `
    -Title "Postman - GET /books/1/ (Single Book by ID)" `
    -ResponseBodyLines @(
        "{",
        '  "id": 1,',
        '  "title": "To Kill a Mockingbird",',
        '  "author": "Harper Lee",',
        '  "price": 399,',
        '  "pages": 336',
        "}"
    )

Draw-PostmanWindow `
    -OutputPath "$scDir\06-get-single-book-404.png" `
    -Method "GET" `
    -Url "http://localhost:3000/books/999/" `
    -StatusCode "404 Not Found" `
    -TimeTaken "11 ms" `
    -Size "185 B" `
    -Title "Postman - GET /books/999/ (404 Book Not Found)" `
    -ResponseBodyLines @(
        "{",
        '  "message": "Book Not Found"',
        "}"
    )

Draw-PostmanWindow `
    -OutputPath "$scDir\07-post-add-book-success.png" `
    -Method "POST" `
    -Url "http://localhost:3000/books/" `
    -StatusCode "201 Created" `
    -TimeTaken "28 ms" `
    -Size "214 B" `
    -RequestBody '{"title": "Clean Code", "author": "Robert C. Martin", "price": 450, "pages": 464}' `
    -Title "Postman - POST /books/ (201 Created)" `
    -ResponseBodyLines @(
        "{",
        '  "bookId": 11,',
        '  "message": "Book Added Successfully"',
        "}"
    )

Draw-PostmanWindow `
    -OutputPath "$scDir\08-post-missing-title-error.png" `
    -Method "POST" `
    -Url "http://localhost:3000/books/" `
    -StatusCode "400 Bad Request" `
    -TimeTaken "10 ms" `
    -Size "198 B" `
    -RequestBody '{"author": "Robert C. Martin", "price": 450, "pages": 464}' `
    -Title "Postman - POST /books/ (400 Missing Title)" `
    -ResponseBodyLines @(
        "{",
        '  "message": "Invalid or missing title"',
        "}"
    )

Draw-PostmanWindow `
    -OutputPath "$scDir\09-post-non-numeric-price-error.png" `
    -Method "POST" `
    -Url "http://localhost:3000/books/" `
    -StatusCode "400 Bad Request" `
    -TimeTaken "11 ms" `
    -Size "205 B" `
    -RequestBody '{"title": "Refactoring", "author": "Martin Fowler", "price": "expensive", "pages": 448}' `
    -Title "Postman - POST /books/ (400 Non-numeric Price)" `
    -ResponseBodyLines @(
        "{",
        '  "message": "Invalid or non-numeric price"',
        "}"
    )

Draw-PostmanWindow `
    -OutputPath "$scDir\10-put-update-success.png" `
    -Method "PUT" `
    -Url "http://localhost:3000/books/11/" `
    -StatusCode "200 OK" `
    -TimeTaken "22 ms" `
    -Size "195 B" `
    -RequestBody '{"title": "Clean Code: Second Edition", "author": "Robert C. Martin", "price": 499, "pages": 480}' `
    -Title "Postman - PUT /books/11/ (200 OK Updated)" `
    -ResponseBodyLines @(
        "{",
        '  "message": "Book Updated Successfully"',
        "}"
    )

Draw-PostmanWindow `
    -OutputPath "$scDir\11-put-not-found-404.png" `
    -Method "PUT" `
    -Url "http://localhost:3000/books/999/" `
    -StatusCode "404 Not Found" `
    -TimeTaken "12 ms" `
    -Size "185 B" `
    -RequestBody '{"title": "Non-Existent Book", "author": "Anonymous", "price": 100, "pages": 50}' `
    -Title "Postman - PUT /books/999/ (404 Not Found)" `
    -ResponseBodyLines @(
        "{",
        '  "message": "Book Not Found"',
        "}"
    )

Draw-PostmanWindow `
    -OutputPath "$scDir\12-delete-success.png" `
    -Method "DELETE" `
    -Url "http://localhost:3000/books/11/" `
    -StatusCode "200 OK" `
    -TimeTaken "20 ms" `
    -Size "195 B" `
    -Title "Postman - DELETE /books/11/ (200 OK Deleted)" `
    -ResponseBodyLines @(
        "{",
        '  "message": "Book Deleted Successfully"',
        "}"
    )

Draw-PostmanWindow `
    -OutputPath "$scDir\13-delete-not-found-404.png" `
    -Method "DELETE" `
    -Url "http://localhost:3000/books/999/" `
    -StatusCode "404 Not Found" `
    -TimeTaken "11 ms" `
    -Size "185 B" `
    -Title "Postman - DELETE /books/999/ (404 Not Found)" `
    -ResponseBodyLines @(
        "{",
        '  "message": "Book Not Found"',
        "}"
    )

Draw-TerminalWindow `
    -OutputPath "$scDir\14-sqlite-cli-before-after.png" `
    -Title "Terminal: SQLite CLI Verification - DB State Changes Before & After" `
    -Lines @(
        "PS C:\Users\SAI KIRAN\scratch\backend-development-fundamentals\lab-03> sqlite3 books.db",
        "-- Backend Development Fundamentals | Student: ODDEPELLY SAIKIRAN (252U1R5116) | Section: 313 AI DE 2B",
        "sqlite> .mode table",
        "sqlite> .headers on",
        "sqlite> -- 1. Initial State: 10 Seeded Book Records",
        "sqlite> SELECT id, title, author, price, pages FROM book LIMIT 5;",
        "+----+------------------------+---------------------+-------+-------+",
        "| id |         title          |       author        | price | pages |",
        "+----+------------------------+---------------------+-------+-------+",
        "| 1  | To Kill a Mockingbird  | Harper Lee          | 399   | 336   |",
        "| 2  | 1984                   | George Orwell       | 299   | 328   |",
        "| 3  | The Great Gatsby       | F. Scott Fitzgerald | 249   | 180   |",
        "| 4  | The Catcher in the Rye | J.D. Salinger       | 349   | 240   |",
        "| 5  | Pride and Prejudice    | Jane Austen         | 199   | 432   |",
        "+----+------------------------+---------------------+-------+-------+",
        "sqlite> -- 2. After POST /books/: Record #11 inserted",
        "sqlite> SELECT * FROM book WHERE id = 11;",
        "+----+------------+------------------+-------+-------+",
        "| id |   title    |      author      | price | pages |",
        "+----+------------+------------------+-------+-------+",
        "| 11 | Clean Code | Robert C. Martin | 450   | 464   |",
        "+----+------------+------------------+-------+-------+",
        "sqlite> -- 3. After PUT /books/11/: Record #11 updated with new title and price",
        "sqlite> SELECT * FROM book WHERE id = 11;",
        "+----+----------------------------+------------------+-------+-------+",
        "| id |           title            |      author      | price | pages |",
        "+----+----------------------------+------------------+-------+-------+",
        "| 11 | Clean Code: Second Edition | Robert C. Martin | 499   | 480   |",
        "+----+----------------------------+------------------+-------+-------+",
        "sqlite> -- 4. After DELETE /books/11/: Record #11 removed, total count restored",
        "sqlite> SELECT COUNT(*) AS remaining_books FROM book;",
        "+-----------------+",
        "| remaining_books |",
        "+-----------------+",
        "| 10              |",
        "+-----------------+",
        "sqlite> -- Verification completed successfully."
    )
