async function fetchTodos() {
  const res = await fetch('/api/todos');
  const todos = await res.json();
  const list = document.getElementById('todo-list');
  list.innerHTML = '';
  todos.forEach(todo => {
    const li = document.createElement('li');
    li.textContent = todo;
    list.appendChild(li);
  });
}

async function addTodo() {
  const input = document.getElementById('todo-input');
  const todo = input.value;
  if (!todo) return;
  await fetch('/api/todos', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ todo })
  });
  input.value = '';
  fetchTodos();
}

fetchTodos();
