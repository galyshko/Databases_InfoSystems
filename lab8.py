import redis

# Підключення до Redis (локальний, порт 6379)
r = redis.Redis(host='localhost', port=6379, decode_responses=True)

def add_task(task):
    r.lpush("tasks", task)
    print(f"✅ Завдання додано: {task}")

def show_tasks():
    tasks = r.lrange("tasks", 0, -1)
    if not tasks:
        print("📭 Список завдань порожній.")
    else:
        print("📋 Завдання:")
        for i, task in enumerate(tasks, 1):
            print(f"{i}. {task}")

def remove_task():
    task = r.rpop("tasks")
    if task:
        print(f"❌ Видалено завдання: {task}")
    else:
        print("📭 Немає завдань для видалення.")

# Приклад використання
add_task("Підготувати звіт")
add_task("Написати есе")
show_tasks()
remove_task()
show_tasks()
