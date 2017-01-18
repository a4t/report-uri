resource "aws_route53_record" "app" {
  zone_id = "${var.route53["zone_id"]}"
  name    = "${var.route53["domain"]}"
  type    = "A"

  alias {
    name                   = "${aws_elb.app.dns_name}"
    zone_id                = "${aws_elb.app.zone_id}"
    evaluate_target_health = true
  }
}
