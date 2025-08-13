const express = require('express');
const bodyParser = require('body-parser');
const app = express();

let todos = [];

app.use(bodyParser.json());
app.use(express.static('public'));

app.get('/api/todos', (req, res) => {
  res.json(todos);
});

app.post('/api/todos', (req, res) => {
  const todo = req.body.todo;
  if (todo) {
    todos.push(todo);
    res.status(201).json({ message: 'Todo added' });
  } else {
    res.status(400).json({ error: 'Todo cannot be empty' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Todo app running on port ${PORT}`));
