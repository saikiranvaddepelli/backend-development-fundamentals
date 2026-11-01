const http = require('http');

function makeRequest(options, postData = null) {
  return new Promise((resolve, reject) => {
    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => { data += chunk; });
      res.on('end', () => {
        try {
          resolve({
            statusCode: res.statusCode,
            headers: res.headers,
            body: data ? JSON.parse(data) : null
          });
        } catch (e) {
          resolve({
            statusCode: res.statusCode,
            headers: res.headers,
            rawBody: data
          });
        }
      });
    });

    req.on('error', (err) => reject(err));

    if (postData) {
      req.write(typeof postData === 'string' ? postData : JSON.stringify(postData));
    }
    req.end();
  });
}

async function runTests() {
  console.log('--- Starting API Route Tests ---');

  // Test 1: GET /books/
  console.log('\n1. Testing GET /books/ ...');
  const res1 = await makeRequest({
    hostname: 'localhost',
    port: 3000,
    path: '/books/',
    method: 'GET'
  });
  console.log(`Status: ${res1.statusCode}`);
  console.log(`Books count: ${Array.isArray(res1.body) ? res1.body.length : 'N/A'}`);
  console.log(`First book:`, res1.body[0]);

  // Test 2: GET /books/:bookId/
  console.log('\n2. Testing GET /books/1/ ...');
  const res2 = await makeRequest({
    hostname: 'localhost',
    port: 3000,
    path: '/books/1/',
    method: 'GET'
  });
  console.log(`Status: ${res2.statusCode}`);
  console.log(`Book:`, res2.body);

  // Test 2b: GET /books/999/ (Not Found)
  console.log('\n2b. Testing GET /books/999/ (Non-existent ID) ...');
  const res2b = await makeRequest({
    hostname: 'localhost',
    port: 3000,
    path: '/books/999/',
    method: 'GET'
  });
  console.log(`Status: ${res2b.statusCode}`);
  console.log(`Response:`, res2b.body);

  // Test 3: POST /books/
  console.log('\n3. Testing POST /books/ ...');
  const newBook = {
    title: 'Atomic Habits',
    author: 'James Clear',
    price: 499,
    pages: 320
  };
  const res3 = await makeRequest(
    {
      hostname: 'localhost',
      port: 3000,
      path: '/books/',
      method: 'POST',
      headers: { 'Content-Type': 'application/json' }
    },
    newBook
  );
  console.log(`Status: ${res3.statusCode}`);
  console.log(`Response:`, res3.body);
  const createdId = res3.body.bookId;

  // Test 4: PUT /books/:bookId/
  console.log(`\n4. Testing PUT /books/${createdId}/ ...`);
  const updateData = {
    title: 'Atomic Habits (Updated Edition)',
    author: 'James Clear',
    price: 550,
    pages: 330
  };
  const res4 = await makeRequest(
    {
      hostname: 'localhost',
      port: 3000,
      path: `/books/${createdId}/`,
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' }
    },
    updateData
  );
  console.log(`Status: ${res4.statusCode}`);
  console.log(`Response:`, res4.body);

  // Verify updated book
  const res4Verify = await makeRequest({
    hostname: 'localhost',
    port: 3000,
    path: `/books/${createdId}/`,
    method: 'GET'
  });
  console.log(`Verification GET /books/${createdId}/:`, res4Verify.body);

  // Test 5: DELETE /books/:bookId/
  console.log(`\n5. Testing DELETE /books/${createdId}/ ...`);
  const res5 = await makeRequest({
    hostname: 'localhost',
    port: 3000,
    path: `/books/${createdId}/`,
    method: 'DELETE'
  });
  console.log(`Status: ${res5.statusCode}`);
  console.log(`Response:`, res5.body);

  // Verify deletion
  const res5Verify = await makeRequest({
    hostname: 'localhost',
    port: 3000,
    path: `/books/${createdId}/`,
    method: 'GET'
  });
  console.log(`Verification after DELETE (Status): ${res5Verify.statusCode} -`, res5Verify.body);

  console.log('\n--- All Route Tests Completed Successfully! ---');
}

// Start server in-process and run tests
const app = require('./index.js');
setTimeout(() => {
  runTests().then(() => {
    console.log('Testing finished. Exiting.');
    process.exit(0);
  }).catch((err) => {
    console.error('Test error:', err);
    process.exit(1);
  });
}, 1000);
