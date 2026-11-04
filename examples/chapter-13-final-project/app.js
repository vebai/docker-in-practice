const express = require('express');
const { Pool } = require('pg');
const redis = require('redis');

const app = express();
const port = 3000;

app.use(express.json());

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

const redisClient = redis.createClient({
  url: process.env.REDIS_URL || 'redis://redis:6379',
});

app.get('/health', (_, res) => res.json({ status: 'ok' }));

async function initDb() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS todos (
      id SERIAL PRIMARY KEY,
      task TEXT NOT NULL
    )
  `);
}

app.get('/todos', async (req, res) => {
  try {
    const cached = await redisClient.get('todos');
    if (cached) return res.json(JSON.parse(cached));

    const result = await pool.query('SELECT * FROM todos ORDER BY id DESC');
    await redisClient.set('todos', JSON.stringify(result.rows), { EX: 30 });
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/todos', async (req, res) => {
  const { task } = req.body;
  if (!task) return res.status(400).json({ error: 'Task is required' });

  try {
    const result = await pool.query(
      'INSERT INTO todos (task) VALUES ($1) RETURNING *',
      [task]
    );
    await redisClient.del('todos');
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

async function start() {
  await redisClient.connect();
  await initDb();
  app.listen(port, () => console.log(`Listening on ${port}`));
}

start().catch((err) => {
  console.error(err);
  process.exit(1);
});
