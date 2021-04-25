# Inner Source Example -"How to Update"
# --------------------
# - Fork this repo to your org/user…
# - See Readme for further details

# DNS Zone

dns_zone_name = "cloudkube.io"

# A Records

dns_a_records = {
  dev_cluster = {
    name    = "dev"
    records = ["52.154.237.242"]
  }
  dev_cluster_wildcard = {
    name    = "*.dev"
    records = ["52.154.237.242"]
  }
}

# CNAME Records

dns_cname_records = {
  nodejs_demo = {
    name   = "nodejs-demo"
    record = "azure-nodejs-demo.azurewebsites.net"
  }
  node_js_demo_dev = {
    name   = "nodejs-demo-dev"
    record = "azure-nodejs-demo-dev.azurewebsites.net"
  }
}
