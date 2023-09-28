resource "shoreline_notebook" "kafka_high_producer_latency_on_broker" {
  name       = "kafka_high_producer_latency_on_broker"
  data       = file("${path.module}/data/kafka_high_producer_latency_on_broker.json")
  depends_on = [shoreline_action.invoke_kafka_latency_test,shoreline_action.invoke_update_kafka_config]
}

resource "shoreline_file" "kafka_latency_test" {
  name             = "kafka_latency_test"
  input_file       = "${path.module}/data/kafka_latency_test.sh"
  md5              = filemd5("${path.module}/data/kafka_latency_test.sh")
  description      = "High network latency can cause producer latency on Kafka brokers."
  destination_path = "/agent/scripts/kafka_latency_test.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_kafka_config" {
  name             = "update_kafka_config"
  input_file       = "${path.module}/data/update_kafka_config.sh"
  md5              = filemd5("${path.module}/data/update_kafka_config.sh")
  description      = "Tune Kafka configuration parameters, such as the producer batch size and the number of acknowledgments required, to optimize performance."
  destination_path = "/agent/scripts/update_kafka_config.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_kafka_latency_test" {
  name        = "invoke_kafka_latency_test"
  description = "High network latency can cause producer latency on Kafka brokers."
  command     = "`chmod +x /agent/scripts/kafka_latency_test.sh && /agent/scripts/kafka_latency_test.sh`"
  params      = []
  file_deps   = ["kafka_latency_test"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_latency_test]
}

resource "shoreline_action" "invoke_update_kafka_config" {
  name        = "invoke_update_kafka_config"
  description = "Tune Kafka configuration parameters, such as the producer batch size and the number of acknowledgments required, to optimize performance."
  command     = "`chmod +x /agent/scripts/update_kafka_config.sh && /agent/scripts/update_kafka_config.sh`"
  params      = ["NEW_BATCH_SIZE","NEW_NUMBER_OF_ACKNOWLEDGMENTS","PATH_TO_KAFKA_CONFIG_FILE"]
  file_deps   = ["update_kafka_config"]
  enabled     = true
  depends_on  = [shoreline_file.update_kafka_config]
}

