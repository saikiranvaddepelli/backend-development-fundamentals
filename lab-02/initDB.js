const { open } = require('sqlite');
const sqlite3 = require('sqlite3');
const path = require('path');

const dbPath = path.join(__dirname, 'books.db');

const initialBooks = [
  { title: 'To Kill a Mockingbird', author: 'Harper Lee', price: 399, pages: 336 },
  { title: '1984', author: 'George Orwell', price: 299, pages: 328 },
  { title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', price: 249, pages: 180 },
  { title: 'Pride and Prejudice', author: 'Jane Austen', price: 349, pages: 279 },
  { title: 'The Catcher in the Rye', author: 'J.D. Salinger', price: 299, pages: 234 },
  { title: 'The Hobbit', author: 'J.R.R. Tolkien', price: 499, pages: 310 },
  { title: 'Fahrenheit 451', author: 'Ray Bradbury', price: 320, pages: 256 },
  { title: 'Brave New World', author: 'Aldous Huxley', price: 360, pages: 288 },
  { title: 'Crime and Punishment', author: 'Fyodor Dostoevsky', price: 450, pages: 671 },
  { title: 'The Alchemist', author: 'Paulo Coelho', price: 275, pages: 208 }
];

async function initializeDatabase() {
  const db = await open({
    filename: dbPath,
    driver: sqlite3.Database
  });

  console.log('Opened SQLite database at:', dbPath);

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

  console.log('Created "book" table.');

  for (const book of initialBooks) {
    await db.run(
      `INSERT INTO book (title, author, price, pages) VALUES (?, ?, ?, ?)`,
      [book.title, book.author, book.price, book.pages]
    );
  }

  console.log(`Successfully seeded ${initialBooks.length} sample books.`);
  const rows = await db.all('SELECT * FROM book');
  console.table(rows);

  await db.close();
}

initializeDatabase().catch((error) => {
  console.error('Error seeding database:', error.message);
  process.exit(1);
});
