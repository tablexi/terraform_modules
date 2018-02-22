module "http" {
  source = "../"

  sg_on_lb_id = "https"
  name = "http"
  sg_for_access_by_sgs_id = "https"
  port = 80
  protocol = "HTTP"
  target_ids = ["https"]
  target_id_count = 1
  vpc_id = "http"
}

module "https" {
  source = "../"

  certificate_arn = "https"
  sg_on_lb_id = "https"
  name = "https"
  sg_for_access_by_sgs_id = "https"
  port = 443
  protocol = "HTTPS"
  target_ids = ["https"]
  target_id_count = 1
  vpc_id = "https"
}
