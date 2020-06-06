provider "google" {
  credentials = "$SOMEPATH/$project-uuid.json"
  project     = "adrifterra"
  region      = "us-east1"
  zone        = "us-central1-b"
}
