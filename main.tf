terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "kafka_high_producer_latency_on_broker" {
  source    = "./modules/kafka_high_producer_latency_on_broker"

  providers = {
    shoreline = shoreline
  }
}