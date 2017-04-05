# frozen_string_literal: true

AWS_CREDENTIALS = Aws::Credentials.new(Rails.application.secrets[:aws_key_id], Rails.application.secrets[:aws_secret])