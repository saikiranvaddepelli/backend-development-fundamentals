const express = require('express');
const path = require('path');
const { open } = require('sqlite');
const sqlite3 = require('sqlite3');

const app = express();
app.use(express.json());

// Request logger middleware
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.originalUrl} -> ${res.statusCode} (${duration}ms)`);
  });
  next();
});

const dbPath = path.join(__dirname, 'books.db');
let db = null;

// Initialize database and start server
const initializeDBAndServer = async () => {
  try {
    db = await open({
      filename: dbPath,
      driver: sqlite3.Database
    });

    // Ensure the book table exists
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
      console.log(`Database connected successfully at ${dbPath}`);
    });
  } catch (error) {
    console.error(`DB Error: ${error.message}`);
    process.exit(1);
  }
};

// Root endpoint for API overview
app.get('/', (req, res) => {
  res.status(200).json({
    message: 'Welcome to Lab 2 SQLite Database and CRUD Routes API',
    endpoints: {
      getAllBooks: 'GET /books/',
      getSingleBook: 'GET /books/:bookId/',
      addBook: 'POST /books/',
      updateBook: 'PUT /books/:bookId/',
      deleteBook: 'DELETE /books/:bookId/'
    }
  });
});

// Route 1: GET /books/ - Get all books
app.get('/books/', async (req, res) => {
  try {
    const getBooksQuery = `
      SELECT *
      FROM book
      ORDER BY id;
    `;
    const booksArray = await db.all(getBooksQuery);
    res.status(200).json(booksArray);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Route 2: GET /books/:bookId/ - Get single book by ID
app.get('/books/:bookId/', async (req, res) => {
  try {
    const { bookId } = req.params;
    const getBookQuery = `
      SELECT *
      FROM book
      WHERE id = ?;
    `;
    const book = await db.get(getBookQuery, [bookId]);
    if (!book) {
      return res.status(404).json({ error: `Book with id ${bookId} not found` });
    }
    res.status(200).json(book);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Route 3: POST /books/ - Add a new book
app.post('/books/', async (req, res) => {
  try {
    const { title, author, price, pages } = req.body;
    if (!title || !author || price === undefined || pages === undefined) {
      return res.status(400).json({
        error: 'Missing required fields. Please provide title, author, price, and pages.'
      });
    }

    const addBookQuery = `
      INSERT INTO book (title, author, price, pages)
      VALUES (?, ?, ?, ?);
    `;
    const result = await db.run(addBookQuery, [title, author, price, pages]);
    res.status(201).json({
      message: 'Book Added Successfully',
      bookId: result.lastID
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Route 4: PUT /books/:bookId/ - Update an existing book
app.put('/books/:bookId/', async (req, res) => {
  try {
    const { bookId } = req.params;
    const { title, author, price, pages } = req.body;

    const checkBookQuery = `SELECT * FROM book WHERE id = ?;`;
    const existingBook = await db.get(checkBookQuery, [bookId]);
    if (!existingBook) {
      return res.status(404).json({ error: `Book with id ${bookId} not found` });
    }

    const updateBookQuery = `
      UPDATE book
      SET
        title = ?,
        author = ?,
        price = ?,
        pages = ?
      WHERE id = ?;
    `;
    await db.run(updateBookQuery, [
      title !== undefined ? title : existingBook.title,
      author !== undefined ? author : existingBook.author,
      price !== undefined ? price : existingBook.price,
      pages !== undefined ? pages : existingBook.pages,
      bookId
    ]);

    res.status(200).json({
      message: 'Book Updated Successfully',
      bookId: Number(bookId)
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Route 5: DELETE /books/:bookId/ - Delete a book by ID
app.delete('/books/:bookId/', async (req, res) => {
  try {
    const { bookId } = req.params;
    const checkBookQuery = `SELECT * FROM book WHERE id = ?;`;
    const existingBook = await db.get(checkBookQuery, [bookId]);
    if (!existingBook) {
      return res.status(404).json({ error: `Book with id ${bookId} not found` });
    }

    const deleteBookQuery = `
      DELETE FROM book
      WHERE id = ?;
    `;
    await db.run(deleteBookQuery, [bookId]);

    res.status(200).json({
      message: 'Book Deleted Successfully',
      deletedBookId: Number(bookId)
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Handle unmatched routes with 404
app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint not found' });
});

initializeDBAndServer();

module.exports = app;
