resource "aws_autoscaling_group" "hhtest-autoscaling-group-by-tf2" {
  # availability_zones        = ["ap-northeast-2a", "ap-northeast-2c"]
  capacity_rebalance        = "true"
  default_cooldown          = "300"
  desired_capacity          = "1"
  force_delete              = "false"
  health_check_grace_period = "15"
  health_check_type         = "EC2"
  max_instance_lifetime     = "0"
  max_size                  = "1"
  metrics_granularity       = "1Minute"
  min_size                  = "1"

  mixed_instances_policy {
    instances_distribution {
      on_demand_allocation_strategy            = "prioritized"
      on_demand_base_capacity                  = "0"
      on_demand_percentage_above_base_capacity = "100"
      spot_allocation_strategy                 = "lowest-price"
      spot_instance_pools                      = "2"
    }

    launch_template {
      launch_template_specification {
#        launch_template_id   = "lt-05036271597aa5b0e"
#        launch_template_name = "hhtest-launch-template"
        launch_template_id   = aws_launch_template.hhtest-launch-template.id
        launch_template_name = aws_launch_template.hhtest-launch-template.name
        version              = "1"
      }

      override {
        instance_type = "t3a.medium"
      }
    }
  }

  name                    = "AWSServiceRoleForAutoScaling"
  protect_from_scale_in   = "false"
  service_linked_role_arn = "arn:aws:iam::046822486271:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"

  tag {
    key                 = "eks:cluster-name"
    propagate_at_launch = "true"
    value               = "hhtest-eks-cluster"
  }

  tag {
    key                 = "kubernetes.io/cluster/hhtest-eks-cluster"
    propagate_at_launch = "true"
    value               = "owned"
  }

  tag {
    key                 = "eks:nodegroup-name"
    propagate_at_launch = "true"
    value               = "hhtest-eks-nodegroup"
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/hhtest-eks-cluster"
    propagate_at_launch = "true"
    value               = "owned"
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    propagate_at_launch = "true"
    value               = "true"
  }

  termination_policies      = ["AllocationStrategy", "OldestLaunchTemplate", "OldestInstance"]
#  vpc_zone_identifier       = ["subnet-0254e7609f3ea68cc", "subnet-0f0752035a0954fee"]
  vpc_zone_identifier       = [aws_subnet.hhtest-public-subnet1.id, aws_subnet.hhtest-public-subnet3.id]
  wait_for_capacity_timeout = "10m"
}