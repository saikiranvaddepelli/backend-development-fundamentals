const express = require("express");
const path = require("path");
const { open } = require("sqlite");
const sqlite3 = require("sqlite3");

const app = express();
app.use(express.json());

const dbPath = path.join(__dirname, "books.db");
let db = null;

const initializeDBAndServer = async () => {
  try {
    db = await open({
      filename: dbPath,
      driver: sqlite3.Database
    });

    await db.exec(`
      CREATE TABLE IF NOT EXISTS book (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        price INTEGER NOT NULL,
        pages INTEGER NOT NULL
      );
    `);

    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => {
      console.log(`Server Running at http://localhost:${PORT}/`);
    });
  } catch (error) {
    console.error(`DB Error: ${error.message}`);
    process.exit(1);
  }
};

app.get("/", (req, res) => {
  res.status(200).json({
    message: "Lab 3: REST API, query parameters, validation, debugging",
    endpoints: {
      getBooks: "GET /books/?search_q=&order_by=&order=&limit=&offset=&min_price=&max_price=",
      getBookById: "GET /books/:bookId/",
      addBook: "POST /books/",
      updateBook: "PUT /books/:bookId/",
      deleteBook: "DELETE /books/:bookId/"
    }
  });
});

app.get(["/books", "/books/"], async (req, res) => {
  try {
    const {
      search_q = "",
      order_by = "id",
      order = "ASC",
      limit = 10,
      offset = 0,
      min_price,
      max_price
    } = req.query;

    const validColumns = ["id", "title", "author", "price", "pages"];
    const validOrderBy = validColumns.includes(order_by.toLowerCase())
      ? order_by.toLowerCase()
      : "id";
    const validOrder = order.toUpperCase() === "DESC" ? "DESC" : "ASC";
    const parsedLimit = parseInt(limit, 10) > 0 ? parseInt(limit, 10) : 10;
    const parsedOffset = parseInt(offset, 10) >= 0 ? parseInt(offset, 10) : 0;

    let query = `SELECT * FROM book WHERE title LIKE ?`;
    const params = [`%${search_q}%`];

    if (min_price !== undefined && max_price !== undefined && min_price !== "" && max_price !== "") {
      query += ` AND price BETWEEN ? AND ?`;
      params.push(Number(min_price), Number(max_price));
    } else if (min_price !== undefined && min_price !== "") {
      query += ` AND price >= ?`;
      params.push(Number(min_price));
    } else if (max_price !== undefined && max_price !== "") {
      query += ` AND price <= ?`;
      params.push(Number(max_price));
    }

    query += ` ORDER BY ${validOrderBy} ${validOrder} LIMIT ? OFFSET ?;`;
    params.push(parsedLimit, parsedOffset);

    const books = await db.all(query, params);
    res.status(200).json(books);
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
});

app.get(["/books/:bookId", "/books/:bookId/"], async (req, res) => {
  try {
    const { bookId } = req.params;
    const book = await db.get(`SELECT * FROM book WHERE id = ?;`, [bookId]);
    if (!book) {
      return res.status(404).json({ message: "Book Not Found" });
    }
    res.status(200).json(book);
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
});

app.post(["/books", "/books/"], async (req, res) => {
  try {
    const { title, author, price, pages } = req.body;

    if (!title || typeof title !== "string" || title.trim() === "") {
      return res.status(400).json({ message: "Invalid or missing title" });
    }
    if (!author || typeof author !== "string" || author.trim() === "") {
      return res.status(400).json({ message: "Invalid or missing author" });
    }
    if (
      price === undefined ||
      price === null ||
      isNaN(price) ||
      Number(price) < 0 ||
      (typeof price === "string" && price.trim() === "")
    ) {
      return res.status(400).json({ message: "Invalid or non-numeric price" });
    }

    const parsedPages =
      pages !== undefined && !isNaN(pages) && Number(pages) > 0
        ? Number(pages)
        : 0;

    const result = await db.run(
      `INSERT INTO book (title, author, price, pages) VALUES (?, ?, ?, ?);`,
      [title.trim(), author.trim(), Number(price), parsedPages]
    );

    res.status(201).json({
      bookId: result.lastID,
      message: "Book Added Successfully"
    });
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
});

app.put(["/books/:bookId", "/books/:bookId/"], async (req, res) => {
  try {
    const { bookId } = req.params;
    const existingBook = await db.get(`SELECT * FROM book WHERE id = ?;`, [bookId]);
    if (!existingBook) {
      return res.status(404).json({ message: "Book Not Found" });
    }

    const { title, author, price, pages } = req.body;

    if (!title || typeof title !== "string" || title.trim() === "") {
      return res.status(400).json({ message: "Invalid or missing title" });
    }
    if (!author || typeof author !== "string" || author.trim() === "") {
      return res.status(400).json({ message: "Invalid or missing author" });
    }
    if (
      price === undefined ||
      price === null ||
      isNaN(price) ||
      Number(price) < 0 ||
      (typeof price === "string" && price.trim() === "")
    ) {
      return res.status(400).json({ message: "Invalid or non-numeric price" });
    }

    const parsedPages =
      pages !== undefined && !isNaN(pages) && Number(pages) > 0
        ? Number(pages)
        : existingBook.pages;

    await db.run(
      `UPDATE book SET title = ?, author = ?, price = ?, pages = ? WHERE id = ?;`,
      [title.trim(), author.trim(), Number(price), parsedPages, bookId]
    );

    res.status(200).json({ message: "Book Updated Successfully" });
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
});

app.delete(["/books/:bookId", "/books/:bookId/"], async (req, res) => {
  try {
    const { bookId } = req.params;
    const existingBook = await db.get(`SELECT * FROM book WHERE id = ?;`, [bookId]);
    if (!existingBook) {
      return res.status(404).json({ message: "Book Not Found" });
    }

    await db.run(`DELETE FROM book WHERE id = ?;`, [bookId]);
    res.status(200).json({ message: "Book Deleted Successfully" });
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
});

initializeDBAndServer();

module.exports = app;
