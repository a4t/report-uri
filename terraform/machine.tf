resource "aws_elb" "app" {
  name    = "${var.name}"
  subnets = ["${aws_subnet.public_0.id}", "${aws_subnet.public_1.id}"]

  security_groups = [
    "${aws_security_group.elb.id}",
  ]

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.ssl_certificate_id}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 5
    target              = "HTTP:80/csp_report/ping"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 60

  tags {
    Name    = "${var.name}"
    Service = "${var.name}"
    Role    = "elb"
  }
}

data "template_file" "init" {
  template = "${file("./user_data")}"

  vars {
    SLACK_WEBHOOK_URL = "${var.slack_webhook_url}"
    NOTIFICATION_YML  = "${file("/app/config/notification.yml")}"
  }
}

resource "aws_launch_configuration" "app" {
  name          = "${var.name}"
  image_id      = "${var.instance["ami_id"]}"
  instance_type = "${var.instance["type"]}"

  security_groups = [
    "${aws_security_group.developer.id}",
    "${aws_security_group.app.id}",
  ]

  key_name                    = "${var.instance["key_name"]}"
  associate_public_ip_address = true

  root_block_device = {
    volume_type = "gp2"
    volume_size = "8"
  }

  user_data = "${data.template_file.init.rendered}"
}

resource "aws_autoscaling_group" "app" {
  availability_zones = ["${var.az[0]}", "${var.az[1]}"]

  load_balancers = [
    "${aws_elb.app.id}",
  ]

  vpc_zone_identifier       = ["${aws_subnet.public_0.id}", "${aws_subnet.public_1.id}"]
  name                      = "${var.name}"
  max_size                  = "${var.instance["server_count"]}"
  min_size                  = "${var.instance["server_count"]}"
  default_cooldown          = 600
  health_check_grace_period = 420
  health_check_type         = "EC2"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.app.name}"

  tag {
    key                 = "Name"
    value               = "${var.name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Service"
    value               = "${var.name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "machine"
    propagate_at_launch = true
  }
}
