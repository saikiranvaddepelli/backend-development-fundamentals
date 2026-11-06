const path = require("path");
const sqlite3 = require("sqlite3");
const { open } = require("sqlite");

const dbPath = path.join(__dirname, "books.db");

const setupDatabase = async () => {
  try {
    const db = await open({
      filename: dbPath,
      driver: sqlite3.Database
    });

    await db.exec(`
      DROP TABLE IF EXISTS book;
      CREATE TABLE book (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        price INTEGER NOT NULL,
        pages INTEGER NOT NULL
      );
    `);

    const books = [
      { title: "To Kill a Mockingbird", author: "Harper Lee", price: 399, pages: 336 },
      { title: "1984", author: "George Orwell", price: 299, pages: 328 },
      { title: "The Great Gatsby", author: "F. Scott Fitzgerald", price: 249, pages: 180 },
      { title: "The Catcher in the Rye", author: "J.D. Salinger", price: 349, pages: 240 },
      { title: "Pride and Prejudice", author: "Jane Austen", price: 199, pages: 432 },
      { title: "The Hobbit", author: "J.R.R. Tolkien", price: 499, pages: 310 },
      { title: "Fahrenheit 451", author: "Ray Bradbury", price: 279, pages: 256 },
      { title: "Jane Eyre", author: "Charlotte Bronte", price: 319, pages: 532 },
      { title: "Animal Farm", author: "George Orwell", price: 199, pages: 144 },
      { title: "Brave New World", author: "Aldous Huxley", price: 359, pages: 288 }
    ];

    for (const book of books) {
      await db.run(
        `INSERT INTO book (title, author, price, pages) VALUES (?, ?, ?, ?);`,
        [book.title, book.author, book.price, book.pages]
      );
    }

    console.log("Database initialized and 10 records seeded successfully.");
    await db.close();
  } catch (error) {
    console.error("Error setting up database:", error.message);
    process.exit(1);
  }
};

setupDatabase();
