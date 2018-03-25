# kafka-playground

Learning Kafka by playing. This repo currently follows the [tutorial](https://docs.confluent.io/current/installation/docker/docs/index.html) by Confluent.

This repo also uses Kafka Connect from [Debezium](https://github.com/debezium/docker-images) for simulating Kafka Connect.

## Usage

Run Kafka and its dependencies:
```sh
docker-compose up
```

List existing topics:
```sh
docker-compose exec kafka /usr/bin/kafka-topics --list --zookeeper zookeeper:2181
```

Simulate message producer:
```sh
# you may change the value of parameters if needed.
docker-compose exec kafka /usr/bin/kafka-producer-perf-test \
    --num-records 10000 \
    --topic dummy.topic \
    --producer-props bootstrap.servers=kafka:9092 \
    --record-size 500 \
    --throughput 20
```

Consume message:
```sh
docker-compose exec kafka /usr/bin/kafka-console-consumer \
    --bootstrap-server kafka:9092 \
    --topic dummy.topic \
    --from-beginning
```

Add connector to Kafka Connect:
```sh
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @./config/register-mysql.json
```

## Access

 - Prometheus: [localhost:9090](http://localhost:9090/)
 - Grafana: [localhost:3000](http://localhost:3000/)
