#!/usr/bin/env ruby

require 'thor'

class Dotfiles < Thor
  include Thor::Actions
  Thor::Sandbox::Dotfiles.source_root(File.expand_path('..', __FILE__))
  @user = %x[whoami].chomp

  desc "install", "Install all dotfiles into #{@user}'s home directory"
  method_options :force => :boolean
  def install
    Dir['*'].each do |file|
      next if %w[Thorfile README.md README.adoc LICENSE.md .config etc].include?(file)
      link_file(file, "~#{@user}/.#{file}", options[:force])
    end
  end
end

# => thor dotfiles:install
