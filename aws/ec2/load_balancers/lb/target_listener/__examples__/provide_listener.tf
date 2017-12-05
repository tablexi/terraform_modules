module "provide_listener" {
  source = "../"

  create_listener = false
  sg_on_lb_id = "http"
  listener_arn = "provide_listener"
  name = "provide_listener"
  sg_for_access_by_sgs_id = "http"
  port = 80
  protocol = "HTTP"
  target_id_count = 1
  target_ids = ["http"]
  vpc_id = "provide_listener"
}
