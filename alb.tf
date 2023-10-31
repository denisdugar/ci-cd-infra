resource "aws_lb" "jenkins_alb" {
  name               = "jenkins-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.test_subnet_public_1.id, aws_subnet.test_subnet_public_2.id]
}

resource "aws_lb_target_group" "jenkins_alb_target_group" {
  name     = "jenkins-alb-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.test_vpc.id
  health_check {
    enabled = true
    path    = "/"
    port    = "traffic-port"
    protocol = "HTTP"
    interval = 120
    timeout  = 60
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "jenkins_alb_listener_http" {
  load_balancer_arn = aws_lb.jenkins_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_alb_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "jenkins_tg_attachment" {
  target_group_arn = aws_lb_target_group.jenkins_alb_target_group.arn
  target_id        = aws_instance.jenkins.id
  port             = 8080
}