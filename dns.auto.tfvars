# =============
#  DNS Records
# =============
# - possible example for inner source
# - separate file to make pull requests easier

# A Records
# ---------

dns_a_records = {
  dev_cluster = {
    name    = "dev"
    records = ["20.82.210.167"]
  }
  dev_cluster_wildcard = {
    name    = "*.dev"
    records = ["20.82.210.167"]
  }
}

# CNAME Records
# -------------

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
