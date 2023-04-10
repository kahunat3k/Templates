# Brainboard auto-generated file.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.20.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
}



provider "azurerm" {
  features {}
}

data "azurerm_kubernetes_cluster" "example" {
  resource_group_name = azurerm_resource_group.resource-group.name
  name                = "example"
}

provider "kubernetes" {
  host                   = "${data.azurerm_kubernetes_cluster.example.kube_config.0.host}"
  client_certificate     = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_config.0.cluster_ca_certificate)}"
}
