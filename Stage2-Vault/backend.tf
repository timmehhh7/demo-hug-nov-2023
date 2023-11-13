terraform {
  backend "gcs" {
    bucket = "tfairweather-demo-states"
    prefix = "hug-nov-2023-vault/state"
  }
}