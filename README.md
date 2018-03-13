# kafka-playground

Learning Kafka by playing. This repo currently follows the [tutorial](https://docs.confluent.io/current/installation/docker/docs/index.html) by Confluent.

## Usage

Run Kafka and its dependencies:
```sh
docker-compose up
```

Simulate message producer:
```sh
# you may change the value of parameters if needed.
docker-compose exec kafka /usr/bin/kafka-producer-perf-test \
    --num-records 100 \
    --topic dummy.topic \
    --producer-props bootstrap.servers=kafka:9092 \
    --record-size 1000 \
    --throughput 20
```

Consume message:
```sh
docker-compose exec kafka /usr/bin/kafka-console-consumer \
    --bootstrap-server kafka:9092 \
    --topic dummy.topic \
    --from-beginning
```
