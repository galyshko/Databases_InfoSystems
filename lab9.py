import redis

# Підключення до Redis
r = redis.Redis(host='localhost', port=6379, decode_responses=True)
pubsub = r.pubsub() #Створює Pub/Sub об'єкт для підписки на канали

# Підписка на канал "news"
pubsub.subscribe('news')

#Виводить повідомлення, що скрипт очікує дані
print("Очікування повідомлень у каналі 'news'...")
for message in pubsub.listen():
    if message['type'] == 'message':
        print(f"Отримано: {message['data']}")
